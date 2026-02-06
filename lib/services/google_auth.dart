import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_logger.dart';

/// Alternative Google authentication service
/// Returns user data as a Map for legacy compatibility
///
/// Note: Consider using AuthServices instead for better type safety
class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Timeout duration for authentication operations
  static const Duration _authTimeout = Duration(seconds: 30);

  /// Authenticates user with Google and returns user data as Map
  ///
  /// Returns Map with user data (displayName, email, photoURL, uid) or null if failed
  ///
  /// Legacy method - prefer using AuthServices.signInWithGoogle() for new code
  Future<Map<String, dynamic>?> login() async {
    try {
      AppLogger.info('Iniciando Google Auth login');

      // Step 1: Select account
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn().timeout(
        _authTimeout,
      );

      if (gUser == null) {
        AppLogger.info('Usuario canceló la selección de cuenta Google');
        return null;
      }

      // Step 2: Get credentials
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Step 3: Firebase login
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .timeout(_authTimeout);

      final user = userCredential.user;
      if (user == null) {
        AppLogger.warning('Firebase devolvió UserCredential sin usuario');
        return null;
      }

      AppLogger.info('Google Auth login exitoso: ${user.email}');

      // Return data in expected format for LoginScreen
      return {
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'uid': user.uid,
      };
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error('Timeout en Google Auth login', e, stackTrace);
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error en Google Auth login', e, stackTrace);
      return null;
    }
  }
}
