import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_constants.dart';
import '../utils/app_logger.dart';

/// Service for Spotify OAuth authentication
/// Handles user authorization and token management
class SpotifyAuth {
  /// Spotify client ID from environment variables
  String get clientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';

  /// Spotify client secret from environment variables
  String get clientSecret => dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  /// SharedPreferences key for storing Spotify token
  static const String _tokenKey = 'spotify_token';

  /// Authenticates user with Spotify OAuth flow
  ///
  /// Returns user profile data with access token, or null if authentication fails
  ///
  /// Steps:
  /// 1. Clears any existing token
  /// 2. Opens browser for user authorization
  /// 3. Exchanges authorization code for access token
  /// 4. Fetches user profile
  /// 5. Stores token in SharedPreferences
  Future<Map<String, dynamic>?> login() async {
    try {
      // Validate credentials
      if (clientId.isEmpty || clientSecret.isEmpty) {
        AppLogger.error('Faltan credenciales de Spotify en .env');
        return null;
      }

      // Clear previous token
      await logout();
      AppLogger.debug('Token anterior eliminado');

      // Build authorization URL
      final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
        'response_type': SpotifyApiConstants.responseType,
        'client_id': clientId,
        'redirect_uri': SpotifyApiConstants.redirectUri,
        'scope': SpotifyApiConstants.scopes,
      }).toString();

      AppLogger.info('Iniciando Spotify OAuth');

      // Open browser for authorization
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: 'vibraapp',
      ).timeout(SpotifyApiConstants.requestTimeout);

      AppLogger.debug('Callback recibido de Spotify');

      // Extract authorization code
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) {
        AppLogger.warning('No se recibió código de autorización de Spotify');
        return null;
      }

      AppLogger.debug('Código de autorización obtenido');

      // Exchange code for access token
      final tokenResponse = await http
          .post(
            Uri.parse(SpotifyApiConstants.tokenEndpoint),
            headers: {
              HttpConstants.headerContentType:
                  HttpConstants.contentTypeFormUrlEncoded,
            },
            body: {
              'grant_type': SpotifyApiConstants.grantTypeAuthCode,
              'code': code,
              'redirect_uri': SpotifyApiConstants.redirectUri,
              'client_id': clientId,
              'client_secret': clientSecret,
            },
          )
          .timeout(SpotifyApiConstants.requestTimeout);

      if (tokenResponse.statusCode != 200) {
        AppLogger.error(
          'Error obteniendo token de Spotify',
          'Status: ${tokenResponse.statusCode}, Body: ${tokenResponse.body}',
        );
        return null;
      }

      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];
      AppLogger.debug('Access token obtenido');

      // Save token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, accessToken);

      // Fetch user profile
      final profileResponse = await http
          .get(
            Uri.parse(SpotifyApiConstants.userProfileEndpoint),
            headers: {
              HttpConstants.headerAuthorization:
                  '${HttpConstants.authTypeBearer} $accessToken',
            },
          )
          .timeout(SpotifyApiConstants.requestTimeout);

      if (profileResponse.statusCode != 200) {
        AppLogger.error(
          'Error obteniendo perfil de Spotify',
          'Status: ${profileResponse.statusCode}',
        );
        return null;
      }

      final Map<String, dynamic> profile = json.decode(profileResponse.body);
      profile['access_token'] = accessToken;

      AppLogger.info('Spotify login exitoso: ${profile['display_name']}');
      return profile;
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error('Timeout en Spotify Auth', e, stackTrace);
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error en Spotify Auth', e, stackTrace);
      return null;
    }
  }

  /// Retrieves saved Spotify access token from SharedPreferences
  ///
  /// Returns token string or null if not found
  static Future<String?> getSavedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e, stackTrace) {
      AppLogger.error('Error obteniendo token guardado', e, stackTrace);
      return null;
    }
  }

  /// Removes saved Spotify token from SharedPreferences
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      AppLogger.debug('Token de Spotify eliminado');
    } catch (e, stackTrace) {
      AppLogger.error('Error eliminando token de Spotify', e, stackTrace);
    }
  }
}
