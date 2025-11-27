// lib/services/ticketmaster_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/concert_detail.dart';

class TicketmasterService {
  final String apiKey = 'TU_API_KEY_AQUI';

  Future<List<ConcertDetail>> getConcerts(DateTime start, DateTime end) async {
    final startStr = start.toUtc().toIso8601String();
    final endStr = end.toUtc().toIso8601String();

    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$apiKey&startDateTime=$startStr&endDateTime=$endStr&classificationName=music');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['_embedded'] != null && data['_embedded']['events'] != null) {
        final events = data['_embedded']['events'] as List<dynamic>;
        return events.map((e) => ConcertDetail.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Error al cargar conciertos (${response.statusCode})');
    }
  }
}
