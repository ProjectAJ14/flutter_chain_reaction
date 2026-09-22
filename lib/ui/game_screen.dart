import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../game/controller.dart';
import 'board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.settings,
    required this.onRestart,
    required this.onExit,
  });
  final GameSettings settings;
  final VoidCallback onRestart, onExit;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final c = GameController(widget.settings);

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  Future<void> _guard(VoidCallback go, String title, String action) async {
    if (c.moves == 0 || c.engine.winner != null) return go();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('The current game will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    );
    if (ok == true) go();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final color = c.currentPlayer.color;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _guard(widget.onExit, 'Leave game?', 'Leave');
          },
          child: Scaffold(
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -1.3),
                  radius: 1.7,
                  colors: [color.withValues(alpha: 0.22), kBackground],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                          child: Row(
                            children: [
                              IconButton(
                                tooltip: 'Back to menu',
                                icon: const Icon(Icons.arrow_back_rounded),
                                onPressed: () => _guard(
                                  widget.onExit,
                                  'Leave game?',
                                  'Leave',
                                ),
                              ),
                              Expanded(child: _PlayerStrip(c)),
                              IconButton(
                                tooltip: 'Restart',
                                icon: const Icon(Icons.refresh_rounded),
                                onPressed: () => _guard(
                                  widget.onRestart,
                                  'Restart game?',
                                  'Restart',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: RepaintBoundary(
                              child: BoardView(controller: c),
                            ),
                          ),
                        ),
                        _StatusLine(c),
                      ],
                    ),
                    if (c.showWinner)
                      _WinnerOverlay(
                        c,
                        onRestart: widget.onRestart,
                        onExit: widget.onExit,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PlayerStrip extends StatelessWidget {
  const _PlayerStrip(this.c);
  final GameController c;

  @override
  Widget build(BuildContext context) {
    final e = c.engine;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var p = 0; p < e.playerCount; p++)
          Builder(
            builder: (context) {
              final info = kPlayers[p];
              final alive = e.isAlive(p);
              final active = p == e.current && e.winner == null;
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: alive ? 1 : 0.3,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: active ? 12 : 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: info.color.withValues(alpha: active ? 0.22 : 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: info.color.withValues(alpha: active ? 0.9 : 0),
                      width: 1.5,
                    ),
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: info.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (active)
                          Text(
                            '${info.name}  ',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        Text(
                          '${e.orbsOf(p)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            decoration: alive
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine(this.c);
  final GameController c;

  @override
  Widget build(BuildContext context) {
    final color = c.currentPlayer.color;
    final chain = c.busy && c.chain >= 2;
    final text = c.engine.winner != null
        ? '${kPlayers[c.engine.winner!].name} takes the board!'
        : chain
        ? 'CHAIN ×${c.chain}'
        : "${c.currentPlayer.name}'s turn";
    return SizedBox(
      height: 64,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, a) => FadeTransition(
            opacity: a,
            child: ScaleTransition(
              scale: Tween(begin: 0.7, end: 1.0).animate(a),
              child: child,
            ),
          ),
          child: Text(
            text,
            key: ValueKey(text),
            style: TextStyle(
              color: color,
              fontSize: chain ? 22 + (c.chain.clamp(0, 12)).toDouble() : 20,
              fontWeight: chain ? FontWeight.w900 : FontWeight.w600,
              letterSpacing: chain ? 2 : 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _WinnerOverlay extends StatelessWidget {
  const _WinnerOverlay(this.c, {required this.onRestart, required this.onExit});
  final GameController c;
  final VoidCallback onRestart, onExit;

  @override
  Widget build(BuildContext context) {
    final w = kPlayers[c.engine.winner!];
    return Positioned.fill(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) => Opacity(
          opacity: t,
          child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: 0.65),
          child: Stack(
            children: [
              IgnorePointer(
                child: Lottie.asset(
                  'assets/confetti.json',
                  fit: BoxFit.cover,
                  repeat: false,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events_rounded, size: 80, color: w.color),
                    const SizedBox(height: 12),
                    Text(
                      '${w.name} wins!',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: w.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'after ${c.moves} moves',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: w.color,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(220, 52),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: onRestart,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('PLAY AGAIN'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: onExit,
                      child: const Text('Change setup'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
