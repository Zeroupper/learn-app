import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Pushes [page] as if lightning struck it into place: the screen blows out
/// white, the page is revealed inside the flash already at full size, and the
/// whole thing rattles as the strike lands.
///
/// ponytail: a PageRouteBuilder and a few transforms — no shader, no package.
Route<T> lightningStrikeRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 750),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) =>
          _Strike(animation: animation, child: child),
    );

class _Strike extends StatelessWidget {
  const _Strike({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  /// Flash moments and their power — a leader, a stutter, then the main hit.
  static const _strikes = <double>[0.0, 0.10, 0.20];
  static const _power = <double>[0.9, 0.35, 1.0];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) {
        final t = animation.value;

        var flash = 0.0;
        for (var i = 0; i < _strikes.length; i++) {
          final since = t - _strikes[i];
          if (since < 0) continue;
          flash = math.max(flash, _power[i] * math.exp(-since * 22));
        }

        // The page is uncovered by the second flash, not slid in.
        final reveal =
            Curves.easeOutCubic.transform(((t - 0.08) / 0.30).clamp(0.0, 1.0));

        // Impact rattle: a hard shake that dies off within a few frames.
        final rattle = math.exp(-t * 9) * (1 - t);
        final jolt = Offset(
          math.sin(t * 78) * 9 * rattle,
          math.cos(t * 61) * 5 * rattle,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: reveal,
              child: Transform.translate(
                offset: jolt,
                // Slams down to size rather than growing into it.
                child: Transform.scale(scale: 1 + 0.14 * (1 - reveal), child: child),
              ),
            ),
            if (flash > 0.01)
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: flash.clamp(0.0, 1.0)),
                        const Color(0xFFCFE0FF)
                            .withValues(alpha: (flash * 0.75).clamp(0.0, 1.0)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
