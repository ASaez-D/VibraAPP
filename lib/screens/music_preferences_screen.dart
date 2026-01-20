import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/spotify_api_service.dart';
import '../services/user_data_service.dart';
import 'home_screen.dart';

class MusicPreferencesScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final String authSource;

  const MusicPreferencesScreen({
    super.key,
    required this.userProfile,
    required this.authSource,
  });

  @override
  State<MusicPreferencesScreen> createState() => _MusicPreferencesScreenState();
}

class _MusicPreferencesScreenState extends State<MusicPreferencesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SpotifyAPIService _spotifyService = SpotifyAPIService();
  final UserDataService _userDataService = UserDataService();

  List<Map<String, String>> searchResults = [];
  final Set<Map<String, String>> selectedArtists = {};
  final Set<String> selectedGenres = {}; 

  bool _isSearching = false;
  bool _isSaving = false;

  final List<Map<String, dynamic>> genreOptions = [
    {'label': '🔥 Urbano & Reggaeton', 'value': 'Urbano', 'color': Colors.orangeAccent},
    {'label': '🎸 Rock & Alternative', 'value': 'Rock', 'color': Colors.redAccent},
    {'label': '🎤 Pop & Hits', 'value': 'Pop', 'color': Colors.pinkAccent},
    {'label': '💃 Indie Español', 'value': 'Indie', 'color': Colors.tealAccent},
    {'label': '🎧 Electrónica & House', 'value': 'Electronic', 'color': Colors.blueAccent},
    {'label': '🎪 Festivales', 'value': 'Festival', 'color': Colors.amber},
    {'label': '🎤 Hip-Hop / Rap', 'value': 'Hip-Hop', 'color': Colors.purpleAccent},
    {'label': '🤘 Heavy Metal', 'value': 'Metal', 'color': Colors.grey},
    {'label': '💃 Flamenco', 'value': 'Flamenco', 'color': Colors.deepOrange},
    {'label': '🎹 Jazz & Blues', 'value': 'Jazz', 'color': Colors.indigoAccent},
    {'label': '🎻 Clásica', 'value': 'Classical', 'color': Colors.brown},
    {'label': '🌍 Latino', 'value': 'Latin', 'color': Colors.yellowAccent},
  ];

  Future<void> _searchArtists(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final results = await _spotifyService.searchArtists(query);
      setState(() => searchResults = results);
    } catch (e) {
      // Error capturado: Considerar usar un logger en producción
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isSaving = true);
    try {
      final List<String> artistNames = selectedArtists.map((a) => a['name']!).toList();
      final List<String> genreValues = selectedGenres.toList();

      await _userDataService.saveUserPreferences(
        widget.userProfile['uid'] ?? widget.userProfile['id'], 
        {
          'favoriteArtists': artistNames,
          'favoriteGenres': genreValues,
          'preferencesSet': true,
        }
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userProfile: widget.userProfile,
            authSource: widget.authSource,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error guardando: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String displayName = widget.userProfile['displayName'] ?? 'Usuario';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.prefsTitle(displayName),
                style: GoogleFonts.montserrat(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.prefsSubtitle,
                style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 25),

              TextField(
                controller: _searchController,
                onChanged: _searchArtists,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: l10n.prefsSearchHint,
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                ),
              ),
              
              // Nota: No uses llaves {} aquí dentro de la Column para evitar errores de Set/List
              if (_isSearching)
                 const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(color: Colors.greenAccent)))
              else if (searchResults.isNotEmpty)
                 Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A), 
                    borderRadius: BorderRadius.circular(20), 
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final artist = searchResults[index];
                      final isSelected = selectedArtists.any((a) => a['name'] == artist['name']);
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(artist['image']!)),
                        title: Text(artist['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        trailing: Icon(isSelected ? Icons.check_circle : Icons.add_circle_outline, color: isSelected ? Colors.greenAccent : Colors.white38),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            if (isSelected) {
                              selectedArtists.removeWhere((a) => a['name'] == artist['name']);
                            } else {
                              selectedArtists.add(artist);
                            }
                            _searchController.clear();
                            searchResults = [];
                          });
                        },
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedArtists.isNotEmpty) ...[
                        Text(l10n.prefsYourArtists, style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: selectedArtists.map((artist) {
                            return Chip(
                              label: Text(artist['name']!, style: const TextStyle(color: Colors.white)),
                              avatar: CircleAvatar(backgroundImage: NetworkImage(artist['image']!)),
                              backgroundColor: Colors.greenAccent.withValues(alpha: 0.15),
                              deleteIcon: const Icon(Icons.close, size: 16, color: Colors.greenAccent),
                              onDeleted: () => setState(() => selectedArtists.removeWhere((a) => a['name'] == artist['name'])),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), 
                                side: BorderSide(color: Colors.greenAccent.withValues(alpha: 0.3)),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 25),
                      ],

                      Text(l10n.prefsGenres, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      
                      Wrap(
                        spacing: 10, runSpacing: 10,
                        children: genreOptions.map((genre) {
                          final isSelected = selectedGenres.contains(genre['value']);
                          final color = genre['color'] as Color;
                          return FilterChip(
                            label: Text(genre['label']),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                            ),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                if (selected) {
                                  selectedGenres.add(genre['value']);
                                } else {
                                  selectedGenres.remove(genre['value']);
                                }
                              });
                            },
                            backgroundColor: const Color(0xFF1F1F1F),
                            selectedColor: color, 
                            checkmarkColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: isSelected ? BorderSide.none : BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 100), 
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.black,
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (selectedArtists.isNotEmpty || selectedGenres.isNotEmpty) 
                ? [Colors.greenAccent, Colors.lightGreenAccent] 
                : [Colors.grey.shade800, Colors.grey.shade700],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: (selectedArtists.isNotEmpty || selectedGenres.isNotEmpty) && !_isSaving
                ? _saveAndContinue
                : null,
            child: _isSaving 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
              : Text(
                  l10n.prefsBtnStart,
                  style: TextStyle(
                    color: (selectedArtists.isNotEmpty || selectedGenres.isNotEmpty) ? Colors.black : Colors.white38, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16
                  )
                ),
          ),
        ),
      ),
    );
  }
}