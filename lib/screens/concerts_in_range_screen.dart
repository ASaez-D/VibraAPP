import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Asegúrate de que estas importaciones apunten a tus archivos correctos
import '../models/concert_detail.dart';
import '../services/ticketmaster_service.dart';
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
    // Inicializa el formato de fecha para español
    initializeDateFormatting('es_ES', null);
    concertsFuture = service.getConcerts(widget.startDate, widget.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "EVENTOS DISPONIBLES",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<List<ConcertDetail>>(
        future: concertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          } else {
            final concerts = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: concerts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return _buildConcertCard(context, concerts[index]);
              },
            );
          }
        },
      ),
    );
  }

  // --- WIDGET DE LA TARJETA ---
  Widget _buildConcertCard(BuildContext context, ConcertDetail concert) {
    final String day = DateFormat('d', 'es_ES').format(concert.date);
    final String month = DateFormat('MMM', 'es_ES').format(concert.date).toUpperCase();
    final String time = DateFormat('HH:mm', 'es_ES').format(concert.date);

    String priceLabel = concert.priceRange.isNotEmpty ? concert.priceRange.split('-')[0].trim() : "Info";
    if (priceLabel.length > 8) priceLabel = "Ver más";

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
        // Aumentado a 145 para evitar las barras amarillas (overflow)
        height: 145, 
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF252525), 
              const Color(0xFF151515), 
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. IMAGEN
            Hero( 
              tag: concert.name + concert.date.toString(), 
              child: Container(
                width: 115,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(concert.imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.1), 
                      BlendMode.darken
                    ),
                  ),
                ),
                child: concert.imageUrl.isEmpty 
                    ? const Center(child: Icon(Icons.music_note, color: Colors.white24)) 
                    : null,
              ),
            ),

            // 2. CONTENIDO
            Expanded(
              child: Padding(
                // Ajustado el padding vertical a 10 para ganar espacio interno
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    // A. FECHA y HORA
                    Row(
                      children: [
                        Text(
                          "$day $month",
                          style: const TextStyle(
                            color: Colors.greenAccent, 
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // B. TÍTULO (Usamos Flexible para evitar overflow horizontal/vertical)
                    Flexible(
                      child: Text(
                        concert.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          height: 1.1, 
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 4),

                    // C. UBICACIÓN
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            concert.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),

                    // Espacio ajustado para que suba un poquito
                    const SizedBox(height: 8),

                    // D. PRECIO Y FLECHA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Badge Precio
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            priceLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        
                        // FLECHA (Estilo: Círculo negro con borde)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 60, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text(
            'No hay conciertos',
            style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Prueba con otras fechas',
            style: TextStyle(color: Colors.grey[800], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 50, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Ups, algo falló',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'No pudimos cargar los eventos.\n$error',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}