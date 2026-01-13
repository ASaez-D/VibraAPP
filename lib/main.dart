import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

// --------------------------------------------------------
// NOTIFICADORES GLOBALES
// --------------------------------------------------------

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
final ValueNotifier<double> textScaleNotifier = ValueNotifier(1.0); 

// --------------------------------------------------------
// LÓGICA DE PERSISTENCIA
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
// MAIN (CORREGIDO)
// --------------------------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('es_ES', null);

  themeNotifier.value = await _loadThemeMode(); 
  
  themeNotifier.addListener(() {
    _saveThemeMode(themeNotifier.value);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Escuchamos cambios en la escala de texto
    return ValueListenableBuilder<double>(
      valueListenable: textScaleNotifier,
      builder: (context, currentScale, child) {

        // 2. Escuchamos cambios en el tema
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, child) {
            
            return MaterialApp(
              title: 'Vibra',
              debugShowCheckedModeBanner: false,

              // 3. AQUÍ ESTÁ LA MAGIA: Usamos 'builder' para inyectar el textScale
              builder: (context, child) {
                return MediaQuery(
                  // Usamos copyWith para mantener otras propiedades del sistema (brillo, tamaño, etc.)
                  // y solo sobreescribimos el factor de escala de texto.
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(currentScale), // <--- CAMBIO IMPORTANTE: 'textScaleFactor' está obsoleto en Flutter nuevo, usa 'textScaler'
                  ),
                  child: child!, // Renderizamos la pantalla que toque
                );
              },

              themeMode: currentMode,

              // TEMA CLARO
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.green,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF54FF78),
                  brightness: Brightness.light,
                ),
                useMaterial3: true, // Recomendado para Flutter moderno
              ),

              // TEMA OSCURO
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF0C0C0C),
                primarySwatch: Colors.green,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF0C0C0C),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF54FF78),
                  brightness: Brightness.dark,
                  surface: const Color(0xFF1C1C1E), // Color para tarjetas en modo oscuro
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