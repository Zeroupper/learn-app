import 'package:sqflite/sqflite.dart';

/// Key-value settings stored in SQLite (non-secret values only;
/// the API key lives in flutter_secure_storage).
class SettingsRepository {
  final Database db;
  SettingsRepository(this.db);

  static const keyModel = 'ai_model';
  static const keyDailyNewCap = 'daily_new_cap';
  static const keyTextScale = 'text_scale';
  static const defaultModel = 'anthropic/claude-haiku-4.5';
  static const defaultDailyNewCap = 10;
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

  Future<int> dailyNewCap() async =>
      int.tryParse(await get(keyDailyNewCap) ?? '') ?? defaultDailyNewCap;

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

  Future<bool> isGrammarDone(String id) async =>
      await get('grammar_done:$id') == '1';

  Future<void> setGrammarDone(String id) => set('grammar_done:$id', '1');
}
