import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// LOCALIZACIÓN E IMPORTS INTERNOS
import '../l10n/app_localizations.dart';
import '../services/user_data_service.dart';
import '../providers/language_provider.dart';

// IMPORTS PANTALLAS
import 'login_screen.dart';
import 'settings_screen.dart';
import 'customizeProfile_screen.dart';
import 'calendar_screen.dart';
import 'ticket_screen.dart';
import 'social_screen.dart';
import 'concert_detail_screen.dart';
import 'filtered_events_screen.dart';
import 'saved_events_screen.dart';
import 'account_screen.dart';
import 'help_screen.dart';

// SERVICIOS
import '../services/ticketmaster_service.dart';
import '../services/spotify_api_service.dart';
import '../models/concert_detail.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final String authSource;
  final String? spotifyAccessToken;

  const HomeScreen({
    super.key,
    required this.userProfile,
    required this.authSource,
    this.spotifyAccessToken,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final TicketmasterService _ticketmasterService = TicketmasterService();
  final SpotifyAPIService _spotifyService = SpotifyAPIService();
  final UserDataService _userDataService = UserDataService();

  Future<List<ConcertDetail>>? _concertsFuture;
  late Future<List<Map<String, String>>> _artistsFuture;

  List<ConcertDetail> _recommendedConcerts = [];
  List<ConcertDetail> _weekendConcerts = [];
  List<ConcertDetail> _secondaryVibeConcerts = [];
  List<ConcertDetail> _cachedConcerts = [];

  final Set<String> _likedIds = {};
  final Set<String> _savedIds = {};

  List<ConcertDetail> _searchResults = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  String _userCountryCode = 'ES';
  String _currentVibe = "lo mejor";
  String _secondaryVibeTitle = "";
  String _topArtistName = "";

  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _currentKeyword;

  final List<String> _targetArtists = ["Bad Bunny", "Rosalía", "Quevedo", "Aitana", "Feid", "C. Tangana"];

  final List<Ticket> myTickets = [
    Ticket(eventName: "Concierto de Kassandra", eventDate: DateTime(2025, 12, 20), location: "Auditorio Nacional", status: "Activa"),
    Ticket(eventName: "Festival de Música", eventDate: DateTime(2026, 1, 15), location: "Estadio Central", status: "Usada"),
  ];

  @override
  void initState() {
    super.initState();
    _artistsFuture = Future.value([]);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userDataService.saveUserProfile(user);
      _loadUserInteractions();
    }

    _detectUserCountryAndInit();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadUserInteractions() async {
    try {
      final likes = await _userDataService.getUserInteractions('favorites');
      final saves = await _userDataService.getUserInteractions('saved_events');
      if (mounted) {
        setState(() {
          _likedIds.addAll(likes);
          _savedIds.addAll(saves);
        });
      }
    } catch (e) {
      debugPrint("Error cargando interacciones: $e");
    }
  }

  void _detectUserCountryAndInit() {
    final locale = PlatformDispatcher.instance.locale;
    setState(() {
      String detected = locale.countryCode ?? 'ES';
      if (detected == 'US') detected = 'ES';
      _userCountryCode = detected;
    });
    _reloadAllData();
  }

  void _reloadAllData() {
    _loadWeekendPlans();
    if (widget.authSource == 'spotify' && widget.spotifyAccessToken != null) {
      _analyzeUserTasteAndLoad();
    } else {
      _loadPreferencesFromDB();
    }
  }

  Future<void> _loadPreferencesFromDB() async {
    bool hasPreferences = false;
    try {
      final prefs = await _userDataService.getUserPreferences();
      if (prefs != null) {
        final genres = List<String>.from(prefs['favoriteGenres'] ?? []);
        final artists = List<String>.from(prefs['favoriteArtists'] ?? []);

        if (genres.isNotEmpty || artists.isNotEmpty) {
          hasPreferences = true;
          String? primaryGenre;
          String? secondaryGenre;

          if (genres.isNotEmpty) {
            primaryGenre = genres[0];
            _currentVibe = primaryGenre;
            if (genres.length > 1) secondaryGenre = genres[1];
          }

          if (artists.isNotEmpty) {
            _loadSpecificRecommendations(artists);
          } else {
            _loadGenericArtistsImages();
          }
          _loadData(keyword: primaryGenre, refresh: true);
          if (secondaryGenre != null) _loadSecondaryVibe(secondaryGenre);
        }
      }
    } catch (e) { debugPrint("Error DB: $e"); }

    if (!hasPreferences) {
      _loadGenericArtistsImages();
      _loadData(keyword: null, refresh: true);
    }
  }

  Future<void> _analyzeUserTasteAndLoad() async {
    try {
      final topArtistsData = await _spotifyService.getUserTopArtistsWithGenres(widget.spotifyAccessToken!);
      String? dominantKeyword;
      String? secondaryKeyword;

      if (topArtistsData.isNotEmpty) {
        final allGenres = topArtistsData.expand((e) => e['genres'] as List).join(" ").toLowerCase();
        if (allGenres.contains("reggaeton") || allGenres.contains("urbano") || allGenres.contains("latino")) {
          dominantKeyword = "Urbano"; secondaryKeyword = "Electronic";
        } else if (allGenres.contains("rock") || allGenres.contains("metal") || allGenres.contains("punk")) {
          dominantKeyword = "Rock"; secondaryKeyword = "Pop";
        } else if (allGenres.contains("indie") || allGenres.contains("alternative")) {
          dominantKeyword = "Indie"; secondaryKeyword = "Rock";
        } else if (allGenres.contains("electronic") || allGenres.contains("house") || allGenres.contains("techno")) {
          dominantKeyword = "Electronic"; secondaryKeyword = "Pop";
        } else {
          dominantKeyword = "Pop";
        }
        _currentVibe = dominantKeyword ?? "lo mejor";
        _loadSpecificRecommendations(topArtistsData.map((e) => e['name'] as String).toList());
        if (secondaryKeyword != null) _loadSecondaryVibe(secondaryKeyword);
      } else { _loadGenericArtistsImages(); }
      _loadData(keyword: dominantKeyword, refresh: true);
    } catch (e) {
      _loadGenericArtistsImages();
      _loadData(keyword: null, refresh: true);
    }
  }

  void _loadWeekendPlans() {
    DateTime now = DateTime.now();
    int daysUntilFriday = (DateTime.friday - now.weekday + 7) % 7;
    DateTime nextFriday = now.add(Duration(days: daysUntilFriday));
    DateTime nextSunday = nextFriday.add(const Duration(days: 2));

    _ticketmasterService.getConcerts(nextFriday, nextSunday, countryCode: _userCountryCode, size: 10).then((events) {
      if (mounted) setState(() => _weekendConcerts = _filterDuplicates(events));
    });
  }

  void _loadSecondaryVibe(String keyword) {
    setState(() { _secondaryVibeTitle = keyword; });
    _ticketmasterService.getConcerts(DateTime.now(), DateTime.now().add(const Duration(days: 90)), countryCode: _userCountryCode, keyword: keyword, size: 10).then((events) {
      if (mounted) setState(() => _secondaryVibeConcerts = _filterDuplicates(events));
    });
  }

  void _loadData({String? keyword, bool refresh = false}) {
    if (refresh) {
      _currentPage = 0;
      _cachedConcerts = [];
      _hasMore = true;
      _currentKeyword = keyword;
    }
    if (!_hasMore && !refresh && keyword == _currentKeyword) return;

    setState(() {
      if (!refresh) _isLoadingMore = true;
      _concertsFuture = _ticketmasterService.getConcerts(DateTime.now(), DateTime.now().add(const Duration(days: 90)), countryCode: _userCountryCode, keyword: _currentKeyword, page: _currentPage, size: 20).then((events) {
        if (events.isEmpty) {
          if (_currentKeyword != null && _currentPage == 0) {
            Future.microtask(() {
              if (mounted) {
                setState(() { _currentKeyword = null; _currentVibe = "lo mejor"; });
                _loadData(refresh: true);
              }
            });
            return [];
          }
          setState(() { _hasMore = false; _isLoadingMore = false; });
          return _cachedConcerts;
        }
        final seenNames = _cachedConcerts.map((c) => c.name.trim().toLowerCase()).toSet();
        final newUnique = events.where((e) {
          final clean = e.name.trim().toLowerCase();
          if (seenNames.contains(clean)) return false;
          seenNames.add(clean);
          return true;
        }).toList();

        setState(() {
          _cachedConcerts.addAll(newUnique);
          _currentPage++;
          _isLoadingMore = false;
        });
        return _cachedConcerts;
      });
    });
  }

  Future<void> _loadSpecificRecommendations(List<String> artistNames) async {
    if (artistNames.isEmpty) return;
    _topArtistName = artistNames.first;
    List<ConcertDetail> foundEvents = [];
    final results = await Future.wait(artistNames.take(3).map((artist) => _ticketmasterService.searchEventsByKeyword(artist, _userCountryCode)));
    for (var list in results) foundEvents.addAll(list);
    if (mounted) {
      setState(() {
        _recommendedConcerts = _filterDuplicates(foundEvents);
        _artistsFuture = Future.value(artistNames.map((name) => {"name": name, "image": ""}).toList());
        _loadArtistsImages(artistNames);
      });
    }
  }

  List<ConcertDetail> _filterDuplicates(List<ConcertDetail> events) {
    final seen = <String>{};
    return events.where((e) {
      final clean = e.name.trim().toLowerCase();
      if (seen.contains(clean)) return false;
      seen.add(clean);
      return true;
    }).toList();
  }

  void _loadArtistsImages(List<String> names) {
    _artistsFuture = Future.wait(names.map((name) async {
      try {
        final results = await _spotifyService.searchArtists(name);
        if (results.isNotEmpty) return results.first;
      } catch (e) {}
      return {"name": name, "image": ""};
    }));
  }

  void _loadGenericArtistsImages() {
    _artistsFuture = Future.wait(_targetArtists.map((name) async {
      try {
        final results = await _spotifyService.searchArtists(name);
        if (results.isNotEmpty) return results.first;
      } catch (e) {}
      return {"name": name, "image": ""};
    })).then((list) => list.where((item) => item["image"] != "").toList());
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) { _isSearching = false; _searchResults = []; } else {
        _isSearching = true;
        _searchResults = _cachedConcerts.where((concert) => concert.name.toLowerCase().contains(query) || concert.venue.toLowerCase().contains(query)).toList();
      }
    });
  }

  void _clearSearch() { _searchController.clear(); FocusScope.of(context).unfocus(); }

  void _onTabTapped(int index) {
    if (index != 0) {
      switch (index) {
        case 1: Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen())); break;
        case 2: Navigator.push(context, MaterialPageRoute(builder: (_) => TickerScreen(tickets: myTickets))); break;
        case 3: Navigator.push(context, MaterialPageRoute(builder: (_) => const SocialScreen())); break;
      }
    }
    setState(() => _currentIndex = index);
  }

  void _shareConcert(ConcertDetail concert) {
    final dateStr = DateFormat('d MMM yyyy').format(concert.date);
    Share.share('¡Mira este planazo en Vibra! 🎸\n${concert.name}\n📅 $dateStr\n📍 ${concert.venue}\n${concert.ticketUrl}');
  }

  void _toggleLike(ConcertDetail concert) {
    HapticFeedback.lightImpact();
    final id = concert.name;
    setState(() {
      if (_likedIds.contains(id)) _likedIds.remove(id);
      else _likedIds.add(id);
    });
    _userDataService.toggleFavorite(id, {
      'name': concert.name, 'date': concert.date.toIso8601String(), 'imageUrl': concert.imageUrl, 'venue': concert.venue,
    });
  }

  void _toggleSave(ConcertDetail concert) {
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();
    final id = concert.name;
    setState(() {
      if (_savedIds.contains(id)) {
        _savedIds.remove(id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eliminado"), duration: Duration(seconds: 1)));
      } else {
        _savedIds.add(id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonSuccess), backgroundColor: Colors.greenAccent, duration: const Duration(seconds: 1)));
      }
    });
    _userDataService.toggleSaved(id, {
      'name': concert.name, 'date': concert.date.toIso8601String(), 'imageUrl': concert.imageUrl, 'venue': concert.venue,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color accentColor = Colors.greenAccent;
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7);
    final Color cardBg = isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
    final Color primaryText = isDarkMode ? Colors.white : const Color(0xFF222222);
    final Color secondaryText = isDarkMode ? Colors.white54 : Colors.grey.shade600;
    final Color hintText = isDarkMode ? Colors.white.withOpacity(0.4) : Colors.grey.shade400;
    final Color searchBarBg = isDarkMode ? const Color(0xFF1C1C1E) : Colors.grey.shade200;
    final Color dividerColor = isDarkMode ? Colors.white12 : Colors.grey.shade300;
    final String displayName = widget.userProfile['displayName'] ?? 'Usuario';
    final String photoUrl = widget.userProfile['photoURL'] ?? '';
    final bool isLinked = photoUrl.isNotEmpty;
    final bool isSpotify = widget.authSource == 'spotify';
    final Color serviceColor = isSpotify ? const Color(0xFF1DB954) : const Color(0xFF4285F4);
    final IconData fallbackIcon = isSpotify ? Icons.music_note : Icons.account_circle;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: searchBarBg, borderRadius: BorderRadius.circular(30), border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.grey.shade300, width: 1), boxShadow: [BoxShadow(color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: primaryText, fontSize: 15),
                      cursorColor: accentColor,
                      decoration: InputDecoration(
                          hintText: l10n.homeSearchHint(_userCountryCode),
                          hintStyle: TextStyle(color: hintText, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: hintText, size: 22),
                          suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: Icon(Icons.close, color: secondaryText, size: 20), onPressed: _clearSearch) : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Builder(builder: (context) {
                  return GestureDetector(onTap: () => Scaffold.of(context).openEndDrawer(), child: Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: accentColor, width: 1.5)), child: CircleAvatar(radius: 22, backgroundColor: cardBg, backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null, child: photoUrl.isEmpty ? Icon(Icons.person, color: primaryText, size: 24) : null)));
                }),
              ],
            ),
          ),
        ),
      ),
      body: _isSearching ? _buildSearchResults(l10n, primaryText, secondaryText, cardBg) : _buildHomeContent(l10n, primaryText, secondaryText, accentColor, cardBg, displayName),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: scaffoldBg,
        selectedItemColor: accentColor,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''), BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: ''), BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: ''), BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: '')],
      ),
      endDrawer: _buildDrawer(context, l10n, primaryText, accentColor, scaffoldBg, dividerColor, displayName, photoUrl, isLinked, serviceColor, fallbackIcon),
    );
  }

  Widget _buildSearchResults(AppLocalizations l10n, Color primaryText, Color secondaryText, Color cardBg) {
    if (_searchResults.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search_off, size: 60, color: secondaryText.withOpacity(0.5)), const SizedBox(height: 16), Text(l10n.homeSearchNoResults, style: TextStyle(color: secondaryText, fontSize: 16)), TextButton(onPressed: _clearSearch, child: Text(l10n.homeSearchClear, style: const TextStyle(color: Colors.blueAccent)))]));
    }
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: _searchResults.length, separatorBuilder: (_, __) => const SizedBox(height: 20), itemBuilder: (context, index) => _buildListCard(_searchResults[index], primaryText, secondaryText, cardBg));
  }

  Widget _buildHomeContent(AppLocalizations l10n, Color primaryText, Color secondaryText, Color accentColor, Color cardBg, String displayName) {
    return FutureBuilder<List<ConcertDetail>>(
      future: _concertsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _cachedConcerts.isEmpty) {
          return Center(child: CircularProgressIndicator(color: accentColor));
        } else if (snapshot.hasError || (_cachedConcerts.isEmpty && (!snapshot.hasData || snapshot.data!.isEmpty))) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.location_off_rounded, color: secondaryText.withOpacity(0.5), size: 50), const SizedBox(height: 10), Text(l10n.homeErrorNoEvents(_userCountryCode), style: TextStyle(color: secondaryText, fontWeight: FontWeight.bold)), const SizedBox(height: 15), TextButton(onPressed: () { setState(() { _userCountryCode = 'ES'; _reloadAllData(); }); }, style: TextButton.styleFrom(backgroundColor: accentColor.withOpacity(0.1), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Text(l10n.homeBtnRetryCountry, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)))]));
        }

        final concerts = _cachedConcerts;
        String displayVibe = _currentVibe == "lo mejor" ? l10n.vibeBest : _currentVibe;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.homeGreeting(displayName), style: TextStyle(color: secondaryText, fontSize: 16, fontWeight: FontWeight.w500)),
                    Text(l10n.homeVibeTitle(displayVibe), style: TextStyle(color: primaryText, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 2) return _buildArtistsCarousel(l10n, primaryText, secondaryText, accentColor, cardBg);

                  if (index == 3) {
                    final displayList = _recommendedConcerts.isNotEmpty ? _recommendedConcerts : concerts.take(8).toList();
                    final title = _recommendedConcerts.isNotEmpty ? l10n.homeSectionForYou : l10n.homeSectionTrends(_userCountryCode);
                    final sub = _recommendedConcerts.isNotEmpty ? l10n.homeSectionForYouSub(_topArtistName) : l10n.homeSectionTrendsSub;
                    return displayList.isNotEmpty ? _buildHorizontalSection(title, sub, displayList, primaryText, secondaryText, accentColor, cardBg) : const SizedBox.shrink();
                  }

                  if (index == 6) {
                    final displayList = _weekendConcerts.isNotEmpty ? _weekendConcerts : concerts.skip(5).take(8).toList();
                    final title = l10n.homeSectionWeekend;
                    final sub = l10n.homeSectionWeekendSub;
                    return displayList.isNotEmpty ? _buildHorizontalSection(title, sub, displayList, primaryText, secondaryText, Colors.orangeAccent, cardBg) : const SizedBox.shrink();
                  }

                  if (index == 9) {
                    final displayList = _secondaryVibeConcerts.isNotEmpty ? _secondaryVibeConcerts : concerts.reversed.take(8).toList();
                    final title = _secondaryVibeConcerts.isNotEmpty ? l10n.homeVibeTitle(_secondaryVibeTitle) : l10n.homeSectionDiscover;
                    final sub = l10n.homeSectionDiscoverSub;
                    return displayList.isNotEmpty ? _buildHorizontalSection(title, sub, displayList, primaryText, secondaryText, Colors.purpleAccent, cardBg) : const SizedBox.shrink();
                  }

                  if (index == 12) return _buildCollectionsCarousel(l10n, primaryText, secondaryText, accentColor);

                  int concertIndex = index;
                  if (index > 2) concertIndex--;
                  if (index > 3) concertIndex--;
                  if (index > 6) concertIndex--;
                  if (index > 9) concertIndex--;
                  if (index > 12) concertIndex--;
                  if (concertIndex >= concerts.length) return null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: _buildDiceCard(context, concerts[concertIndex], primaryText, secondaryText, accentColor, cardBg),
                  );
                },
                childCount: concerts.length + 5,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: _hasMore
                      ? _isLoadingMore
                          ? CircularProgressIndicator(color: accentColor)
                          : TextButton(
                              onPressed: () => _loadData(keyword: _currentKeyword, refresh: false),
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  backgroundColor: cardBg,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(color: secondaryText.withOpacity(0.2)))), // FIX: 'border' cambiado por 'side'
                              child: Text(l10n.homeBtnShowMore, style: TextStyle(color: primaryText, fontWeight: FontWeight.bold)),
                            )
                      : _currentKeyword != null
                          ? Column(
                              children: [
                                Text(l10n.homeTextNoMore(_currentKeyword!), style: TextStyle(color: secondaryText)),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _currentKeyword = null;
                                      _currentVibe = "lo mejor";
                                    });
                                    _loadData(keyword: null, refresh: true);
                                  },
                                  style: TextButton.styleFrom(backgroundColor: accentColor.withOpacity(0.1), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                  child: Text(l10n.homeBtnViewAll, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )
                          : Text(l10n.homeTextEnd, style: TextStyle(color: secondaryText.withOpacity(0.5))),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        );
      },
    );
  }

  Widget _buildHorizontalSection(String title, String subtitle, List<ConcertDetail> items, Color primaryText, Color secondaryText, Color accent, Color cardBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: title, subtitle: subtitle, primaryText: primaryText, secondaryText: secondaryText, accentColor: accent, cardBg: cardBg),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(width: 220, child: _buildDiceCard(context, items[i], primaryText, secondaryText, accent, cardBg)),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle, required Color primaryText, required Color secondaryText, required Color accentColor, required Color cardBg, VoidCallback? onMoreTap}) {
    return Padding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: primaryText, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1.1)), const SizedBox(height: 4), Container(height: 3, width: 40, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))), const SizedBox(height: 6), Text(subtitle, style: TextStyle(color: secondaryText, fontSize: 13, fontWeight: FontWeight.w500))]), if (onMoreTap != null) GestureDetector(onTap: onMoreTap, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.arrow_forward, color: primaryText, size: 18)))]));
  }

  Widget _buildArtistsCarousel(AppLocalizations l10n, Color primaryText, Color secondaryText, Color accentColor, Color cardBg) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildSectionHeader(title: l10n.homeSectionArtists, subtitle: l10n.homeSectionArtistsSub, primaryText: primaryText, secondaryText: secondaryText, accentColor: accentColor, cardBg: cardBg), SizedBox(height: 110, child: FutureBuilder<List<Map<String, String>>>(future: _artistsFuture, builder: (context, snapshot) { if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(color: accentColor)); if (!snapshot.hasData) return const SizedBox.shrink(); final artists = snapshot.data!; return ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 16), itemCount: artists.length, itemBuilder: (context, index) { return Container(margin: const EdgeInsets.only(right: 20), child: Column(children: [Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.blueAccent])), child: CircleAvatar(radius: 32, backgroundColor: cardBg, backgroundImage: (artists[index]['image'] != null && artists[index]['image']!.isNotEmpty) ? NetworkImage(artists[index]['image']!) : null, child: (artists[index]['image'] == null || artists[index]['image']!.isEmpty) ? Icon(Icons.music_note, color: secondaryText) : null)), const SizedBox(height: 8), SizedBox(width: 80, child: Text(artists[index]['name']!, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: secondaryText, fontSize: 12))) ])); }); })), const SizedBox(height: 20)]);
  }

  Widget _buildCollectionsCarousel(AppLocalizations l10n, Color primaryText, Color secondaryText, Color accentColor) {
    final collections = [{"name": "Esta noche", "id": "tonight", "color": Colors.purpleAccent, "img": "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=400&auto=format&fit=crop"}, {"name": "Urbano & Latino", "id": "KnvZfZ7vAj6", "color": const Color(0xFFFF4500), "img": "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=400&auto=format&fit=crop"}, {"name": "Electrónica", "id": "KnvZfZ7vAvF", "color": Colors.blueAccent, "img": "https://images.unsplash.com/photo-1571266028243-3716f02d2d2e?q=80&w=400&auto=format&fit=crop"}, {"name": "Rock & Indie", "id": "KnvZfZ7vAeA", "color": const Color(0xFF8B0000), "img": "https://images.unsplash.com/photo-1498038432885-c6f3f1b912ee?q=80&w=400&auto=format&fit=crop"}, {"name": "Pop & Hits", "id": "KnvZfZ7vAev", "color": Colors.pinkAccent, "img": "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?q=80&w=400&auto=format&fit=crop"}, {"name": "Jazz & Blues", "id": "KnvZfZ7vAvE", "color": Colors.amber, "img": "https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?q=80&w=400&auto=format&fit=crop"}];
    final Color cardBg = Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildSectionHeader(title: l10n.homeSectionCollections, subtitle: l10n.homeSectionCollectionsSub, primaryText: primaryText, secondaryText: secondaryText, accentColor: accentColor, cardBg: cardBg), SizedBox(height: 110, child: ListView.builder(scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), padding: const EdgeInsets.only(left: 16, right: 16), itemCount: collections.length, itemBuilder: (context, index) { final col = collections[index]; final color = col["color"] as Color; return GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FilteredEventsScreen(categoryName: col["name"] as String, categoryId: col["id"] as String, accentColor: color))), child: Container(width: 180, margin: const EdgeInsets.only(right: 12), child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Stack(fit: StackFit.expand, children: [Image.network(col["img"] as String, fit: BoxFit.cover, cacheWidth: 400, color: Colors.black.withOpacity(0.3), colorBlendMode: BlendMode.darken), Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(0.9), color.withOpacity(0.2), Colors.black.withOpacity(0.8)], stops: const [0.0, 0.5, 1.0]))), Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.6), width: 1.5))), Positioned(bottom: 12, left: 14, child: Row(children: [Container(height: 20, width: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(col["name"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5))]))])))); })), const SizedBox(height: 30)]);
  }

  Widget _buildDiceCard(BuildContext context, ConcertDetail concert, Color primaryText, Color secondaryText, Color accentColor, Color cardBg) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String dayNum = DateFormat('d').format(concert.date);
    final String monthName = DateFormat('MMM', Localizations.localeOf(context).languageCode).format(concert.date).toUpperCase().replaceAll('.', '');
    String priceLabel = concert.priceRange.isNotEmpty ? concert.priceRange : l10n.detailCheckPrices;
    String uniqueHeroTag = "${concert.name}_${concert.date}_home_${DateTime.now().millisecondsSinceEpoch}_${concert.hashCode}";
    String concertId = concert.name;
    bool isLiked = _likedIds.contains(concertId);
    bool isSaved = _savedIds.contains(concertId);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ConcertDetailScreen(concert: concert, initialIsLiked: isLiked, initialIsSaved: isSaved, heroTag: uniqueHeroTag, onStateChanged: (liked, saved) { setState(() { if (liked) _likedIds.add(concertId); else _likedIds.remove(concertId); if (saved) _savedIds.add(concertId); else _savedIds.remove(concertId); }); })));
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
                _AnimatedIconButton(isSelected: false, iconSelected: Icons.ios_share_rounded, iconUnselected: Icons.ios_share_rounded, colorSelected: Colors.white, onTap: () => _shareConcert(concert), fillColor: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.5)),
                const SizedBox(width: 8),
                _AnimatedIconButton(isSelected: isLiked, iconSelected: Icons.favorite, iconUnselected: Icons.favorite_border_rounded, colorSelected: Colors.redAccent, fillColorSelected: Colors.redAccent.withOpacity(0.2), onTap: () => _toggleLike(concert), fillColor: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.5)),
                const SizedBox(width: 8),
                _AnimatedIconButton(isSelected: isSaved, iconSelected: Icons.bookmark, iconUnselected: Icons.bookmark_border_rounded, colorSelected: accentColor, fillColorSelected: accentColor.withOpacity(0.2), onTap: () => _toggleSave(concert), fillColor: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.5))
              ])),
              Positioned(bottom: 20, left: 20, right: 150, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(concert.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.1, shadows: [Shadow(color: Colors.black, blurRadius: 10)])), const SizedBox(height: 6), Row(children: [Icon(Icons.location_on, color: accentColor, size: 14), const SizedBox(width: 4), Expanded(child: Text(concert.venue, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis))])]))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(ConcertDetail concert, Color primaryText, Color secondaryText, Color cardBg) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String day = DateFormat('d MMM', Localizations.localeOf(context).languageCode).format(concert.date).toUpperCase();
    final Color accentColor = Colors.greenAccent;
    return GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConcertDetailScreen(concert: concert))), child: Container(height: 100, decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade300)), child: Row(children: [ClipRRect(borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)), child: Image.network(concert.imageUrl, width: 100, height: 100, fit: BoxFit.cover, cacheWidth: 200)), Expanded(child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(concert.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: primaryText, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text(concert.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: secondaryText, fontSize: 13)), const SizedBox(height: 6), Text(day, style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold))]))), Padding(padding: const EdgeInsets.only(right: 16), child: Icon(Icons.arrow_forward_ios, color: secondaryText.withOpacity(0.5), size: 16))])));
  }

  Widget _buildDrawer(BuildContext context, AppLocalizations l10n, Color primaryText, Color accentColor, Color scaffoldBg, Color dividerColor, String displayName, String photoUrl, bool isLinked, Color serviceColor, IconData fallbackIcon) {
    return Drawer(backgroundColor: scaffoldBg, child: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Padding(padding: const EdgeInsets.only(right: 10), child: CircleAvatar(radius: 18, backgroundColor: serviceColor, backgroundImage: isLinked ? NetworkImage(photoUrl) : null, child: !isLinked ? Icon(fallbackIcon, color: primaryText, size: 20) : null)), Text(displayName, style: TextStyle(color: primaryText, fontSize: 20, fontWeight: FontWeight.bold))]), const SizedBox(height: 4), GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomizeProfileScreen())), child: Text(l10n.menuEditProfile, style: TextStyle(color: primaryText.withOpacity(0.7), fontWeight: FontWeight.w500)))]),), const Divider(color: Colors.white24), _menuItem(context, l10n.menuAccount, Icons.account_circle, AccountScreen(userProfile: widget.userProfile, authSource: widget.authSource)), _menuItem(context, l10n.menuSaved, Icons.bookmark_outline, SavedEventsScreen(savedConcerts: _cachedConcerts.where((c) => _savedIds.contains(c.name)).toList())), _menuItem(context, l10n.menuSettings, Icons.settings, const SettingsScreen()), _menuItem(context, l10n.menuHelp, Icons.help_outline, const HelpScreen()), const Spacer(), Divider(color: dividerColor), ListTile(leading: const Icon(Icons.logout, color: Colors.redAccent), title: Text(l10n.menuLogout, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)), onTap: () { Navigator.of(context).pop(); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); }),])));
  }

  Widget _menuItem(BuildContext context, String title, IconData icon, Widget screen) {
    final primaryText = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return ListTile(leading: Icon(icon, color: primaryText.withOpacity(0.8)), title: Text(title, style: TextStyle(color: primaryText)), onTap: () { Navigator.of(context).pop(); Navigator.push(context, MaterialPageRoute(builder: (_) => screen)); });
  }
}

class _AnimatedIconButton extends StatelessWidget {
  final bool isSelected;
  final IconData iconSelected;
  final IconData iconUnselected;
  final Color colorSelected;
  final Color? fillColorSelected;
  final VoidCallback onTap;
  final Color? fillColor;

  const _AnimatedIconButton({required this.isSelected, required this.iconSelected, required this.iconUnselected, required this.colorSelected, required this.onTap, this.fillColorSelected, this.fillColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: isSelected ? (fillColorSelected ?? colorSelected.withOpacity(0.2)) : (fillColor ?? Colors.black.withOpacity(0.4)), shape: BoxShape.circle, border: Border.all(color: isSelected ? colorSelected : Colors.white.withOpacity(0.1), width: 1.5)), child: Icon(isSelected ? iconSelected : iconUnselected, color: isSelected ? colorSelected : Colors.white, size: 20)));
  }
}