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
class ReviewState {
  final int wordId;
  final Direction direction;
  final int repetitions;
  final double easeFactor; // start 2.5, floor 1.3
  final int intervalDays;
  final DateTime? dueAt; // null = new, never studied
  final int lapses;
  final DateTime? lastReviewedAt;

  const ReviewState({
    required this.wordId,
    required this.direction,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 0,
    this.dueAt,
    this.lapses = 0,
    this.lastReviewedAt,
  });

  bool get isNew => dueAt == null;
  bool get isMastered => repetitions >= masteryRepetitions;

  ReviewState copyWith({
    int? repetitions,
    double? easeFactor,
    int? intervalDays,
    DateTime? dueAt,
    int? lapses,
    DateTime? lastReviewedAt,
  }) =>
      ReviewState(
        wordId: wordId,
        direction: direction,
        repetitions: repetitions ?? this.repetitions,
        easeFactor: easeFactor ?? this.easeFactor,
        intervalDays: intervalDays ?? this.intervalDays,
        dueAt: dueAt ?? this.dueAt,
        lapses: lapses ?? this.lapses,
        lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      );

  factory ReviewState.fromRow(Map<String, dynamic> r) => ReviewState(
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
