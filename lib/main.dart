import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <--- 1. IMPORTAR DOTENV

// --- IMPORTACIONES INTERNAS ---
import 'l10n/app_localizations.dart';
import 'providers/language_provider.dart';
import 'screens/login_screen.dart';

// --------------------------------------------------------
// NOTIFICADORES GLOBALES
// --------------------------------------------------------
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
final ValueNotifier<double> textScaleNotifier = ValueNotifier(1.0);

// --------------------------------------------------------
// LÓGICA DE PERSISTENCIA DE TEMA
// --------------------------------------------------------
const String _themeKey = 'userThemeMode';

Future<ThemeMode> _loadThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final String? savedTheme = prefs.getString(_themeKey);

  if (savedTheme == 'light') return ThemeMode.light;
  if (savedTheme == 'dark') return ThemeMode.dark;
  return ThemeMode.system;
}

Future<void> _saveThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_themeKey, mode.toString().split('.').last);
}

// --------------------------------------------------------
// MAIN
// --------------------------------------------------------
void main() async {
  // Asegura que el motor de Flutter esté listo antes de ejecutar código asíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // --- 2. CARGAR VARIABLES DE ENTORNO (CRUCIAL PARA SPOTIFY) ---
  await dotenv.load(fileName: ".env");

  // Inicializar Firebase
  await Firebase.initializeApp();

  // Inicializamos soporte de fechas para TODOS los idiomas soportados
  await initializeDateFormatting('es_ES', null);
  await initializeDateFormatting('en_US', null);
  await initializeDateFormatting('fr_FR', null);
  await initializeDateFormatting('pt_PT', null);
  await initializeDateFormatting('ca_ES', null);
  await initializeDateFormatting('de_DE', null);

  // Cargamos la preferencia de tema guardada
  themeNotifier.value = await _loadThemeMode();

  themeNotifier.addListener(() {
    _saveThemeMode(themeNotifier.value);
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el estado del idioma del Provider
    final languageProvider = Provider.of<LanguageProvider>(context);

    return ValueListenableBuilder<double>(
      valueListenable: textScaleNotifier,
      builder: (context, currentScale, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, child) {
            return MaterialApp(
              title: 'Vibra',
              debugShowCheckedModeBanner: false,

              // --- CONFIGURACIÓN DE IDIOMA ---
              locale: languageProvider.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              // --- ESCALADO DE TEXTO ACCESIBLE ---
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(currentScale),
                  ),
                  child: child!,
                );
              },

              // --- TEMAS ---
              themeMode: currentMode,

              // TEMA CLARO
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF54FF78),
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              ),

              // TEMA OSCURO
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF0C0C0C),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF0C0C0C),
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF54FF78),
                  brightness: Brightness.dark,
                  surface: const Color(0xFF1C1C1E),
                ),
                useMaterial3: true,
              ),

              home: const LoginScreen(),
            );
          },
        );
      },
    );
  }
}
