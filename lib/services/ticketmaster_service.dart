import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/concert.dart';

class TicketmasterService {
  final String apiKey = 'hy4R9jYjmpBU2aKeNbwR1UMGEXw3Wdb6';

  String formatDate(DateTime dt) =>
      dt.toUtc().toIso8601String().split('.').first + 'Z';

  Future<List<Concert>> getConcerts(DateTime start, DateTime end) async {
    final startStr = formatDate(start);
    final endStr = formatDate(end);

    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$apiKey&startDateTime=$startStr&endDateTime=$endStr&classificationName=music');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['_embedded'] != null && data['_embedded']['events'] != null) {
        final events = data['_embedded']['events'] as List<dynamic>;
        return events.map((e) => Concert.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
          'Error al cargar conciertos (${response.statusCode}): ${response.body}');
    }
  }
}
