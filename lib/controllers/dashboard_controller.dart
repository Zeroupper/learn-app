import 'package:flutter/foundation.dart';

import '../data/settings_repository.dart';
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

  /// Exercises completed today (card sessions + grammar lessons). Exactly 1 at
  /// the moment the day's first one lands — the cue to celebrate.
  final int activitiesToday;
  final int streak;
  final int hearts;
  final List<LevelStat> levels;

  const DashboardStats({
    required this.totalWords,
    required this.learnedWords,
    required this.masteredWords,
    required this.dueCount,
    required this.reviewsToday,
    required this.activitiesToday,
    required this.streak,
    required this.hearts,
    required this.levels,
  });

  double get overallProgress =>
      totalWords == 0 ? 0 : learnedWords / totalWords;

  /// Words still to learn before the next heart comes back. 0 when full.
  int get wordsToNextHeart => hearts >= DashboardController.maxHearts
      ? 0
      : DashboardController.wordsPerHeart -
          (learnedWords % DashboardController.wordsPerHeart);
}

/// App-wide cache of [DashboardStats] — the shell's counters and the home
/// screen read the same instance, so one reload serves both. Refreshes itself
/// whenever a review is saved.
class StatsStore extends ChangeNotifier {
  StatsStore(this._vocab, this._srs, this._settings) {
    _srs.revision.addListener(refresh);
    refresh();
  }

  final VocabRepository _vocab;
  final SrsRepository _srs;
  final SettingsRepository _settings;

  /// Null until the first load finishes.
  DashboardStats? stats;

  Future<void> refresh() async {
    stats = await DashboardController.load(_vocab, _srs, _settings);
    notifyListeners();
  }

  @override
  void dispose() {
    _srs.revision.removeListener(refresh);
    super.dispose();
  }
}

/// Computes home-screen statistics.
class DashboardController {
  static Future<DashboardStats> load(
    VocabRepository vocab,
    SrsRepository srs,
    SettingsRepository settings, {
    DateTime? now,
  }) async {
    final clock = now ?? DateTime.now();
    return compute(
      vocab: vocab,
      states: await srs.allStates(),
      reviewTimes: await srs.reviewTimes(),
      learnedTimes: await srs.learnedAtTimes(),
      activityTimes: await settings.activityTimes(),
      correctCounts: await srs.correctAnswerCounts(),
      now: clock,
    );
  }

  /// A word is mastered once answered correctly (cleanly) this many times.
  static const masteredCorrectAnswers = 3;

  /// Hearts everyone begins with.
  static const startingHearts = 3;

  /// Ceiling you can bank back up to by learning words.
  static const maxHearts = 5;

  /// Words learned per heart earned back.
  static const wordsPerHeart = 50;

  /// Pure aggregation — no I/O, unit-testable.
  static DashboardStats compute({
    required VocabRepository vocab,
    required List<ReviewState> states,
    required List<DateTime> reviewTimes,
    required Map<int, int> correctCounts, // wordId -> clean correct answers
    required DateTime now,
    List<DateTime> learnedTimes = const [], // when each word became "learned"
    List<DateTime> activityTimes = const [], // finished sessions and lessons
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
    final activitiesToday =
        activityTimes.where((t) => !t.isBefore(today)).length;
    final dueCount = states
        .where((s) => s.dueAt != null && !s.dueAt!.isAfter(clock))
        .length;

    // Only completed exercises move the streak — an abandoned half-session
    // still logs reviews, and those count as "ismétlés" but not as a day done.
    final (streak, hearts) =
        streakAndHearts(activityTimes, learnedTimes, clock);

    return DashboardStats(
      totalWords: vocab.count,
      learnedWords: learnedTotal,
      masteredWords: masteredTotal,
      dueCount: dueCount,
      reviewsToday: reviewsToday,
      activitiesToday: activitiesToday,
      streak: streak,
      hearts: hearts,
      levels: levels,
    );
  }

  static DateTime _dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Day arithmetic via the constructor, not `Duration` — adding 24h across a
  /// DST boundary lands on 23:00 of the same day and would corrupt the walk.
  static DateTime _nextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);

  /// Replays the history one day at a time.
  ///
  /// A day with at least one *completed* exercise extends the streak. A skipped
  /// day spends a heart instead of breaking it — the streak holds but does not
  /// grow. With no hearts left the streak resets to 0. Hearts start at [startingHearts], come
  /// back one per [wordsPerHeart] words learned, and never bank above
  /// [maxHearts].
  ///
  /// Today is never charged: the day is not over yet, so a streak stays visible
  /// until midnight rather than reading 0 every morning.
  static (int streak, int hearts) streakAndHearts(
    List<DateTime> activityTimes,
    List<DateTime> learnedTimes,
    DateTime now,
  ) {
    final active = activityTimes.map(_dayStart).toSet();
    if (active.isEmpty) return (0, startingHearts);

    final learnedPerDay = <DateTime, int>{};
    for (final t in learnedTimes) {
      final d = _dayStart(t);
      learnedPerDay[d] = (learnedPerDay[d] ?? 0) + 1;
    }

    final today = _dayStart(now);
    var day = active.reduce((a, b) => a.isBefore(b) ? a : b);
    var streak = 0;
    var hearts = startingHearts;
    var learned = 0;
    var earned = 0;

    while (!day.isAfter(today)) {
      if (active.contains(day)) {
        streak++;
      } else if (day != today) {
        if (hearts > 0) {
          hearts--;
        } else {
          streak = 0;
        }
      }
      // Hearts accrue at the point they were earned, so a big backlog of words
      // cannot be cashed in retroactively to survive a long absence.
      learned += learnedPerDay[day] ?? 0;
      final total = learned ~/ wordsPerHeart;
      hearts = (hearts + total - earned).clamp(0, maxHearts);
      earned = total;
      day = _nextDay(day);
    }
    return (streak, hearts);
  }
}
