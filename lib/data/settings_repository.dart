import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../models/exam.dart';

/// Key-value settings stored in SQLite (non-secret values only;
/// the API key lives in flutter_secure_storage).
class SettingsRepository {
  final Database db;
  SettingsRepository(this.db);

  static const keyModel = 'ai_model';
  static const keySessionSize = 'session_size';
  static const keyTextScale = 'text_scale';
  static const keyTheme = 'theme';
  static const defaultModel = 'anthropic/claude-haiku-4.5';
  static const defaultSessionSize = 20;
  static const defaultTextScale = 1.15;

  Future<String?> get(String key) async {
    final rows = await db.query('settings',
        where: 'key = ?', whereArgs: [key], limit: 1);
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> set(String key, String value) async {
    await db.insert('settings', {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String> model() async => await get(keyModel) ?? defaultModel;

  /// How many cards one round contains, due and new together.
  Future<int> sessionSize() async =>
      int.tryParse(await get(keySessionSize) ?? '') ?? defaultSessionSize;

  /// Raw stored theme name; [AppTheme.byName] falls back when it is unknown.
  Future<String?> themeName() => get(keyTheme);

  Future<double> textScale() async =>
      double.tryParse(await get(keyTextScale) ?? '') ?? defaultTextScale;

  static const keySpeakingIndex = 'speaking_index';
  static const keySpeakingBest = 'speaking_best';

  Future<int> speakingIndex() async =>
      int.tryParse(await get(keySpeakingIndex) ?? '') ?? 0;

  Future<void> setSpeakingIndex(int i) => set(keySpeakingIndex, '$i');

  Future<int> speakingBest() async =>
      int.tryParse(await get(keySpeakingBest) ?? '') ?? 0;

  Future<void> setSpeakingBest(int v) => set(keySpeakingBest, '$v');

  static const _grammarDonePrefix = 'grammar_done:';

  Future<bool> isGrammarDone(String id) async =>
      await get('$_grammarDonePrefix$id') != null;

  /// Stores the completion date, so finished lessons count towards the streak
  /// the same way card reviews do. (Legacy rows hold '1' and have no date.)
  Future<void> setGrammarDone(String id) => set(
        '$_grammarDonePrefix$id',
        DateTime.now().toIso8601String(),
      );

  static const _sessionDonePrefix = 'session_done:';

  /// Records a *finished* card session. A half-done session is not activity —
  /// the streak only moves when an exercise is completed.
  Future<void> markSessionDone() {
    final now = DateTime.now().toIso8601String();
    return set('$_sessionDonePrefix$now', now);
  }

  static const _examPrefix = 'exam_attempt:';

  /// Keeps the whole marked paper so it can be reopened from the history.
  ///
  /// ponytail: never pruned. One exam is a few kB of JSON, so this only needs
  /// revisiting if someone sits hundreds of them.
  Future<void> saveExamAttempt(ExamAttempt attempt) => set(
    '$_examPrefix${attempt.takenAt.toIso8601String()}',
    jsonEncode(attempt.toJson()),
  );

  /// Past exams, newest first — the ISO timestamp in the key sorts by date.
  Future<List<ExamAttempt>> examAttempts() async {
    final rows = await db.query(
      'settings',
      columns: ['value'],
      where: 'key LIKE ?',
      whereArgs: ['$_examPrefix%'],
      orderBy: 'key DESC',
    );
    return [
      for (final r in rows)
        ExamAttempt.fromJson(
          jsonDecode(r['value'] as String) as Map<String, dynamic>,
        ),
    ];
  }

  /// When each exercise — grammar lesson or finished card session — was
  /// completed. Undated legacy grammar rows are skipped.
  Future<List<DateTime>> activityTimes() async {
    final rows = await db.query('settings',
        columns: ['value'],
        where: 'key LIKE ? OR key LIKE ?',
        whereArgs: ['$_grammarDonePrefix%', '$_sessionDonePrefix%']);
    return rows
        .map((r) => DateTime.tryParse(r['value'] as String? ?? ''))
        .nonNulls
        .toList();
  }
}
