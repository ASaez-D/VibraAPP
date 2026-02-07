import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/song_recognition_service.dart';
import '../utils/app_logger.dart';

class SongRecognitionDialog extends StatefulWidget {
  const SongRecognitionDialog({super.key});

  @override
  State<SongRecognitionDialog> createState() => _SongRecognitionDialogState();
}

class _SongRecognitionDialogState extends State<SongRecognitionDialog>
    with SingleTickerProviderStateMixin {
  final SongRecognitionService _service = SongRecognitionService();
  ACRCloudSession? _session;

  bool _isListening = true;
  String? _statusMessage;
  Map<String, dynamic>? _result;
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
      _result = null;
    });

    try {
      _session = await _service.startRecognition();
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

  void _processResult(ACRCloudResponse? response) {
    if (!mounted) return;

    if (response == null) {
      _handleError("No se recibió respuesta.");
      return;
    }

    // Attempt to parse metadata
    // The library returns an object, we need to inspect it.
    // Based on typical ACRCloud response structure:
    if (response.metadata != null && response.metadata!.music.isNotEmpty) {
      // Debug logging
      try {
        // Try to print the raw structure if possible, or at least the string representation
        print("ACRCloud Metadata: ${response.metadata.toString()}");
      } catch (e) {
        print(e);
      }

      final music = response.metadata!.music.first;
      // Log the full response to debug the structure
      AppLogger.debug("ACRCloud Music Object: ${music.toString()}");

      // Temporarily disable external metadata access until structure is confirmed
      String? spotifyId;
      // try {
      //   // Inspecting available properties via toString() in logs first
      //   // dynamic extMeta = (music as dynamic).externalMetadata;
      // } catch (e) {
      //   AppLogger.error("Error parsing metadata", e);
      // }

      // externalMetadata might be structured differently or require a cast if types are incomplete
      // dynamic extMeta = (music as dynamic).externalMetadata;
      // String? spotifyId;
      // if (extMeta is Map) {
      //   spotifyId = extMeta['spotify']?['track']?['id'];
      // } else if (extMeta != null) {
      //   // If it's an object, try accessing safely or assume it might be missing
      //   try {
      //     spotifyId = extMeta.spotify?.track?.id;
      //   } catch (_) {}
      // }

      setState(() {
        _isListening = false;
        _result = {
          'title': music.title,
          'artist': music.artists.map((a) => a.name).join(", "),
          'album': music.album?.name,
          'spotify': spotifyId,
        };
      });
    } else {
      _handleError("No se encontró ninguna coincidencia.");
    }
  }

  void _handleError(String msg) {
    if (mounted) {
      setState(() {
        _isListening = false;
        _statusMessage = msg;
        _result = null;
      });
    }
  }

  Future<void> _openSpotify(String? trackId) async {
    if (trackId == null) return;
    // Construct URI.
    // Usually externalMetadata gives specific IDs.
    // Let's assume we get an ID or we might need to search.
    // For now, if we have an ID:
    final uri = Uri.parse("https://open.spotify.com/track/$trackId");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No se pudo abrir Spotify")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Dialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isListening) ...[
              ScaleTransition(
                scale: Tween(
                  begin: 1.0,
                  end: 1.2,
                ).animate(_animationController),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _statusMessage ?? "Escuchando...",
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ] else if (_result != null) ...[
              const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                _result!['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _result!['artist'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              if (_result!['spotify'] != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.music_note), // Ideally Spotify logo
                  label: const Text("Abrir en Spotify"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _openSpotify(_result!['spotify']),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _startListening,
                child: const Text("Intentar de nuevo"),
              ),
            ] else ...[
              Icon(
                Icons.error_outline,
                size: 50,
                color: textColor.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                _statusMessage ?? "Error desconocido",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startListening,
                child: const Text("Reintentar"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cerrar"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
