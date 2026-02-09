import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'spotify_auth.dart';
import 'user_data_service.dart';
import '../utils/app_logger.dart';

class SessionManager {
  static final SpotifyAuth _spotifyAuth = SpotifyAuth();
  static final UserDataService _userDataService = UserDataService();

  /// Determines the initial screen based on current session state
  static Future<Widget> getInitialScreen() async {
    try {
      // 1. Check Firebase Session (Google / Email)
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        AppLogger.info('Sesión recuperada de Firebase: ${firebaseUser.email}');
        
        // Cargar datos adicionales del usuario si es necesario
        // Por ahora construimos el perfil básico desde el objeto User
        final userProfile = {
          'uid': firebaseUser.uid,
          'displayName': firebaseUser.displayName ?? 'Usuario',
          'email': firebaseUser.email,
          'photoURL': firebaseUser.photoURL,
        };

        return HomeScreen(
          userProfile: userProfile,
          authSource: 'google', // Asumimos google/firebase
        );
      }

      // 2. Check Spotify Session
      final spotifyToken = await SpotifyAuth.getSavedToken();
      if (spotifyToken != null) {
        AppLogger.info('Token de Spotify encontrado, verificando validez...');
        
        final profile = await _spotifyAuth.getUserProfile(spotifyToken);
        
        if (profile != null) {
          AppLogger.info('Sesión recuperada de Spotify: ${profile['display_name']}');
          
          return HomeScreen(
            userProfile: profile,
            authSource: 'spotify',
            spotifyAccessToken: spotifyToken,
          );
        } else {
          AppLogger.warning('Token de Spotify inválido o expirado');
          await SpotifyAuth.logout(); // Limpiar token inválido
        }
      }

      // 3. No session found
      AppLogger.info('No se encontró sesión activa');
      return const LoginScreen();
      
    } catch (e, stackTrace) {
      AppLogger.error('Error verificando sesión', e, stackTrace);
      return const LoginScreen();
    }
  }
}
