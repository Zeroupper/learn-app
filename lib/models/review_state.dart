import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_state.freezed.dart';

enum Direction {
  enToHu('en_hu'),
  huToEn('hu_en');

  final String code;
  const Direction(this.code);

  static Direction fromCode(String c) =>
      Direction.values.firstWhere((d) => d.code == c);
}

/// A card is mastered once answered correctly this many times in a row.
/// (SM-2 also spaces mastered cards far apart, so they rarely resurface.)
const int masteryRepetitions = 3;

/// Mutable SM-2 review state for one (word, direction) card. PK = (wordId, direction).
///
/// Rows, not JSON: this one lives in SQLite, so the mapping is hand-written
/// while equality and `copyWith` come from freezed.
@freezed
abstract class ReviewState with _$ReviewState {
  const ReviewState._();

  const factory ReviewState({
    required int wordId,
    required Direction direction,
    @Default(0) int repetitions,
    @Default(2.5) double easeFactor, // start 2.5, floor 1.3
    @Default(0) int intervalDays,
    DateTime? dueAt, // null = new, never studied
    @Default(0) int lapses,
    DateTime? lastReviewedAt,
  }) = _ReviewState;

  bool get isNew => dueAt == null;
  bool get isMastered => repetitions >= masteryRepetitions;

  static ReviewState fromRow(Map<String, dynamic> r) => ReviewState(
    wordId: r['word_id'] as int,
    direction: Direction.fromCode(r['direction'] as String),
    repetitions: r['repetitions'] as int,
    easeFactor: (r['ease_factor'] as num).toDouble(),
    intervalDays: r['interval_days'] as int,
    dueAt: _fromMillis(r['due_at'] as int?),
    lapses: r['lapses'] as int,
    lastReviewedAt: _fromMillis(r['last_reviewed_at'] as int?),
  );

  Map<String, dynamic> toRow() => {
    'word_id': wordId,
    'direction': direction.code,
    'repetitions': repetitions,
    'ease_factor': easeFactor,
    'interval_days': intervalDays,
    'due_at': dueAt?.millisecondsSinceEpoch,
    'lapses': lapses,
    'last_reviewed_at': lastReviewedAt?.millisecondsSinceEpoch,
  };

  static DateTime? _fromMillis(int? ms) =>
      ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
}
