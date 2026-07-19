import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Opens the on-device SQLite database and creates schema v1.
/// Only mutable state lives here; vocabulary is a bundled JSON asset.
class AppDatabase {
  static Future<Database> open() async {
    final dir = await getDatabasesPath();
    return openDatabase(
      p.join(dir, 'learn_app.db'),
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: createSchema,
    );
  }

  static Future<void> createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE review_state (
        word_id INTEGER NOT NULL,
        direction TEXT NOT NULL,
        repetitions INTEGER NOT NULL DEFAULT 0,
        ease_factor REAL NOT NULL DEFAULT 2.5,
        interval_days INTEGER NOT NULL DEFAULT 0,
        due_at INTEGER,
        lapses INTEGER NOT NULL DEFAULT 0,
        last_reviewed_at INTEGER,
        PRIMARY KEY (word_id, direction)
      )
    ''');
    await db.execute('CREATE INDEX idx_review_state_due ON review_state(due_at)');
    await db.execute('''
      CREATE TABLE review_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER NOT NULL,
        direction TEXT NOT NULL,
        reviewed_at INTEGER NOT NULL,
        quality INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_review_log_at ON review_log(reviewed_at)');
    await db.execute('CREATE TABLE settings (key TEXT PRIMARY KEY, value TEXT)');
  }
}
