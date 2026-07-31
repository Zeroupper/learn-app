import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/models/vocab_word.dart';
import 'package:learn_app/services/session_builder.dart';

void main() {
  VocabWord word(int id) => VocabWord(
        id: id,
        en: 'w$id',
        enAccepted: const [],
        hu: const ['x'],
        level: CefrLevel.a1,
        pos: 'noun',
      );

  final words = [for (var i = 1; i <= 30; i++) word(i)];

  test('new cards fill in asset order up to the session size', () {
    final q = SessionBuilder.build(
      words: words,
      directions: [Direction.enToHu],
      dueStates: [],
      existingKeys: {},
      sessionSize: 5,
    );
    expect(q.length, 5);
    expect(q.map((c) => c.wordId), [1, 2, 3, 4, 5]);
  });

  test('due cards come first, oldest-due, and fill the whole round', () {
    final base = DateTime(2026, 1, 1);
    final due = [
      for (var i = 1; i <= 25; i++)
        ReviewState(
          wordId: i,
          direction: Direction.enToHu,
          dueAt: base.add(Duration(minutes: 25 - i)), // higher i = older
          intervalDays: 1,
          repetitions: 1,
        )
    ];
    final q = SessionBuilder.build(
      words: words,
      directions: [Direction.enToHu],
      dueStates: due,
      existingKeys: {for (var i = 1; i <= 25; i++) '$i:en_hu'},
      sessionSize: 20,
    );
    expect(q.length, 20); // the round is full of due cards
    expect(q.first.wordId, 25); // oldest due first
  });

  test('mixed directions interleave', () {
    final q = SessionBuilder.build(
      words: words,
      directions: [Direction.enToHu, Direction.huToEn],
      dueStates: [],
      existingKeys: {},
      sessionSize: 4,
    );
    expect(q.length, 4);
    expect(q[0].direction, Direction.enToHu);
    expect(q[1].direction, Direction.huToEn);
  });

  test('due cards leave room for new ones inside the session size', () {
    final due = [
      for (var i = 1; i <= 3; i++)
        ReviewState(
          wordId: i,
          direction: Direction.enToHu,
          dueAt: DateTime(2026, 1, 1),
          intervalDays: 1,
          repetitions: 1,
        )
    ];
    final q = SessionBuilder.build(
      words: words,
      directions: [Direction.enToHu],
      dueStates: due,
      existingKeys: {for (var i = 1; i <= 3; i++) '$i:en_hu'},
      sessionSize: 8,
    );
    expect(q.length, 8); // 3 due + 5 new, never more than asked for
    expect(q.take(3).map((c) => c.wordId), [1, 2, 3]);
    expect(q.skip(3).map((c) => c.wordId), [4, 5, 6, 7, 8]);
  });

  test('reinsert position is offset ahead, clamped to end', () {
    expect(SessionBuilder.reinsertPosition(0, 10), 3);
    expect(SessionBuilder.reinsertPosition(9, 10), 10);
  });
}
