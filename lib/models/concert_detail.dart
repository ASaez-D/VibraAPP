// lib/models/concert_detail.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ConcertDetail {
  final String name;
  final String venue;
  final String address;
  final String city;
  final String country;
  final DateTime date;
  final String imageUrl;
  final String ticketUrl;
  final String genre;

  ConcertDetail({
    required this.name,
    required this.venue,
    this.address = '',
    this.city = '',
    this.country = '',
    required this.date,
    required this.imageUrl,
    this.ticketUrl = '',
    this.genre = '',
  });

  factory ConcertDetail.fromJson(Map<String, dynamic> json) {
    final venue = json['_embedded']?['venues']?[0];
    return ConcertDetail(
      name: json['name'] ?? 'Sin nombre',
      venue: venue?['name'] ?? 'Desconocido',
      address: venue?['address']?['line1'] ?? '',
      city: venue?['city']?['name'] ?? '',
      country: venue?['country']?['name'] ?? '',
      date: DateTime.parse(json['dates']?['start']?['dateTime'] ?? DateTime.now().toIso8601String()),
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : '',
      ticketUrl: json['url'] ?? '',
      genre: (json['classifications'] != null && json['classifications'].isNotEmpty)
          ? json['classifications'][0]['genre']?['name'] ?? ''
          : '',
    );
  }
}

class ConcertDetailScreen extends StatelessWidget {
  final ConcertDetail concert;

  const ConcertDetailScreen({super.key, required this.concert});

  Future<void> _launchTickets(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('No se pudo abrir el link: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(concert.name, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEN PRINCIPAL
            concert.imageUrl.isNotEmpty
                ? Image.network(concert.imageUrl,
                    width: double.infinity, height: 250, fit: BoxFit.cover)
                : Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[900],
                    child: const Icon(Icons.music_note,
                        color: Colors.white38, size: 80),
                  ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy, HH:mm', 'es_ES')
                        .format(concert.date),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  if (concert.genre.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.category, color: Colors.greenAccent),
                        const SizedBox(width: 8),
                        Text(concert.genre,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 16)),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.greenAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${concert.venue}\n${concert.address}\n${concert.city}, ${concert.country}',
                          style:
                              const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: concert.ticketUrl.isNotEmpty
                          ? () => _launchTickets(concert.ticketUrl)
                          : null,
                      child: const Text(
                        'Comprar Entradas',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
