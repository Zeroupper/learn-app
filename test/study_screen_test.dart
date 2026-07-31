import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:learn_app/controllers/study_controller.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/models/vocab_word.dart';
import 'package:learn_app/services/session_builder.dart';
import 'package:learn_app/services/tts_service.dart';
import 'package:learn_app/screens/study_screen.dart';
import 'package:learn_app/controllers/dashboard_controller.dart';
import 'package:learn_app/data/app_database.dart';
import 'package:learn_app/data/settings_repository.dart';
import 'package:learn_app/data/srs_repository.dart';
import 'package:learn_app/data/vocab_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late StatsStore stats;
  late SettingsRepository settings;

  const word = VocabWord(
    id: 1,
    en: 'dog',
    enAccepted: [],
    hu: ['kutya'],
    level: CefrLevel.a1,
    pos: 'noun',
  );

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options:
          OpenDatabaseOptions(version: 1, onCreate: AppDatabase.createSchema),
    );
    final srs = SrsRepository(db);
    settings = SettingsRepository(db);
    // A session was already finished today, so completing this one is the
    // day's second — no streak screen over the summary this test checks.
    await settings.markSessionDone();
    stats = StatsStore(VocabRepository([word]), srs, settings);
    await stats.refresh();
  });

  StudyController makeController() => StudyController(
        queue: const [SessionCard(1, Direction.enToHu)],
        lookup: (_) => word,
        loadState: (id, dir) async =>
            ReviewState(wordId: id, direction: dir),
        saveReview: (_, _) async {},
      );

  Widget wrap(StudyController c) => MultiProvider(
        providers: [
          Provider<TtsService>(create: (_) => TtsService()),
          ChangeNotifierProvider<StatsStore>.value(value: stats),
          Provider<SettingsRepository>.value(value: settings),
        ],
        child: MaterialApp(home: StudyScreen(controller: c)),
      );

  testWidgets('wrong answer requires acknowledgement, card returns, then finishes',
      (tester) async {
    await tester.pumpWidget(wrap(makeController()));
    await tester.pumpAndSettle();

    // Wrong answer.
    await tester.enterText(find.byType(TextField), 'cat');
    await tester.tap(find.text('Ellenőrzés'));
    await tester.pumpAndSettle();

    expect(find.text('Nem helyes'), findsOneWidget);
    expect(find.text('Megértettem'), findsOneWidget);
    expect(find.text('Tovább'), findsNothing); // must acknowledge, not skip

    // Acknowledge -> the failed card is re-queued and shown again.
    await tester.tap(find.text('Megértettem'));
    await tester.pumpAndSettle();
    expect(find.text('dog'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Correct this time.
    await tester.enterText(find.byType(TextField), 'kutya');
    await tester.tap(find.text('Ellenőrzés'));
    await tester.pumpAndSettle();
    expect(find.text('Helyes!'), findsOneWidget);

    // Proceed -> session summary. runAsync because finishing a session writes
    // its completion marker and reloads stats through the real database.
    await tester.runAsync(() => tester.tap(find.text('Tovább')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Kész!'), findsOneWidget);
  });
}
