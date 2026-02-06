import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../utils/api_constants.dart';
import '../utils/app_logger.dart';
import '../utils/text_constants.dart';

/// Service for Spotify API operations
/// Handles artist search and user top artists retrieval
class SpotifyAPIService {
  /// Spotify client ID from environment variables
  String get clientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';

  /// Spotify client secret from environment variables
  String get clientSecret => dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  String? _token;
  DateTime? _tokenExpiration;

  /// Ensures a valid client credentials token is available
  ///
  /// Automatically refreshes token if expired or missing
  Future<void> _ensureToken() async {
    // Check if current token is still valid
    if (_token != null &&
        _tokenExpiration != null &&
        DateTime.now().isBefore(_tokenExpiration!)) {
      return;
    }

    // Validate credentials
    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception('Faltan las credenciales de Spotify en el archivo .env');
    }

    final String credentials = base64Encode(
      utf8.encode('$clientId:$clientSecret'),
    );

    try {
      final response = await http
          .post(
            Uri.parse(SpotifyApiConstants.tokenEndpoint),
            headers: {
              HttpConstants.headerAuthorization:
                  '${HttpConstants.authTypeBasic} $credentials',
              HttpConstants.headerContentType:
                  HttpConstants.contentTypeFormUrlEncoded,
            },
            body: {
              'grant_type': SpotifyApiConstants.grantTypeClientCredentials,
            },
          )
          .timeout(SpotifyApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['access_token'];
        _tokenExpiration = DateTime.now().add(
          Duration(seconds: data['expires_in']),
        );
        AppLogger.debug('Token de cliente Spotify obtenido');
      } else {
        AppLogger.error(
          'Error obteniendo token de cliente Spotify',
          'Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Error obteniendo token de cliente: ${response.statusCode}',
        );
      }
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error('Timeout obteniendo token de Spotify', e, stackTrace);
      rethrow;
    }
  }

  /// Retrieves user's top artists with their genres
  ///
  /// Requires a valid user access token (from OAuth flow)
  ///
  /// Returns list of artists with name and genres, or empty list on error
  Future<List<Map<String, dynamic>>> getUserTopArtistsWithGenres(
    String userAccessToken,
  ) async {
    final url = Uri.parse(
      '${SpotifyApiConstants.topArtistsEndpoint}?limit=${SpotifyApiConstants.defaultArtistLimit}',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              HttpConstants.headerAuthorization:
                  '${HttpConstants.authTypeBearer} $userAccessToken',
            },
          )
          .timeout(SpotifyApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        AppLogger.info('Top artists obtenidos: ${items.length} artistas');

        return items.map<Map<String, dynamic>>((artist) {
          return {
            'name': artist['name'].toString(),
            'genres': List<String>.from(artist['genres'] ?? []),
          };
        }).toList();
      } else {
        AppLogger.error(
          'Error obteniendo top artists de Spotify',
          'Status: ${response.statusCode}, Body: ${response.body}',
        );
        return [];
      }
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error('Timeout obteniendo top artists', e, stackTrace);
      return [];
    } catch (e, stackTrace) {
      AppLogger.error('Error obteniendo top artists', e, stackTrace);
      return [];
    }
  }

  /// Searches for artists by name
  ///
  /// Uses client credentials token (no user auth required)
  ///
  /// Returns list with artist name and image URL, or empty list on error
  Future<List<Map<String, String>>> searchArtists(String query) async {
    if (query.isEmpty) return [];

    try {
      await _ensureToken();

      final url = Uri.parse(
        '${SpotifyApiConstants.searchEndpoint}?q=${Uri.encodeComponent(query)}'
        '&type=${SpotifyApiConstants.searchTypeArtist}'
        '&limit=${SpotifyApiConstants.searchLimit}',
      );

      final response = await http
          .get(
            url,
            headers: {
              HttpConstants.headerAuthorization:
                  '${HttpConstants.authTypeBearer} $_token',
            },
          )
          .timeout(SpotifyApiConstants.requestTimeout);

      if (response.statusCode != 200) {
        AppLogger.warning('Búsqueda de artista falló: ${response.statusCode}');
        return [];
      }

      final data = json.decode(response.body);

      // Validate response structure
      if (data['artists'] == null || data['artists']['items'] == null) {
        return [];
      }

      final items = data['artists']['items'] as List;

      return items.map<Map<String, String>>((artist) {
        String imageUrl = AppTextConstants.defaultUserIconUrl;

        // Use artist image if available
        if (artist['images'] != null && (artist['images'] as List).isNotEmpty) {
          imageUrl = artist['images'][0]['url'];
        }

        return {'name': artist['name'] ?? '', 'image': imageUrl};
      }).toList();
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error('Timeout buscando artista', e, stackTrace);
      return [];
    } catch (e, stackTrace) {
      AppLogger.error('Error buscando artista', e, stackTrace);
      return [];
    }
  }
}
