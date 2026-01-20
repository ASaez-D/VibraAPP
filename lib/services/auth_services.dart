import 'dart:developer' as developer; // Añadido para logs profesionales
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      
      if (gUser == null) {
        developer.log('El usuario canceló el inicio de sesión', name: 'auth.services');
        return null; 
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Iniciamos sesión en Firebase con la credencial de Google
      return await FirebaseAuth.instance.signInWithCredential(credential);
      
    } catch (e, stackTrace) {
      // Reemplazado print por developer.log
      developer.log(
        'Error Google Sign In',
        name: 'auth.services',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Método opcional para cerrar sesión
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}