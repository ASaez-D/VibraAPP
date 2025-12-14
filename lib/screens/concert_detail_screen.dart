import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../models/concert_detail.dart';

class ConcertDetailScreen extends StatefulWidget {
  final ConcertDetail concert;
  
  final String? heroTag;

  final bool initialIsLiked;
  final bool initialIsSaved;
  final Function(bool isLiked, bool isSaved)? onStateChanged;

  const ConcertDetailScreen({
    super.key, 
    required this.concert,
    this.heroTag,
    this.initialIsLiked = false,
    this.initialIsSaved = false,
    this.onStateChanged,
  });

  @override
  State<ConcertDetailScreen> createState() => _ConcertDetailScreenState();
}

class _ConcertDetailScreenState extends State<ConcertDetailScreen> with TickerProviderStateMixin {
  // Mantener solo el accentColor fijo o moverlo al Theme global si es posible
  final Color accentColor = Colors.greenAccent; 

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

  // --- FUNCIONES (Sin cambios de lógica) ---

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
      // Corregida la URL de Maps para búsqueda por texto
      googleMapsUrl = Uri.parse("http://maps.google.com/?q=${Uri.encodeComponent('${widget.concert.venue}, ${widget.concert.city}')}");
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
      // Usar Theme.of(context).textTheme.bodyMedium?.color para el texto del SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Guardado", style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white)),
          backgroundColor: accentColor, 
          duration: const Duration(milliseconds: 800)
        )
      );
    }
    _notifyChanges();
  }

  void _notifyChanges() {
    if (widget.onStateChanged != null) {
      widget.onStateChanged!(isLiked, isSaved);
    }
  }

  // WIDGETS AUXILIARES con soporte de tema
  
  // Función auxiliar para obtener colores dinámicos
  Map<String, Color> _getThemedColors(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return {
      'scaffoldBg': isDarkMode ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7),
      'cardBg': isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
      'primaryText': isDarkMode ? Colors.white : Colors.black87,
      'secondaryText': isDarkMode ? Colors.white54 : Colors.grey[600]!,
      'iconBg': isDarkMode ? Colors.grey[900]! : Colors.grey[200]!,
      'borderColor': isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
      'shadowColor': isDarkMode ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.1),
    };
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(title, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800));
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 14),
        Expanded(child: Text(text, style: TextStyle(color: textColor, fontSize: 15, height: 1.3))),
      ],
    );
  }

  Widget _buildAnimatedActionButton({
    required IconData icon, 
    required String label, 
    required VoidCallback onTap, 
    required Color iconColor, 
    required Color textColor, 
    required Color buttonBg,
    required Color borderColor,
    Animation<double>? animation
  }) {
    Widget content = Column(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: buttonBg, // Usar el color de fondo dinámico
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: animation != null 
        ? ScaleTransition(scale: animation, child: content)
        : content,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Obtener colores basados en el tema
    final colors = _getThemedColors(context);
    final scaffoldBg = colors['scaffoldBg']!;
    final cardBg = colors['cardBg']!;
    final primaryText = colors['primaryText']!;
    final secondaryText = colors['secondaryText']!;
    final iconBg = colors['iconBg']!;
    final borderColor = colors['borderColor']!;
    final shadowColor = colors['shadowColor']!;
    
    // 2. Data Formatting
    final String formattedDate = DateFormat('EEE d MMM, HH:mm', 'es_ES').format(widget.concert.date);
    String mainPrice = widget.concert.priceRange.isNotEmpty ? widget.concert.priceRange.split('-')[0].trim() : "Info";
    
    final String heroTagToUse = widget.heroTag ?? widget.concert.name + widget.concert.date.toString();
    
    // 3. Renderizado de la pantalla
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: Text("Evento", style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: primaryText, size: 24),
            onPressed: () {},
          ),
        ],
      ),

      // CONTENIDO PRINCIPAL 
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // 1. IMAGEN DEL CONCIERTO 
              Hero(
                tag: heroTagToUse,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: iconBg, // Usar color dinámico
                      boxShadow: [
                        BoxShadow(color: shadowColor, blurRadius: 20, offset: const Offset(0,10))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.concert.imageUrl.isNotEmpty
                          ? Image.network(widget.concert.imageUrl, fit: BoxFit.cover)
                          : Center(child: Icon(Icons.music_note, size: 50, color: secondaryText.withOpacity(0.5))),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 2. DATOS PRINCIPALES
              Text(
                widget.concert.name,
                style: TextStyle(color: primaryText, fontSize: 30, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Text(
                formattedDate.toUpperCase(),
                style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
              const SizedBox(height: 6),
              Text(
                widget.concert.venue,
                style: TextStyle(color: secondaryText, fontSize: 18, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 32),

              // 3. BOTONES DE ACCIÓN ANIMADOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Botón Guardar
                  _buildAnimatedActionButton(
                    icon: isSaved ? Icons.bookmark : Icons.bookmark_border_rounded, 
                    label: isSaved ? "Guardado" : "Guardar",
                    iconColor: isSaved ? accentColor : primaryText,
                    textColor: secondaryText,
                    buttonBg: primaryText.withOpacity(0.08),
                    borderColor: isSaved ? accentColor.withOpacity(0.7) : borderColor,
                    onTap: _toggleSave,
                    animation: _saveAnimation,
                  ),
                  // Botón Compartir
                  _buildAnimatedActionButton(
                    icon: Icons.ios_share_rounded, 
                    label: "Compartir",
                    iconColor: primaryText,
                    textColor: secondaryText,
                    buttonBg: primaryText.withOpacity(0.08),
                    borderColor: borderColor,
                    onTap: _shareEvent,
                  ),
                  // Botón Me gusta
                  _buildAnimatedActionButton(
                    icon: isLiked ? Icons.favorite : Icons.thumb_up_off_alt_rounded, 
                    label: "Me gusta",
                    iconColor: isLiked ? Colors.redAccent : primaryText, 
                    textColor: secondaryText,
                    buttonBg: primaryText.withOpacity(0.08),
                    borderColor: isLiked ? Colors.redAccent.withOpacity(0.7) : borderColor,
                    onTap: _toggleLike,
                    animation: _likeAnimation,
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Divider(color: primaryText.withOpacity(0.1)),
              const SizedBox(height: 32),

              // 4. INFORMACIÓN
              _buildSectionTitle("Información", primaryText),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.info_outline_rounded, "Mayores de 18 años (DNI requerido).", secondaryText, primaryText),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: primaryText.withOpacity(0.1)),
                    ),
                    _buildInfoRow(Icons.campaign_outlined, "Organizado por ${widget.concert.venue}", secondaryText, primaryText),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 5. UBICACIÓN 
              _buildSectionTitle("Ubicación", primaryText),
              const SizedBox(height: 16),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.meeting_room_rounded, "Apertura puertas: ${DateFormat('HH:mm').format(widget.concert.date)}", secondaryText, primaryText),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                // Usar un color de fondo dinámico para el icono
                                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                                child: Icon(Icons.storefront_rounded, color: primaryText, size: 24),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.concert.venue, style: TextStyle(color: primaryText, fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text("${widget.concert.address}, ${widget.concert.city}", style: TextStyle(color: secondaryText, fontSize: 13)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    // MAPA PREVIEW 
                    GestureDetector(
                      onTap: () => _openMap(context),
                      child: Container(
                        height: 180, 
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                          color: cardBg,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  // Usar una imagen de mapa más neutral para ambos temas, o un placeholder gris.
                                  // Mantener la imagen de Unsplash, pero aplicar un filtro/overlay dinámico.
                                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600&auto=format&fit=crop',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(color: iconBg), // Color dinámico en caso de error
                                ),
                              ),
                              // Overlay dinámico para contraste
                              Container(color: primaryText.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.6)),
                              Icon(Icons.location_on, color: accentColor, size: 48),
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    // Fondo dinámico para el botón del mapa
                                    color: primaryText.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: borderColor)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Ver mapa", style: TextStyle(color: primaryText, fontSize: 12, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 6),
                                      Icon(Icons.open_in_new, color: primaryText, size: 14),
                                    ],
                                  ),
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

      // --- 6. FOOTER DE COMPRA ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          color: scaffoldBg,
          border: Border(top: BorderSide(color: primaryText.withOpacity(0.1))),
        ),
        child: SafeArea(
          top: false, 
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mainPrice.isEmpty ? "Info" : mainPrice,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (widget.concert.priceRange.isNotEmpty)
                    Text(
                      "Consulta en web.",
                      style: TextStyle(color: secondaryText, fontSize: 11),
                    )
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: widget.concert.ticketUrl.isNotEmpty ? () => _launchURL(widget.concert.ticketUrl) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      // El texto del botón principal SIEMPRE debe ser oscuro para contrastar con accentColor
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
      ),
    );
  }
}