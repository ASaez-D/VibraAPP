import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibra_project/widgets/themed_card.dart';

void main() {
  group('ThemedCard Widget Tests', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThemedCard(child: Text('Test Content'))),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('applies onTap when provided', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedCard(
              onTap: () {
                wasTapped = true;
              },
              child: const Text('Tappable Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(wasTapped, true);
    });

    testWidgets('renders without onTap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThemedCard(child: Text('Non-Tappable Card'))),
        ),
      );

      expect(find.byType(GestureDetector), findsNothing);
      expect(find.text('Non-Tappable Card'), findsOneWidget);
    });

    testWidgets('renders with custom padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThemedCard(
              padding: EdgeInsets.all(20),
              child: Text('Padded Card'),
            ),
          ),
        ),
      );

      expect(find.text('Padded Card'), findsOneWidget);
    });

    testWidgets('renders with custom border radius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThemedCard(borderRadius: 24.0, child: Text('Rounded Card')),
          ),
        ),
      );

      expect(find.text('Rounded Card'), findsOneWidget);
    });

    testWidgets('adapts to dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(body: ThemedCard(child: Text('Dark Mode Card'))),
        ),
      );

      expect(find.text('Dark Mode Card'), findsOneWidget);
    });

    testWidgets('adapts to light theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: ThemedCard(child: Text('Light Mode Card')),
          ),
        ),
      );

      expect(find.text('Light Mode Card'), findsOneWidget);
    });

    testWidgets('can wrap complex child widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemedCard(
              child: Column(
                children: const [
                  Text('Title'),
                  SizedBox(height: 10),
                  Text('Subtitle'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });
  });
}
