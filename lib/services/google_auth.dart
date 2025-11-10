import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>?> login() async {
    // Paso 1: Seleccionar la cuenta
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
    if (gUser == null) return null;

    // Paso 2: Obtener credenciales
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Paso 3: Login Firebase
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) return null;

    // Retornar exactamente lo que espera tu LoginScreen
    return {
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'uid': user.uid,
    };
  }
}
