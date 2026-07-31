import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../celebration_music.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/lightning_route.dart';
import '../widgets/thunderstorm.dart';

/// Pushes the streak animation, but only when the just-finished task was the
/// first thing the user did today. Call it once the activity is persisted *and*
/// [StatsStore] has been refreshed, so the count includes it.
///
/// The "exactly one activity today" test needs no extra bookkeeping: that is
/// true for one moment per day, which is precisely when to celebrate.
Future<void> maybeCelebrateStreak(BuildContext context) async {
  final stats = context.read<StatsStore>().stats;
  if (stats == null || stats.activitiesToday != 1) return;

  await Navigator.of(
    context,
  ).push(lightningStrikeRoute(StreakCelebrationScreen(streak: stats.streak)));
}

/// Full-screen "your streak grew" moment.
class StreakCelebrationScreen extends StatefulWidget {
  const StreakCelebrationScreen({super.key, required this.streak});

  final int streak;

  @override
  State<StreakCelebrationScreen> createState() =>
      _StreakCelebrationScreenState();
}

class _StreakCelebrationScreenState extends State<StreakCelebrationScreen> {
  final _player = AudioPlayer();
  final _cheer = AudioPlayer();
  final _fades = <Timer>[];

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
    // Fire-and-forget: a silenced phone or a busy audio session must not stop
    // the screen from showing.
    _playCheer();
    _playMusic();
  }

  Future<void> _playCheer() async {
    try {
      // Both players default to requesting AUDIOFOCUS_GAIN, and the music
      // starting second takes focus off the cheer, which stops it dead. The
      // cheer is a short layer on top, so it asks for no focus at all.
      await _cheer.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
        ),
      );
      await _cheer.setVolume(0);
      await _cheer.play(AssetSource(celebrationCheer));
    } catch (_) {
      // Silence is fine; the music still carries the moment.
      return;
    }
    _fadeIn(_cheer, to: 0.7, over: celebrationCheerFadeIn);
  }

  /// A different track each time, dropped in at its best moment, rising under
  /// the cheer instead of cutting in over it. Falls back to the drum roll when
  /// the file has not been added yet.
  Future<void> _playMusic() async {
    final track = pickCelebrationTrack();
    try {
      await _player.setVolume(0);
      await _player.play(AssetSource(track.asset), position: track.start);
    } catch (_) {
      try {
        await _player.play(AssetSource(celebrationFallback));
      } catch (_) {
        // No audio at all — the screen is still worth showing.
        return;
      }
    }
    _fadeIn(_player, to: 1, over: celebrationFadeIn);
  }

  /// ponytail: 100ms steps are inaudible as steps and need no animation
  /// controller.
  void _fadeIn(
    AudioPlayer player, {
    required double to,
    required Duration over,
  }) {
    const step = Duration(milliseconds: 100);
    final steps = over.inMilliseconds / step.inMilliseconds;
    _fades.add(
      Timer.periodic(step, (t) {
        final progress = t.tick / steps;
        if (progress >= 1) t.cancel();
        player.setVolume(progress.clamp(0, 1) * to);
      }),
    );
  }

  @override
  void dispose() {
    // The roll runs ~10s; leaving early should cut it, not talk over the
    // next screen.
    for (final t in _fades) {
      t.cancel();
    }
    _cheer.dispose();
    _player.dispose();
    super.dispose();
  }

  /// Never let a missing or malformed asset take the whole screen down.
  Widget _lottie(String name, Size size) => SizedBox.fromSize(
    size: size,
    child: Lottie.asset(
      'assets/animations/$name.lottie',
      repeat: true,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const Icon(
        Icons.local_fire_department,
        size: 120,
        color: Colors.amber,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final streak = widget.streak;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Thunderstorm(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Spacer(),
                  // Rocket takes off, fire burns over the top of it.
                  SizedBox(
                    height: 210,
                    width: 210,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 80,
                          child: _lottie(
                            'Fire animation',
                            const Size.square(190),
                          ),
                        ),
                        _lottie('Crazy bottle rocker', const Size.square(210)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _StreakRollover(to: streak),
                  Text(
                    streak == 1 ? 'napos sorozat indul!' : 'napos sorozat!',
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  _FadesIn(
                    delay: const Duration(milliseconds: 1400),
                    child: Text(
                      streak == 1
                          ? 'Szép kezdés. Holnap is gyere vissza! 💪'
                          : 'Ma is megvolt. Így tovább! 💪',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange.shade100,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _FadesIn(
                    delay: const Duration(milliseconds: 1900),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepOrange.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Folytatás',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows yesterday's streak, holds it long enough to register, then rolls it
/// over to today's: the old number rises out of view while the new one climbs
/// in from below, like an odometer.
class _StreakRollover extends StatefulWidget {
  const _StreakRollover({required this.to});

  final int to;

  static const hold = Duration(milliseconds: 750);
  static const roll = Duration(milliseconds: 700);

  @override
  State<_StreakRollover> createState() => _StreakRolloverState();
}

class _StreakRolloverState extends State<_StreakRollover> {
  late int _shown = widget.to - 1;
  Timer? _timer;

  static const _style = TextStyle(
    fontSize: 88,
    height: 1,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _timer = Timer(_StreakRollover.hold, () {
      if (mounted) setState(() => _shown = widget.to);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _StreakRollover.roll,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      // Both numbers occupy the same spot mid-roll instead of the switcher's
      // default of parking the outgoing one top-left.
      layoutBuilder: (current, previous) =>
          Stack(alignment: Alignment.center, children: [...previous, ?current]),
      transitionBuilder: (child, animation) {
        final arriving = child.key == ValueKey(widget.to);
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, arriving ? 0.85 : -0.85),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text('$_shown', key: ValueKey(_shown), style: _style),
    );
  }
}

/// ponytail: TweenAnimationBuilder runs once on first build, so this needs no
/// AnimationController.
class _FadesIn extends StatelessWidget {
  const _FadesIn({required this.delay, required this.child});

  final Duration delay;
  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: delay + const Duration(milliseconds: 400),
    // Hold at 0 until the delay has passed, then fade over the remainder.
    curve: Interval(delay.inMilliseconds / (delay.inMilliseconds + 400), 1),
    builder: (_, t, c) => Opacity(opacity: t, child: c),
    child: child,
  );
}
