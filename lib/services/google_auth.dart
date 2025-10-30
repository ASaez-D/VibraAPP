import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _googleSignIn.initialize();
      _initialized = true;
    }
  }

  Future<Map<String, dynamic>?> login() async {
    try {
      await _ensureInitialized();

      // Iniciar la autenticación (usuario interactivo)
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();

      if (account == null) {
        print('Usuario canceló login de Google');
        return null;
      }

      // Si solo necesitas perfil básico y correo:
      final profile = <String, dynamic>{
        'displayName': account.displayName,
        'email': account.email,
        'photoUrl': account.photoUrl,
        'id': account.id,
      };

      // Si necesitas tokens de autorización (para acceder a APIs adicionales):
      // final GoogleSignInClientAuthorization authClient = await account.authorizationClient
      //     .authorizationForScopes(<String>['https://www.googleapis.com/auth/userinfo.profile']);
      // final accessToken = authClient.accessToken;
      // Puedes añadirlo al perfil si lo necesitas.

      print('Perfil Google: $profile');
      return profile;
    } catch (e) {
      print('Error en login de Google: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _ensureInitialized();
      await _googleSignIn.signOut();
      print('Usuario desconectado de Google');
    } catch (e) {
      print('Error al cerrar sesión de Google: $e');
    }
  }
}
