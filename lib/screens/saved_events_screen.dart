import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/concert_detail.dart';
import '../services/user_data_service.dart';
import 'concert_detail_screen.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../widgets/empty_state_widget.dart';

class SavedEventsScreen extends StatefulWidget {
  const SavedEventsScreen({super.key});

  @override
  State<SavedEventsScreen> createState() => _SavedEventsScreenState();
}

class _SavedEventsScreenState extends State<SavedEventsScreen> {
  final UserDataService _dataService = UserDataService();
  List<ConcertDetail> _savedConcerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedEvents();
  }

  Future<void> _loadSavedEvents() async {
    try {
      final eventsData = await _dataService.getSavedEvents();
      if (mounted) {
        setState(() {
          _savedConcerts = eventsData.map((data) {
            // Map Firestore data to ConcertDetail
            // Note: We might have partial data here depending on what we saved
            // Adjust fields as necessary based on what toggleSaved stores
            return ConcertDetail(
              name: data['name'] ?? '',
              date: data['date'] != null
                  ? DateTime.parse(data['date'])
                  : DateTime.now(),
              venue: data['venue'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              ticketUrl: data['ticketUrl'] ?? '',
              priceRange: data['priceRange'] ?? '',

              genre: data['genre'] ?? '',
            );
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = AppTheme(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackground,
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
        title: Text(
          l10n.menuSaved.toUpperCase(),
          style: TextStyle(
            color: theme.primaryText,
            fontWeight: AppTypography.fontWeightBlack,
            letterSpacing: 1.2,
            fontSize: AppTypography.fontSizeRegular,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            )
          : _savedConcerts.isEmpty
          ? _buildEmptyState(context, l10n, theme)
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              physics: const BouncingScrollPhysics(),
              itemCount: _savedConcerts.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                return _buildConcertCard(
                  context,
                  _savedConcerts[index],
                  index,
                  theme,
                  l10n,
                );
              },
            ),
    );
  }

  Widget _buildConcertCard(
    BuildContext context,
    ConcertDetail concert,
    int index,
    AppTheme theme,
    AppLocalizations localizations,
  ) {
    final currentLocale = Localizations.localeOf(context).languageCode;

    final String day = DateFormat('d', currentLocale).format(concert.date);
    final String month = DateFormat(
      'MMM',
      currentLocale,
    ).format(concert.date).toUpperCase();
    final String time = DateFormat('HH:mm', currentLocale).format(concert.date);

    final String uniqueHeroTag = "saved_${concert.name}_$index";

    String priceLabel = concert.priceRange.isNotEmpty
        ? concert.priceRange.split('-')[0].trim()
        : "Info";
    if (priceLabel.length > 8) {
      priceLabel = localizations.savedPriceInfo;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConcertDetailScreen(
              concert: concert,
              heroTag: uniqueHeroTag,
              initialIsSaved: true,
            ),
          ),
        );
      },
      child: Container(
        height: AppSizes.cardHeightMedium,
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(AppBorders.radiusExtraLarge),
          border: Border.all(color: theme.borderColor),
          boxShadow: theme.cardShadow,
        ),
        child: Row(
          children: [
            Hero(
              tag: uniqueHeroTag,
              child: Container(
                width: AppSizes.imageWidthLarge,
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppBorders.radiusExtraLarge),
                    bottomLeft: Radius.circular(AppBorders.radiusExtraLarge),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppBorders.radiusExtraLarge),
                    bottomLeft: Radius.circular(AppBorders.radiusExtraLarge),
                  ),
                  child: concert.imageUrl.isNotEmpty
                      ? Image.network(
                          concert.imageUrl,
                          fit: BoxFit.cover,
                          cacheWidth: AppSizes.imageCacheWidth,
                        )
                      : Center(
                          child: Icon(
                            Icons.music_note,
                            color: theme.secondaryText.withOpacity(0.5),
                          ),
                        ),
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
                          "$day $month",
                          style: TextStyle(
                            color: AppColors.primaryAccent,
                            fontWeight: AppTypography.fontWeightBold,
                            fontSize: AppTypography.fontSizeSmall,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.secondaryText.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          time,
                          style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: AppTypography.fontSizeSmall,
                            fontWeight: AppTypography.fontWeightRegular,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        concert.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.primaryText,
                          fontWeight: AppTypography.fontWeightBlack,
                          fontSize: AppTypography.fontSizeRegular,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: AppSizes.iconSizeSmall,
                          color: theme.secondaryText,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            concert.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.secondaryText,
                              fontSize: AppTypography.fontSizeSmall,
                              fontWeight: AppTypography.fontWeightRegular,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.borderColor),
                            borderRadius: BorderRadius.circular(
                              AppBorders.radiusMedium,
                            ),
                          ),
                          child: Text(
                            priceLabel,
                            style: TextStyle(
                              color: theme.primaryText,
                              fontWeight: AppTypography.fontWeightBold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: theme.isDarkMode
                                ? Colors.black
                                : Colors.grey[100],
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.borderColor),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: theme.primaryText,
                            size: AppSizes.iconSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations localizations,
    AppTheme theme,
  ) {
    return EmptyStateWidget(
      icon: Icons.bookmark_border,
      title: localizations.savedEmptyTitle,
      subtitle: localizations.savedEmptySub,
    );
  }
}
