import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SpotifyAuth {
  final String clientId = '80f01713b268402aa0bd1c47c8524bd9'; // Nuestro Client ID
  final String redirectUri = 'myapp://callback'; // Mismo del Spotify Dashboard
  final String scopes = 'user-read-private user-read-email user-top-read';

  /// Devuelve null si no se pudo iniciar sesión
  Future<Map<String, dynamic>?> login() async {
    try {
      // Limpiar token previo antes de iniciar login
      await logout();

      // Abrir web con login y forzar siempre el login
      final url =
          'https://accounts.spotify.com/authorize?response_type=token&client_id=$clientId&redirect_uri=$redirectUri&scope=$scopes&show_dialog=true';

      print('URL para login Spotify: $url'); // <-- Debug URL

      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'myapp',
      );

      print('RESULTADO LOGIN: $result'); // <-- Debug resultado

      final uri = Uri.parse(result);
      final fragment = uri.fragment;

      // Si el usuario canceló o no hay token
      if (!fragment.contains('access_token=')) {
        print('No se recibió token de Spotify o usuario canceló login');
        return null;
      }

      final token = fragment.split('&')[0].split('=')[1];

      // Guardar token localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('spotify_token', token);

      // Llamar a la API de Spotify
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $token'},
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
      // Captura cancelación y otros errores
      print('Error en login de Spotify: $e');
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
  }
}
