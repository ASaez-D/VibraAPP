import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/concert_detail.dart';

class ConcertDetailScreen extends StatelessWidget {
  final ConcertDetail concert;

  const ConcertDetailScreen({super.key, required this.concert});

  // Función para abrir Google Maps externo
  void _openMap() async {
    final Uri googleMapsUrl;
    
    // Si tenemos coordenadas, usamos lat/long
    if (concert.latitude != null && concert.longitude != null) {
      googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${concert.latitude},${concert.longitude}');
    } else {
      // Si no, buscamos por texto (Nombre del lugar + ciudad)
      final query = Uri.encodeComponent('${concert.venue}, ${concert.city}');
      googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$query');
    }

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String day = DateFormat('d', 'es_ES').format(concert.date);
    final String month = DateFormat('MMM', 'es_ES').format(concert.date).toUpperCase();
    final String time = DateFormat('HH:mm', 'es_ES').format(concert.date);
    final String fullDate = DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(concert.date);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: concert.imageUrl.isNotEmpty
                ? Image.network(concert.imageUrl, fit: BoxFit.cover)
                : Container(color: Colors.grey[900]),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    const Color(0xFF0E0E0E).withOpacity(0.9),
                    const Color(0xFF0E0E0E),
                  ],
                  stops: const [0.0, 0.4, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // Contenido
          SingleChildScrollView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (concert.genre.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                      ),
                      child: Text(
                        concert.genre.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 12),
                  Text(
                    concert.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Fecha
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(day, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            Text(month, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fullDate, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.grey, size: 16),
                              const SizedBox(width: 6),
                              Text("$time h", style: const TextStyle(color: Colors.grey, fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  
                  // Información de Texto Ubicación
                  _buildInfoSection(
                    icon: Icons.location_on_outlined,
                    title: concert.venue,
                    subtitle: "${concert.address}, ${concert.city}",
                  ),

                  const SizedBox(height: 16),

                  // --- AQUÍ ESTÁ EL MAPA ESTÉTICO ---
                  GestureDetector(
                    onTap: _openMap,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                        // Imagen de fondo estilo mapa oscuro (URL estática segura)
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://api.mapbox.com/styles/v1/mapbox/dark-v10/static/-3.7038,40.4168,14,0/800x400?access_token=pk.eyJ1IjoiZXhhbXBsZSIsImEiOiJja2RlMm14bXQwbmw5MnRxdHR2d294aXljIn0.xxx'), 
                              // Nota: Usamos una imagen genérica oscura de internet si falla la carga o 
                              // un color solido. Para producción, guarda una imagen 'dark_map.png' en tus assets.
                              // Como no tenemos assets, usaremos un truco visual con color:
                        ),
                        color: Colors.grey[850], 
                      ),
                      child: Stack(
                        children: [
                          // Capa de textura de mapa (simulada con imagen o color)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Dark_map.png/800px-Dark_map.png?20140924080135", // Imagen genérica de mapa oscuro
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (c,e,s) => Container(color: Colors.grey[800]),
                            ),
                          ),
                          // Gradiente oscuro encima para que no brille tanto
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ),
                          // Contenido del centro
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.greenAccent),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.map, color: Colors.greenAccent, size: 20),
                                  SizedBox(width: 8),
                                  Text("Ver en el mapa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildInfoSection(
                    icon: Icons.confirmation_number_outlined,
                    title: "Precio estimado",
                    subtitle: concert.priceRange,
                    iconColor: Colors.greenAccent,
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0E0E0E),
          border: Border(top: BorderSide(color: Colors.grey[900]!)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: concert.ticketUrl.isNotEmpty ? () => _launchURL(concert.ticketUrl) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('COMPRAR ENTRADAS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({required IconData icon, required String title, required String subtitle, Color iconColor = Colors.white70}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}