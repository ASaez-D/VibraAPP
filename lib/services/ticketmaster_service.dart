import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/concert_detail.dart';

class TicketmasterService {
  // ⚠️ RECUERDA: Pon tu API Key real de Ticketmaster aquí
  final String apiKey = 'hy4R9jYjmpBU2aKeNbwR1UMGEXw3Wdb6';

  String _formatDate(DateTime date) {
    final utcDate = date.toUtc();
    final isoString = utcDate.toIso8601String();
    return "${isoString.split('.')[0]}Z";
  }

  // --- 1. OBTENER CONCIERTOS (FEED PRINCIPAL) ---
  // Ahora acepta 'keyword' para filtrar por tu "Vibra" (ej: Rock, Latino)
  Future<List<ConcertDetail>> getConcerts(
    DateTime start, 
    DateTime end, {
    String? classificationId,
    String countryCode = 'ES', // País detectado automáticamente
    String? keyword,           // Filtro inteligente (Tu Vibra)
  }) async {
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);

    // URL Base
    String baseUrl = 'https://app.ticketmaster.com/discovery/v2/events.json?'
        'apikey=$apiKey'
        '&startDateTime=$startStr'
        '&endDateTime=$endStr'
        '&countryCode=$countryCode'
        '&size=50'
        '&sort=date,asc';
    
    // Lógica de Filtros
    if (keyword != null && keyword.isNotEmpty) {
      // Si sabemos tu gusto (Vibra), filtramos por esa palabra clave
      baseUrl += '&keyword=${Uri.encodeComponent(keyword)}';
    } else if (classificationId != null && classificationId.isNotEmpty) {
      // Si pulsaste una categoría manual
      baseUrl += '&classificationId=$classificationId';
    } else {
      // Por defecto, música general
      baseUrl += '&segmentName=Music';
    }

    final url = Uri.parse(baseUrl);
    // print("Fetching: $url"); // Descomentar para debug

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Usamos utf8.decode para acentos y ñ
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['_embedded'] != null && data['_embedded']['events'] != null) {
          final events = data['_embedded']['events'] as List<dynamic>;
          return events.map((e) => ConcertDetail.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        print("Error Ticketmaster: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Excepción en servicio TM: $e");
      return []; 
    }
  }

  // --- 2. BUSCAR EVENTOS ESPECÍFICOS (Para "Solo para ti") ---
  // Busca un artista concreto en un país concreto
  Future<List<ConcertDetail>> searchEventsByKeyword(String artistName, String countryCode) async {
    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json?'
        'apikey=$apiKey'
        '&keyword=${Uri.encodeComponent(artistName)}'
        '&segmentName=Music'
        '&countryCode=$countryCode'
        '&size=5' // Pocos resultados, solo los más relevantes
        '&sort=date,asc');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['_embedded'] != null && data['_embedded']['events'] != null) {
          final events = data['_embedded']['events'] as List<dynamic>;
          return events.map((e) => ConcertDetail.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}