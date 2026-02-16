import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui'; // For ImageFilter
import '../services/ticketmaster_service.dart';
import '../models/concert_detail.dart';
import '../utils/app_logger.dart';
import '../utils/app_constants.dart';
import '../utils/api_constants.dart';
import '../l10n/app_localizations.dart';
// import 'package:url_launcher/url_launcher.dart'; // Removed as now we use internal navigation
import 'concert_detail_screen.dart';

class EventsMapScreen extends StatefulWidget {
  const EventsMapScreen({super.key});

  @override
  State<EventsMapScreen> createState() => _EventsMapScreenState();
}

class _EventsMapScreenState extends State<EventsMapScreen> {
  final TicketmasterService _ticketmasterService = TicketmasterService();
  final MapController _mapController = MapController();

  // State
  LatLng? _currentPosition;
  List<ConcertDetail> _events = [];
  bool _isLoading = true;
  String? _errorMsg;
  double _radiusKm = 50; // Default radius increased to 50km
  int _daysAhead = 90; // Default 3 months
  bool _onlyMusic = true; // Default to filtering only music
  ConcertDetail? _selectedEvent;

  // Debounce for slider
  // Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndLocate();
  }

  Future<void> _checkPermissionsAndLocate() async {
    bool serviceEnabled;
    LocationPermission permission;

    final l10n = AppLocalizations.of(context);

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _errorMsg =
              l10n?.nearbyEventsLocationDisabled ?? "Ubicación desactivada.";
          _isLoading = false;
        });
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _errorMsg =
                l10n?.nearbyEventsPermissionDenied ?? "Permiso denegado.";
            _isLoading = false;
          });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _errorMsg =
              l10n?.nearbyEventsPermissionPermanentlyDenied ??
              "Permiso denegado permanentemente.";
          _isLoading = false;
        });
      }
      return;
    }

    // Get position
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = true; // Keep loading to fetch events
      });

      // Initial fetch
      _fetchNearbyEvents();
    } catch (e) {
      AppLogger.error("Error getting location", e);
      if (mounted) {
        setState(() {
          _errorMsg = l10n?.nearbyEventsLocationError ?? "Error de ubicación.";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchNearbyEvents() async {
    if (_currentPosition == null) return;
    final l10n = AppLocalizations.of(context);

    setState(() => _isLoading = true);
    _selectedEvent = null; // Deselect on refresh

    try {
      final geoPoint =
          "${_currentPosition!.latitude},${_currentPosition!.longitude}";

      final events = await _ticketmasterService.getConcerts(
        DateTime.now(),
        DateTime.now().add(Duration(days: _daysAhead)),
        geoPoint: geoPoint,
        radius: _radiusKm.toInt(),
        unit: 'km',
        size: 100, // Increased fetch size
        segmentName: _onlyMusic
            ? TicketmasterApiConstants.segmentNameMusic
            : null,
      );

      if (mounted) {
        setState(() {
          _events = events;
          _isLoading = false;
          _errorMsg = events.isEmpty
              ? (AppLocalizations.of(context)?.nearbyEventsNoEvents ??
                    "No hay eventos.")
              : null;
        });
      }
    } catch (e) {
      AppLogger.error("Error fetching nearby events", e);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMsg = l10n?.nearbyEventsLoadError ?? "Error al cargar eventos.";
        });
      }
    }
  }

  void _onEventTapped(ConcertDetail event) {
    setState(() {
      _selectedEvent = event;
    });
  }

  void _openEventDetail(ConcertDetail event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConcertDetailScreen(concert: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          l10n?.nearbyEventsTitle ?? "Eventos Cercanos",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black, blurRadius: 10)],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // MAP LAYER
          if (_currentPosition != null)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition!,
                initialZoom: 13.0,
                onTap: (_, __) => setState(() => _selectedEvent = null),
              ),
              children: [
                TileLayer(
                  // Dark Matter CartoDB
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.vibraapp',
                ),
                MarkerLayer(
                  markers: [
                    // User Marker (Pulse)
                    Marker(
                      point: _currentPosition!,
                      width: 60,
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryAccent.withValues(alpha : 0.3),
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryAccent,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.black,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Event Markers
                    ..._events
                        .map((event) {
                          if (event.latitude == null ||
                              event.longitude == null) {
                            return null;
                          }

                          return Marker(
                            point: LatLng(event.latitude!, event.longitude!),
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () => _onEventTapped(event),
                              child: const Icon(
                                Icons.location_on,
                                color: AppColors.secondaryAccent,
                                size: 40,
                              ),
                            ),
                          );
                        })
                        .whereType<Marker>(),
                  ],
                ),
              ],
            ),

          // LOADING / ERROR LAYER
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              ),
            ),

          if (_errorMsg != null && !_isLoading)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _errorMsg!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _checkPermissionsAndLocate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                      ),
                      child: Text(
                        l10n?.nearbyEventsRetry ?? "Reintentar",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // CONTROLS LAYER (Glassmorphism)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassmorphismStart.withValues(alpha : 0.8),
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n?.nearbyEventsRadius(_radiusKm.toInt()) ??
                                "Radio: ${_radiusKm.toInt()} km",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            l10n?.nearbyEventsCount(_events.length) ??
                                "${_events.length} eventos",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _radiusKm,
                        min: 5,
                        max: 200,
                        divisions: 39,
                        activeColor: AppColors.primaryAccent,
                        inactiveColor: Colors.white24,
                        label: "${_radiusKm.toInt()} km",
                        onChanged: (val) {
                          setState(() => _radiusKm = val);
                        },
                        onChangeEnd: (val) => _fetchNearbyEvents(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n?.nearbyEventsMusicOnly ?? "Solo Música",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Switch(
                            value: _onlyMusic,
                            onChanged: (val) {
                              setState(() {
                                _onlyMusic = val;
                                _fetchNearbyEvents();
                              });
                            },
                            activeThumbColor: AppColors.primaryAccent,
                            activeTrackColor: AppColors.primaryAccent
                                .withValues(alpha : 0.5),
                            inactiveThumbColor: Colors.white54,
                            inactiveTrackColor: Colors.white24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n?.nearbyEventsDaysAhead ?? "Próximos días:",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          DropdownButton<int>(
                            value: _daysAhead,
                            dropdownColor: AppColors.glassmorphismStart,
                            style: const TextStyle(color: Colors.white),
                            underline: Container(), // Hide underline
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 30,
                                child: Text(
                                  l10n?.nearbyEventsTimeRange30Days ??
                                      "30 días",
                                ),
                              ),
                              DropdownMenuItem(
                                value: 60,
                                child: Text(
                                  l10n?.nearbyEventsTimeRange60Days ??
                                      "60 días",
                                ),
                              ),
                              DropdownMenuItem(
                                value: 90,
                                child: Text(
                                  l10n?.nearbyEventsTimeRange3Months ??
                                      "3 meses",
                                ),
                              ),
                              DropdownMenuItem(
                                value: 180,
                                child: Text(
                                  l10n?.nearbyEventsTimeRange6Months ??
                                      "6 meses",
                                ),
                              ),
                              DropdownMenuItem(
                                value: 365,
                                child: Text(
                                  l10n?.nearbyEventsTimeRange1Year ?? "1 año",
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _daysAhead = val;
                                  _fetchNearbyEvents();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // EVENT DETAIL CARD (Bottom)
          if (_selectedEvent != null)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.glassmorphismStart.withValues(alpha : 0.95),
                          AppColors.glassmorphismEnd.withValues(alpha : 0.95),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha : 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryAccent.withValues(alpha : 
                                  0.2,
                                ), // Spotify Green tint
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.event,
                                color: AppColors.secondaryAccent,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedEvent!.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${_selectedEvent!.date.day}/${_selectedEvent!.date.month}/${_selectedEvent!.date.year} • ${_selectedEvent!.venue}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white54,
                              ),
                              onPressed: () =>
                                  setState(() => _selectedEvent = null),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _openEventDetail(_selectedEvent!),
                            child: Text(
                              l10n?.nearbyEventsViewDetails ?? "Ver Detalles",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
