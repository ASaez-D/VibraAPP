import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/concert_detail.dart';

class TicketmasterService {
  final String apiKey = 'hy4R9jYjmpBU2aKeNbwR1UMGEXw3Wdb6';

  String _formatDate(DateTime date) {
    final utcDate = date.toUtc();
    final isoString = utcDate.toIso8601String();
    return "${isoString.split('.')[0]}Z";
  }

  // AHORA ACEPTA UN PARÁMETRO OPCIONAL classificationId
  Future<List<ConcertDetail>> getConcerts(DateTime start, DateTime end, {String? classificationId}) async {
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);

    // Construimos la URL base
    String baseUrl = 'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$apiKey&startDateTime=$startStr&endDateTime=$endStr&sort=date,asc';
    
    // Si nos pasan una clasificación (Género, Segmento...), la añadimos, si no, por defecto música
    if (classificationId != null && classificationId.isNotEmpty) {
      baseUrl += '&classificationId=$classificationId';
    } else {
      baseUrl += '&classificationName=music';
    }

    final url = Uri.parse(baseUrl);
    // print("Llamando a API: $url"); // Debug

    try {
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
        print("Error Ticketmaster: ${response.statusCode} - ${response.body}");
        throw Exception('Error al cargar conciertos');
      }
    } catch (e) {
      print("Excepción en servicio: $e");
      return []; // Retornamos lista vacía en vez de explotar
    }
  }
}