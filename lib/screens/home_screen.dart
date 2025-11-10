import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String displayName;
  final bool isGoogle; // Nuevo: indica si el usuario vino de Google

  const HomeScreen({super.key, required this.displayName, this.isGoogle = false});

  Future<void> _signOut(BuildContext context) async {
    try {
      // Si es Google, cerrar sesión de Firebase y Google
      if (isGoogle) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
      }

      // Volver al LoginScreen limpiando la pila
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: const Text('Vibra'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Hola, $displayName!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido a Vibra 🎵',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _signOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
