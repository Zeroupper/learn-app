import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Storm-lit backdrop: a dark sky that gets torn open by forked lightning
/// every few seconds, in the stuttering double-strike real lightning has.
///
/// ponytail: a CustomPainter and one controller, no dependency and no asset —
/// the whole effect is a flash envelope plus a jagged polyline.
class Thunderstorm extends StatefulWidget {
  const Thunderstorm({super.key, this.cycle = const Duration(seconds: 5)});

  /// How long one strike-and-silence loop lasts.
  final Duration cycle;

  @override
  State<Thunderstorm> createState() => _ThunderstormState();
}

class _ThunderstormState extends State<Thunderstorm>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.cycle)..repeat();

  // Two bolts, alternating between strikes so it never looks like a loop.
  static final _bolts = [_Bolt.generate(11), _Bolt.generate(29)];

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, _) =>
            CustomPaint(painter: _StormPainter(_c.value, _bolts), size: Size.infinite),
      );
}

/// A fork of lightning as fractions of the canvas, so it scales to any size.
class _Bolt {
  const _Bolt(this.trunk, this.branch);

  final List<Offset> trunk;
  final List<Offset> branch;

  static _Bolt generate(int seed) {
    final r = math.Random(seed);
    var x = 0.2 + r.nextDouble() * 0.6;
    final trunk = <Offset>[Offset(x, -0.02)];
    for (var y = 0.0; y < 0.62; y += 0.07) {
      x += (r.nextDouble() - 0.5) * 0.13;
      trunk.add(Offset(x.clamp(0.05, 0.95), y));
    }
    // A shorter fork peeling off partway down.
    final from = trunk[trunk.length ~/ 2];
    var bx = from.dx;
    final branch = <Offset>[from];
    for (var i = 1; i <= 4; i++) {
      bx += (r.nextDouble() - 0.3) * 0.11;
      branch.add(Offset(bx.clamp(0.05, 0.95), from.dy + i * 0.06));
    }
    return _Bolt(trunk, branch);
  }
}

class _StormPainter extends CustomPainter {
  _StormPainter(this.t, this.bolts);

  final double t;
  final List<_Bolt> bolts;

  /// Strike moments within the cycle. Each group is one storm event: a bright
  /// leader, a stutter, then the main stroke.
  static const _strikes = <double>[0.02, 0.07, 0.11, 0.54, 0.60];

  /// How bright each strike is, and which bolt it draws.
  static const _power = <double>[0.55, 0.30, 1.0, 0.45, 0.85];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Storm sky: near-black at the edges, a bruised blue toward the horizon.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B0B14), Color(0xFF1E2338), Color(0xFF0A0A10)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    // Which strike (if any) is lighting the sky right now.
    var flash = 0.0;
    var active = -1;
    for (var i = 0; i < _strikes.length; i++) {
      final since = t - _strikes[i];
      if (since < 0 || since > 0.16) continue;
      // Instant onset, quick decay — lightning does not fade in.
      final v = _power[i] * math.exp(-since * 34);
      if (v > flash) {
        flash = v;
        active = i;
      }
    }
    if (active < 0) return;

    // Sky lights up from above.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFBFD4FF).withValues(alpha: 0.55 * flash),
            const Color(0xFF6E86C8).withValues(alpha: 0.14 * flash),
            Colors.transparent,
          ],
        ).createShader(rect),
    );

    if (flash < 0.22) return; // faint stutters glow but draw no fork
    _drawBolt(canvas, size, bolts[active % bolts.length], flash);
  }

  void _drawBolt(Canvas canvas, Size size, _Bolt bolt, double flash) {
    Path pathOf(List<Offset> pts) {
      final p = Path()
        ..moveTo(pts.first.dx * size.width, pts.first.dy * size.height);
      for (final o in pts.skip(1)) {
        p.lineTo(o.dx * size.width, o.dy * size.height);
      }
      return p;
    }

    for (final pts in [bolt.trunk, bolt.branch]) {
      final path = pathOf(pts);
      final main = pts == bolt.trunk;
      final width = (main ? 3.5 : 1.8) * flash;

      // Glow underneath, hot white core on top.
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 5
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF9FC0FF).withValues(alpha: 0.5 * flash)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
      );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = Colors.white.withValues(alpha: flash.clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(_StormPainter old) => old.t != t;
}
