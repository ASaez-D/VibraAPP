import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/concert_detail.dart';
import '../l10n/app_localizations.dart';
import '../screens/filtered_events_screen.dart';
import '../screens/concert_detail_screen.dart';

// --- 1. TARJETA DE CONCIERTO (Dice Card) ---
class ConcertCard extends StatelessWidget {
  final ConcertDetail concert;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLikeToggle;
  final VoidCallback onSaveToggle;
  final VoidCallback onShare;
  final Function(bool, bool)? onStateChangedFromDetail;

  const ConcertCard({
    super.key,
    required this.concert,
    required this.isLiked,
    required this.isSaved,
    required this.onLikeToggle,
    required this.onSaveToggle,
    required this.onShare,
    this.onStateChangedFromDetail,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
    final accentColor = Colors.greenAccent;

    final String dayNum = DateFormat('d').format(concert.date);
    final String monthName = DateFormat('MMM', Localizations.localeOf(context).languageCode).format(concert.date).toUpperCase().replaceAll('.', '');
    String rawPrice = concert.priceRange;
    String priceLabel = (rawPrice.isEmpty || rawPrice == "Ver precios" || rawPrice == "Info") ? l10n.detailCheckPrices : rawPrice;
    String uniqueHeroTag = "${concert.name}_${concert.date}_home_${concert.hashCode}";

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ConcertDetailScreen(
          concert: concert, initialIsLiked: isLiked, initialIsSaved: isSaved, heroTag: uniqueHeroTag, 
          onStateChanged: (liked, saved) => onStateChangedFromDetail?.call(liked, saved)
        )));
      },
      child: Container(
        height: 320,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: cardBg, boxShadow: [BoxShadow(color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(child: Hero(tag: uniqueHeroTag, child: concert.imageUrl.isNotEmpty ? Image.network(concert.imageUrl, fit: BoxFit.cover, cacheWidth: 500) : Container(color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey.shade300))),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.1), isDarkMode ? Colors.black.withOpacity(0.95) : Colors.black.withOpacity(0.8)], stops: const [0.4, 0.6, 1.0]))),
              Positioned(top: 16, left: 16, child: Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(monthName, style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w900, height: 1)), Text(dayNum, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900, height: 1))]))),
              Positioned(top: 16, right: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(20), border: Border.all(color: isDarkMode ? Colors.white24 : Colors.grey.shade400)), child: Text(priceLabel, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 12)))),
              Positioned(bottom: 20, right: 20, child: Row(children: [
                _AnimatedIconButton(isSelected: false, iconSelected: Icons.ios_share_rounded, iconUnselected: Icons.ios_share_rounded, colorSelected: Colors.white, onTap: onShare, fillColor: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.5)),
                const SizedBox(width: 8),
                _AnimatedIconButton(isSelected: isLiked, iconSelected: Icons.favorite, iconUnselected: Icons.favorite_border_rounded, colorSelected: Colors.redAccent, fillColorSelected: Colors.redAccent.withOpacity(0.2), onTap: onLikeToggle, fillColor: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.5)),
                const SizedBox(width: 8),
                _AnimatedIconButton(isSelected: isSaved, iconSelected: Icons.bookmark, iconUnselected: Icons.bookmark_border_rounded, colorSelected: accentColor, fillColorSelected: accentColor.withOpacity(0.2), onTap: onSaveToggle, fillColor: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.5))
              ])),
              Positioned(bottom: 20, left: 20, right: 150, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(concert.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.1, shadows: [Shadow(color: Colors.black, blurRadius: 10)])), const SizedBox(height: 6), Row(children: [Icon(Icons.location_on, color: accentColor, size: 14), const SizedBox(width: 4), Expanded(child: Text(concert.venue, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis))])]))
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. TARJETA DE LISTA (Resultados de búsqueda) ---
class ConcertListCard extends StatelessWidget {
  final ConcertDetail concert;
  const ConcertListCard({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDarkMode ? Colors.white : const Color(0xFF222222);
    final secondaryText = isDarkMode ? Colors.white54 : Colors.grey.shade600;
    final accentColor = Colors.greenAccent;
    final String day = DateFormat('d MMM', Localizations.localeOf(context).languageCode).format(concert.date).toUpperCase();

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConcertDetailScreen(concert: concert))),
      child: Container(
        height: 100,
        decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade300)),
        child: Row(children: [
          ClipRRect(borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)), child: Image.network(concert.imageUrl, width: 100, height: 100, fit: BoxFit.cover, cacheWidth: 200, errorBuilder: (_,__,___) => Container(width: 100, color: Colors.grey))),
          Expanded(child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(concert.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: primaryText, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text(concert.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: secondaryText, fontSize: 13)), const SizedBox(height: 6), Text(day, style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold))]))),
          Padding(padding: const EdgeInsets.only(right: 16), child: Icon(Icons.arrow_forward_ios, color: secondaryText.withOpacity(0.5), size: 16))
        ]),
      ),
    );
  }
}

