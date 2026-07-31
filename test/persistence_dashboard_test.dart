import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:learn_app/controllers/dashboard_controller.dart';
import 'package:learn_app/controllers/study_controller.dart';
import 'package:learn_app/data/app_database.dart';
import 'package:learn_app/data/settings_repository.dart';
import 'package:learn_app/data/srs_repository.dart';
import 'package:learn_app/data/vocab_repository.dart';
import 'package:learn_app/models/exam.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/models/vocab_word.dart';
import 'package:learn_app/services/session_builder.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<Database> freshDb() => databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(version: 1, onCreate: AppDatabase.createSchema),
      );

  const word = VocabWord(
    id: 1,
    en: 'dog',
    enAccepted: [],
    hu: ['kutya'],
    level: CefrLevel.a1,
    pos: 'noun',
  );
  final vocab = VocabRepository([word]);

  test('a completed card is persisted and shows up in the dashboard', () async {
    final db = await freshDb();
    final srs = SrsRepository(db);
    final now = DateTime(2026, 7, 3, 10);

    final controller = StudyController.withRepo(
      queue: const [SessionCard(1, Direction.enToHu)],
      lookup: (_) => word,
      srs: srs,
      clock: () => now,
    );

    await controller.check('kutya'); // correct
    await controller.proceed(); // advances -> finished

    // Persistence
    final states = await srs.allStates();
    expect(states.length, 1, reason: 'review_state row written');
    final times = await srs.reviewTimes();
    expect(times.length, 1, reason: 'review_log row written');

    // Dashboard reflects it
    final stats = await DashboardController.load(vocab, srs, SettingsRepository(db), now: now);
    expect(stats.reviewsToday, 1);
    expect(stats.learnedWords, 1);
    final a1 = stats.levels.firstWhere((l) => l.level == CefrLevel.a1);
    expect(a1.learned, 1);

    await db.close();
  });

  test('sat exams are stored newest first and do not count as activity',
      () async {
    final db = await freshDb();
    final settings = SettingsRepository(db);

    ExamAttempt attempt(DateTime at, String level) => ExamAttempt(
          takenAt: at,
          exam: Exam(level: level, parts: [
            ExamPart(section: ExamSection.grammar, questions: [
              const ExamQuestion(id: 'g1', prompt: 'q', options: ['a', 'b']),
            ]),
          ]),
          answers: const {'g1': 'b'},
          marks: const [QuestionMark(id: 'g1', score: 100, expected: 'b')],
        );

    await settings.saveExamAttempt(attempt(DateTime(2026, 7, 3, 10), 'a1'));
    await settings.saveExamAttempt(attempt(DateTime(2026, 7, 30, 18), 'a2'));

    final history = await settings.examAttempts();
    expect(history.map((a) => a.exam.level), ['a2', 'a1']);
    expect(history.first.answers['g1'], 'b');
    expect(history.first.result.averagePercent, 100);

    // Exams live in the same settings table as the streak's activity rows;
    // the two must not read each other's keys.
    expect(await settings.activityTimes(), isEmpty);

    await db.close();
  });
}
