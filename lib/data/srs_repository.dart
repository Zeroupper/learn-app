import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/review_state.dart';

/// Persists SM-2 review states and the review log.
class SrsRepository {
  final Database db;
  SrsRepository(this.db);

  /// Bumped on every save so the dashboard can reload after a study session,
  /// regardless of how the user navigates back to it.
  final ValueNotifier<int> revision = ValueNotifier(0);

  /// Returns the stored state for a card, or a fresh (new) state if none exists.
  Future<ReviewState> stateFor(int wordId, Direction dir) async {
    final rows = await db.query(
      'review_state',
      where: 'word_id = ? AND direction = ?',
      whereArgs: [wordId, dir.code],
      limit: 1,
    );
    if (rows.isEmpty) return ReviewState(wordId: wordId, direction: dir);
    return ReviewState.fromRow(rows.first);
  }

  Future<List<ReviewState>> allStates() async {
    final rows = await db.query('review_state');
    return rows.map(ReviewState.fromRow).toList();
  }

  /// Due cards (dueAt <= now) for the given directions, oldest-due first.
  Future<List<ReviewState>> dueCards(
    List<Direction> directions,
    DateTime now,
  ) async {
    final codes = directions.map((d) => "'${d.code}'").join(',');
    final rows = await db.query(
      'review_state',
      where: 'due_at IS NOT NULL AND due_at <= ? AND direction IN ($codes)',
      whereArgs: [now.millisecondsSinceEpoch],
      orderBy: 'due_at ASC',
    );
    return rows.map(ReviewState.fromRow).toList();
  }

  /// wordId -> number of times answered correctly on the first try (quality>=4:
  /// clean correct or accent-only "almost"; excludes q=3 corrected-after-fail
  /// and q=1 wrong). Used for the "learned" / "mastered" dashboard counts.
  Future<Map<int, int>> correctAnswerCounts() async {
    final rows = await db.rawQuery(
      'SELECT word_id, COUNT(*) c FROM review_log WHERE quality >= 4 GROUP BY word_id',
    );
    return {for (final r in rows) r['word_id'] as int: r['c'] as int};
  }

  /// Timestamps of every logged review (for "today" count and streak).
  Future<List<DateTime>> reviewTimes() async {
    final rows = await db.query('review_log', columns: ['reviewed_at']);
    return rows
        .map((r) => DateTime.fromMillisecondsSinceEpoch(r['reviewed_at'] as int))
        .toList();
  }

  Future<void> save(ReviewState state, {int? quality, DateTime? reviewedAt}) async {
    await db.insert(
      'review_state',
      state.toRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (quality != null) {
      await db.insert('review_log', {
        'word_id': state.wordId,
        'direction': state.direction.code,
        'reviewed_at': (reviewedAt ?? DateTime.now()).millisecondsSinceEpoch,
        'quality': quality,
      });
    }
    revision.value++;
  }
}
