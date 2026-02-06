import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/app_logger.dart';

/// Service for handling authentication operations
/// Manages Google Sign In integration with Firebase Authentication
class AuthServices {
  /// Timeout duration for authentication operations
  static const Duration _authTimeout = Duration(seconds: 30);

  /// Authenticates user with Google Sign In and Firebase
  ///
  /// Returns [UserCredential] if successful, null if user cancels or error occurs
  ///
  /// Throws [TimeoutException] if operation takes longer than 30 seconds
  Future<UserCredential?> signInWithGoogle() async {
    try {
      AppLogger.info('Iniciando proceso de Google Sign In');

      // Request Google Sign In with timeout
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn().timeout(
        _authTimeout,
      );

      if (gUser == null) {
        AppLogger.info('Usuario canceló el inicio de sesión con Google');
        return null;
      }

      AppLogger.debug('Usuario seleccionado: ${gUser.email}');

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .timeout(_authTimeout);

      AppLogger.info('Google Sign In exitoso: ${userCredential.user?.email}');
      return userCredential;
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error('Timeout en Google Sign In', e, stackTrace);
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error en Google Sign In', e, stackTrace);
      return null;
    }
  }

  /// Signs out the current user from both Google and Firebase
  Future<void> signOut() async {
    try {
      AppLogger.info('Cerrando sesión');
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      AppLogger.info('Sesión cerrada exitosamente');
    } catch (e, stackTrace) {
      AppLogger.error('Error al cerrar sesión', e, stackTrace);
      rethrow;
    }
  }
}
