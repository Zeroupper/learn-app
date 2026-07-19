import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:learn_app/controllers/study_controller.dart';
import 'package:learn_app/models/review_state.dart';
import 'package:learn_app/models/vocab_word.dart';
import 'package:learn_app/services/session_builder.dart';
import 'package:learn_app/services/tts_service.dart';
import 'package:learn_app/screens/study_screen.dart';

void main() {
  const word = VocabWord(
    id: 1,
    en: 'dog',
    enAccepted: [],
    hu: ['kutya'],
    level: CefrLevel.a1,
    pos: 'noun',
  );

  StudyController makeController() => StudyController(
        queue: const [SessionCard(1, Direction.enToHu)],
        lookup: (_) => word,
        loadState: (id, dir) async =>
            ReviewState(wordId: id, direction: dir),
        saveReview: (_, _) async {},
      );

  Widget wrap(StudyController c) => Provider<TtsService>(
        create: (_) => TtsService(),
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

    // Proceed -> session summary.
    await tester.tap(find.text('Tovább'));
    await tester.pumpAndSettle();
    expect(find.text('Kész!'), findsOneWidget);
  });
}
