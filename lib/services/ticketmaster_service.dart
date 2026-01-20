import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/concert_detail.dart';

class TicketmasterService {
  // ⚠️ RECUERDA: Mantén tu API Key segura. 
  final String apiKey = 'hy4R9jYjmpBU2aKeNbwR1UMGEXw3Wdb6';

  String _formatDate(DateTime date) {
    final utcDate = date.toUtc();
    final isoString = utcDate.toIso8601String();
    return "${isoString.split('.')[0]}Z";
  }

  // --- 1. OBTENER CONCIERTOS (FEED PRINCIPAL Y SECCIONES) ---
  Future<List<ConcertDetail>> getConcerts(
    DateTime start, 
    DateTime end, {
    String? classificationId,
    String countryCode = 'ES', 
    String? keyword,           
    int page = 0,              
    int size = 50, 
  }) async {
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);

    // URL Base
    String baseUrl = 'https://app.ticketmaster.com/discovery/v2/events.json?'
        'apikey=$apiKey'
        '&startDateTime=$startStr'
        '&endDateTime=$endStr'
        '&countryCode=$countryCode'
        '&size=$size'     
        '&page=$page'     
        '&sort=date,asc';
    
    // Lógica de Filtros
    if (keyword != null && keyword.isNotEmpty) {
      baseUrl += '&keyword=${Uri.encodeComponent(keyword)}';
    } else if (classificationId != null && classificationId.isNotEmpty) {
      baseUrl += '&classificationId=$classificationId';
    } else {
      baseUrl += '&segmentName=Music';
    }

    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['_embedded'] != null && data['_embedded']['events'] != null) {
          final events = data['_embedded']['events'] as List<dynamic>;
          return events.map((e) => ConcertDetail.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        // Reemplazado print por developer.log
        developer.log(
          'Error en respuesta de Ticketmaster',
          name: 'ticketmaster.service',
          error: 'Status: ${response.statusCode}, Body: ${response.body}',
        );
        return [];
      }
    } catch (e, stackTrace) {
      // Reemplazado print por developer.log incluyendo el stackTrace para mejor depuración
      developer.log(
        'Excepción en servicio TM',
        name: 'ticketmaster.service',
        error: e,
        stackTrace: stackTrace,
      );
      return []; 
    }
  }

  // --- 2. BUSCAR EVENTOS ESPECÍFICOS (Para "Solo para ti") ---
  Future<List<ConcertDetail>> searchEventsByKeyword(String artistName, String countryCode) async {
    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json?'
        'apikey=$apiKey'
        '&keyword=${Uri.encodeComponent(artistName)}'
        '&segmentName=Music'
        '&countryCode=$countryCode'
        '&size=5' 
        '&sort=date,asc');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['_embedded'] != null && data['_embedded']['events'] != null) {
          final events = data['_embedded']['events'] as List<dynamic>;
          return events.map((e) => ConcertDetail.fromJson(e)).toList();
        }
      } else {
        developer.log(
          'Error en búsqueda por keyword',
          name: 'ticketmaster.service',
          error: 'Status: ${response.statusCode}',
        );
      }
      return [];
    } catch (e) {
      developer.log(
        'Excepción en búsqueda por keyword',
        name: 'ticketmaster.service',
        error: e,
      );
      return [];
    }
  }
}