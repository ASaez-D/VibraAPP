import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibra_project/widgets/custom_button.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('renders with correct text and icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              color: Colors.blue,
              icon: Icons.star,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Tap Me',
              color: Colors.green,
              icon: Icons.check,
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(wasPressed, true);
    });

    testWidgets('renders with custom color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Red Button',
              color: Colors.red,
              icon: Icons.warning,
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style;

      expect(style, isNotNull);
    });

    testWidgets('has full width', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Full Width',
              color: Colors.purple,
              icon: Icons.expand,
              onPressed: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('icon and text have correct colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'White Text',
              color: Colors.orange,
              icon: Icons.favorite,
              onPressed: () {},
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.white);

      final text = tester.widget<Text>(find.text('White Text'));
      expect(text.style?.color, Colors.white);
    });

    testWidgets('renders with different icons', (WidgetTester tester) async {
      final icons = [Icons.home, Icons.settings, Icons.favorite, Icons.search];

      for (final icon in icons) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton(
                text: 'Icon Test',
                color: Colors.blue,
                icon: icon,
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(icon), findsOneWidget);
      }
    });
  });
}
