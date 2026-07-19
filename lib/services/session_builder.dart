import '../models/review_state.dart';
import '../models/vocab_word.dart';

/// One card in a study session: a (word, direction) pair.
class SessionCard {
  final int wordId;
  final Direction direction;
  const SessionCard(this.wordId, this.direction);

  String get key => '$wordId:${direction.code}';

  @override
  bool operator ==(Object other) =>
      other is SessionCard &&
      other.wordId == wordId &&
      other.direction == direction;

  @override
  int get hashCode => Object.hash(wordId, direction);
}

/// Pure session-queue construction. Due cards first (oldest-due, capped), then
/// new cards in frequency (asset) order. Multiple directions interleave.
class SessionBuilder {
  static const int dueCap = 20;

  static List<SessionCard> build({
    required List<VocabWord> words, // level-filtered, frequency order
    required List<Direction> directions,
    required List<ReviewState> dueStates, // dueAt <= now, filtered to dirs
    required Set<String> existingKeys, // '$wordId:$dirCode' with a stored state
    int newCap = 10,
  }) {
    final due = [...dueStates]..sort((a, b) => a.dueAt!.compareTo(b.dueAt!));
    final dueCards =
        due.take(dueCap).map((s) => SessionCard(s.wordId, s.direction)).toList();

    final newCards = <SessionCard>[];
    for (final w in words) {
      for (final d in directions) {
        if (newCards.length >= newCap) break;
        if (!existingKeys.contains('${w.id}:${d.code}')) {
          newCards.add(SessionCard(w.id, d));
        }
      }
      if (newCards.length >= newCap) break;
    }

    final combined = [...dueCards, ...newCards];
    return directions.length > 1 ? _interleave(combined, directions) : combined;
  }

  static List<SessionCard> _interleave(
      List<SessionCard> cards, List<Direction> directions) {
    final groups = {
      for (final d in directions) d: cards.where((c) => c.direction == d).toList()
    };
    final result = <SessionCard>[];
    for (var i = 0; result.length < cards.length; i++) {
      for (final d in directions) {
        final g = groups[d]!;
        if (i < g.length) result.add(g[i]);
      }
    }
    return result;
  }

  /// Where to re-insert a failed card: [offset] positions ahead, clamped to end.
  static int reinsertPosition(int fromIndex, int length, [int offset = 3]) {
    final target = fromIndex + offset;
    return target > length ? length : target;
  }
}
