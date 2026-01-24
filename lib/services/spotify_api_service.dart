import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <--- 1. IMPORTAR DOTENV

class SpotifyAPIService {
  // --- 2. LEER VARIABLES DE ENTORNO ---
  String get clientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  String get clientSecret => dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  String? _token;
  DateTime? _tokenExpiration;

  // --- 1. GESTIÓN DE TOKEN DE CLIENTE ---
  Future<void> _ensureToken() async {
    if (_token != null &&
        _tokenExpiration != null &&
        DateTime.now().isBefore(_tokenExpiration!)) {
      return;
    }

    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception('Faltan las credenciales de Spotify en el archivo .env');
    }

    final String credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));

    // URL REAL de Spotify para obtener token
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'), 
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      _tokenExpiration = DateTime.now().add(Duration(seconds: data['expires_in']));
    } else {
      developer.log('Error token body: ${response.body}');
      throw Exception('Error obteniendo token de cliente: ${response.statusCode}');
    }
  }

  // --- 2. OBTENER ARTISTAS Y GÉNEROS DEL USUARIO ---
  Future<List<Map<String, dynamic>>> getUserTopArtistsWithGenres(String userAccessToken) async {
    // URL REAL para Top Artists
    final url = Uri.parse('https://api.spotify.com/v1/me/top/artists?limit=20'); 
    
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $userAccessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;
        
        return items.map<Map<String, dynamic>>((artist) {
          return {
            'name': artist['name'].toString(),
            'genres': List<String>.from(artist['genres'] ?? []), 
          };
        }).toList();
      } else {
        developer.log(
          "Error Spotify Top Artists", 
          name: 'spotify.service', 
          error: "Status: ${response.statusCode} - Body: ${response.body}"
        );
        return [];
      }
    } catch (e) {
      developer.log(
        "Excepción Spotify Top Genres", 
        name: 'spotify.service', 
        error: e
      );
      return [];
    }
  }

  // --- 3. BUSCAR ARTISTAS ---
  Future<List<Map<String, String>>> searchArtists(String query) async {
    if (query.isEmpty) return [];

    try {
      await _ensureToken();

      // URL REAL de Búsqueda
      final url = Uri.parse(
        'https://api.spotify.com/v1/search?q=${Uri.encodeComponent(query)}&type=artist&limit=1'
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode != 200) {
        return [];
      }

      final data = json.decode(response.body);
      // Verificamos que existan 'artists' e 'items'
      if (data['artists'] == null || data['artists']['items'] == null) return [];
      
      final items = data['artists']['items'] as List;

      return items.map<Map<String, String>>((artist) {
        String imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
        
        // Verificamos si hay imágenes disponibles
        if (artist['images'] != null && (artist['images'] as List).isNotEmpty) {
          imageUrl = artist['images'][0]['url'];
        }

        return {
          'name': artist['name'] ?? '',
          'image': imageUrl,
        };
      }).toList();
    } catch (e) {
      developer.log('Error buscando artista: $e');
      return [];
    }
  }
}
