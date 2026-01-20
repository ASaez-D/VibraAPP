import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';

import '../models/concert_detail.dart';
import '../services/ticketmaster_service.dart'; 
import '../services/user_data_service.dart'; 

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
  final Color accentColor = Colors.greenAccent;
  
  final TicketmasterService _ticketmasterService = TicketmasterService();
  final UserDataService _userDataService = UserDataService();

  late bool isLiked;
  late bool isSaved;

  late AnimationController _likeController;
  late Animation<double> _likeAnimation;
  late AnimationController _saveController;
  late Animation<double> _saveAnimation;

  List<ConcertDetail> _relatedConcerts = [];
  bool _isLoadingRelated = true;

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialIsLiked;
    isSaved = widget.initialIsSaved;

    _likeController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _likeController, curve: Curves.easeOutBack));

    _saveController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _saveAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _saveController, curve: Curves.easeOutBack));

    _loadMoreDates();
  }

  void _loadMoreDates() async {
    final results = await _ticketmasterService.searchEventsByKeyword(
      widget.concert.name, 
      'ES' 
    );

    if (mounted) {
      setState(() {
        _relatedConcerts = results.where((c) => c.date != widget.concert.date && c.venue != widget.concert.venue).toList();
        _isLoadingRelated = false;
      });
    }
  }

  @override
  void dispose() {
    _likeController.dispose();
    _saveController.dispose();
    super.dispose();
  }

  // --- FUNCIONES ---

  void _launchURL(String url) async {
    if (url.isEmpty) {
      return;
    }
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

  void _shareEvent(AppLocalizations l10n) {
    final dateStr = DateFormat('d MMM yyyy').format(widget.concert.date);
    // Corregido según sugerencia del linter: usar la clase Share del paquete share_plus correctamente   
    // ignore: deprecated_member_use
    Share.share('¡Mira este planazo en Vibra! 🎸\n${widget.concert.name}\n📅 $dateStr\n📍 ${widget.concert.venue}\n${widget.concert.ticketUrl}');
  }

  // --- CONECTAR BOTONES A FIREBASE ---

  void _toggleLike() {
    HapticFeedback.lightImpact();
    _likeController.forward().then((_) => _likeController.reverse());
    
    setState(() {
      isLiked = !isLiked;
    });

    _userDataService.toggleFavorite(widget.concert.name, {
      'name': widget.concert.name,
      'date': widget.concert.date.toIso8601String(),
      'imageUrl': widget.concert.imageUrl,
      'venue': widget.concert.venue,
    });

    _notifyChanges();
  }

  void _toggleSave(AppLocalizations l10n) {
    HapticFeedback.lightImpact();
    _saveController.forward().then((_) => _saveController.reverse());
    
    setState(() {
      isSaved = !isSaved;
    });

    _userDataService.toggleSaved(widget.concert.name, {
      'name': widget.concert.name,
      'date': widget.concert.date.toIso8601String(),
      'imageUrl': widget.concert.imageUrl,
      'venue': widget.concert.venue,
    });

    if (isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.commonSuccess, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white)),
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

  Map<String, Color> _getThemedColors(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return {
      'scaffoldBg': isDarkMode ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7),
      'cardBg': isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
      'primaryText': isDarkMode ? Colors.white : Colors.black87,
      'secondaryText': isDarkMode ? Colors.white54 : Colors.grey[600]!,
      'iconBg': isDarkMode ? Colors.grey[900]! : Colors.grey[200]!,
      'borderColor': isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
      'shadowColor': isDarkMode ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.1),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    final colors = _getThemedColors(context);
    final scaffoldBg = colors['scaffoldBg']!;
    final cardBg = colors['cardBg']!;
    final primaryText = colors['primaryText']!;
    final secondaryText = colors['secondaryText']!;
    final iconBg = colors['iconBg']!;
    final borderColor = colors['borderColor']!;
    final shadowColor = colors['shadowColor']!;
    
    final String formattedDate = DateFormat('EEE d MMM, HH:mm', currentLocale).format(widget.concert.date);
    
    String mainPrice = widget.concert.priceRange; 
    // Corregido: Envolviendo en bloques con llaves
    if (mainPrice == "Ver precios") {
      mainPrice = l10n.detailCheckPrices;
    } else if (mainPrice == "GRATIS") {
      mainPrice = l10n.detailFree;
    }

    final String heroTagToUse = widget.heroTag ?? widget.concert.name + widget.concert.date.toString();

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.detailEventTitle, style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.bold)),
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

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              Hero(
                tag: heroTagToUse,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: iconBg,
                      boxShadow: [
                        BoxShadow(color: shadowColor, blurRadius: 20, offset: const Offset(0,10))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.concert.imageUrl.isNotEmpty
                          ? Image.network(
                              widget.concert.imageUrl, 
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.broken_image, size: 50, color: secondaryText)),
                            )
                          : Center(child: Icon(Icons.music_note, size: 50, color: secondaryText.withValues(alpha: 0.5))),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAnimatedActionButton(
                    icon: isSaved ? Icons.bookmark : Icons.bookmark_border_rounded, 
                    label: isSaved ? l10n.detailBtnSaved : l10n.detailBtnSave,
                    iconColor: isSaved ? accentColor : primaryText,
                    textColor: secondaryText,
                    buttonBg: primaryText.withValues(alpha: 0.08),
                    borderColor: isSaved ? accentColor.withValues(alpha: 0.7) : borderColor,
                    onTap: () => _toggleSave(l10n),
                    animation: _saveAnimation,
                  ),
                  _buildAnimatedActionButton(
                    icon: Icons.ios_share_rounded, 
                    label: l10n.detailBtnShare,
                    iconColor: primaryText,
                    textColor: secondaryText,
                    buttonBg: primaryText.withValues(alpha: 0.08),
                    borderColor: borderColor,
                    onTap: () => _shareEvent(l10n),
                  ),
                  _buildAnimatedActionButton(
                    icon: isLiked ? Icons.favorite : Icons.thumb_up_off_alt_rounded, 
                    label: l10n.detailBtnLike,
                    iconColor: isLiked ? Colors.redAccent : primaryText, 
                    textColor: secondaryText,
                    buttonBg: primaryText.withValues(alpha: 0.08),
                    borderColor: isLiked ? Colors.redAccent.withValues(alpha: 0.7) : borderColor,
                    onTap: _toggleLike,
                    animation: _likeAnimation,
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Divider(color: primaryText.withValues(alpha: 0.1)),
              const SizedBox(height: 32),

              _buildSectionTitle(l10n.detailInfoTitle, primaryText),
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
                    _buildInfoRow(Icons.info_outline_rounded, l10n.detailAgeRestricted, secondaryText, primaryText),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: primaryText.withValues(alpha: 0.1)),
                    ),
                    _buildInfoRow(Icons.campaign_outlined, l10n.detailOrganizedBy(widget.concert.venue), secondaryText, primaryText),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              _buildSectionTitle(l10n.detailLocationTitle, primaryText),
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
                          _buildInfoRow(Icons.meeting_room_rounded, "${l10n.detailDoorsOpen}: ${DateFormat('HH:mm').format(widget.concert.date)}", secondaryText, primaryText),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
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
                                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600&auto=format&fit=crop',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(color: iconBg),
                                ),
                              ),
                              Container(color: primaryText.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.6)),
                              Icon(Icons.location_on, color: accentColor, size: 48),
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryText.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: borderColor)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(l10n.detailViewMap, style: TextStyle(color: primaryText, fontSize: 12, fontWeight: FontWeight.bold)),
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

              const SizedBox(height: 32),

              if (!_isLoadingRelated && _relatedConcerts.isNotEmpty) ...[
                _buildSectionTitle(l10n.detailRelatedEvents, primaryText),
                const SizedBox(height: 16),
                SizedBox(
                  height: 130, 
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _relatedConcerts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final related = _relatedConcerts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ConcertDetailScreen(concert: related)));
                        },
                        child: Container(
                          width: 280,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(related.imageUrl, width: 80, height: 100, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 80, color: iconBg)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(DateFormat('d MMM yyyy', currentLocale).format(related.date), style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(related.city, style: TextStyle(color: primaryText, fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(related.venue, style: TextStyle(color: secondaryText, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: secondaryText.withValues(alpha: 0.5), size: 14),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          color: scaffoldBg,
          border: Border(top: BorderSide(color: primaryText.withValues(alpha: 0.1))),
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
                    mainPrice, 
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (mainPrice != l10n.detailCheckPrices && mainPrice != l10n.detailFree)
                    Text(
                      l10n.detailCheckWeb,
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
                      foregroundColor: Colors.black, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(l10n.detailBtnBuy, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            color: buttonBg,
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
}