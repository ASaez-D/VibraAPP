import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/spotify_api_service.dart';
import '../screens/home_screen.dart';


class MusicPreferencesScreen extends StatefulWidget {
  final String displayName;

  const MusicPreferencesScreen({super.key, required this.displayName});

  @override
  State<MusicPreferencesScreen> createState() => _MusicPreferencesScreenState();
}

class _MusicPreferencesScreenState extends State<MusicPreferencesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SpotifyAPIService _spotifyService = SpotifyAPIService();

  List<Map<String, String>> searchResults = [];
  final Set<Map<String, String>> selectedArtists = {};
  final Set<String> selectedGenres = {};

  bool _isSearching = false;

  final List<String> genres = [
    'Pop',
    'Rock',
    'Hip-Hop',
    'Reggaeton',
    'Electrónica',
    'Indie',
    'Jazz',
    'R&B',
    'Clásica',
    'Trap',
    'Soul',
    'Country',
    'K-Pop',
    'Dancehall',
    'Metal',
    'Funk',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error buscando artistas: $e')),
      );
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedGenreList =
        genres.where((g) => selectedGenres.contains(g)).toList();
    final unselectedGenres =
        genres.where((g) => !selectedGenres.contains(g)).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Text(
                '¡Hola, ${widget.displayName}! 🎧',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Queremos saber más de ti. Cuéntanos qué música te gusta.',
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 25),

              // BUSCADOR
              TextField(
                controller: _searchController,
                onChanged: _searchArtists,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Busca tus artistas favoritos...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // RESULTADOS BÚSQUEDA
              if (_isSearching)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(color: Colors.greenAccent),
                  ),
                )
              else if (searchResults.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 220),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final artist = searchResults[index];
                      final isSelected = selectedArtists
                          .any((a) => a['name'] == artist['name']);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(artist['image']!),
                        ),
                        title: Text(
                          artist['name']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                          color: isSelected
                              ? Colors.greenAccent
                              : Colors.white38,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            if (isSelected) {
                              selectedArtists.removeWhere(
                                  (a) => a['name'] == artist['name']);
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

              // SCROLL
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ARTISTAS SELECCIONADOS
                      if (selectedArtists.isNotEmpty)
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: selectedArtists.map((artist) {
                            return Chip(
                              label: Text(
                                artist['name']!,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                ),
                              ),
                              avatar: CircleAvatar(
                                backgroundImage: NetworkImage(artist['image']!),
                              ),
                              backgroundColor:
                                  Colors.greenAccent.withOpacity(0.2),
                              deleteIcon: const Icon(Icons.close,
                                  color: Colors.white70),
                              onDeleted: () {
                                setState(() {
                                  selectedArtists.removeWhere(
                                      (a) => a['name'] == artist['name']);
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            );
                          }).toList(),
                        ),

                      if (selectedArtists.isNotEmpty)
                        const SizedBox(height: 20),

                      // TEXTO GÉNEROS
                      Text(
                        'Selecciona tus géneros favoritos:',
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 10),

                      // GÉNEROS SELECCIONADOS
                      if (selectedGenreList.isNotEmpty)
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: selectedGenreList.map((genre) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    genre,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedGenres.remove(genre);
                                      });
                                    },
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 18),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                      if (selectedGenreList.isNotEmpty)
                        const SizedBox(height: 15),

                      // GÉNEROS DISPONIBLES
                      Text(
                        'Géneros disponibles:',
                        style: GoogleFonts.montserrat(
                            color: Colors.white38, fontSize: 14),
                      ),
                      const SizedBox(height: 5),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: unselectedGenres.map((genre) {
                          return ChoiceChip(
                            label: Text(
                              genre,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white70),
                            ),
                            selected: false,
                            backgroundColor: const Color(0xFF1F1F1F),
                            selectedColor: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onSelected: (_) {
                              setState(() {
                                selectedGenres.add(genre);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÓN CONTINUAR
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.greenAccent, Colors.lightGreenAccent],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: selectedArtists.isNotEmpty ||
                            selectedGenres.isNotEmpty
                        ? () {
                           Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(displayName: widget.displayName),
                            ),
                          );
                          }
                        : null,
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
