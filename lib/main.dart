import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // <--- COMENTADO
import 'package:intl/date_symbol_data_local.dart'; 

import 'package:vibra_project/screens/calendar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. COMENTA ESTA LÍNEA SI NO TIENES EL JSON DE FIREBASE AÚN
  // await Firebase.initializeApp(); 
  
  // 2. INICIALIZAR FECHAS (Esto sí es necesario para el calendario)
  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibra',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.greenAccent, 
          secondary: Colors.greenAccent,
        ),
        useMaterial3: true,
      ),
      // Iniciamos directo en Home
      home: const HomeScreen(displayName: "Usuario"), 
      
      debugShowCheckedModeBanner: false,
    );
  }
}