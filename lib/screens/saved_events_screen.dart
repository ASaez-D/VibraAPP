import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/concert_detail.dart';
import 'concert_detail_screen.dart';

class SavedEventsScreen extends StatelessWidget {
  final List<ConcertDetail> savedConcerts;

  const SavedEventsScreen({super.key, required this.savedConcerts});

  // --- FUNCIÓN DE COLORES DINÁMICOS ---
  Map<String, dynamic> _getThemedColors(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return {
      'scaffoldBg': isDarkMode ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7),
      'primaryText': isDarkMode ? Colors.white : Colors.black87,
      'secondaryText': isDarkMode ? Colors.grey[400] : Colors.grey[600],
      'accentColor': Colors.greenAccent, // Mantenido fijo
      'cardGradient': isDarkMode 
          ? const LinearGradient( // Modo oscuro: Degradado sutil de negro
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF252525), Color(0xFF151515)],
            )
          : const LinearGradient( // Modo claro: Degradado sutil de blanco/gris claro
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFEEEEEE)],
            ),
      'cardShadow': isDarkMode 
          ? BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))
          : BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
      'cardBorderColor': isDarkMode ? Colors.white.withOpacity(0.08) : Colors.grey.withOpacity(0.2),
      'emptyIconColor': isDarkMode ? Colors.grey[800] : Colors.grey[400],
      'emptyTextColor': isDarkMode ? Colors.grey[600] : Colors.grey[700],
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getThemedColors(context);
    final Color scaffoldBg = colors['scaffoldBg'];
    final Color primaryText = colors['primaryText'];
    
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "MIS GUARDADOS",
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
      ),
      body: savedConcerts.isEmpty
          ? _buildEmptyState(colors)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: savedConcerts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return _buildConcertCard(context, savedConcerts[index], index, colors);
              },
            ),
    );
  }

  // Aceptamos el MAPA de colores
  Widget _buildConcertCard(BuildContext context, ConcertDetail concert, int index, Map<String, dynamic> colors) {
    final Color primaryText = colors['primaryText'];
    final Color secondaryText = colors['secondaryText'];
    final Color accentColor = colors['accentColor'];
    final Gradient cardGradient = colors['cardGradient'];
    final BoxShadow cardShadow = colors['cardShadow'];
    final Color cardBorderColor = colors['cardBorderColor'];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final String day = DateFormat('d', 'es_ES').format(concert.date);
    final String month = DateFormat('MMM', 'es_ES').format(concert.date).toUpperCase();
    final String time = DateFormat('HH:mm', 'es_ES').format(concert.date);

    final String uniqueHeroTag = "saved_${concert.name}_$index";

    String priceLabel = concert.priceRange.isNotEmpty ? concert.priceRange.split('-')[0].trim() : "Info";
    if (priceLabel.length > 8) priceLabel = "Ver más";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConcertDetailScreen(
              concert: concert,
              heroTag: uniqueHeroTag, 
              initialIsSaved: true, 
            ),
          ),
        );
      },
      child: Container(
        height: 145, 
        decoration: BoxDecoration(
          gradient: cardGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cardBorderColor),
          boxShadow: [cardShadow],
        ),
        child: Row(
          children: [
            // HERO CON TAG ÚNICO
            Hero(
              tag: uniqueHeroTag, 
              child: Container(
                width: 115,
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
                  child: concert.imageUrl.isNotEmpty
                      ? Image.network(
                            concert.imageUrl, 
                            fit: BoxFit.cover,
                            cacheWidth: 300, 
                        )
                      : Center(child: Icon(Icons.music_note, color: secondaryText.withOpacity(0.5))),
                ),
              ),
            ),

            // CONTENIDO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text("$day $month", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 8),
                        Container(width: 4, height: 4, decoration: BoxDecoration(color: secondaryText.withOpacity(0.5), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(time, style: TextStyle(color: secondaryText, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Text(
                        concert.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: primaryText, fontWeight: FontWeight.w800, fontSize: 16, height: 1.1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: secondaryText),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(concert.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: secondaryText, fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          // Borde y texto del precio dinámico
                          decoration: BoxDecoration(border: Border.all(color: cardBorderColor), borderRadius: BorderRadius.circular(20)),
                          child: Text(priceLabel, style: TextStyle(color: primaryText, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          // Fondo del icono dinámico
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.black : Colors.grey[100], 
                            shape: BoxShape.circle, 
                            border: Border.all(color: cardBorderColor)
                          ),
                          child: Icon(Icons.arrow_forward_ios_rounded, color: primaryText, size: 12),
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

  // Aceptamos el MAPA de colores
  Widget _buildEmptyState(Map<String, dynamic> colors) {
    final Color emptyIconColor = colors['emptyIconColor'];
    final Color emptyTextColor = colors['emptyTextColor'];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: emptyIconColor),
          const SizedBox(height: 16),
          Text('No tienes conciertos guardados', style: TextStyle(color: emptyTextColor, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('¡Dale al icono de guardar en la Home!', style: TextStyle(color: emptyIconColor, fontSize: 14)),
        ],
      ),
    );
  }
}