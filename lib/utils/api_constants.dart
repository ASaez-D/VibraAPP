/// API-related constants for external services
/// Centralizes URLs, endpoints, timeouts, and OAuth configurations
library;

/// Spotify API constants
class SpotifyApiConstants {
  SpotifyApiConstants._();

  // Base URLs
  static const String authBaseUrl = 'https://accounts.spotify.com';
  static const String apiBaseUrl = 'https://api.spotify.com/v1';

  // Endpoints
  static const String tokenEndpoint = '$authBaseUrl/api/token';
  static const String authorizeEndpoint = '$authBaseUrl/authorize';
  static const String userProfileEndpoint = '$apiBaseUrl/me';
  static const String topArtistsEndpoint = '$apiBaseUrl/me/top/artists';
  static const String searchEndpoint = '$apiBaseUrl/search';

  // OAuth Configuration
  static const String redirectUri = 'vibraapp://callback';
  static const String scopes =
      'user-read-private user-read-email user-top-read';
  static const String responseType = 'code';
  static const String grantTypeAuthCode = 'authorization_code';
  static const String grantTypeClientCredentials = 'client_credentials';

  // Query Parameters
  static const int defaultArtistLimit = 20;
  static const int searchLimit = 1;
  static const String searchTypeArtist = 'artist';

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 10);
}

/// Ticketmaster API constants
class TicketmasterApiConstants {
  TicketmasterApiConstants._();

  // Base URLs
  static const String baseUrl = 'https://app.ticketmaster.com/discovery/v2';

  // Endpoints
  static const String eventsEndpoint = '$baseUrl/events.json';

  // Query Parameters
  static const String segmentNameMusic = 'Music';
  static const String sortByDate = 'date,asc';
  static const int defaultPageSize = 20;
  static const int defaultPage = 0;
  static const int searchPageSize = 5;

  // Date ranges
  static const int defaultSearchDaysAhead = 365;

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 10);
}

/// HTTP client constants
class HttpConstants {
  HttpConstants._();

  // Headers
  static const String headerAuthorization = 'Authorization';
  static const String headerContentType = 'Content-Type';

  // Content Types
  static const String contentTypeFormUrlEncoded =
      'application/x-www-form-urlencoded';
  static const String contentTypeJson = 'application/json';

  // Authorization Types
  static const String authTypeBearer = 'Bearer';
  static const String authTypeBasic = 'Basic';
}
