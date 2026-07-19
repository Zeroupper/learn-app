import '../models/review_state.dart';

/// Pure SM-2 scheduler. No I/O — trivially unit-testable.
///
/// Quality is decided by the caller: 5 = correct first try, 4 = accent-only
/// "almost", 3 = correct after an in-session failure, 1 = wrong.
class SrsScheduler {
  static const double minEase = 1.3;
  static const Duration relapseDelay = Duration(minutes: 10);

  static ReviewState applyReview(ReviewState s, int quality, DateTime now) {
    final newEase = _clampEase(
      s.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)),
    );

    if (quality < 3) {
      // Lapse: reset progress, show again in ~10 minutes.
      return s.copyWith(
        repetitions: 0,
        lapses: s.lapses + 1,
        intervalDays: 0,
        easeFactor: newEase,
        dueAt: now.add(relapseDelay),
        lastReviewedAt: now,
      );
    }

    final reps = s.repetitions + 1;
    final interval = switch (reps) {
      1 => 1,
      2 => 6,
      _ => (s.intervalDays * newEase).round(),
    };
    return s.copyWith(
      repetitions: reps,
      intervalDays: interval,
      easeFactor: newEase,
      dueAt: now.add(Duration(days: interval)),
      lastReviewedAt: now,
    );
  }

  static double _clampEase(double ef) => ef < minEase ? minEase : ef;
}
