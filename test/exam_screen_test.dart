import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:learn_app/data/app_database.dart';
import 'package:learn_app/data/settings_repository.dart';
import 'package:learn_app/models/exam.dart';
import 'package:learn_app/screens/exam_screen.dart';
import 'package:learn_app/services/ai_service.dart';
import 'package:learn_app/services/tts_service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A cut-down exam with the shape that matters here: two reading parts that
/// have to share one page, and a section either side of them.
const _exam = {
  'level': 'a1',
  'parts': [
    {
      'section': 'grammar',
      'instructions_hu': 'Válaszd ki a helyes alakot.',
      'passage_title': '',
      'passage': '',
      'questions': [
        {
          'id': 'g1',
          'prompt': 'She ___ a cat.',
          'options': ['have', 'has'],
          'correct_index': 1,
        },
      ],
    },
    {
      'section': 'reading',
      'instructions_hu': 'Olvasd el.',
      'passage_title': 'The Park',
      'passage': 'Anna went to the park.',
      'questions': [
        {
          'id': 'r1',
          'prompt': 'Where did Anna go?',
          'options': ['home', 'the park'],
          'correct_index': 1,
        },
      ],
    },
    {
      'section': 'reading',
      'instructions_hu': 'Olvasd el.',
      'passage_title': 'The Shop',
      'passage': 'Bela bought bread.',
      'questions': [
        {
          'id': 'r2',
          'prompt': 'What did Bela buy?',
          'options': ['milk', 'bread'],
          'correct_index': 1,
        },
      ],
    },
    {
      'section': 'writing',
      'instructions_hu': 'Írj néhány mondatot.',
      'passage_title': '',
      'passage': '',
      'questions': [
        {
          'id': 'w1',
          'prompt': 'Describe your day.',
          'options': <String>[],
          'correct_index': -1,
        },
      ],
    },
  ],
};

const _marks = {
  'marks': [
    {'id': 'g1', 'score': 100, 'explanation_hu': '', 'expected': 'has'},
    {'id': 'r1', 'score': 100, 'explanation_hu': '', 'expected': 'the park'},
    {'id': 'r2', 'score': 0, 'explanation_hu': 'Kenyeret vett.', 'expected': 'bread'},
    {'id': 'w1', 'score': 100, 'explanation_hu': '', 'expected': 'I woke up…'},
  ],
  'overall_feedback_hu': 'Szép munka.',
};

void main() {
  late SettingsRepository settings;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: AppDatabase.createSchema,
      ),
    );
    settings = SettingsRepository(db);
  });

  /// Answers the exam call first, the marking call second.
  http.Client fakeAi() {
    var call = 0;
    return MockClient((_) async {
      final payload = call++ == 0 ? _exam : _marks;
      return http.Response(
        jsonEncode({
          'choices': [
            {
              'message': {'content': jsonEncode(payload)},
            },
          ],
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
  }

  Widget wrap(Widget child) => MultiProvider(
    providers: [
      Provider<TtsService>(create: (_) => TtsService()),
      Provider<SettingsRepository>.value(value: settings),
      Provider<AiService>(
        create: (_) => AiService(
          client: fakeAi(),
          getApiKey: () async => 'key',
          getModel: () async => 'model',
        ),
      ),
    ],
    child: MaterialApp(home: child),
  );

  testWidgets('leaving the screen does not blow up on dispose', (tester) async {
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const ExamScreen())),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Szintvizsga'), findsWidgets);

    // The screen resolves TtsService in dispose; looking it up that late used
    // to throw "Looking up a deactivated widget's ancestor is unsafe".
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('one section per page, forwards and back, then submit', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const ExamScreen()));
    await tester.pumpAndSettle();

    // No level is passed before the first exam.
    expect(find.text('A1 még nincs meg'), findsOneWidget);

    await tester.ensureVisible(find.text('Vizsga indítása'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vizsga indítása'));
    await tester.pumpAndSettle();

    // Page 1 of 3: grammar only — reading is not on this page.
    expect(find.text('1/3 — Nyelvtan'), findsOneWidget);
    expect(find.textContaining('She ___ a cat.'), findsOneWidget);
    expect(find.textContaining('Where did Anna go?'), findsNothing);
    expect(find.text('0/1 megválaszolva'), findsOneWidget);

    await tester.tap(find.text('has'));
    await tester.pump();
    expect(find.text('1/1 megválaszolva'), findsOneWidget);

    await tester.tap(find.text('Tovább'));
    await tester.pumpAndSettle();

    // Page 2: both reading passages share it, numbered straight through.
    expect(find.text('2/3 — Olvasás'), findsOneWidget);
    expect(find.text('1. szöveg'), findsOneWidget);
    expect(find.textContaining('1. Where did Anna go?'), findsOneWidget);

    // Back keeps the answer already given.
    await tester.tap(find.text('Vissza'));
    await tester.pumpAndSettle();
    expect(find.text('1/1 megválaszolva'), findsOneWidget);

    await tester.tap(find.text('Tovább'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('the park'));
    await tester.pump();

    // The second passage is further down the same page.
    await tester.scrollUntilVisible(find.text('bread'), 200);
    expect(find.text('2. szöveg'), findsOneWidget);
    expect(find.textContaining('2. What did Bela buy?'), findsOneWidget);
    // scrollUntilVisible stops as soon as the row is built, which can still be
    // under the nav bar — tapping there would hit "Tovább" instead.
    await tester.ensureVisible(find.text('bread'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('bread'));
    await tester.pump();
    expect(find.text('2/2 megválaszolva'), findsOneWidget);

    await tester.tap(find.text('Tovább'));
    await tester.pumpAndSettle();

    // Last page submits instead of advancing.
    expect(find.text('3/3 — Írás'), findsOneWidget);
    expect(find.text('Tovább'), findsNothing);
    await tester.enterText(find.byType(TextField), 'I woke up early.');
    await tester.tap(find.text('Beadás'));
    await tester.pumpAndSettle();

    expect(find.text('Eredmény'), findsOneWidget);

    // The paper is filed with every answer given across the pages.
    // examAttempts() hits the real sqflite-ffi DB; running it in the fake-async
    // zone never completes, so escape to real async with runAsync.
    late final List<ExamAttempt> history;
    await tester.runAsync(() async {
      history = await settings.examAttempts();
    });
    expect(history.single.answers['g1'], 'has');
    expect(history.single.answers['w1'], 'I woke up early.');
    expect(history.single.result.passed, isTrue, reason: 'reading at 50% is the pass floor');
  });
}
