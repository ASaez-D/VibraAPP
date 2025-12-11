import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/concert_detail.dart';

class ConcertDetailScreen extends StatelessWidget {
  final ConcertDetail concert;

  // Quitamos los colores fijos. Los obtendremos del Theme.
  final Color accentColor = Colors.greenAccent;
  
  const ConcertDetailScreen({super.key, required this.concert});

  // --- FUNCIÓN PARA COMPRAR ENTRADAS ---
  void _launchURL(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // --- FUNCIÓN OPTIMIZADA Y CORREGIDA PARA ABRIR MAPA EXTERNO ---
  void _openMap(BuildContext context) async {
    final Uri urlToLaunch;
    final query = Uri.encodeComponent('${concert.venue}, ${concert.city}');
    
    // 1. Intentar abrir la app nativa con coordenadas (geo:) si están disponibles
    if (concert.latitude != null && concert.longitude != null) {
      urlToLaunch = Uri.parse("geo:${concert.latitude},${concert.longitude}?q=${query}");
    } else {
      // 2. Si no hay coordenadas, usar la URL web de búsqueda de Google Maps
      // Formato corregido
      urlToLaunch = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query"); 
    }

    try {
      if (await canLaunchUrl(urlToLaunch)) {
        await launchUrl(urlToLaunch, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: usar la URL web de búsqueda de Google Maps si la primera falla
        final webUrlFallback = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
        if (await canLaunchUrl(webUrlFallback)) {
          await launchUrl(webUrlFallback, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $webUrlFallback';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo abrir el mapa: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definimos los colores dinámicos basados en el tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white54 : Colors.grey[700];
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.grey[100]!;
    final mapTextureUrl = isDark 
        ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Dark_map.png/800px-Dark_map.png'
        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Map-texture-light.png/800px-Map-texture-light.png';
    
    final String formattedDate = DateFormat('EEE d MMM, HH:mm', 'es_ES').format(concert.date);
    String mainPrice = concert.priceRange.isNotEmpty ? concert.priceRange.split('-')[0].trim() : "";

    return Scaffold(
      // Usamos el color de fondo del tema
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      appBar: AppBar(
        // Usamos el color de fondo del tema
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        // Color de título dinámico
        title: Text("Evento", style: TextStyle(color: mainTextColor, fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(
          // Color dinámico
          icon: Icon(Icons.arrow_back_ios_new, color: mainTextColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            // Color dinámico
            icon: Icon(Icons.more_horiz_rounded, color: mainTextColor, size: 24),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    
                    // 1. IMAGEN DEL CONCIERTO (HERO)
                    Hero(
                      tag: concert.name + concert.date.toString(),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // Color de placeholder adaptado
                            color: isDark ? Colors.grey[900] : Colors.grey[300], 
                            boxShadow: [
                              // Sombra adaptada
                              BoxShadow(color: isDark ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0,10))
                            ],
                            image: concert.imageUrl.isNotEmpty
                                ? DecorationImage(image: NetworkImage(concert.imageUrl), fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 2. DATOS PRINCIPALES
                    Text(
                      concert.name,
                      style: TextStyle(
                        color: mainTextColor, // Color dinámico
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formattedDate.toUpperCase(),
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      concert.venue,
                      style: TextStyle(color: secondaryTextColor, fontSize: 18, fontWeight: FontWeight.w500), // Color dinámico
                    ),

                    const SizedBox(height: 32),

                    // 3. BOTONES DE ACCIÓN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBigActionButton(Icons.bookmark_border_rounded, "Guardar", isDark),
                        _buildBigActionButton(Icons.ios_share_rounded, "Compartir", isDark),
                        _buildBigActionButton(Icons.thumb_up_off_alt_rounded, "Me gusta", isDark),
                      ],
                    ),

                    const SizedBox(height: 32),
                    // Divisor adaptado
                    Divider(color: mainTextColor.withOpacity(0.1)), 
                    const SizedBox(height: 32),

                    // 4. INFORMACIÓN
                    _buildSectionTitle("Información", mainTextColor),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor, // Color de tarjeta dinámico
                        borderRadius: BorderRadius.circular(20),
                        // Borde adaptado
                        border: Border.all(color: mainTextColor.withOpacity(0.05)), 
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.info_outline_rounded, "Mayores de 18 años (DNI requerido).", mainTextColor, secondaryTextColor),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            // Divisor adaptado
                            child: Divider(color: mainTextColor.withOpacity(0.1)), 
                          ),
                          _buildInfoRow(Icons.campaign_outlined, "Organizado por ${concert.venue}", mainTextColor, secondaryTextColor),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 5. UBICACIÓN (PREVIEW DE MAPA ESTÁTICO)
                    _buildSectionTitle("Ubicación", mainTextColor),
                    const SizedBox(height: 16),
                    
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor, // Color de tarjeta dinámico
                        borderRadius: BorderRadius.circular(20),
                        // Borde adaptado
                        border: Border.all(color: mainTextColor.withOpacity(0.05)), 
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildInfoRow(Icons.meeting_room_rounded, "Apertura puertas: ${DateFormat('HH:mm').format(concert.date)}", mainTextColor, secondaryTextColor),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      // Fondo del icono adaptado
                                      decoration: BoxDecoration(color: isDark ? Colors.grey[900] : Colors.grey[300], borderRadius: BorderRadius.circular(10)), 
                                      // Icono adaptado
                                      child: Icon(Icons.storefront_rounded, color: mainTextColor, size: 24), 
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Texto adaptado
                                          Text(concert.venue, style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold, fontSize: 16)), 
                                          const SizedBox(height: 4),
                                          // Texto adaptado
                                          Text("${concert.address}, ${concert.city}", style: TextStyle(color: secondaryTextColor, fontSize: 13)), 
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // --- MAPA PREVIEW (IMAGEN ESTÁTICA SEGURA) ---
                          GestureDetector(
                            onTap: () => _openMap(context),
                            child: Container(
                              height: 180, 
                              width: double.infinity,
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  // Imagen de mapa adaptada al tema
                                  image: NetworkImage(mapTextureUrl), 
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Capa de oscurecimiento adaptada (más clara en modo claro)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  // Marcador central
                                  Icon(Icons.location_on, color: accentColor, size: 48),
                                  
                                  // Botón "Abrir Mapa"
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        // Fondo del botón adaptado
                                        color: isDark ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8), 
                                        borderRadius: BorderRadius.circular(8),
                                        // Borde adaptado
                                        border: Border.all(color: isDark ? Colors.white24 : Colors.black12)
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Texto adaptado
                                          Text("Ver mapa", style: TextStyle(color: mainTextColor, fontSize: 12, fontWeight: FontWeight.bold)), 
                                          const SizedBox(width: 6),
                                          // Icono adaptado
                                          Icon(Icons.open_in_new, color: mainTextColor, size: 14), 
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // FOOTER (Botón de compra)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: BoxDecoration(
              // Fondo adaptado
              color: Theme.of(context).scaffoldBackgroundColor, 
              // Borde adaptado
              border: Border(top: BorderSide(color: mainTextColor.withOpacity(0.1))), 
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainPrice.isEmpty ? "GRATIS" : mainPrice,
                      // Texto adaptado
                      style: TextStyle(color: mainTextColor, fontSize: 24, fontWeight: FontWeight.w900), 
                    ),
                    if (concert.priceRange.isNotEmpty)
                    // Texto adaptado
                    Text("Precio estimado", style: TextStyle(color: secondaryTextColor, fontSize: 11)), 
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: concert.ticketUrl.isNotEmpty ? () => _launchURL(concert.ticketUrl) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        // El color del texto es negro (funciona bien en modo claro y oscuro)
                        foregroundColor: Colors.black, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('COMPRAR ENTRADAS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---
  // Añadimos mainTextColor como argumento
  Widget _buildSectionTitle(String title, Color mainTextColor) {
    return Text(
      title,
      style: TextStyle(color: mainTextColor, fontSize: 22, fontWeight: FontWeight.w800),
    );
  }

  // Añadimos mainTextColor y detailColor como argumentos
  Widget _buildInfoRow(IconData icon, String text, Color mainTextColor, Color? detailColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color del icono adaptado
        Icon(icon, color: detailColor, size: 22), 
        const SizedBox(width: 14),
        Expanded(
          // Color del texto adaptado
          child: Text(text, style: TextStyle(color: mainTextColor, fontSize: 15, height: 1.3))), 
      ],
    );
  }

  // Añadimos isDark como argumento
  Widget _buildBigActionButton(IconData icon, String label, bool isDark) {
    final bgColor = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05);
    final borderColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.1);
    final iconColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : Colors.grey[700];

    return Column(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}