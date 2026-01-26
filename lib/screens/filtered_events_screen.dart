import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/concert_detail.dart';
import '../services/ticketmaster_service.dart';
import '../l10n/app_localizations.dart';
import 'concert_detail_screen.dart';

class FilteredEventsScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  final Color accentColor;
  // Nuevos parámetros para filtrar por región
  final String countryCode;
  final String? city;

  const FilteredEventsScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.accentColor,
    this.countryCode = 'ES', // Valor por defecto
    this.city,
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
    // AHORA SÍ FILTRAMOS POR PAÍS Y CIUDAD
    _eventsFuture = _service.getConcerts(
      DateTime.now(),
      DateTime.now().add(const Duration(days: 90)),
      classificationId: widget.categoryId,
      countryCode: widget.countryCode, // <--- USO DEL PAÍS
      city: widget.city,               // <--- USO DE LA CIUDAD
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String currentLocale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDarkMode ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              l10n.rangeTitle.toUpperCase(),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              // Mostramos también la ubicación en el título para que el usuario sepa qué está viendo
              widget.city != null 
                  ? "${widget.categoryName} (${widget.city})"
                  : widget.categoryName,
              style: TextStyle(
                color: widget.accentColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<ConcertDetail>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: widget.accentColor));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 50, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 10),
                  Text(
                    l10n.homeSearchNoResults,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  if (widget.city != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "No hay eventos de '${widget.categoryName}' en ${widget.city}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                ],
              ),
            );
          }

          final events = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildEventCard(context, events[index], l10n, currentLocale);
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, ConcertDetail event, AppLocalizations l10n, String locale) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Formato de fecha localizado (JAN/ENE)
    final String dateStr = DateFormat('dd MMM', locale).format(event.date).toUpperCase();
    final String timeStr = DateFormat('HH:mm').format(event.date);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ConcertDetailScreen(concert: event)),
      ),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Corregido: withValues -> withOpacity para compatibilidad
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Image.network(
                event.imageUrl,
                width: 100,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 100, color: Colors.grey),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "$dateStr  •  $timeStr",
                          style: TextStyle(
                            color: widget.accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // BOTÓN VER MÁS
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.savedPriceInfo, // "See more" / "Ver más"
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}