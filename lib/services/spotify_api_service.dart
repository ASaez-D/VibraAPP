import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio para conectarse con la API de Spotify y buscar artistas.
/// 
/// IMPORTANTE!!!
/// IMPORTANTE!!!
/// Hay que cambiarlo para que no se vea la clientSecret
/// IMPORTANTE!!!
/// IMPORTANTE!!!
/// 

class SpotifyAPIService {

  final String clientId = '80f01713b268402aa0bd1c47c8524bd9';
  final String clientSecret = 'a9f061e91c35424480bdb3f271407864';

  String? _token;
  DateTime? _tokenExpiration;

  Future<void> _ensureToken() async {
    if (_token != null &&
        _tokenExpiration != null &&
        DateTime.now().isBefore(_tokenExpiration!)) return;

    final String credentials =
        base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Authorization': 'Basic $credentials'},
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      _tokenExpiration =
          DateTime.now().add(Duration(seconds: data['expires_in']));
    } else {
      throw Exception(
          'Error obteniendo token de Spotify: ${response.statusCode} ${response.body}');
    }
  }


  Future<List<Map<String, String>>> searchArtists(String query) async {
    if (query.isEmpty) return [];

    await _ensureToken();

    final url =
        'https://api.spotify.com/v1/search?q=${Uri.encodeComponent(query)}&type=artist&limit=8';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode != 200) {
      print('Error Spotify API: ${response.statusCode}');
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
