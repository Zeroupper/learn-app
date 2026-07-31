import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/widgets/thunderstorm.dart';

void main() {
  testWidgets('strikes across a full cycle and disposes its ticker', (t) async {
    await t.pumpWidget(const MaterialApp(home: Thunderstorm()));
    await t.pump();

    // Step through two whole cycles, crossing every scripted strike. A painter
    // that throws mid-flash surfaces here rather than on a phone.
    for (var i = 0; i < 20; i++) {
      await t.pump(const Duration(milliseconds: 500));
    }
    expect(find.byType(Thunderstorm), findsOneWidget);

    // A repeating controller left running past disposal fails the test here.
    await t.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(find.byType(Thunderstorm), findsNothing);
  });

  testWidgets('fills whatever space it is given', (t) async {
    await t.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 300, height: 400, child: Thunderstorm()),
        ),
      ),
    );
    await t.pump(const Duration(milliseconds: 100));
    expect(t.getSize(find.byType(Thunderstorm)), const Size(300, 400));
  });
}
