import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/controllers/dashboard_controller.dart';
import 'package:learn_app/data/app_database.dart';
import 'package:learn_app/data/settings_repository.dart';
import 'package:learn_app/data/srs_repository.dart';
import 'package:learn_app/data/vocab_repository.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/models/vocab_word.dart';
import 'package:learn_app/widgets/app_shell.dart';
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

  /// Real sqflite I/O has to run outside the fake-async zone that
  /// [testWidgets] installs, hence [WidgetTester.runAsync].
  Future<StatsStore> loadedStore(WidgetTester t, {bool withReview = false}) async {
    late StatsStore store;
    await t.runAsync(() async {
      // sqflite caches open databases by path, so ':memory:' is shared between
      // tests unless it is dropped first.
      await databaseFactory.deleteDatabase(inMemoryDatabasePath);
      final db = await databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options:
            OpenDatabaseOptions(version: 1, onCreate: AppDatabase.createSchema),
      );
      final srs = SrsRepository(db);
      final settings = SettingsRepository(db);
      if (withReview) {
        await srs.save(
          ReviewState(wordId: 1, direction: Direction.enToHu),
          quality: 5,
        );
        await settings.markSessionDone(); // only finished sessions streak
      }
      store = StatsStore(VocabRepository([word]), srs, settings);
      await store.refresh();
    });
    return store;
  }

  Future<void> pump(WidgetTester t, StatsStore store, Widget shell) async {
    await t.pumpWidget(ChangeNotifierProvider<StatsStore>.value(
      value: store,
      child: MaterialApp(home: shell),
    ));
    await t.pump();
  }

  testWidgets('shows title, both counters and the settings gear', (t) async {
    final store = await loadedStore(t, withReview: true);
    await pump(t, store,
        const AppShell(title: 'Kezdőlap', showSettings: true, child: SizedBox()));

    expect(find.text('Kezdőlap'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2)); // streak: 1 day, learned: 1 word
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    expect(find.byIcon(Icons.menu_book), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // everyone starts with 3 hearts
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('zero streak greys the flame; gear hidden off the home tab',
      (t) async {
    final store = await loadedStore(t);
    await pump(t, store, const AppShell(title: 'Nyelvtan', child: SizedBox()));

    expect(find.text('0'), findsNWidgets(2));
    expect(find.byIcon(Icons.settings_outlined), findsNothing);
    final flame = t.widget<Icon>(find.byIcon(Icons.local_fire_department));
    expect(flame.color, Colors.grey);
  });
}
