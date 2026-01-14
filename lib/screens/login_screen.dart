import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/spotify_auth.dart';
import '../services/google_auth.dart';
import '../services/user_data_service.dart';
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
    // 2. Acceso corto a las traducciones
    final l10n = AppLocalizations.of(context)!;

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

              Text(
                l10n.appTitle, // "Vibra"
                style: const TextStyle( // El estilo sí puede ser const
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
                // Texto dinámico: Cargando... o Iniciar con...
                text: _isLoadingSpotify ? l10n.loginLoading : l10n.loginSpotify,
                textColor: Colors.black,
                onPressed: _isLoadingSpotify
                    ? null
                    : () async {
                        setState(() => _isLoadingSpotify = true);
                        final spotify = SpotifyAuth();

                        try {
                          final profile = await spotify.login();
                          if (profile == null) throw 'No profile data';

                          final String? accessToken = profile['access_token']; 
                          String? photoUrl;
                          final images = profile['images'];
                          if (images is List && images.isNotEmpty) {
                            photoUrl = images[0]['url'] as String?;
                          }

                          final Map<String, dynamic> userProfile = {
                            'id': profile['id'],
                            'displayName': profile['display_name'] ?? 'Usuario',
                            'email': profile['email'],
                            'photoURL': photoUrl,
                            'profileUrl': profile['external_urls']?['spotify'],
                          };

                          await UserDataService().saveUserFromMap(userProfile);

                          if (!mounted) return;

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
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              // "Error al iniciar sesión: {error}"
                              SnackBar(content: Text(l10n.loginError(e.toString()))),
                            );
                          }
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

              // --- BOTÓN GOOGLE ---
              _buildLoginButton(
                gradientColors: [
                  Colors.blueAccent.shade700,
                  Colors.blueAccent.shade400,
                ],
                iconPath: 'assets/googleLogo.png',
                // Texto dinámico
                text: _isLoadingGoogle ? l10n.loginLoading : l10n.loginGoogle,
                textColor: Colors.white,
                isGoogle: true,
                onPressed: _isLoadingGoogle
                    ? null
                    : () async {
                        setState(() => _isLoadingGoogle = true);

                        try {
                          final googleAuth = GoogleAuth();
                          final profile = await googleAuth.login();

                          if (profile == null) throw 'No profile data';

                          final Map<String, dynamic> userProfile = {
                            'displayName': profile['displayName'] ?? 'Usuario',
                            'email': profile['email'],
                            'photoURL': profile['photoURL'],
                            'uid': profile['uid'],
                          };

                          await UserDataService().saveUserFromMap(userProfile);

                          final prefs = await UserDataService().getUserPreferences();
                          final bool hasPreferences = prefs != null && prefs['preferencesSet'] == true;

                          if (!mounted) return;

                          if (hasPreferences) {
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
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              // "Error al iniciar sesión: {error}"
                              SnackBar(content: Text(l10n.loginError(e.toString()))),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoadingGoogle = false);
                        }
                      },
              ),

              const SizedBox(height: 40),

              // Términos y condiciones
              Text(
                l10n.loginTerms, 
                style: const TextStyle(color: Colors.white38, fontSize: 12, height: 1.4),
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