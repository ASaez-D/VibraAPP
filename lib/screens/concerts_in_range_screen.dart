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
  // Color de acento constante (verde)
  final Color accentColor = Colors.greenAccent; 

  @override
  void initState() {
    super.initState();
    // Inicializa el formato de fecha para español
    initializeDateFormatting('es_ES', null);
    concertsFuture = service.getConcerts(widget.startDate, widget.endDate);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Obtener el estado del tema y los colores dinámicos
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final titleBgColor = isDark ? Colors.transparent : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      appBar: AppBar(
        backgroundColor: titleBgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: mainTextColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "EVENTOS DISPONIBLES",
          style: TextStyle(
            color: mainTextColor,
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
            return Center(
              child: CircularProgressIndicator(color: accentColor), 
            );
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString(), isDark); 
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(isDark); 
          } else {
            final concerts = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: concerts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return _buildConcertCard(context, concerts[index], isDark); 
              },
            );
          }
        },
      ),
    );
  }

  // --- WIDGET DE LA TARJETA ---
  Widget _buildConcertCard(BuildContext context, ConcertDetail concert, bool isDark) {
    
    // Colores dinámicos para la tarjeta
    final cardColorLight = Colors.white;
    final cardColorDark1 = const Color(0xFF252525);
    final cardColorDark2 = const Color(0xFF151515);

    final cardTextColor = isDark ? Colors.white : Colors.black;
    final cardDetailColor = isDark ? Colors.grey[500] : Colors.grey[700];
    final dotColor = isDark ? Colors.white24 : Colors.black26;
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.1);
    
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
        height: 145, 
        decoration: BoxDecoration(
          gradient: isDark 
              ? LinearGradient( // Modo Oscuro: Gradiente oscuro
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cardColorDark1, cardColorDark2],
                )
              : null, // Modo Claro: Color sólido
          color: isDark ? null : cardColorLight, 
          
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor), 
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.1), 
              blurRadius: isDark ? 15 : 8,
              offset: const Offset(0, 4),
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
                    colorFilter: isDark ? ColorFilter.mode(
                      Colors.black.withOpacity(0.1), 
                      BlendMode.darken
                    ) : null,
                  ),
                ),
                child: concert.imageUrl.isEmpty 
                    ? Center(child: Icon(Icons.music_note, color: dotColor)) 
                    : null,
              ),
            ),

            // 2. CONTENIDO
            Expanded(
              child: Padding(
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
                          style: TextStyle(
                            color: accentColor, 
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(width: 4, height: 4, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(color: cardDetailColor, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // B. TÍTULO
                    Flexible(
                      child: Text(
                        concert.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cardTextColor, 
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
                        Icon(Icons.location_on, size: 12, color: cardDetailColor), 
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            concert.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: cardDetailColor, fontSize: 12, fontWeight: FontWeight.w500), 
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // D. PRECIO Y FLECHA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Badge Precio
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: dotColor!), 
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            priceLabel,
                            style: TextStyle(
                              color: cardTextColor, 
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        
                        // FLECHA
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black : Colors.black.withOpacity(0.05),
                            shape: BoxShape.circle,
                            border: Border.all(color: isDark ? Colors.white12 : Colors.black12), 
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: cardTextColor, 
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

  // --- WIDGET DE ESTADO VACÍO ---
  Widget _buildEmptyState(bool isDark) {
    // Definimos las variables de color localmente, resolviendo el error.
    final textColor = isDark ? Colors.grey[600] : Colors.grey[500];
    final detailColor = isDark ? Colors.grey[800] : Colors.grey[400];
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 60, color: detailColor), 
          const SizedBox(height: 16),
          Text(
            'No hay conciertos',
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold), 
          ),
          const SizedBox(height: 8),
          Text(
            'Prueba con otras fechas',
            // Corregido para usar detailColor en lugar de secondaryTextColor
            style: TextStyle(color: detailColor, fontSize: 14), 
          ),
        ],
      ),
    );
  }

  // --- WIDGET DE ESTADO DE ERROR ---
  Widget _buildErrorState(String error, bool isDark) {
    // Definimos las variables de color localmente
    final textColor = isDark ? Colors.white : Colors.black;
    final detailColor = isDark ? Colors.white54 : Colors.black54;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 50, color: Colors.redAccent), 
            const SizedBox(height: 16),
            Text(
              'Ups, algo falló',
              style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'No pudimos cargar los eventos.\n$error',
              style: TextStyle(color: detailColor, fontSize: 13), 
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}