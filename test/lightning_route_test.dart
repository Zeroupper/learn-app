import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/widgets/lightning_route.dart';

void main() {
  Future<void> strike(WidgetTester t) async {
    await t.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              lightningStrikeRoute(const Scaffold(body: Text('struck'))),
            ),
            child: const Text('go'),
          ),
        ),
      ),
    ));
    await t.tap(find.text('go'));
  }

  testWidgets('the page lands, and the flash does not linger', (t) async {
    await strike(t);
    await t.pump();

    // Mid-strike the page exists but is still being revealed.
    await t.pump(const Duration(milliseconds: 120));
    expect(find.text('struck'), findsOneWidget);
    expect(t.widget<Opacity>(find.byType(Opacity).first).opacity, lessThan(1.0));

    // Once it settles the page is fully revealed — no dimming left behind.
    await t.pumpAndSettle();
    expect(find.text('struck'), findsOneWidget);
    expect(t.widget<Opacity>(find.byType(Opacity).first).opacity, 1.0);
  });

  testWidgets('popping returns to where it struck from', (t) async {
    await strike(t);
    await t.pumpAndSettle();
    expect(find.text('go'), findsNothing);

    final ctx = t.element(find.text('struck'));
    Navigator.of(ctx).pop();
    await t.pumpAndSettle();
    expect(find.text('go'), findsOneWidget);
  });
}
