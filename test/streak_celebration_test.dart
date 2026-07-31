import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/controllers/dashboard_controller.dart';
import 'package:learn_app/data/app_database.dart';
import 'package:learn_app/data/settings_repository.dart';
import 'package:learn_app/data/srs_repository.dart';
import 'package:learn_app/data/vocab_repository.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/models/vocab_word.dart';
import 'package:learn_app/screens/streak_celebration_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  const word = VocabWord(
    id: 1,
    en: 'dog',
    enAccepted: [],
    hu: ['kutya'],
    level: CefrLevel.a1,
    pos: 'noun',
  );

  /// A store whose day already contains [finishedToday] completed exercises.
  Future<StatsStore> storeWith(WidgetTester t, int finishedToday) async {
    late StatsStore store;
    await t.runAsync(() async {
      await databaseFactory.deleteDatabase(inMemoryDatabasePath);
      final db = await databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options:
            OpenDatabaseOptions(version: 1, onCreate: AppDatabase.createSchema),
      );
      final srs = SrsRepository(db);
      final settings = SettingsRepository(db);
      for (var i = 0; i < finishedToday; i++) {
        await srs.save(ReviewState(wordId: 1, direction: Direction.enToHu),
            quality: 5);
        await settings.markSessionDone();
        // Markers are keyed by timestamp; keep them distinct.
        await Future<void>.delayed(const Duration(milliseconds: 2));
      }
      store = StatsStore(VocabRepository([word]), srs, settings);
      await store.refresh();
    });
    return store;
  }

  /// Pumps a button that runs the gate, taps it, and reports whether the
  /// celebration screen was pushed.
  Future<bool> tapAndCheck(WidgetTester t, StatsStore store) async {
    await t.pumpWidget(ChangeNotifierProvider<StatsStore>.value(
      value: store,
      child: MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => maybeCelebrateStreak(context),
            child: const Text('go'),
          ),
        ),
      ),
    ));
    await t.tap(find.text('go'));
    // Explicit pumps, not pumpAndSettle: the fire burns on a repeating
    // controller, so the tree never goes quiet.
    await t.pump();
    await t.pump(const Duration(milliseconds: 1000)); // lightning strike
    return find.byType(StreakCelebrationScreen).evaluate().isNotEmpty;
  }

  testWidgets('celebrates on the first finished exercise of the day', (t) async {
    expect(await tapAndCheck(t, await storeWith(t, 1)), isTrue);
    await t.pump(const Duration(seconds: 4)); // let the rollover land
    expect(find.text('1'), findsOneWidget); // day one of the streak
    expect(find.text('napos sorozat indul!'), findsOneWidget);
  });

  testWidgets('stays quiet on later exercises the same day', (t) async {
    expect(await tapAndCheck(t, await storeWith(t, 2)), isFalse);
  });

  testWidgets('stays quiet when nothing has been finished yet', (t) async {
    expect(await tapAndCheck(t, await storeWith(t, 0)), isFalse);
  });

  testWidgets('holds yesterday\'s streak, then rolls over to today\'s',
      (t) async {
    await t.pumpWidget(
        const MaterialApp(home: StreakCelebrationScreen(streak: 7)));
    await t.pump();

    // Opens on the old number so the increment is visible.
    expect(find.text('6'), findsOneWidget);
    expect(find.text('7'), findsNothing);

    // Mid-roll both are on screen, stacked, as one slides out and one in.
    await t.pump(const Duration(milliseconds: 1000));
    expect(find.text('6'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);

    // Once it settles only the new streak is left.
    await t.pump(const Duration(seconds: 2));
    expect(find.text('6'), findsNothing);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('napos sorozat!'), findsOneWidget);
  });
}
