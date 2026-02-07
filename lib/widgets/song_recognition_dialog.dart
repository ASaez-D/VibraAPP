import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui'; // For ImageFilter
import '../services/song_recognition_service.dart';
import '../services/ticketmaster_service.dart';
import '../models/concert_detail.dart';
import '../utils/app_logger.dart';

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
      duration: const Duration(seconds: 1),
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
    setState(() {
      _isListening = true;
      _statusMessage = "Escuchando...";
      _songResult = null;
      _upcomingEvent = null;
      _eventError = null;
    });

    try {
      _session = await _recognitionService.startRecognition();
      if (_session == null) {
        _handleError("No se pudo iniciar el reconocimiento.");
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

    if (response == null) {
      _handleError("No se recibió respuesta.");
      return;
    }

    if (response.metadata != null && response.metadata!.music.isNotEmpty) {
      final music = response.metadata!.music.first;
      AppLogger.debug("ACRCloud Music Object: ${music.toString()}");

      // Extract Metadata
      String title = music.title;
      String artist = music.artists.map((a) => a.name).join(", ");
      String? album = music.album?.name;

      // Attempt to find Spotify ID safely
      String? spotifyId;
      try {
        // ACRCloud structure varies; primarily used for consistency check
        // In production, we might parse external_metadata if available
        // dynamic extMeta = (music as dynamic).externalMetadata;
        // spotifyId = extMeta?['spotify']?['track']?['id'];
      } catch (_) {}

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
      _handleError("No se encontró ninguna coincidencia.");
    }
  }

  Future<void> _searchArtistEvents(String artistName) async {
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
          _eventError = "No hay conciertos próximos.";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingEvent = false;
        _eventError = "No se pudo cargar la info de conciertos.";
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
          const SnackBar(content: Text("No se pudo abrir Spotify")),
        );
      }
    }
  }

  Future<void> _openTicketUrl() async {
    if (_upcomingEvent?.ticketUrl != null) {
      final uri = Uri.parse(_upcomingEvent!.ticketUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Premium Dark Theme styling
    const textColor = Colors.white;
    const secondaryColor = Colors.white70;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E1E1E).withOpacity(0.95),
                  const Color(0xFF2C2C2C).withOpacity(0.95),
                ],
              ),
              border: Border.all(color: Colors.white12, width: 1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
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
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.redAccent, Colors.deepOrange],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    _statusMessage ?? "Escuchando...",
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: textColor.withOpacity(0.5)),
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
                          color: Colors.purpleAccent.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title & Artist
                  Text(
                    _songResult!['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _songResult!['artist'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Spotify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new, size: 20),
                      label: const Text("ESCUCHAR EN SPOTIFY"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: _openSpotify,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 16),

                  // Concert Info Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PRÓXIMOS EVENTOS",
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_isLoadingEvent)
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: secondaryColor,
                      ),
                    )
                  else if (_upcomingEvent != null)
                    GestureDetector(
                      onTap: _openTicketUrl,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            // Date Box
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${_upcomingEvent!.date.day}",
                                    style: const TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    _monthName(_upcomingEvent!.date.month),
                                    style: TextStyle(
                                      color: textColor.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _upcomingEvent!.city,
                                    style: const TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _upcomingEvent!.venue,
                                    style: TextStyle(
                                      color: textColor.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _eventError ?? "No hay fechas disponibles.",
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _startListening,
                    child: const Text(
                      "Escuchar otra vez",
                      style: TextStyle(color: secondaryColor),
                    ),
                  ),

                  // --- STATE: ERROR ---
                ] else ...[
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: textColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _statusMessage ?? "Error desconocido",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
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
                    child: const Text("Reintentar"),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Cerrar",
                      style: TextStyle(color: secondaryColor),
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
    const months = [
      "ENE",
      "FEB",
      "MAR",
      "ABR",
      "MAY",
      "JUN",
      "JUL",
      "AGO",
      "SEP",
      "OCT",
      "NOV",
      "DIC",
    ];
    return months[month - 1];
  }
}
