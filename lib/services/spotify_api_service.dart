import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyAPIService {
  // ⚠️ RECUERDA: Pon tus credenciales reales aquí
  final String clientId = '80f01713b268402aa0bd1c47c8524bd9';
  final String clientSecret = 'a9f061e91c35424480bdb3f271407864';

  String? _token;
  DateTime? _tokenExpiration;

  // --- 1. GESTIÓN DE TOKEN DE CLIENTE (Para búsquedas públicas) ---
  Future<void> _ensureToken() async {
    if (_token != null &&
        _tokenExpiration != null &&
        DateTime.now().isBefore(_tokenExpiration!)) return;

    final String credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));

    // Endpoint oficial de Spotify para tokens
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Authorization': 'Basic $credentials'},
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      _tokenExpiration = DateTime.now().add(Duration(seconds: data['expires_in']));
    } else {
      throw Exception('Error obteniendo token de cliente: ${response.statusCode}');
    }
  }

  // --- 2. OBTENER ARTISTAS Y GÉNEROS DEL USUARIO (Lógica Premium) ---
  // Requiere el accessToken del usuario (obtenido en el Login)
  Future<List<Map<String, dynamic>>> getUserTopArtistsWithGenres(String userAccessToken) async {
    // Endpoint oficial: Mis artistas top
    final url = Uri.parse('https://api.spotify.com/v1/me/top/artists?limit=10&time_range=medium_term');
    
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
            // Extraemos la lista de géneros (ej: ['trap latino', 'reggaeton'])
            'genres': List<String>.from(artist['genres'] ?? []), 
          };
        }).toList();
      } else {
        print("Error Spotify Top Artists: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Excepción Spotify Top Genres: $e");
      return [];
    }
  }

  // --- 3. BUSCAR ARTISTAS (Para fotos en el carrusel) ---
  Future<List<Map<String, String>>> searchArtists(String query) async {
    if (query.isEmpty) return [];

    await _ensureToken();

    final url = Uri.parse('https://api.spotify.com/v1/search?q=${Uri.encodeComponent(query)}&type=artist&limit=1');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = json.decode(response.body);
    final items = data['artists']['items'] as List;

    return items.map<Map<String, String>>((artist) {
      return {
        'name': artist['name'] ?? '',
        'image': (artist['images'] as List).isNotEmpty
            ? artist['images'][0]['url']
            : 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
      };
    }).toList();
  }
}