import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/concert_detail.dart';

class ConcertDetailScreen extends StatelessWidget {
  final ConcertDetail concert;

  final Color accentColor = Colors.greenAccent;
  final Color backgroundColor = const Color(0xFF0E0E0E);
  final Color cardColor = const Color(0xFF1C1C1E);

  const ConcertDetailScreen({super.key, required this.concert});

  // --- FUNCIÓN PARA COMPRAR ENTRADAS ---
  void _launchURL(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // --- FUNCIÓN OPTIMIZADA PARA ABRIR MAPA EXTERNO ---
  void _openMap(BuildContext context) async {
    final Uri googleMapsUrl;
    
    // Si tenemos coordenadas exactas, usamos geo:
    if (concert.latitude != null && concert.longitude != null) {
      // Intenta abrir la app nativa directamente con coordenadas
      googleMapsUrl = Uri.parse("geo:${concert.latitude},${concert.longitude}?q=${concert.latitude},${concert.longitude}(${Uri.encodeComponent(concert.venue)})");
    } else {
      // Si no, búsqueda por texto
      final query = Uri.encodeComponent('${concert.venue}, ${concert.city}');
      googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    }

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback si no hay app de mapas, abre navegador
        final webUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${concert.venue}, ${concert.city}')}");
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir el mapa")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEE d MMM, HH:mm', 'es_ES').format(concert.date);
    String mainPrice = concert.priceRange.isNotEmpty ? concert.priceRange.split('-')[0].trim() : "";

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Evento", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 24),
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
                            color: Colors.grey[900],
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0,10))
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
                      style: const TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 32),

                    // 3. BOTONES DE ACCIÓN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBigActionButton(Icons.bookmark_border_rounded, "Guardar"),
                        _buildBigActionButton(Icons.ios_share_rounded, "Compartir"),
                        _buildBigActionButton(Icons.thumb_up_off_alt_rounded, "Me gusta"),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Divider(color: Colors.white.withOpacity(0.1)),
                    const SizedBox(height: 32),

                    // 4. INFORMACIÓN
                    _buildSectionTitle("Información"),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.info_outline_rounded, "Mayores de 18 años (DNI requerido)."),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(color: Colors.white10),
                          ),
                          _buildInfoRow(Icons.campaign_outlined, "Organizado por ${concert.venue}"),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 5. UBICACIÓN (PREVIEW DE MAPA ESTÁTICO)
                    _buildSectionTitle("Ubicación"),
                    const SizedBox(height: 16),
                    
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildInfoRow(Icons.meeting_room_rounded, "Apertura puertas: ${DateFormat('HH:mm').format(concert.date)}"),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
                                      child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 24),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(concert.venue, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Text("${concert.address}, ${concert.city}", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // --- MAPA PREVIEW (IMAGEN ESTÁTICA SEGURA) ---
                          // Esto NO crashea porque es solo una imagen con un botón
                          GestureDetector(
                            onTap: () => _openMap(context),
                            child: Container(
                              height: 180, 
                              width: double.infinity,
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                  // Usamos una textura de mapa oscuro genérica de alta calidad
                                  image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Dark_map.png/800px-Dark_map.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Capa de oscurecimiento para resaltar el botón
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                  // Marcador central (Simulado)
                                  Icon(Icons.location_on, color: accentColor, size: 48),
                                  
                                  // Botón "Abrir Mapa"
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.white24)
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text("Ver mapa", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                          SizedBox(width: 6),
                                          Icon(Icons.open_in_new, color: Colors.white, size: 14),
                                        ],
                                      ),
                                    ),
                                  )
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

          // FOOTER
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainPrice.isEmpty ? "GRATIS" : mainPrice,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    if (concert.priceRange.isNotEmpty)
                    const Text("Precio estimado", style: TextStyle(color: Colors.grey, fontSize: 11)),
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
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[400], size: 22),
        const SizedBox(width: 14),
        Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.3))),
      ],
    );
  }

  Widget _buildBigActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}