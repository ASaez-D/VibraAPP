import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
// ¡IMPORTACIÓN NECESARIA!
import 'package:shared_preferences/shared_preferences.dart'; 

// --------------------------------------------------------
// NOTIFICADORES GLOBALES
// --------------------------------------------------------

// 1. NOTIFICADOR DE TEMA
// Esto nos permitirá cambiar el tema desde cualquier pantalla
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

// 2. NOTIFICADOR DE ESCALA DE TEXTO (NUEVO)
// 1.0 = Texto Normal (por defecto)
// 1.3 = Texto Grande (aproximadamente 30% más grande)
final ValueNotifier<double> textScaleNotifier = ValueNotifier(1.0); 

// --------------------------------------------------------
// LÓGICA DE PERSISTENCIA (AÑADIDA)
// --------------------------------------------------------

const String _themeKey = 'userThemeMode';

// Función para cargar el tema guardado
Future<ThemeMode> _loadThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final String? savedTheme = prefs.getString(_themeKey);

  if (savedTheme == 'light') {
    return ThemeMode.light;
  } else if (savedTheme == 'dark') {
    return ThemeMode.dark;
  } 
  // Valor por defecto si no hay nada guardado o si es 'system'
  return ThemeMode.system;
}

// Función para guardar el tema actual
Future<void> _saveThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  // Guardamos el enum como un string ('light', 'dark', o 'system')
  await prefs.setString(_themeKey, mode.toString().split('.').last);
}

// --------------------------------------------------------
// MAIN (MODIFICADO)
// --------------------------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('es_ES', null);

  // 1. Cargar el tema guardado ANTES de ejecutar la app
  themeNotifier.value = await _loadThemeMode(); 
  
  // 2. Escuchar cambios en el notifier y guardar el nuevo valor automáticamente
  themeNotifier.addListener(() {
    _saveThemeMode(themeNotifier.value);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Envolvemos todo el MaterialApp en ValueListenableBuilder para la ESCALA DE TEXTO
    return ValueListenableBuilder<double>(
      valueListenable: textScaleNotifier,
      builder: (context, currentScale, child) {

        // 2. Envolvemos el resultado en ValueListenableBuilder para el TEMA
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, child) {
            
            // 3. Aplicamos la escala de texto usando MediaQuery
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: currentScale, // <--- APLICAMOS LA ESCALA AQUÍ
              ),
              child: MaterialApp(
                title: 'Vibra',
                debugShowCheckedModeBanner: false,

                // 4. CONFIGURACIÓN DEL MODO (Controlado por el usuario)
                themeMode: currentMode,

                // TEMA CLARO (FONDO BLANCO)
                theme: ThemeData(
                  brightness: Brightness.light,
                  scaffoldBackgroundColor: Colors.white, // Fondo blanco explícito
                  primarySwatch: Colors.green,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black), // Iconos negros
                    titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                   // Definimos el esquema de colores para usarlo en otros lados
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF54FF78),
                    brightness: Brightness.light,
                  ),
                ),

                // TEMA OSCURO (FONDO NEGRO - TU DISEÑO ORIGINAL)
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: const Color(0xFF0C0C0C), // Tu negro personalizado
                  primarySwatch: Colors.green,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Color(0xFF0C0C0C),
                    iconTheme: IconThemeData(color: Colors.white),
                  ),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF54FF78),
                    brightness: Brightness.dark,
                  ),
                ),

                home: const LoginScreen(),
              ),
            );
          },
        );
      },
    );
  }
}