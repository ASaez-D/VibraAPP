import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart'; // Ya no es necesario aquí si está en main
import '../l10n/app_localizations.dart';
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
    // initializeDateFormatting('es_ES', null); // Se hace globalmente
    
    DateTime start = widget.startDate;
    DateTime end = DateTime(widget.endDate.year, widget.endDate.month, widget.endDate.day, 23, 59, 59);

    concertsFuture = service.getConcerts(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    String titleDate = "";
    if (widget.startDate.day == widget.endDate.day && widget.startDate.month == widget.endDate.month) {
      titleDate = DateFormat('d MMM', currentLocale).format(widget.startDate).toUpperCase();
    } else {
      titleDate = "${DateFormat('d MMM', currentLocale).format(widget.startDate)} - ${DateFormat('d MMM', currentLocale).format(widget.endDate)}".toUpperCase();
    }

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
        title: Column(
          children: [
            const Text(
              "EVENTOS DISPONIBLES", // Puedes añadir "eventsAvailable" al ARB si quieres traducirlo
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2, fontSize: 14),
            ),
            Text(titleDate, style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: FutureBuilder<List<ConcertDetail>>(
        future: concertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(l10n); // Pasamos l10n
          } else {
            final allConcerts = snapshot.data!;
            final validConcerts = allConcerts.where((c) {
              return c.date.isAfter(widget.startDate.subtract(const Duration(seconds: 1))) && 
                     c.date.isBefore(widget.endDate.add(const Duration(days: 1))); 
            }).toList();

            if (validConcerts.isEmpty) return _buildEmptyState(l10n);

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: validConcerts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return _buildConcertCard(context, validConcerts[index], currentLocale, l10n);
              },
            );
          }
        },
      ),
    );
  }

  // --- TARJETA ---
  Widget _buildConcertCard(BuildContext context, ConcertDetail concert, String locale, AppLocalizations l10n) {
    final String day = DateFormat('d', locale).format(concert.date);
    final String month = DateFormat('MMM', locale).format(concert.date).toUpperCase();
    final String time = DateFormat('HH:mm', locale).format(concert.date);

    String priceLabel = concert.priceRange.isNotEmpty ? concert.priceRange.split('-')[0].trim() : "Info";
    // "Ver más" -> Podrías añadirlo al ARB como "seeMore"
    if (priceLabel.length > 8) priceLabel = "Ver más"; 

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConcertDetailScreen(concert: concert)));
      },
      child: Container(
        height: 145, 
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF252525), Color(0xFF151515)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Hero( 
              tag: "${concert.name}_calendar_${concert.date}", 
              child: Container(
                width: 115, height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
                  child: concert.imageUrl.isNotEmpty
                    ? Image.network(concert.imageUrl, fit: BoxFit.cover, cacheWidth: 300, errorBuilder: (c,e,s) => Container(color: Colors.grey[900], child: const Icon(Icons.music_note, color: Colors.white24)))
                    : Container(color: Colors.grey[900], child: const Icon(Icons.music_note, color: Colors.white24)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Row(
                      children: [
                        Text("$day $month", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 8),
                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Flexible(child: Text(concert.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, height: 1.1))),
                    const SizedBox(height: 4),
                    Row(children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(child: Text(concert.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500))),
                    ]),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(20)), child: Text(priceLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Colors.white12)), child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 12)),
                    ])
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 60, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text(l10n.homeErrorNoEvents(''), style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold)), // "No hay eventos"
          const SizedBox(height: 8),
          Text('Prueba con otras fechas', style: TextStyle(color: Colors.grey[800], fontSize: 14)), // Podrías añadir esto al ARB también
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(child: Text('Error: $error', style: const TextStyle(color: Colors.white)));
  }
}