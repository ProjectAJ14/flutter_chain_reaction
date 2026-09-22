import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/controller.dart';
import 'board.dart';

const _boards = [(5, 8, 'Small'), (6, 9, 'Classic'), (8, 12, 'Large')];

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key, required this.initial, required this.onStart});
  final GameSettings initial;
  final ValueChanged<GameSettings> onStart;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late int players = widget.initial.players;
  late int board = _boards
      .indexWhere((b) => b.$1 == widget.initial.cols)
      .clamp(0, 2);

  void _pick(VoidCallback f) {
    HapticFeedback.selectionClick();
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -1.2),
            radius: 1.6,
            colors: [Color(0xFF232538), kBackground],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, child) => Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 24 * (1 - t)),
                      child: child,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Image(
                          image: AssetImage('assets/ns-logo-dark-f.png'),
                          height: 32,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 36,
                        child: CustomPaint(painter: _OrbRowPainter(players)),
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (r) => LinearGradient(
                          colors: [
                            for (var p = 0; p < players; p++) kPlayers[p].color,
                          ],
                        ).createShader(r),
                        child: const Text(
                          'CHAIN\nREACTION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 44,
                            height: 1,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Pass-and-play strategy for 2–8 players',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(height: 40),
                      const _Label('PLAYERS'),
                      Row(
                        children: [
                          for (var n = 2; n <= 8; n++)
                            _Choice(
                              label: '$n',
                              selected: players == n,
                              onTap: () => _pick(() => players = n),
                            ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const _Label('BOARD'),
                      Row(
                        children: [
                          for (var i = 0; i < _boards.length; i++)
                            _Choice(
                              label: _boards[i].$3,
                              sub: '${_boards[i].$1} × ${_boards[i].$2}',
                              selected: board == i,
                              onTap: () => _pick(() => board = i),
                            ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(58),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          final b = _boards[board];
                          widget.onStart(
                            GameSettings(
                              players: players,
                              cols: b.$1,
                              rows: b.$2,
                            ),
                          );
                        },
                        child: const Text('PLAY'),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Tap a cell to add an orb. When a cell holds as many orbs as it has '
                        'neighbours, it explodes and captures every cell around it. '
                        'Last colour standing wins.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    ),
  );
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    this.sub,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final String? sub;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.black : Colors.white;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                if (sub != null)
                  Text(
                    sub!,
                    style: TextStyle(
                      color: fg.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbRowPainter extends CustomPainter {
  _OrbRowPainter(this.n);
  final int n;

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 34.0;
    final start = size.width / 2 - gap * (n - 1) / 2;
    for (var p = 0; p < n; p++) {
      drawOrb(
        canvas,
        Offset(start + gap * p, size.height / 2),
        11,
        kPlayers[p].color,
      );
    }
  }

  @override
  bool shouldRepaint(_OrbRowPainter old) => old.n != n;
}
