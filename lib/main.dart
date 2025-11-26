import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vibra_project/screens/calendar_screen.dart';
import 'screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      ),
      home: const LoginScreen(),   
      debugShowCheckedModeBanner: false,
    );
  }
}
