import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../models/concert_detail.dart';

class ConcertDetailScreen extends StatefulWidget {
  final ConcertDetail concert;
  
  // NUEVO: Para evitar choques de animaciones Hero
  final String? heroTag;
  
  // Parámetros para sincronizar
  final bool initialIsLiked;
  final bool initialIsSaved;
  final Function(bool isLiked, bool isSaved)? onStateChanged;

  const ConcertDetailScreen({
    super.key, 
    required this.concert,
    this.heroTag, // <--- AÑADIDO
    this.initialIsLiked = false,
    this.initialIsSaved = false,
    this.onStateChanged,
  });

  @override
  State<ConcertDetailScreen> createState() => _ConcertDetailScreenState();
}

class _ConcertDetailScreenState extends State<ConcertDetailScreen> with TickerProviderStateMixin {
  final Color accentColor = Colors.greenAccent;
  final Color backgroundColor = const Color(0xFF0E0E0E);
  final Color cardColor = const Color(0xFF1C1C1E);

  late bool isLiked;
  late bool isSaved;

  late AnimationController _likeController;
  late Animation<double> _likeAnimation;
  late AnimationController _saveController;
  late Animation<double> _saveAnimation;

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialIsLiked;
    isSaved = widget.initialIsSaved;

    _likeController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _likeController, curve: Curves.easeOutBack));

    _saveController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _saveAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _saveController, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _likeController.dispose();
    _saveController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMap(BuildContext context) {
    final Uri googleMapsUrl;
    if (widget.concert.latitude != null && widget.concert.longitude != null) {
      googleMapsUrl = Uri.parse("geo:${widget.concert.latitude},${widget.concert.longitude}?q=${widget.concert.latitude},${widget.concert.longitude}(${Uri.encodeComponent(widget.concert.venue)})");
    } else {
      googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${widget.concert.venue}, ${widget.concert.city}')}");
    }
    _launchURL(googleMapsUrl.toString());
  }

  void _shareEvent() {
    final dateStr = DateFormat('d MMM yyyy').format(widget.concert.date);
    Share.share('¡Mira este planazo en Vibra! 🎸\n${widget.concert.name}\n📅 $dateStr\n📍 ${widget.concert.venue}\n${widget.concert.ticketUrl}');
  }

  void _toggleLike() {
    HapticFeedback.lightImpact();
    _likeController.forward().then((_) => _likeController.reverse());
    setState(() {
      isLiked = !isLiked;
    });
    _notifyChanges();
  }

  void _toggleSave() {
    HapticFeedback.lightImpact();
    _saveController.forward().then((_) => _saveController.reverse());
    setState(() {
      isSaved = !isSaved;
    });
    if (isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Guardado"), backgroundColor: accentColor, duration: const Duration(milliseconds: 800))
      );
    }
    _notifyChanges();
  }

  void _notifyChanges() {
    if (widget.onStateChanged != null) {
      widget.onStateChanged!(isLiked, isSaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEE d MMM, HH:mm', 'es_ES').format(widget.concert.date);

    // USAMOS EL TAG PERSONALIZADO SI EXISTE, SI NO, EL DE POR DEFECTO
    final String heroTagToUse = widget.heroTag ?? widget.concert.name + widget.concert.date.toString();

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
                    
                    // IMAGEN CON HERO DINÁMICO
                    Hero(
                      tag: heroTagToUse, // <--- AQUÍ ESTÁ EL ARREGLO
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[900],
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0,10))
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: widget.concert.imageUrl.isNotEmpty
                                ? Image.network(widget.concert.imageUrl, fit: BoxFit.cover)
                                : const Center(child: Icon(Icons.music_note, size: 50, color: Colors.white24)),
                          ),
                        ),
                      ),
                    ),

                    // ... (El resto del diseño es igual, lo resumo para no ocupar tanto) ...
                    const SizedBox(height: 24),
                    Text(widget.concert.name, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.5)),
                    const SizedBox(height: 12),
                    Text(formattedDate.toUpperCase(), style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    const SizedBox(height: 6),
                    Text(widget.concert.venue, style: const TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w500)),
                    
                    const SizedBox(height: 32),

                    // BOTONES DE ACCIÓN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAnimatedActionButton(
                          icon: isSaved ? Icons.bookmark : Icons.bookmark_border_rounded, 
                          label: isSaved ? "Guardado" : "Guardar",
                          color: isSaved ? accentColor : Colors.white,
                          onTap: _toggleSave,
                          animation: _saveAnimation,
                        ),
                        _buildAnimatedActionButton(
                          icon: Icons.ios_share_rounded, 
                          label: "Compartir",
                          color: Colors.white,
                          onTap: _shareEvent,
                        ),
                        _buildAnimatedActionButton(
                          icon: isLiked ? Icons.favorite : Icons.thumb_up_off_alt_rounded, 
                          label: "Me gusta",
                          color: isLiked ? Colors.redAccent : Colors.white, 
                          onTap: _toggleLike,
                          animation: _likeAnimation,
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                                color: const Color(0xFF1C1C1E),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600&auto=format&fit=crop',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF2A2A2A)),
                                      ),
                                    ),
                                    Container(color: Colors.black.withOpacity(0.3)),
                                    Icon(Icons.location_on, color: accentColor, size: 48),
                                    Positioned(
                                      bottom: 12, right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
                                        child: Row(mainAxisSize: MainAxisSize.min, children: const [Text("Ver mapa", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)), SizedBox(width: 6), Icon(Icons.open_in_new, color: Colors.white, size: 14)]),
                                      ),
                                    )
                                  ],
                                ),
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800));
  Widget _buildInfoRow(IconData icon, String text) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: Colors.grey[400], size: 22), const SizedBox(width: 14), Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.3)))]);
  Widget _buildAnimatedActionButton({required IconData icon, required String label, required VoidCallback onTap, Color color = Colors.white, Animation<double>? animation}) {
    Widget content = Column(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withOpacity(0.5), width: 1.5)), child: Icon(icon, color: color, size: 26)), const SizedBox(height: 8), Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500))]);
    return GestureDetector(onTap: onTap, child: animation != null ? ScaleTransition(scale: animation, child: content) : content);
  }
}