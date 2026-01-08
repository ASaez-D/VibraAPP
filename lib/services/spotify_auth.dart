import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SpotifyAuth {
  final String clientId = '80f01713b268402aa0bd1c47c8524bd9';
  final String clientSecret = 'a9f061e91c35424480bdb3f271407864';
  final String redirectUri = 'vibraapp://callback'; 
  final String scopes = 'user-read-private user-read-email user-top-read';

  /// Devuelve un Mapa con los datos del perfil Y el access_token
  Future<Map<String, dynamic>?> login() async {
    try {
      // Limpiar token previo
      await logout();
      print('🧹 Token anterior eliminado.');

      // 1. URL OFICIAL DE LOGIN (Authorize)
      // Generamos la URL con los parámetros necesarios
      final url = Uri.https('accounts.spotify.com', '/authorize', {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scopes,
      }).toString();
      
      print('URL para login Spotify: $url');

      // 2. Abrir navegador
      print('🕒 Abriendo navegador...');
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'vibraapp',
      );
      print('📥 Resultado recibido: $result');

      // 3. Obtener el código
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) {
        print('Error: No se recibió código de autorización');
        return null;
      }

      print('✅ Código recibido: $code');

      // 4. Intercambiar código por Token (URL OFICIAL)
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
        print('Error Token: ${tokenResponse.statusCode} - ${tokenResponse.body}');
        return null;
      }

      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];
      print('✅ Access Token obtenido');

      // Guardar token localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('spotify_token', accessToken);

      // 5. Obtener Perfil de Usuario (URL OFICIAL)
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode != 200) {
        print('Error Perfil: ${response.statusCode} - ${response.body}');
        return null;
      }

      // Decodificamos el perfil
      final Map<String, dynamic> profile = json.decode(response.body);
      
      // --- CAMBIO CLAVE ---
      // Inyectamos el token dentro del mapa del perfil para que LoginScreen pueda leerlo
      // y pasárselo a la HomeScreen.
      profile['access_token'] = accessToken; 

      print('Perfil obtenido correctamente: ${profile['display_name']}');
      return profile;

    } catch (e) {
      print('🚨 Excepción en Spotify Auth: $e');
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