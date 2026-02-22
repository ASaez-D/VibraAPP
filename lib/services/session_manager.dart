import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'spotify_auth.dart';
import '../utils/app_logger.dart';

class SessionManager {
  static const String _spotifyProfileKey = 'spotify_saved_profile';

  /// Saves Spotify profile to SharedPreferences for session restoration
  static Future<void> saveSpotifyProfile(Map<String, dynamic> profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_spotifyProfileKey, json.encode(profile));
    } catch (e) {
      AppLogger.warning('No se pudo guardar perfil de Spotify: $e');
    }
  }

  /// Clears saved Spotify profile
  static Future<void> clearSpotifyProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_spotifyProfileKey);
    } catch (e) {
      AppLogger.warning('No se pudo limpiar perfil de Spotify');
    }
  }

  /// Determines the initial screen based on current session state
  static Future<Widget> getInitialScreen() async {
    try {
      // 1. Check Firebase Session (Google / Email)
      // Usamos authStateChanges().first en lugar de currentUser, porque
      // currentUser puede ser null al inicio aunque haya sesión activa
      // (Firebase necesita tiempo para restaurar el token desde disco).
      final firebaseUser = await FirebaseAuth.instance
          .authStateChanges()
          .first
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => FirebaseAuth.instance.currentUser,
          );

      if (firebaseUser != null) {
        AppLogger.info('Sesión recuperada de Firebase: ${firebaseUser.email}');

        final userProfile = {
          'uid': firebaseUser.uid,
          'displayName': firebaseUser.displayName ?? 'Usuario',
          'email': firebaseUser.email,
          'photoURL': firebaseUser.photoURL,
        };

        return HomeScreen(userProfile: userProfile, authSource: 'google');
      }

      // 2. Check Spotify Session — first try saved profile (no network needed)
      final prefs = await SharedPreferences.getInstance();
      final savedProfileJson = prefs.getString(_spotifyProfileKey);
      if (savedProfileJson != null) {
        try {
          final savedProfile =
              json.decode(savedProfileJson) as Map<String, dynamic>;
          AppLogger.info(
            'Sesión Spotify restaurada desde perfil guardado: ${savedProfile['display_name']}',
          );

          final spotifyToken = await SpotifyAuth.getSavedToken();

          return HomeScreen(
            userProfile: savedProfile,
            authSource: 'spotify',
            spotifyAccessToken: spotifyToken,
          );
        } catch (e) {
          AppLogger.warning(
            'Perfil de Spotify guardado inválido, limpiando...',
          );
          await clearSpotifyProfile();
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
