import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui'; // For ImageFilter
import '../services/song_recognition_service.dart';
import '../services/ticketmaster_service.dart';
import '../models/concert_detail.dart';
import '../utils/app_logger.dart';
import '../utils/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../screens/concert_detail_screen.dart';

class SongRecognitionDialog extends StatefulWidget {
  const SongRecognitionDialog({super.key});

  @override
  State<SongRecognitionDialog> createState() => _SongRecognitionDialogState();
}

class _SongRecognitionDialogState extends State<SongRecognitionDialog>
    with SingleTickerProviderStateMixin {
  final SongRecognitionService _recognitionService = SongRecognitionService();
  final TicketmasterService _ticketmasterService = TicketmasterService();
  ACRCloudSession? _session;

  bool _isListening = true;
  String? _statusMessage;

  // Result Data
  Map<String, dynamic>? _songResult;
  ConcertDetail? _upcomingEvent;
  bool _isLoadingEvent = false;
  String? _eventError;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.durationOneSecond,
    )..repeat(reverse: true);

    _startListening();
  }

  @override
  void dispose() {
    _session?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startListening() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isListening = true;
      _statusMessage = l10n?.songRecListening ?? "Escuchando...";
      _songResult = null;
      _upcomingEvent = null;
      _eventError = null;
    });

    try {
      _session = await _recognitionService.startRecognition();
      if (_session == null) {
        _handleError(
          l10n?.songRecErrorInit ?? "No se pudo iniciar el reconocimiento.",
        );
        return;
      }

      final result = await _session!.result;
      _processResult(result);
    } catch (e) {
      _handleError("Error: $e");
    }
  }

  Future<void> _processResult(ACRCloudResponse? response) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);

    if (response == null) {
      _handleError(l10n?.songRecNoResponse ?? "No se recibió respuesta.");
      return;
    }

    if (response.metadata != null && response.metadata!.music.isNotEmpty) {
      final music = response.metadata!.music.first;
      AppLogger.debug("ACRCloud Music Object: ${music.toString()}");

      // Extract Metadata
      String title = music.title;
      String artist = music.artists.map((a) => a.name).join(", ");
      String? album = music.album.name;

      // Attempt to find Spotify ID safely
      String? spotifyId;
      // Debug logging
      try {
        // Try to print the raw structure if possible
        AppLogger.debug("ACRCloud Metadata: ${response.metadata.toString()}");
      } catch (e) {
        AppLogger.error("Error logging metadata", e);
      }

      // Update UI with Song Info
      setState(() {
        _isListening = false;
        _songResult = {
          'title': title,
          'artist': artist,
          'album': album,
          'spotifyId': spotifyId,
        };
        _isLoadingEvent = true;
      });

      // Search for Upcoming Events Globally
      _searchArtistEvents(artist);
    } else {
      _handleError(
        l10n?.songRecNoMatch ?? "No se encontró ninguna coincidencia.",
      );
    }
  }

  Future<void> _searchArtistEvents(String artistName) async {
    final l10n = AppLocalizations.of(context);
    try {
      // Search globally (no country code) to find the next big event
      final events = await _ticketmasterService.searchEventsByKeyword(
        artistName,
        '',
      );

      if (!mounted) return;

      setState(() {
        _isLoadingEvent = false;
        if (events.isNotEmpty) {
          _upcomingEvent = events.first; // Pick the first relevant event
        } else {
          _eventError =
              l10n?.songRecNoDatesAvailable ?? "No hay fechas disponibles.";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingEvent = false;
        _eventError =
            l10n?.songRecErrorLoadingEvents ??
            "No se pudo cargar la info de conciertos.";
      });
    }
  }

  void _handleError(String msg) {
    if (mounted) {
      setState(() {
        _isListening = false;
        _statusMessage = msg;
        _songResult = null;
      });
    }
  }

  Future<void> _openSpotify() async {
    if (_songResult == null) return;
    final l10n = AppLocalizations.of(context);

    final String title = _songResult!['title'];
    final String artist = _songResult!['artist'];
    final String? id = _songResult!['spotifyId'];

    Uri uri;
    if (id != null && id.isNotEmpty) {
      uri = Uri.parse("https://open.spotify.com/track/$id");
    } else {
      // Fallback: Search in Spotify Web
      final query = Uri.encodeComponent("$artist $title");
      uri = Uri.parse("https://open.spotify.com/search/$query");
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.songRecOpenSpotifyError ?? "No se pudo abrir Spotify",
            ),
          ),
        );
      }
    }
  }

  void _openEventDetail() {
    if (_upcomingEvent != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConcertDetailScreen(concert: _upcomingEvent!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Localization
    final l10n = AppLocalizations.of(context);

    // Premium Dark Theme styling from AppConstants/AppColors
    const textColor =
        Colors.white; // Explicitly white for contrast on dark gradient
    const secondaryTextColor = Colors.white70;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppBorders.radiusRound),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassmorphismStart.withValues(
                    alpha : AppColors.opacityGlass,
                  ),
                  AppColors.glassmorphismEnd.withValues(alpha : 
                    AppColors.opacityGlass,
                  ),
                ],
              ),
              border: Border.all(
                color: Colors.white12,
                width: AppBorders.borderWidthThin,
              ),
              borderRadius: BorderRadius.circular(AppBorders.radiusRound),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha : 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- STATE: LISTENING ---
                if (_isListening) ...[
                  ScaleTransition(
                    scale: Tween(
                      begin: 1.0,
                      end: 1.2,
                    ).animate(_animationController),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.listeningPulseStart,
                            AppColors.listeningPulseEnd,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.listeningPulseStart.withValues(alpha : 
                              0.4,
                            ),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        size: AppSizes.iconSizeMassive,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Text(
                    _statusMessage ??
                        (l10n?.songRecListening ?? "Escuchando..."),
                    style: const TextStyle(
                      color: textColor,
                      fontSize: AppTypography.fontSizeExtraLarge,
                      fontWeight: AppTypography.fontWeightSemiBold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n?.songRecCancel ?? "Cancelar",
                      style: TextStyle(color: textColor.withValues(alpha:0.5)),
                    ),
                  ),

                  // --- STATE: SUCCESS ---
                ] else if (_songResult != null) ...[
                  // Cover Art Placeholder (Gradient Circle)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withValues(alpha : 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: AppSizes.iconSizeMassive,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Title & Artist
                  Text(
                    _songResult!['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: AppTypography.fontSizeTitle, // Slightly larger
                      fontWeight: AppTypography.fontWeightBold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _songResult!['artist'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: secondaryTextColor,
                      fontSize: AppTypography.fontSizeLarge,
                      fontWeight: AppTypography.fontWeightRegular,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Spotify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.open_in_new,
                        size: AppSizes.iconSizeMedium,
                      ),
                      label: Text(
                        l10n?.songRecOpenSpotify ?? "ESCUCHAR EN SPOTIFY",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.lg,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppBorders.radiusMedium,
                          ),
                        ),
                        elevation: 4,
                      ),
                      onPressed: _openSpotify,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: AppSpacing.lg),

                  // Concert Info Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n?.songRecUpcomingEvents ?? "PRÓXIMOS EVENTOS",
                      style: TextStyle(
                        color: textColor.withValues(alpha : 0.6),
                        fontSize: AppTypography.fontSizeSmall,
                        fontWeight: AppTypography.fontWeightBold,
                        letterSpacing: AppTypography.letterSpacingExtraWide,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  if (_isLoadingEvent)
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: secondaryTextColor,
                      ),
                    )
                  else if (_upcomingEvent != null)
                    GestureDetector(
                      onTap: _openEventDetail,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha : AppColors.opacityLow),
                          borderRadius: BorderRadius.circular(
                            AppBorders.radiusMedium,
                          ),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            // Date Box
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha : 
                                  AppColors.opacityMedium,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppBorders.radiusSmall,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${_upcomingEvent!.date.day}",
                                    style: const TextStyle(
                                      color: textColor,
                                      fontWeight: AppTypography.fontWeightBold,
                                      fontSize: AppTypography.fontSizeLarge,
                                    ),
                                  ),
                                  Text(
                                    _monthName(_upcomingEvent!.date.month),
                                    style: TextStyle(
                                      color: textColor.withValues(alpha : 0.7),
                                      fontSize: AppTypography.fontSizeSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _upcomingEvent!.city,
                                    style: const TextStyle(
                                      color: textColor,
                                      fontWeight: AppTypography.fontWeightBold,
                                      fontSize: AppTypography.fontSizeRegular,
                                    ),
                                  ),
                                  Text(
                                    _upcomingEvent!.venue,
                                    style: TextStyle(
                                      color: textColor.withValues(alpha : 0.7),
                                      fontSize: AppTypography.fontSizeMedium,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: secondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _eventError ??
                            (l10n?.songRecNoEvents ??
                                "No hay fechas disponibles."),
                        style: TextStyle(
                          color: textColor.withValues(alpha : 0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  const SizedBox(height: AppSpacing.xl),
                  TextButton(
                    onPressed: _startListening,
                    child: Text(
                      l10n?.songRecListenAgain ?? "Escuchar otra vez",
                      style: const TextStyle(color: secondaryTextColor),
                    ),
                  ),

                  // --- STATE: ERROR ---
                ] else ...[
                  Icon(
                    Icons.error_outline,
                    size: AppSizes.iconSizeMassive,
                    color: textColor.withValues(alpha : 0.5),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    _statusMessage ??
                        (l10n?.songRecErrorGeneric ?? "Error desconocido"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: AppTypography.fontSizeRegular,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  ElevatedButton(
                    onPressed: _startListening,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(l10n?.songRecRetry ?? "Reintentar"),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n?.songRecClose ?? "Cerrar",
                      style: const TextStyle(color: secondaryTextColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    final l10n = AppLocalizations.of(context);
    switch (month) {
      case 1:
        return l10n?.commonMonthShort1 ?? "ENE";
      case 2:
        return l10n?.commonMonthShort2 ?? "FEB";
      case 3:
        return l10n?.commonMonthShort3 ?? "MAR";
      case 4:
        return l10n?.commonMonthShort4 ?? "ABR";
      case 5:
        return l10n?.commonMonthShort5 ?? "MAY";
      case 6:
        return l10n?.commonMonthShort6 ?? "JUN";
      case 7:
        return l10n?.commonMonthShort7 ?? "JUL";
      case 8:
        return l10n?.commonMonthShort8 ?? "AGO";
      case 9:
        return l10n?.commonMonthShort9 ?? "SEP";
      case 10:
        return l10n?.commonMonthShort10 ?? "OCT";
      case 11:
        return l10n?.commonMonthShort11 ?? "NOV";
      case 12:
        return l10n?.commonMonthShort12 ?? "DIC";
      default:
        return "";
    }
  }
}
