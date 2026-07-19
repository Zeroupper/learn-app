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

  test('streak counts consecutive days ending today', () {
    final now = DateTime(2026, 1, 10, 9);
    final s = DashboardController.compute(
      vocab: vocab,
      states: const [],
      reviewTimes: [
        DateTime(2026, 1, 10, 8),
        DateTime(2026, 1, 9, 20),
        DateTime(2026, 1, 8, 7),
        DateTime(2026, 1, 6, 7), // gap on the 7th breaks the streak
      ],
      correctCounts: const {},
      now: now,
    );
    expect(s.streak, 3);
    expect(s.reviewsToday, 1);
  });

  test('no review today means streak is zero', () {
    final s = DashboardController.compute(
      vocab: vocab,
      states: const [],
      reviewTimes: [DateTime(2026, 1, 9, 8)],
      correctCounts: const {},
      now: DateTime(2026, 1, 10, 9),
    );
    expect(s.streak, 0);
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
