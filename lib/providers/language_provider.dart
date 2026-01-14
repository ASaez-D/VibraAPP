import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('es'); // Idioma por defecto

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Cargar el idioma guardado al iniciar la app
  void _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  // Cambiar el idioma y guardarlo
  void changeLanguage(Locale type) async {
    final prefs = await SharedPreferences.getInstance();
    _locale = type;
    await prefs.setString('language_code', type.languageCode);
    notifyListeners();
  }
}