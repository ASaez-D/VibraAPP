import 'package:flutter/material.dart';
import '../services/spotify_auth.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Vibra
              SizedBox(
                height: 110,
                width: 110,
                child: Image.asset('assets/vibraLogo.png', fit: BoxFit.cover),
              ),

              const SizedBox(height: 24),

              // Nombre de la app
              const Text(
                'Vibra',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 50),

              // Botón Spotify
              _buildLoginButton(
                gradientColors: [
                  Colors.greenAccent.shade700,
                  Colors.greenAccent.shade400,
                ],
                iconPath: 'assets/spotifyLogo.png',
                text: 'Iniciar con Spotify',
                textColor: Colors.black,
                onPressed: () async {
                  final spotify = SpotifyAuth();
                  try {
                    final profile = await spotify.login();
                    final displayName = profile['display_name'] ?? 'Usuario';

                    // Va a HomeScreen.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(displayName: displayName),
                      ),
                    );
                  } catch (e) {
                    // Excepcion.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al iniciar sesión con Spotify: $e'),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 25),

              // Divider
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      color: Colors.white24,
                      thickness: 1,
                      endIndent: 10,
                    ),
                  ),
                  Text(
                    'o',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white24,
                      thickness: 1,
                      indent: 10,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Botón Google
              _buildLoginButton(
                gradientColors: [
                  Colors.blueAccent.shade700,
                  Colors.blueAccent.shade400,
                ],
                iconPath: 'assets/googleLogo.png',
                text: 'Iniciar con Google',
                textColor: Colors.white,
                onPressed: () => print("Google login"),
                isGoogle: true,
              ),

              const SizedBox(height: 40),

              // Texto final -> Términos y condiciones. Fantasmada
              const Text(
                'Al continuar, aceptas nuestros Términos de servicio y Política de privacidad.',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper
  Widget _buildLoginButton({
    required List<Color> gradientColors,
    required String iconPath,
    required String text,
    required VoidCallback onPressed,
    Color textColor = Colors.white,
    bool isGoogle = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: isGoogle
            ? SizedBox(
                width: 26,
                height: 26,
                child: Center(
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        iconPath,
                        width: 14,
                        height: 14,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: 26,
                height: 26,
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
