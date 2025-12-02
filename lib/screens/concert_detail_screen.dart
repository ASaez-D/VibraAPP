import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../models/concert_detail.dart';

class ConcertDetailScreen extends StatefulWidget {
  final ConcertDetail concert;
  
  // NUEVOS PARÁMETROS PARA SINCRONIZAR
  final bool initialIsLiked;
  final bool initialIsSaved;
  final Function(bool isLiked, bool isSaved)? onStateChanged;

  const ConcertDetailScreen({
    super.key, 
    required this.concert,
    this.initialIsLiked = false, // Por defecto false si no se pasa
    this.initialIsSaved = false,
    this.onStateChanged,
  });

  @override
  State<ConcertDetailScreen> createState() => _ConcertDetailScreenState();
}

class _ConcertDetailScreenState extends State<ConcertDetailScreen> {
  final Color accentColor = Colors.greenAccent;
  final Color backgroundColor = const Color(0xFF0E0E0E);
  final Color cardColor = const Color(0xFF1C1C1E);

  late bool isLiked;
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    // Inicializamos con lo que nos manda la Home
    isLiked = widget.initialIsLiked;
    isSaved = widget.initialIsSaved;
  }

  void _launchURL(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text("Abriendo mapa..."), backgroundColor: accentColor, duration: const Duration(seconds: 1))
    );
  }

  void _shareEvent() {
    final dateStr = DateFormat('d MMM yyyy').format(widget.concert.date);
    Share.share('¡Mira este planazo en Vibra! 🎸\n${widget.concert.name}\n📅 $dateStr\n📍 ${widget.concert.venue}\n${widget.concert.ticketUrl}');
  }

  // --- LÓGICA DE SINCRONIZACIÓN ---
  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    _notifyChanges();
  }

  void _toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
    
    if (isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Guardado"), backgroundColor: accentColor, duration: const Duration(milliseconds: 500))
      );
    }
    _notifyChanges();
  }

  // Avisamos a la pantalla anterior (Home) que ha habido cambios
  void _notifyChanges() {
    if (widget.onStateChanged != null) {
      widget.onStateChanged!(isLiked, isSaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEE d MMM, HH:mm', 'es_ES').format(widget.concert.date);
    String mainPrice = widget.concert.priceRange.isNotEmpty ? widget.concert.priceRange.split('-')[0].trim() : "";

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
                    Hero(
                      tag: widget.concert.name + widget.concert.date.toString(),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[900],
                            image: widget.concert.imageUrl.isNotEmpty
                                ? DecorationImage(image: NetworkImage(widget.concert.imageUrl), fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(widget.concert.name, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.5)),
                    const SizedBox(height: 12),
                    Text(formattedDate.toUpperCase(), style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    const SizedBox(height: 6),
                    Text(widget.concert.venue, style: const TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 32),

                    // BOTONES CONECTADOS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBigActionButton(
                          icon: isSaved ? Icons.bookmark : Icons.bookmark_border_rounded, 
                          label: isSaved ? "Guardado" : "Guardar",
                          color: isSaved ? accentColor : Colors.white, 
                          onTap: _toggleSave,
                        ),
                        _buildBigActionButton(
                          icon: Icons.ios_share_rounded, 
                          label: "Compartir",
                          onTap: _shareEvent,
                        ),
                        _buildBigActionButton(
                          icon: isLiked ? Icons.favorite : Icons.thumb_up_off_alt_rounded, 
                          label: "Me gusta",
                          color: isLiked ? Colors.redAccent : Colors.white, 
                          onTap: _toggleLike,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Divider(color: Colors.white.withOpacity(0.1)),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Información"),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.info_outline_rounded, "Mayores de 18 años (DNI requerido)."),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(color: Colors.white10)),
                          _buildInfoRow(Icons.campaign_outlined, "Organizado por ${widget.concert.venue}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Ubicación"),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildInfoRow(Icons.meeting_room_rounded, "Apertura puertas: ${DateFormat('HH:mm').format(widget.concert.date)}"),
                                const SizedBox(height: 16),
                                Row(children: [
                                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 24)),
                                    const SizedBox(width: 16),
                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(widget.concert.venue, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text("${widget.concert.address}, ${widget.concert.city}", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                    ]))
                                ]),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _openMap(context),
                            child: Container(
                              height: 180, width: double.infinity, margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: const DecorationImage(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Dark_map.png/800px-Dark_map.png'), fit: BoxFit.cover)),
                              child: Stack(alignment: Alignment.center, children: [
                                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.black.withOpacity(0.3))),
                                  Icon(Icons.location_on, color: accentColor, size: 48),
                              ]),
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800));
  Widget _buildInfoRow(IconData icon, String text) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: Colors.grey[400], size: 22), const SizedBox(width: 14), Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.3)))]);
  Widget _buildBigActionButton({required IconData icon, required String label, required VoidCallback onTap, Color color = Colors.white}) {
    return GestureDetector(onTap: onTap, child: Column(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withOpacity(0.5), width: 1.5)), child: Icon(icon, color: color, size: 26)), const SizedBox(height: 8), Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500))]));
  }
}