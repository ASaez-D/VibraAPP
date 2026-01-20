import 'package:flutter/foundation.dart'; // Importante para debugPrint
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SpotifyAuth {
  final String clientId = '80f01713b268402aa0bd1c47c8524bd9';
  final String clientSecret = 'a9f061e91c35424480bdb3f271407864';
  final String redirectUri = 'vibraapp://callback'; 
  final String scopes = 'user-read-private user-read-email user-top-read';

  Future<Map<String, dynamic>?> login() async {
    try {
      await logout();
      debugPrint('🧹 Token anterior eliminado.');

      // 1. URL DE LOGIN
      // Nota: He corregido los dominios a los oficiales de Spotify
      final url = Uri.https('accounts.spotify.com', '/authorize', {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scopes,
      }).toString();
      
      debugPrint('URL para login Spotify: $url');

      // 2. Abrir navegador
      debugPrint('🕒 Abriendo navegador...');
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'vibraapp',
      );
      debugPrint('📥 Resultado recibido correctamente');

      // 3. Obtener el código
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) {
        debugPrint('Error: No se recibió código de autorización');
        return null;
      }

      debugPrint('✅ Código recibido');

      // 4. Intercambiar código por Token
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
        debugPrint('Error Token: ${tokenResponse.statusCode} - ${tokenResponse.body}');
        return null;
      }

      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];
      debugPrint('✅ Access Token obtenido');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('spotify_token', accessToken);

      // 5. Obtener Perfil de Usuario
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode != 200) {
        debugPrint('Error Perfil: ${response.statusCode}');
        return null;
      }

      final Map<String, dynamic> profile = json.decode(response.body);
      profile['access_token'] = accessToken; 

      debugPrint('Perfil obtenido correctamente: ${profile['display_name']}');
      return profile;

    } catch (e) {
      debugPrint('🚨 Excepción en Spotify Auth: $e');
      return null;
    }
  }

  static Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('spotify_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('spotify_token');
  }
}