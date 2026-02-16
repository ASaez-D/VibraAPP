import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/environment_config.dart';
import '../models/concert_detail.dart';
import '../utils/api_constants.dart';
import '../utils/app_logger.dart';

/// Service for Ticketmaster API operations
/// Handles concert/event search and retrieval
class TicketmasterService {
  final http.Client _client;

  TicketmasterService({http.Client? client})
    : _client = client ?? http.Client();

  /// Ticketmaster API key from environment configuration
  String get _apiKey => EnvironmentConfig.ticketmasterApiKey;

  /// Retrieves concerts within a date range with optional filters
  ///
  /// Parameters:
  /// - [startDate]: Start of date range
  /// - [endDate]: End of date range
  /// - [countryCode]: Optional country filter (e.g., 'ES', 'US')
  /// - [city]: Optional city filter
  /// - [keyword]: Optional search keyword
  /// - [classificationId]: Optional genre/category ID
  /// - [geoPoint]: Optional "lat,long" string for geospatial search
  /// - [radius]: Radius for geospatial search (default 5 if geoPoint provided)
  /// - [unit]: Unit for radius ('km' or 'miles', default 'km')
  /// - [page]: Page number for pagination (default: 0)
  /// - [size]: Results per page (default: 20)
  ///
  /// Returns list of [ConcertDetail] objects, or empty list on error
  Future<List<ConcertDetail>> getConcerts(
    DateTime startDate,
    DateTime endDate, {
    String? countryCode,
    String? city,
    String? keyword,
    String? classificationId,
    String? geoPoint,
    int? radius,
    String? unit,
    int page = TicketmasterApiConstants.defaultPage,
    int size = TicketmasterApiConstants.defaultPageSize,
    String? segmentName = TicketmasterApiConstants.segmentNameMusic,
  }) async {
    // Validate API key
    if (_apiKey.isEmpty) {
      AppLogger.error('Falta API key de Ticketmaster en .env');
      return [];
    }

    // Format dates to ISO 8601
    final startStr = startDate.toIso8601String().split('.')[0] + 'Z';
    final endStr = endDate.toIso8601String().split('.')[0] + 'Z';

    // Build base URL with required parameters
    String url =
        '${TicketmasterApiConstants.eventsEndpoint}'
        '?apikey=$_apiKey'
        '&startDateTime=$startStr'
        '&endDateTime=$endStr'
        '&size=$size'
        '&page=$page'
        '&sort=${TicketmasterApiConstants.sortByDate}';

    // Add segmentName if provided
    if (segmentName != null && segmentName.isNotEmpty) {
      url += '&segmentName=$segmentName';
    }

    // Add optional filters
    if (countryCode != null && countryCode.isNotEmpty) {
      url += '&countryCode=$countryCode';
    }

    if (city != null && city.isNotEmpty) {
      url += '&city=${Uri.encodeComponent(city)}';
    }

    if (keyword != null && keyword.isNotEmpty) {
      url += '&keyword=${Uri.encodeComponent(keyword)}';
    }

    if (classificationId != null && classificationId.isNotEmpty) {
      url += '&classificationId=$classificationId';
    }

    // Geospatial search
    if (geoPoint != null && geoPoint.isNotEmpty) {
      url += '&geoPoint=$geoPoint';
      if (radius != null) {
        url += '&radius=$radius';
      }
      if (unit != null) {
        url += '&unit=$unit';
      }
    }

    try {
      AppLogger.debug('Ticketmaster API call: $url');

      final response = await _client
          .get(Uri.parse(url))
          .timeout(TicketmasterApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Log total elements if available
        if (data['page'] != null && data['page']['totalElements'] != null) {
          AppLogger.info(
            'Total items found in Ticketmaster API: ${data['page']['totalElements']}',
          );
        }

        if (data['_embedded'] != null && data['_embedded']['events'] != null) {
          final List<dynamic> eventsJson = data['_embedded']['events'];
          AppLogger.info(
            'Eventos obtenidos de Ticketmaster (página actual): ${eventsJson.length}',
          );
          return eventsJson
              .map((json) => ConcertDetail.fromJson(json))
              .toList();
        } else {
          AppLogger.debug('No se encontraron eventos en Ticketmaster');
          return [];
        }
      } else {
        AppLogger.error(
          'Error en Ticketmaster API',
          'Status: ${response.statusCode}',
        );
        return [];
      }
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error('Timeout en Ticketmaster API', e, stackTrace);
      return [];
    } catch (e, stackTrace) {
      AppLogger.error('Error de conexión con Ticketmaster', e, stackTrace);
      return [];
    }
  }

  /// Quick search for events by keyword
  ///
  /// Searches for events in the next year matching the keyword
  ///
  /// Returns up to 5 matching events
  Future<List<ConcertDetail>> searchEventsByKeyword(
    String keyword,
    String? countryCode,
  ) async {
    return getConcerts(
      DateTime.now(),
      DateTime.now().add(
        const Duration(days: TicketmasterApiConstants.defaultSearchDaysAhead),
      ),
      countryCode: countryCode,
      keyword: keyword,
      size: TicketmasterApiConstants.searchPageSize,
    );
  }
}
