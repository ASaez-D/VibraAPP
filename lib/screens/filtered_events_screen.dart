import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/concert_detail.dart';
import '../services/ticketmaster_service.dart';
import '../l10n/app_localizations.dart';
import 'concert_detail_screen.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../utils/text_constants.dart';
import '../widgets/empty_state_widget.dart';

class FilteredEventsScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  final Color accentColor;
  final String countryCode;
  final String? city;

  const FilteredEventsScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.accentColor,
    this.countryCode = AppTextConstants.defaultCountryCode,
    this.city,
  });

  @override
  State<FilteredEventsScreen> createState() => _FilteredEventsScreenState();
}

class _FilteredEventsScreenState extends State<FilteredEventsScreen> {
  final TicketmasterService _ticketmasterService = TicketmasterService();
  late Future<List<ConcertDetail>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    // Filtrar eventos por país, ciudad y clasificación
    _eventsFuture = _ticketmasterService.getConcerts(
      DateTime.now(),
      DateTime.now().add(Duration(days: AppTime.daysInThreeMonths)),
      classificationId: widget.categoryId,
      countryCode: widget.countryCode,
      city: widget.city,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = AppTheme(context);
    final String currentLocale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.primaryText,
            size: AppSizes.iconSizeMedium,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              localizations.rangeTitle.toUpperCase(),
              style: TextStyle(
                color: theme.primaryText,
                fontSize: AppTypography.fontSizeMedium,
                fontWeight: AppTypography.fontWeightBlack,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              widget.city != null
                  ? "${widget.categoryName} (${widget.city})"
                  : widget.categoryName,
              style: TextStyle(
                color: widget.accentColor,
                fontSize: 11,
                fontWeight: AppTypography.fontWeightBold,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<ConcertDetail>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: widget.accentColor),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.event_busy,
              title: localizations.homeSearchNoResults,
              subtitle: widget.city != null
                  ? "No hay eventos de '${widget.categoryName}' en ${widget.city}"
                  : null,
            );
          }

          final events = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
            itemBuilder: (context, index) {
              return _buildEventCard(
                context,
                events[index],
                localizations,
                currentLocale,
                theme,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    ConcertDetail event,
    AppLocalizations localizations,
    String locale,
    AppTheme theme,
  ) {
    // Formato de fecha localizado (JAN/ENE)
    final String dateStr = DateFormat(
      'dd MMM',
      locale,
    ).format(event.date).toUpperCase();
    final String timeStr = DateFormat('HH:mm').format(event.date);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ConcertDetailScreen(concert: event)),
      ),
      child: Container(
        height: AppSizes.cardHeightSmall,
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(AppBorders.radiusExtraLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: AppColors.opacityMedium),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: Image.network(
                event.imageUrl,
                width: AppSizes.imageWidthMedium,
                height: AppSizes.cardHeightSmall,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: AppSizes.imageWidthMedium,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "$dateStr  •  $timeStr",
                          style: TextStyle(
                            color: widget.accentColor,
                            fontSize: AppTypography.fontSizeSmall,
                            fontWeight: AppTypography.fontWeightBold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      event.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.primaryText,
                        fontWeight: AppTypography.fontWeightBold,
                        fontSize: AppTypography.fontSizeRegular,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs / 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: AppSizes.iconSizeSmall,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            event.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: AppTypography.fontSizeSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // BOTÓN VER MÁS
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: theme.isDarkMode
                            ? Colors.white.withValues(
                                alpha: AppColors.opacityMedium,
                              )
                            : Colors.black.withValues(
                                alpha: AppColors.opacityLow,
                              ),
                        borderRadius: BorderRadius.circular(
                          AppBorders.radiusMedium,
                        ),
                      ),
                      child: Text(
                        localizations.savedPriceInfo,
                        style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 11,
                          fontWeight: AppTypography.fontWeightBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
