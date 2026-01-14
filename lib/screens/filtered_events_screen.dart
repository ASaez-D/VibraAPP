import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/concert_detail.dart';
import '../services/ticketmaster_service.dart';
import 'concert_detail_screen.dart';

class FilteredEventsScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId; 
  final Color accentColor;

  const FilteredEventsScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.accentColor,
  });

  @override
  State<FilteredEventsScreen> createState() => _FilteredEventsScreenState();
}

class _FilteredEventsScreenState extends State<FilteredEventsScreen> {
  final TicketmasterService _service = TicketmasterService();
  late Future<List<ConcertDetail>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    DateTime start = DateTime.now();
    DateTime end = DateTime.now().add(const Duration(days: 60));
    String? filterId = widget.categoryId;

    if (widget.categoryId == 'tonight') {
      end = DateTime.now().add(const Duration(days: 1)); 
      filterId = null; 
    }

    _eventsFuture = _service.getConcerts(start, end, classificationId: filterId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.categoryName, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<ConcertDetail>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: widget.accentColor));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_busy, color: Colors.white24, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    l10n.homeErrorNoEvents(widget.categoryName), // "No hay eventos en {categoryName}"
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final events = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) => _buildCard(context, events[index]),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, ConcertDetail concert) {
    // Obtenemos el idioma actual para formatear la fecha de la tarjeta
    final currentLocale = Localizations.localeOf(context).languageCode;
    final String dayNum = DateFormat('d').format(concert.date);
    final String monthName = DateFormat('MMM', currentLocale).format(concert.date).toUpperCase().replaceAll('.', '');

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConcertDetailScreen(concert: concert))),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1C1C1E),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: concert.imageUrl.isNotEmpty
                    ? Image.network(
                        concert.imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 500,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: const Color(0xFF2A2A2A), child: const Icon(Icons.music_note, color: Colors.white10, size: 60));
                        },
                      )
                    : Container(color: const Color(0xFF2A2A2A)),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),

              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Text(monthName, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(dayNum, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 16, left: 16, right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      concert.name, 
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis, 
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: widget.accentColor, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            concert.venue, 
                            style: const TextStyle(color: Colors.white70, fontSize: 13), 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}