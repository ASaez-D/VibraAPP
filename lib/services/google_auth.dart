import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  // Instancia de GoogleSignIn configurada con scopes y serverClientId.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '756981178053-5tgv3oaenpdogipv3fcun1m7gmqi4jfv.apps.googleusercontent.com', 
  );

  /// Inicia sesión con Google
  Future<Map<String, dynamic>?> login() async {
    try {
      // Lanza la ventana de login de Google
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null; // Usuario canceló login.

      // Obtenemos idToken necesario para backend / Firebase.
      final GoogleSignInAuthentication auth = await account.authentication;

      return {
        'displayName': account.displayName,
        'email': account.email,
        'photoUrl': account.photoUrl,
        'id': account.id,
        'idToken': auth.idToken,
      };
    } catch (e) {
      print('Error login Google: $e');
      return null;
    }
  }

  /// Cierra sesión.
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      print('Usuario desconectado de Google');
    } catch (e) {
      print('Error logout Google: $e');
    }
  }
}
