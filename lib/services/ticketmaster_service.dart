import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../models/concert_detail.dart';



class TicketmasterService {

  // ⚠️ Asegúrate de que esta sea tu API Key correcta

  final String _apiKey = 'hy4R9jYjmpBU2aKeNbwR1UMGEXw3Wdb6'; 

  final String _baseUrl = 'https://app.ticketmaster.com/discovery/v2/events.json';



  Future<List<ConcertDetail>> getConcerts(

    DateTime startDate,

    DateTime endDate, {

    String? countryCode,

    String? city,             // Filtro por Ciudad

    String? keyword,          // Filtro por Palabra clave

    String? classificationId, // <--- NUEVO: Filtro por Categoría/Género (Soluciona tu error)

    int page = 0,

    int size = 20,

  }) async {

    

    // Formatear fechas a ISO 8601

    final startStr = startDate.toIso8601String().split('.')[0] + 'Z';

    final endStr = endDate.toIso8601String().split('.')[0] + 'Z';



    // Construcción base de la URL

    String url =

        '$_baseUrl?apikey=$_apiKey&startDateTime=$startStr&endDateTime=$endStr&size=$size&page=$page&sort=date,asc&segmentName=Music';



    // 1. Filtro por País

    if (countryCode != null && countryCode.isNotEmpty) {

      url += '&countryCode=$countryCode';

    }



    // 2. Filtro por Ciudad

    if (city != null && city.isNotEmpty) {

      url += '&city=${Uri.encodeComponent(city)}';

    }



    // 3. Filtro por Palabra Clave

    if (keyword != null && keyword.isNotEmpty) {

      url += '&keyword=${Uri.encodeComponent(keyword)}';

    }



    // 4. Filtro por ID de Clasificación (Género/Estilo)

    // Esto es lo que necesita FilteredEventsScreen

    if (classificationId != null && classificationId.isNotEmpty) {

      url += '&classificationId=$classificationId';

    }



    try {

      debugPrint('API Call: $url'); 

      final response = await http.get(Uri.parse(url));



      if (response.statusCode == 200) {

        final data = json.decode(response.body);



        if (data['_embedded'] != null && data['_embedded']['events'] != null) {

          final List<dynamic> eventsJson = data['_embedded']['events'];

          return eventsJson.map((json) => ConcertDetail.fromJson(json)).toList();

        } else {

          return [];

        }

      } else {

        debugPrint('Error Ticketmaster API: ${response.statusCode}');

        return [];

      }

    } catch (e) {

      debugPrint('Error de conexión: $e');

      return [];

    }

  }



  // Método auxiliar para búsquedas rápidas

  Future<List<ConcertDetail>> searchEventsByKeyword(String keyword, String countryCode) async {

    return getConcerts(

      DateTime.now(),

      DateTime.now().add(const Duration(days: 365)),

      countryCode: countryCode,

      keyword: keyword,

      size: 5,

    );

  }

}