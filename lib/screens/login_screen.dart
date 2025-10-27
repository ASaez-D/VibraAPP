import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido 🎧',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Iniciar sesión con Spotify',
                color: Colors.green,
                icon: Icons.music_note,
                onPressed: () {
                  print("Spotify login");
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Iniciar sesión con Google',
                color: Colors.blue,
                icon: Icons.login,
                onPressed: () {
                  print("Google login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}