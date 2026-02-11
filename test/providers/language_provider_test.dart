import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibra_project/providers/language_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguageProvider Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('default locale is Spanish', () {
      final provider = LanguageProvider();
      expect(provider.locale, const Locale('es'));
    });

    test('setLocale changes locale and notifies listeners', () async {
      final provider = LanguageProvider();
      bool notified = false;

      provider.addListener(() {
        notified = true;
      });

      await provider.setLocale(const Locale('en'));

      expect(provider.locale, const Locale('en'));
      expect(notified, true);
    });

    test('setLocale persists locale to SharedPreferences', () async {
      final provider = LanguageProvider();

      await provider.setLocale(const Locale('fr'));

      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('selected_language');

      expect(savedLanguage, 'fr');
    });

    test('setLocale only accepts supported languages', () async {
      final provider = LanguageProvider();
      final initialLocale = provider.locale;

      // Try to set unsupported language
      await provider.setLocale(const Locale('zh'));

      // Locale should not change
      expect(provider.locale, initialLocale);
    });

    test(
      'loads saved language from SharedPreferences on initialization',
      () async {
        // Set up saved preference
        SharedPreferences.setMockInitialValues({'selected_language': 'ca'});

        final provider = LanguageProvider();

        // Give time for async _loadLanguage to complete
        await Future.delayed(const Duration(milliseconds: 100));

        expect(provider.locale, const Locale('ca'));
      },
    );

    test('supports all required languages', () async {
      final provider = LanguageProvider();
      final supportedLanguages = ['es', 'en', 'fr', 'pt', 'ca', 'de'];

      for (final langCode in supportedLanguages) {
        await provider.setLocale(Locale(langCode));
        expect(provider.locale.languageCode, langCode);
      }
    });

    test('setLocale with same locale still notifies listeners', () async {
      final provider = LanguageProvider();
      int notificationCount = 0;

      provider.addListener(() {
        notificationCount++;
      });

      await provider.setLocale(const Locale('es'));

      // Should notify at least once
      expect(notificationCount, greaterThanOrEqualTo(1));
    });

    test('handles null saved language gracefully', () async {
      SharedPreferences.setMockInitialValues({});

      final provider = LanguageProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      // Should default to Spanish
      expect(provider.locale, const Locale('es'));
    });
  });
}
