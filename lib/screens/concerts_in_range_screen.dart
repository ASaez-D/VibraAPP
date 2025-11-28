import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Importa el modelo
import '../models/concert_detail.dart';
// Importa el servicio
import '../services/ticketmaster_service.dart';
// IMPORTANTE: Importa la pantalla de detalle para que la navegación funcione
import 'concert_detail_screen.dart'; 

class ConcertsInRangeScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const ConcertsInRangeScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<ConcertsInRangeScreen> createState() => _ConcertsInRangeScreenState();
}

class _ConcertsInRangeScreenState extends State<ConcertsInRangeScreen> {
  final TicketmasterService service = TicketmasterService();
  late Future<List<ConcertDetail>> concertsFuture;

  @override
  void initState() {
    super.initState();
    concertsFuture = service.getConcerts(widget.startDate, widget.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E), // Fondo negro premium
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "EVENTOS DISPONIBLES",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<ConcertDetail>>(
        future: concertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Ocurrió un error:\n${snapshot.error}',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey[800]),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay conciertos en estas fechas',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            final concerts = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: concerts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final concert = concerts[index];
                return _buildConcertCard(context, concert);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildConcertCard(BuildContext context, ConcertDetail concert) {
    // Formateo de fecha para el diseño de calendario
    final String day = DateFormat('d', 'es_ES').format(concert.date);
    final String month = DateFormat('MMM', 'es_ES').format(concert.date).toUpperCase();
    final String time = DateFormat('HH:mm', 'es_ES').format(concert.date);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConcertDetailScreen(concert: concert),
          ),
        );
      },
      child: Container(
        height: 130, // Altura fija para uniformidad
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E), // Gris oscuro tipo iOS/Glass
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)), // Borde muy sutil
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. IMAGEN (Izquierda)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: SizedBox(
                width: 110,
                height: double.infinity,
                child: concert.imageUrl.isNotEmpty
                    ? Image.network(
                        concert.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: Colors.grey[850],
                          child: const Icon(Icons.music_note, color: Colors.white24),
                        ),
                      )
                    : Container(
                        color: Colors.grey[850],
                        child: const Icon(Icons.music_note, color: Colors.white24),
                      ),
              ),
            ),

            // 2. INFORMACIÓN (Centro)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Fecha pequeña en verde
                    Row(
                      children: [
                        Text(
                          "$day $month",
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4, 
                          height: 4, 
                          decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle)
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Título
                    Text(
                      concert.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Lugar (Venue)
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.white38),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            concert.venue,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. FLECHA (Derecha)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black, // Círculo negro fondo flecha
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}