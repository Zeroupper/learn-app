import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/controllers/dashboard_controller.dart';
import 'package:learn_app/data/vocab_repository.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/models/vocab_word.dart';

void main() {
  VocabWord word(int id, CefrLevel level) => VocabWord(
        id: id,
        en: 'w$id',
        enAccepted: const [],
        hu: const ['x'],
        level: level,
        pos: 'noun',
      );

  final vocab = VocabRepository([
    word(1, CefrLevel.a1),
    word(2, CefrLevel.a1),
    word(3, CefrLevel.a2),
  ]);

  test('learned needs 1 clean correct answer; mastered needs 3', () {
    final s = DashboardController.compute(
      vocab: vocab,
      states: const [],
      reviewTimes: const [],
      correctCounts: {1: 3, 2: 1}, // word1 mastered, word2 only learned
      now: DateTime(2026, 1, 1),
    );
    expect(s.masteredWords, 1);
    expect(s.learnedWords, 2);
    final a1 = s.levels.firstWhere((l) => l.level == CefrLevel.a1);
    expect(a1.mastered, 1);
    expect(a1.learned, 2);
    expect(a1.total, 2);
  });

  test('a word only ever failed (no clean correct) is not learned', () {
    final s = DashboardController.compute(
      vocab: vocab,
      states: const [],
      reviewTimes: const [],
      correctCounts: const {}, // failed words never reach quality>=4
      now: DateTime(2026, 1, 1),
    );
    expect(s.learnedWords, 0);
    expect(s.masteredWords, 0);
  });

  test('streak counts consecutive days of finished exercises', () {
    final now = DateTime(2026, 1, 10, 9);
    final s = DashboardController.compute(
      vocab: vocab,
      states: const [],
      reviewTimes: [DateTime(2026, 1, 10, 8)],
      activityTimes: [
        DateTime(2026, 1, 10, 8),
        DateTime(2026, 1, 9, 20),
        DateTime(2026, 1, 8, 7),
        DateTime(2026, 1, 6, 7), // gap on the 7th, covered by a heart
      ],
      correctCounts: const {},
      now: now,
    );
    expect(s.streak, 4); // the 6th counts too; the 7th held the streak open
    expect(s.hearts, DashboardController.startingHearts - 1);
    expect(s.reviewsToday, 1);
  });

  test('a streak stays visible until midnight even with nothing done today', () {
    final s = DashboardController.compute(
      vocab: vocab,
      states: const [],
      reviewTimes: const [],
      activityTimes: [DateTime(2026, 1, 8, 8), DateTime(2026, 1, 9, 8)],
      correctCounts: const {},
      now: DateTime(2026, 1, 10, 9),
    );
    expect(s.streak, 2);
    expect(s.hearts, DashboardController.startingHearts); // today is not charged
  });

  group('hearts', () {
    DateTime day(int d) => DateTime(2026, 1, d, 8);

    /// A finished exercise on every listed day; [learned] words on [learnedOn].
    (int, int) run(List<int> activeDays,
            {int learned = 0, int learnedOn = 1, int today = 20}) =>
        DashboardController.streakAndHearts(
          activeDays.map(day).toList(),
          List.filled(learned, day(learnedOn)),
          DateTime(2026, 1, today, 12),
        );

    test('a perfect run keeps all hearts', () {
      expect(run([1, 2, 3], today: 3), (3, 3));
    });

    test('each skipped day spends one heart, streak survives but pauses', () {
      // Studied the 1st and the 4th: the 2nd and 3rd each cost a heart.
      expect(run([1, 4], today: 4), (2, 1));
    });

    test('the streak resets once the hearts run out', () {
      // 1st, then four idle days: 3 hearts absorb three, the fourth breaks it.
      expect(run([1, 6], today: 6), (1, 0));
    });

    test('50 learned words earn one heart back', () {
      // Two skips leave 1 heart; 50 words on day 4 refund one.
      expect(run([1, 4], learned: 50, learnedOn: 4, today: 4), (2, 2));
    });

    test('learning lifts hearts to the cap but never past it', () {
      // 500 words is ten hearts' worth; the balance stops at maxHearts.
      expect(run([1, 2], learned: 500, today: 2), (2, 5));
      // The surplus is gone, so two later skips still cost two hearts.
      expect(run([1, 2, 5], learned: 500, today: 5), (3, 3));
    });

    test('hearts cannot be earned retroactively to survive a long absence', () {
      // 500 words on day 1 is ten hearts' worth, but the cap is 5 — a six-day
      // gap still breaks the streak.
      expect(run([1, 8], learned: 500, today: 8), (1, 0));
    });

    test('nothing finished at all: no streak, the starting hearts', () {
      expect(run(const []), (0, 3));
    });
  });

  test('an abandoned session logs reviews but does not move the streak', () {
    final s = DashboardController.compute(
      vocab: vocab,
      states: const [],
      // Cards were answered today, but the session was never completed.
      reviewTimes: [DateTime(2026, 1, 9, 19), DateTime(2026, 1, 9, 20)],
      activityTimes: const [],
      correctCounts: const {},
      now: DateTime(2026, 1, 9, 21),
    );
    expect(s.streak, 0);
    expect(s.reviewsToday, 2); // they still count as "ismétlés"
    expect(s.activitiesToday, 0);
  });

  test('a finished grammar lesson keeps the streak alive without a review', () {
    final s = DashboardController.compute(
      vocab: vocab,
      states: const [],
      reviewTimes: const [],
      activityTimes: [DateTime(2026, 1, 8, 8), DateTime(2026, 1, 9, 19)],
      correctCounts: const {},
      now: DateTime(2026, 1, 9, 21),
    );
    expect(s.streak, 2);
    expect(s.hearts, DashboardController.startingHearts); // nothing skipped
    expect(s.reviewsToday, 0); // a lesson is not an "ismétlés"
  });

  test('due count includes only past-due states', () {
    final now = DateTime(2026, 1, 10);
    final s = DashboardController.compute(
      vocab: vocab,
      states: [
        ReviewState(wordId: 1, direction: Direction.enToHu, dueAt: DateTime(2026, 1, 9)),
        ReviewState(wordId: 2, direction: Direction.enToHu, dueAt: DateTime(2026, 1, 20)),
      ],
      reviewTimes: const [],
      correctCounts: const {},
      now: now,
    );
    expect(s.dueCount, 1);
  });
}
