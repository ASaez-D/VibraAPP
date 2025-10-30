import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpotifyAuth {
  final String clientId = '80f01713b268402aa0bd1c47c8524bd9'; // Nuestro Client ID -> https://developer.spotify.com/dashboard/80f01713b268402aa0bd1c47c8524bd9
  final String redirectUri = 'myapp://callback'; // Del mismo sitio -> https://developer.spotify.com/dashboard/80f01713b268402aa0bd1c47c8524bd9
  final String scopes = 'user-read-private user-read-email user-top-read';

  Future<Map<String, dynamic>> login() async {
    // Abrir la web con el login.
    final url =
        'https://accounts.spotify.com/authorize?response_type=token&client_id=$clientId&redirect_uri=$redirectUri&scope=$scopes';

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: 'myapp', 
    );

    // Pasamos el resultado para que solo quedemos con el token.
    final token = Uri.parse(result).fragment.split('&')[0].split('=')[1];

    // Llamamos a la API de Spotify para que nos devuelva el usuario.
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final profile = json.decode(response.body);
    print('Perfil Spotify: $profile');

    return profile; // Devuelve los datos del usuario
  }
}