// --- 3. SECCIÓN HORIZONTAL ---
class HorizontalConcertSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ConcertDetail> concerts;
  final Set<String> likedIds;
  final Set<String> savedIds;
  final Function(ConcertDetail) onLike;
  final Function(ConcertDetail) onSave;
  final Function(ConcertDetail) onShare;
  final Function(ConcertDetail, bool, bool) onStateChange;

  const HorizontalConcertSection({super.key, required this.title, required this.subtitle, required this.concerts, required this.likedIds, required this.savedIds, required this.onLike, required this.onSave, required this.onShare, required this.onStateChange});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDarkMode ? Colors.white : const Color(0xFF222222);
    final secondaryText = isDarkMode ? Colors.white54 : Colors.grey.shade600;
    final accentColor = Colors.greenAccent;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: primaryText, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1.1)), const SizedBox(height: 4), Container(height: 3, width: 40, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))), const SizedBox(height: 6), Text(subtitle, style: TextStyle(color: secondaryText, fontSize: 13, fontWeight: FontWeight.w500))])])),
      SizedBox(height: 280, child: ListView.builder(scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), padding: const EdgeInsets.only(left: 16), itemCount: concerts.length, itemBuilder: (ctx, i) { 
        final c = concerts[i];
        return Padding(padding: const EdgeInsets.only(right: 16), child: SizedBox(width: 220, child: ConcertCard(concert: c, isLiked: likedIds.contains(c.name), isSaved: savedIds.contains(c.name), onLikeToggle: () => onLike(c), onSaveToggle: () => onSave(c), onShare: () => onShare(c), onStateChangedFromDetail: (l,s) => onStateChange(c, l, s)))); 
      })),
      const SizedBox(height: 30)
    ]);
  }
}

// --- 4. CARRUSEL DE COLECCIONES ---
class CollectionsCarousel extends StatelessWidget {
  final String countryCode;
  final String? city;

  const CollectionsCarousel({super.key, required this.countryCode, this.city});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDarkMode ? Colors.white : const Color(0xFF222222);
    final secondaryText = isDarkMode ? Colors.white54 : Colors.grey.shade600;
    final accentColor = Colors.greenAccent;
    final collections = [{"name": "Esta noche", "id": "tonight", "color": Colors.purpleAccent, "img": "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=400&auto=format&fit=crop"}, {"name": "Urbano & Latino", "id": "KnvZfZ7vAj6", "color": const Color(0xFFFF4500), "img": "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=400&auto=format&fit=crop"}, {"name": "Electrónica", "id": "KnvZfZ7vAvF", "color": Colors.blueAccent, "img": "https://images.unsplash.com/photo-1571266028243-3716f02d2d2e?q=80&w=400&auto=format&fit=crop"}, {"name": "Rock & Indie", "id": "KnvZfZ7vAeA", "color": const Color(0xFF8B0000), "img": "https://images.unsplash.com/photo-1498038432885-c6f3f1b912ee?q=80&w=400&auto=format&fit=crop"}, {"name": "Pop & Hits", "id": "KnvZfZ7vAev", "color": Colors.pinkAccent, "img": "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?q=80&w=400&auto=format&fit=crop"}, {"name": "Jazz & Blues", "id": "KnvZfZ7vAvE", "color": Colors.amber, "img": "https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?q=80&w=400&auto=format&fit=crop"}];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l10n.homeSectionCollections, style: TextStyle(color: primaryText, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1.1)), const SizedBox(height: 4), Container(height: 3, width: 40, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))), const SizedBox(height: 6), Text(l10n.homeSectionCollectionsSub, style: TextStyle(color: secondaryText, fontSize: 13, fontWeight: FontWeight.w500))])),
      SizedBox(height: 110, child: ListView.builder(scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), padding: const EdgeInsets.only(left: 16, right: 16), itemCount: collections.length, itemBuilder: (context, index) { 
        final col = collections[index]; final color = col["color"] as Color; 
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FilteredEventsScreen(categoryName: col["name"] as String, categoryId: col["id"] as String, accentColor: color, countryCode: countryCode, city: city))),
          child: Container(width: 180, margin: const EdgeInsets.only(right: 12), child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Stack(fit: StackFit.expand, children: [Image.network(col["img"] as String, fit: BoxFit.cover, cacheWidth: 400, color: Colors.black.withOpacity(0.3), colorBlendMode: BlendMode.darken), Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(0.9), color.withOpacity(0.2), Colors.black.withOpacity(0.8)], stops: const [0.0, 0.5, 1.0]))), Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.6), width: 1.5))), Positioned(bottom: 12, left: 14, child: Row(children: [Container(height: 20, width: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(col["name"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5))]))])))
        ); 
      })),
      const SizedBox(height: 30)
    ]);
  }
}

// Botón animado
class _AnimatedIconButton extends StatelessWidget {
  final bool isSelected;
  final IconData iconSelected;
  final IconData iconUnselected;
  final Color colorSelected;
  final Color? fillColorSelected;
  final VoidCallback onTap;
  final Color? fillColor;
  const _AnimatedIconButton({required this.isSelected, required this.iconSelected, required this.iconUnselected, required this.colorSelected, required this.onTap, this.fillColorSelected, this.fillColor});
  @override Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: isSelected ? (fillColorSelected ?? colorSelected.withOpacity(0.2)) : (fillColor ?? Colors.black.withOpacity(0.4)), shape: BoxShape.circle, border: Border.all(color: isSelected ? colorSelected : Colors.white.withOpacity(0.1), width: 1.5)), child: Icon(isSelected ? iconSelected : iconUnselected, color: isSelected ? colorSelected : Colors.white, size: 20)));
  }
}