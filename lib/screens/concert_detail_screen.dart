import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/concert_detail.dart';

class ConcertDetailScreen extends StatelessWidget {
  final ConcertDetail concert;

  const ConcertDetailScreen({super.key, required this.concert});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(concert.name, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            concert.imageUrl.isNotEmpty
                ? Image.network(concert.imageUrl,
                    width: double.infinity, height: 250, fit: BoxFit.cover)
                : Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[900],
                    child: const Icon(Icons.music_note, size: 80, color: Colors.white38),
                  ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y género
                  Text(
                    concert.name,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  if (concert.genre.isNotEmpty)
                    Text(
                      concert.genre,
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),

                  const SizedBox(height: 16),

                  // Fecha y hora
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEEE, d MMMM yyyy, HH:mm', 'es_ES').format(concert.date),
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Ubicación
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${concert.venue}, ${concert.city}, ${concert.country}',
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  if (concert.address.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.home, color: Colors.white70),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            concert.address,
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // Botón de compra de tickets
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: concert.ticketUrl.isNotEmpty
                          ? () => _launchURL(concert.ticketUrl)
                          : null,
                      child: const Text(
                        'Comprar Entradas',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
