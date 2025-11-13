import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SpotifyAuth {
  final String clientId = '80f01713b268402aa0bd1c47c8524bd9';
  final String clientSecret = 'a9f061e91c35424480bdb3f271407864';
  final String redirectUri = 'vibraapp://callback'; 
  final String scopes = 'user-read-private user-read-email user-top-read';

  /// Devuelve null si no se pudo iniciar sesión
  Future<Map<String, dynamic>?> login() async {
    try {
      // Limpiar token previo antes de iniciar login
      await logout();
      print('🧹 Token anterior eliminado.');

      // URL de login con Authorization Code Flow
      final url =
          'https://accounts.spotify.com/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=$scopes&show_dialog=true';
      print('URL para login Spotify: $url');

      // Abrir navegador para autenticación
      print('🕒 Abriendo navegador para autenticación...');
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'vibraapp',
      );
      print('📥 Resultado recibido del login: $result');

      // Obtener el código de autorización
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) {
        print('No se recibió el código de autorización o usuario canceló login');
        return null;
      }

      print('✅ Código de autorización recibido: $code');

      // Intercambiar el código por access_token
      final tokenResponse = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (tokenResponse.statusCode != 200) {
        print(
            'Error al obtener access token: ${tokenResponse.statusCode} - ${tokenResponse.body}');
        return null;
      }

      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];
      print('✅ Access token recibido: $accessToken');

      // Guardar token localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('spotify_token', accessToken);

      // Llamar a la API de Spotify para obtener perfil
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode != 200) {
        print(
            'Error al obtener perfil de Spotify: ${response.statusCode} - ${response.body}');
        return null;
      }

      final profile = json.decode(response.body);
      print('Perfil Spotify: $profile');

      return profile;
    } catch (e) {
      print('🚨 Error en login de Spotify: $e');
      return null;
    }
  }

  /// Recupera token guardado
  static Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('spotify_token');
  }

  /// Elimina token guardado
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('spotify_token');
    print('🧹 Token anterior eliminado.');
  }
}
