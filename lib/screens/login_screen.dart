import 'package:flutter/material.dart';
import '../services/spotify_auth.dart';
import '../services/google_auth.dart';
import '../services/user_data_service.dart'; // Importante: Conexión con BD
import 'home_screen.dart';
import 'music_preferences_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoadingSpotify = false;
  bool _isLoadingGoogle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E), // Fondo negro fijo
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

              // --- BOTÓN SPOTIFY ---
              _buildLoginButton(
                gradientColors: [
                  Colors.greenAccent.shade700,
                  Colors.greenAccent.shade400,
                ],
                iconPath: 'assets/spotifyLogo.png',
                text: _isLoadingSpotify ? 'Cargando...' : 'Iniciar con Spotify',
                textColor: Colors.black,
                onPressed: _isLoadingSpotify
                    ? null
                    : () async {
                        setState(() => _isLoadingSpotify = true);
                        final spotify = SpotifyAuth();

                        try {
                          // 1. Login con Spotify
                          final profile = await spotify.login();
                          if (profile == null) throw 'No se obtuvo perfil';

                          // 2. Extraer token y foto
                          final String? accessToken = profile['access_token']; 
                          String? photoUrl;
                          final images = profile['images'];
                          if (images is List && images.isNotEmpty) {
                            photoUrl = images[0]['url'] as String?;
                          }

                          // 3. Preparar datos del usuario
                          final Map<String, dynamic> userProfile = {
                            'id': profile['id'],
                            'displayName': profile['display_name'] ?? 'Usuario',
                            'email': profile['email'],
                            'photoURL': photoUrl,
                            'profileUrl': profile['external_urls']?['spotify'],
                          };

                          // 4. GUARDAR EN FIREBASE
                          await UserDataService().saveUserFromMap(userProfile);

                          if (!mounted) return;

                          // 5. Navegar a Home (Spotify no necesita preferencias manuales)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(
                                userProfile: userProfile,
                                authSource: 'spotify',
                                spotifyAccessToken: accessToken,
                              ),
                            ),
                          );
                          
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error Spotify: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _isLoadingSpotify = false);
                        }
                      },
              ),

              const SizedBox(height: 25),

              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.white24, thickness: 1, endIndent: 10)),
                  Text('o', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  Expanded(child: Divider(color: Colors.white24, thickness: 1, indent: 10)),
                ],
              ),

              const SizedBox(height: 25),

              // --- BOTÓN GOOGLE (INTELIGENTE) ---
              _buildLoginButton(
                gradientColors: [
                  Colors.blueAccent.shade700,
                  Colors.blueAccent.shade400,
                ],
                iconPath: 'assets/googleLogo.png',
                text: _isLoadingGoogle ? 'Cargando...' : 'Iniciar con Google',
                textColor: Colors.white,
                isGoogle: true,
                onPressed: _isLoadingGoogle
                    ? null
                    : () async {
                        setState(() => _isLoadingGoogle = true);

                        try {
                          // 1. Login con Google
                          final googleAuth = GoogleAuth();
                          final profile = await googleAuth.login();

                          if (profile == null) throw 'No se pudo iniciar sesión';

                          // 2. Preparar datos
                          final Map<String, dynamic> userProfile = {
                            'displayName': profile['displayName'] ?? 'Usuario',
                            'email': profile['email'],
                            'photoURL': profile['photoURL'],
                            'uid': profile['uid'],
                          };

                          // 3. GUARDAR EN FIREBASE
                          await UserDataService().saveUserFromMap(userProfile);

                          // 4. 🧠 CEREBRO: ¿TIENE YA PREFERENCIAS?
                          // Consultamos a la base de datos si ya configuró sus gustos
                          final prefs = await UserDataService().getUserPreferences();
                          final bool hasPreferences = prefs != null && prefs['preferencesSet'] == true;

                          if (!mounted) return;

                          // 5. NAVEGACIÓN INTELIGENTE
                          if (hasPreferences) {
                            // A) YA TIENE GUSTOS -> A LA HOME DIRECTO
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomeScreen(
                                  userProfile: userProfile,
                                  authSource: 'google',
                                ),
                              ),
                            );
                          } else {
                            // B) ES NUEVO -> A ELEGIR GUSTOS
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MusicPreferencesScreen(
                                  userProfile: userProfile,
                                  authSource: 'google',
                                ),
                              ),
                            );
                          }

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error Google: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _isLoadingGoogle = false);
                        }
                      },
              ),

              const SizedBox(height: 40),

              const Text(
                'Al continuar, aceptas nuestros Términos y Política de privacidad.',
                style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- REUSABLE BUTTON ----
  Widget _buildLoginButton({
    required List<Color> gradientColors,
    required String iconPath,
    required String text,
    required VoidCallback? onPressed,
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: isGoogle
                  ? const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}