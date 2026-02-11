import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibra_project/widgets/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget Tests', () {
    testWidgets('renders with title only', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(icon: Icons.inbox, title: 'No Items'),
          ),
        ),
      );

      expect(find.text('No Items'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('renders with title and subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.event,
              title: 'No Events',
              subtitle: 'Check back later for updates',
            ),
          ),
        ),
      );

      expect(find.text('No Events'), findsOneWidget);
      expect(find.text('Check back later for updates'), findsOneWidget);
      expect(find.byIcon(Icons.event), findsOneWidget);
    });

    testWidgets('renders with custom icon color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.music_note,
              title: 'No Music',
              iconColor: Colors.purple,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.purple);
    });

    testWidgets('centers content vertically', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(icon: Icons.search, title: 'No Results'),
          ),
        ),
      );

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('adapts to dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: EmptyStateWidget(
              icon: Icons.error,
              title: 'Dark Mode Empty State',
            ),
          ),
        ),
      );

      expect(find.text('Dark Mode Empty State'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('adapts to light mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: EmptyStateWidget(
              icon: Icons.warning,
              title: 'Light Mode Empty State',
            ),
          ),
        ),
      );

      expect(find.text('Light Mode Empty State'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('shows subtitle only when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(icon: Icons.info, title: 'Title Only'),
          ),
        ),
      );

      // Should only have 3 children: Icon, SizedBox, Title Text
      final column = tester.widget<Column>(find.byType(Column));
      // With subtitle: Icon, SizedBox, Title, SizedBox, Subtitle = 5
      // Without subtitle: Icon, SizedBox, Title = 3
      expect(column.children.length, 3);
    });

    testWidgets('uses different icons correctly', (WidgetTester tester) async {
      final icons = [
        Icons.favorite_border,
        Icons.bookmark_border,
        Icons.star_border,
        Icons.calendar_today,
      ];

      for (final icon in icons) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyStateWidget(icon: icon, title: 'Test'),
            ),
          ),
        );

        expect(find.byIcon(icon), findsOneWidget);
      }
    });

    testWidgets('text is center aligned', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.camera,
              title: 'Centered Title',
              subtitle: 'Centered Subtitle',
            ),
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text('Centered Title'));
      expect(titleText.textAlign, TextAlign.center);

      final subtitleText = tester.widget<Text>(find.text('Centered Subtitle'));
      expect(subtitleText.textAlign, TextAlign.center);
    });
  });
}
