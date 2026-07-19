import '../data/srs_repository.dart';
import '../data/vocab_repository.dart';
import '../models/review_state.dart';
import '../models/vocab_word.dart';

class LevelStat {
  final CefrLevel level;
  final int total;
  final int learned; // answered correctly at least once (moves immediately)
  final int mastered; // 21-day interval in both directions
  const LevelStat(this.level, this.total, this.learned, this.mastered);

  double get progress => total == 0 ? 0 : learned / total;
}

class DashboardStats {
  final int totalWords;
  final int learnedWords;
  final int masteredWords;
  final int dueCount;
  final int reviewsToday;
  final int streak;
  final List<LevelStat> levels;

  const DashboardStats({
    required this.totalWords,
    required this.learnedWords,
    required this.masteredWords,
    required this.dueCount,
    required this.reviewsToday,
    required this.streak,
    required this.levels,
  });

  double get overallProgress =>
      totalWords == 0 ? 0 : learnedWords / totalWords;
}

/// Computes home-screen statistics.
class DashboardController {
  static Future<DashboardStats> load(
    VocabRepository vocab,
    SrsRepository srs, {
    DateTime? now,
  }) async {
    final clock = now ?? DateTime.now();
    return compute(
      vocab: vocab,
      states: await srs.allStates(),
      reviewTimes: await srs.reviewTimes(),
      correctCounts: await srs.correctAnswerCounts(),
      now: clock,
    );
  }

  /// A word is mastered once answered correctly (cleanly) this many times.
  static const masteredCorrectAnswers = 3;

  /// Pure aggregation — no I/O, unit-testable.
  static DashboardStats compute({
    required VocabRepository vocab,
    required List<ReviewState> states,
    required List<DateTime> reviewTimes,
    required Map<int, int> correctCounts, // wordId -> clean correct answers
    required DateTime now,
  }) {
    final clock = now;

    final levels = <LevelStat>[];
    var masteredTotal = 0;
    var learnedTotal = 0;
    for (final level in CefrLevel.values) {
      final words = vocab.byLevel(level);
      var learned = 0;
      var mastered = 0;
      for (final w in words) {
        final correct = correctCounts[w.id] ?? 0;
        // Learned = written correctly at least once (no credit for guessing
        // after seeing the answer).
        if (correct >= 1) learned++;
        if (correct >= masteredCorrectAnswers) mastered++;
      }
      masteredTotal += mastered;
      learnedTotal += learned;
      levels.add(LevelStat(level, words.length, learned, mastered));
    }

    final today = _dayStart(clock);
    final reviewsToday = reviewTimes.where((t) => !t.isBefore(today)).length;
    final dueCount = states
        .where((s) => s.dueAt != null && !s.dueAt!.isAfter(clock))
        .length;

    return DashboardStats(
      totalWords: vocab.count,
      learnedWords: learnedTotal,
      masteredWords: masteredTotal,
      dueCount: dueCount,
      reviewsToday: reviewsToday,
      streak: _streak(reviewTimes, clock),
      levels: levels,
    );
  }

  static DateTime _dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Consecutive days with ≥1 review, ending today. 0 if no review today.
  static int _streak(List<DateTime> times, DateTime now) {
    final days = times.map(_dayStart).toSet();
    var streak = 0;
    var day = _dayStart(now);
    while (days.contains(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
