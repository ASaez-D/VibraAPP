import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/concert_detail.dart';

class TicketmasterService {
  final String apiKey = 'hy4R9jYjmpBU2aKeNbwR1UMGEXw3Wdb6';

  // Función auxiliar para formatear la fecha como le gusta a Ticketmaster
  // Elimina los milisegundos y asegura que termine en 'Z'
  String _formatDate(DateTime date) {
    final utcDate = date.toUtc();
    final isoString = utcDate.toIso8601String();
    // Tomamos la parte antes del punto (si hay milisegundos) y añadimos Z
    return "${isoString.split('.')[0]}Z";
  }

  Future<List<ConcertDetail>> getConcerts(DateTime start, DateTime end) async {
    // Usamos la función de formateo
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);

    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$apiKey&startDateTime=$startStr&endDateTime=$endStr&classificationName=music&sort=date,asc');

    // Imprimir para depuración (mira esto en tu consola si falla)
    print("Llamando a API: $url");

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
        // Imprimir el cuerpo del error para saber qué pasó
        print("Error Ticketmaster: ${response.statusCode} - ${response.body}");
        throw Exception('Error al cargar conciertos (${response.statusCode})');
      }
    } catch (e) {
      print("Excepción en servicio: $e");
      rethrow;
    }
  }
}