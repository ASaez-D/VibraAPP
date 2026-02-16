import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/concert_detail.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_constants.dart';
import 'concert_detail_screen.dart';

class ArtistEventsScreen extends StatelessWidget {
  final String artistName;
  final List<ConcertDetail> events;

  const ArtistEventsScreen({
    super.key,
    required this.artistName,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Theme colors
    final scaffoldBg = isDarkMode ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7);
    final cardBg = isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
    final primaryText = isDarkMode ? Colors.white : Colors.black87;
    final secondaryText = isDarkMode ? Colors.white54 : Colors.grey[600]!;
    final borderColor = isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2);
    final accentColor = AppColors.secondaryAccent;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artistName,
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n?.artistEventsSubtitle ?? 'Próximos conciertos a nivel global',
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: events.isEmpty
          ? _buildEmptyState(l10n, primaryText, secondaryText)
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: events.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventCard(
                  context,
                  event,
                  cardBg,
                  primaryText,
                  secondaryText,
                  borderColor,
                  accentColor,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(AppLocalizations? l10n, Color primaryText, Color secondaryText) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 80,
            color: secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n?.artistEventsEmpty ?? 'No hay conciertos programados',
            style: TextStyle(
              color: secondaryText,
              fontSize: AppTypography.fontSizeLarge,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    ConcertDetail event,
    Color cardBg,
    Color primaryText,
    Color secondaryText,
    Color borderColor,
    Color accentColor,
  ) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final dateFormatted = DateFormat('EEE, d MMM yyyy', currentLocale).format(event.date);
    final timeFormatted = DateFormat('HH:mm', currentLocale).format(event.date);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConcertDetailScreen(concert: event),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppBorders.radiusLarge),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorders.radiusLarge),
                bottomLeft: Radius.circular(AppBorders.radiusLarge),
              ),
              child: event.imageUrl.isNotEmpty
                  ? Image.network(
                      event.imageUrl,
                      width: 120,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 120,
                        height: 140,
                        color: secondaryText.withOpacity(0.1),
                        child: Icon(
                          Icons.music_note,
                          size: 40,
                          color: secondaryText.withOpacity(0.3),
                        ),
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 140,
                      color: secondaryText.withOpacity(0.1),
                      child: Icon(
                        Icons.music_note,
                        size: 40,
                        color: secondaryText.withOpacity(0.3),
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Event Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: accentColor,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          dateFormatted,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: AppTypography.fontSizeSmall,
                            fontWeight: AppTypography.fontWeightBold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: secondaryText,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          timeFormatted,
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: AppTypography.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // City
                    Text(
                      event.city,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: AppTypography.fontSizeMedium,
                        fontWeight: AppTypography.fontWeightBold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Venue
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: secondaryText,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            event.venue,
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: AppTypography.fontSizeSmall,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Price
                    if (event.priceRange.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppBorders.radiusSmall),
                        ),
                        child: Text(
                          event.priceRange,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: AppTypography.fontSizeSmall,
                            fontWeight: AppTypography.fontWeightBold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Arrow Icon
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: secondaryText.withOpacity(0.5),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
