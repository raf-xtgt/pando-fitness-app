import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/features/celebration/celebration_overlay.dart';

void main() {
  // Opens the overlay from a button; [closed] turns true when show() ends.
  Future<ValueNotifier<bool>> open(WidgetTester tester) async {
    final closed = ValueNotifier(false);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              await CelebrationOverlay.show(
                context,
                const CelebrationOverlay(
                  image: 'missing.png', // errorBuilder shows an empty box
                  title: 'You beat your goal!',
                  subtitle: 'All yours.',
                ),
              );
              closed.value = true;
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump(); // builds the route
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('You beat your goal!'), findsOneWidget);
    return closed;
  }

  testWidgets('closes by itself after the duration', (tester) async {
    final closed = await open(tester);
    await tester.pump(const Duration(seconds: 2));
    expect(closed.value, isFalse);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 300));
    expect(closed.value, isTrue);
    expect(find.text('You beat your goal!'), findsNothing);
  });

  testWidgets('closes early on a tap anywhere', (tester) async {
    final closed = await open(tester);
    await tester.tap(find.text('All yours.'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(closed.value, isTrue);
    // The timer must not pop the screen underneath later.
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('closes early on the close button', (tester) async {
    final closed = await open(tester);
    await tester.tap(find.byTooltip('Close'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(closed.value, isTrue);
    expect(find.text('open'), findsOneWidget);
  });
}
