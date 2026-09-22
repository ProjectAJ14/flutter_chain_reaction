import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../game/controller.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key, required this.controller});
  final GameController controller;

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView>
    with SingleTickerProviderStateMixin {
  // One ticker repaints the whole board; no per-cell widgets or controllers.
  late final _ticker = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final e = c.engine;
    return LayoutBuilder(
      builder: (context, box) {
        final s = min(box.maxWidth / e.cols, box.maxHeight / e.rows);
        int? cellAt(Offset p) {
          final x = (p.dx / s).floor(), y = (p.dy / s).floor();
          if (x < 0 || y < 0 || x >= e.cols || y >= e.rows) return null;
          return y * e.cols + x;
        }

        return Center(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onHover: (d) => c.setHighlight(cellAt(d.localPosition)),
            onExit: (_) => c.setHighlight(null),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => c.setHighlight(cellAt(d.localPosition)),
              onTapCancel: () => c.setHighlight(null),
              onTapUp: (d) {
                final i = cellAt(d.localPosition);
                if (d.kind != PointerDeviceKind.mouse) c.setHighlight(null);
                if (i != null) c.tap(i);
              },
              child: CustomPaint(
                size: Size(s * e.cols, s * e.rows),
                painter: BoardPainter(c, _ticker),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BoardPainter extends CustomPainter {
  BoardPainter(this.c, Listenable repaint) : super(repaint: repaint);
  final GameController c;

  static const _cellFill = Color(0xFF15161E);

  @override
  void paint(Canvas canvas, Size size) {
    final e = c.engine;
    final s = size.width / e.cols;
    final now = c.now;
    final ms = now.inMicroseconds / 1000.0;

    double progress(Duration since, int durationMs) =>
        ((now - since).inMicroseconds / (durationMs * 1000)).clamp(0.0, 1.0);

    final gridColor = Color.lerp(
      kPlayers[c.previousPlayer].color,
      c.currentPlayer.color,
      Curves.easeOut.transform(progress(c.turnChangedAt, 350)),
    )!;

    final flying = c.flying.toSet();
    final ft = flying.isEmpty
        ? 1.0
        : progress(c.flightStart, max(1, c.flightDuration.inMilliseconds));

    // Board shake on long chains.
    if (flying.isNotEmpty && c.chain >= 3) {
      final amp = min(c.chain, 10) * 0.35 * (1 - ft);
      canvas.translate(sin(ms * 0.09) * amp, cos(ms * 0.11) * amp);
    }

    Offset center(int i) =>
        Offset((i % e.cols + 0.5) * s, (i ~/ e.cols + 0.5) * s);

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(1.0, s * 0.025)
      ..color = gridColor.withValues(alpha: 0.45);
    final fill = Paint()..color = _cellFill;

    for (var i = 0; i < e.length; i++) {
      final rect = Rect.fromCenter(
        center: center(i),
        width: s,
        height: s,
      ).deflate(s * 0.045);
      final rr = RRect.fromRectAndRadius(rect, Radius.circular(s * 0.2));
      canvas.drawRRect(rr, fill);
      if (e.isCritical(i)) {
        final pulse = 0.10 + 0.07 * sin(ms / 110);
        canvas.drawRRect(
          rr,
          Paint()..color = kPlayers[e.owner(i)].color.withValues(alpha: pulse),
        );
      }
      if (i == c.highlight && !c.busy && e.canPlace(i)) {
        canvas.drawRRect(
          rr,
          Paint()..color = gridColor.withValues(alpha: 0.18),
        );
      }
      if (i == c.rejectedCell) {
        final rt = progress(c.rejectedAt, 450);
        if (rt < 1) {
          canvas.drawRRect(
            rr,
            Paint()..color = Colors.white.withValues(alpha: 0.22 * (1 - rt)),
          );
        }
      }
      canvas.drawRRect(rr, border);
    }

    // Resting orbs.
    for (var i = 0; i < e.length; i++) {
      var n = e.count(i);
      if (flying.contains(i)) n -= e.capacity(i);
      if (n <= 0) continue;

      var p = center(i);
      var scale = 1.0;
      final popped = c.poppedAt[i];
      if (popped != null) {
        final pt = progress(popped, 300);
        if (pt < 1) scale = 0.45 + 0.55 * Curves.easeOutBack.transform(pt);
      }
      if (i == c.rejectedCell) {
        final rt = progress(c.rejectedAt, 450);
        if (rt < 1) p += Offset(sin(rt * pi * 7) * s * 0.08 * (1 - rt), 0);
      }
      final critical = e.isCritical(i);
      if (critical) {
        p += Offset(sin(ms * 0.07 + i), cos(ms * 0.09 + i * 2)) * s * 0.018;
      }
      final angle = ms / 1000 * 2 * pi * (critical ? 0.9 : 0.12) + i;
      _drawMolecule(
        canvas,
        p,
        s * 0.15 * scale,
        n,
        kPlayers[e.owner(i)].color,
        angle,
      );
    }

    // Orbs in flight + shockwave.
    if (flying.isNotEmpty) {
      final travel = Curves.easeOutCubic.transform(ft);
      for (final i in flying) {
        final color = kPlayers[e.owner(i)].color;
        final from = center(i);
        canvas.drawCircle(
          from,
          s * (0.2 + 0.55 * travel),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.09 * (1 - ft) + 0.5
            ..color = color.withValues(alpha: 0.8 * (1 - ft)),
        );
        for (final n in e.neighbors(i)) {
          drawOrb(
            canvas,
            Offset.lerp(from, center(n), travel)!,
            s * 0.15,
            color,
          );
        }
      }
    }
  }

  static void _drawMolecule(
    Canvas canvas,
    Offset c,
    double r,
    int n,
    Color color,
    double angle,
  ) {
    if (n == 1) {
      drawOrb(canvas, c, r, color);
      return;
    }
    final k = min(n, 4);
    final d = r * (k == 2 ? 0.95 : 1.15);
    for (var j = 0; j < k; j++) {
      final a = angle + j * 2 * pi / k;
      drawOrb(canvas, c + Offset(cos(a), sin(a)) * d, r, color);
    }
  }

  @override
  bool shouldRepaint(BoardPainter old) => old.c != c;
}

/// Glossy sphere with a soft halo.
void drawOrb(Canvas canvas, Offset c, double r, Color color) {
  canvas.drawCircle(
    c,
    r * 1.9,
    Paint()
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: c, radius: r * 1.9)),
  );
  canvas.drawCircle(
    c,
    r,
    Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.4),
        radius: 0.9,
        colors: [
          Color.lerp(color, Colors.white, 0.7)!,
          color,
          Color.lerp(color, Colors.black, 0.5)!,
        ],
        stops: const [0, 0.45, 1],
      ).createShader(Rect.fromCircle(center: c, radius: r)),
  );
}
