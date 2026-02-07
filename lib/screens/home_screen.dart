import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

// LOCALIZACIÓN E IMPORTS INTERNOS
import '../l10n/app_localizations.dart';
import '../services/user_data_service.dart';
import '../providers/language_provider.dart';
import '../utils/app_logger.dart';
import '../utils/app_constants.dart';

// WIDGETS REFACTORIZADOS (IMPORTAR AQUÍ)
import '../widgets/home_drawer.dart';
import '../widgets/home_components.dart';

// IMPORTS PANTALLAS
import 'login_screen.dart';
import 'calendar_screen.dart';
import 'ticket_screen.dart';
import 'saved_events_screen.dart';

// SERVICIOS
import '../services/ticketmaster_service.dart';
import '../services/spotify_api_service.dart';
import '../models/concert_detail.dart';
import '../models/ticket.dart';

/// Main home screen showing personalized concert recommendations
///
/// Displays concerts based on user's Spotify taste or saved preferences,
/// with sections for recommendations, weekend events, and trending concerts.
///
/// Features:
/// - Personalized recommendations from Spotify or user preferences
/// - Weekend events section
/// - Search functionality
/// - Like/Save functionality
/// - Region filtering
/// - Pagination support
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final TicketmasterService _tmService = TicketmasterService();
  final SpotifyAPIService _spService = SpotifyAPIService();
  final UserDataService _dbService = UserDataService();
  final TextEditingController _searchCtrl = TextEditingController();

  // DATOS
  Future<List<ConcertDetail>>? _concertsFuture;
  List<ConcertDetail> _recommended = [];
  List<ConcertDetail> _weekend = [];
  List<ConcertDetail> _secondary = [];
  List<ConcertDetail> _cached = [];
  final Set<String> _likedIds = {};
  final Set<String> _savedIds = {};

  List<ConcertDetail> _searchResults = [];
  bool _isSearching = false;

  // ESTADO REGIÓN & FILTROS
  String _country = 'ES';
  String? _city;
  String _vibe = "lo mejor";
  String _secVibeTitle = "";
  String _topArtist = "";

  // PAGINACIÓN
  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;
  String? _keyword;

  final List<Ticket> myTickets = [
    Ticket(
      eventName: "Concierto de Kassandra",
      eventDate: DateTime(2025, 12, 20),
      location: "Auditorio Nacional",
      status: "Activa",
    ),
    Ticket(
      eventName: "Festival de Música",
      eventDate: DateTime(2026, 1, 15),
      location: "Estadio Central",
      status: "Usada",
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _dbService.saveUserProfile(FirebaseAuth.instance.currentUser!);
      _loadInteractions();
    }
    _detectCountry();
    _searchCtrl.addListener(_onSearch);
  }

  /// Loads user's liked and saved events from Firestore
  Future<void> _loadInteractions() async {
    try {
      final likes = await _dbService.getUserInteractions('favorites');
      final saves = await _dbService.getUserInteractions('saved_events');
      if (mounted) {
        setState(() {
          _likedIds.addAll(likes);
          _savedIds.addAll(saves);
        });
      }
      AppLogger.debug(
        'Interacciones cargadas: ${likes.length} likes, ${saves.length} guardados',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error cargando interacciones de usuario', e, stackTrace);
    }
  }

  void _detectCountry() {
    final locale = PlatformDispatcher.instance.locale;
    setState(
      () => _country = (locale.countryCode == 'US')
          ? 'ES'
          : (locale.countryCode ?? 'ES'),
    );
    _reloadAll();
  }

  void _reloadAll() {
    _loadWeekend();
    (widget.authSource == 'spotify' && widget.spotifyAccessToken != null)
        ? _analyzeTaste()
        : _loadPrefs();
  }

  /// Loads user preferences from Firestore (for Google auth users)
  ///
  /// Falls back to generic recommendations if no preferences found
  Future<void> _loadPrefs() async {
    bool hasPrefs = false;
    try {
      final prefs = await _dbService.getUserPreferences();
      if (prefs != null) {
        final genres = List<String>.from(prefs['favoriteGenres'] ?? []);
        final artists = List<String>.from(prefs['favoriteArtists'] ?? []);
        if (genres.isNotEmpty || artists.isNotEmpty) {
          hasPrefs = true;
          if (genres.isNotEmpty) {
            _vibe = genres[0];
            if (genres.length > 1) _loadSecVibe(genres[1]);
          }
          if (artists.isNotEmpty) _loadRecs(artists);
          _loadData(
            keyword: genres.isNotEmpty ? genres[0] : null,
            refresh: true,
          );
          AppLogger.info(
            'Preferencias cargadas: ${genres.length} géneros, ${artists.length} artistas',
          );
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error cargando preferencias de usuario', e, stackTrace);
    }
    if (!hasPrefs) {
      AppLogger.debug('Sin preferencias guardadas, cargando eventos generales');
      _loadData(keyword: null, refresh: true);
    }
  }

  /// Analyzes user's Spotify taste to personalize recommendations
  ///
  /// Fetches top artists and their genres from Spotify API,
  /// then determines dominant music taste (Urbano, Rock, Electronic, Pop)
  Future<void> _analyzeTaste() async {
    try {
      final top = await _spService.getUserTopArtistsWithGenres(
        widget.spotifyAccessToken!,
      );
      String? dom, sec;
      if (top.isNotEmpty) {
        final all = top
            .expand((e) => e['genres'] as List)
            .join(" ")
            .toLowerCase();
        if (all.contains("reggaeton") || all.contains("urbano")) {
          dom = "Urbano";
          sec = "Electronic";
        } else if (all.contains("rock")) {
          dom = "Rock";
          sec = "Pop";
        } else if (all.contains("electronic")) {
          dom = "Electronic";
          sec = "Pop";
        } else {
          dom = "Pop";
        }
        _vibe = dom ?? "lo mejor";
        _loadRecs(top.map((e) => e['name'] as String).toList());
        if (sec != null) _loadSecVibe(sec);
      }
      _loadData(keyword: dom, refresh: true);
    } catch (e) {
      _loadData(keyword: null, refresh: true);
    }
  }

  /// Loads weekend events (Friday-Sunday)
  void _loadWeekend() {
    DateTime now = DateTime.now();
    int days = (DateTime.friday - now.weekday + 7) % 7;
    _tmService
        .getConcerts(
          now.add(Duration(days: days)),
          now.add(Duration(days: days + 2)),
          countryCode: _country,
          city: _city,
          size: 10,
        )
        .then((e) {
          if (mounted) setState(() => _weekend = _dedupe(e));
        });
  }

  /// Loads secondary vibe section with keyword filter
  void _loadSecVibe(String k) {
    setState(() => _secVibeTitle = k);
    _tmService
        .getConcerts(
          DateTime.now(),
          DateTime.now().add(const Duration(days: 90)),
          countryCode: _country,
          city: _city,
          keyword: k,
          size: 10,
        )
        .then((e) {
          if (mounted) setState(() => _secondary = _dedupe(e));
        });
  }

  /// Loads main concert data with pagination support
  ///
  /// Parameters:
  /// - [keyword]: Optional filter keyword (genre)
  /// - [refresh]: If true, resets pagination and clears cache
  void _loadData({String? keyword, bool refresh = false}) {
    if (refresh) {
      _page = 0;
      _cached = [];
      _hasMore = true;
      _keyword = keyword;
    }
    if (!_hasMore && !refresh && keyword == _keyword) return;
    setState(() {
      if (!refresh) _loading = true;
      _concertsFuture = _tmService
          .getConcerts(
            DateTime.now(),
            DateTime.now().add(const Duration(days: 90)),
            countryCode: _country,
            city: _city,
            keyword: _keyword,
            page: _page,
            size: 20,
          )
          .then((events) {
            if (events.isEmpty) {
              if (_keyword != null && _page == 0) {
                Future.microtask(() {
                  if (mounted) {
                    setState(() {
                      _keyword = null;
                      _vibe = "lo mejor";
                    });
                    _loadData(refresh: true);
                  }
                });
                return [];
              }
              setState(() {
                _hasMore = false;
                _loading = false;
              });
              return _cached;
            }
            final seen = _cached.map((c) => c.name.toLowerCase()).toSet();
            setState(() {
              _cached.addAll(
                events.where((e) => seen.add(e.name.toLowerCase())),
              );
              _page++;
              _loading = false;
            });
            return _cached;
          });
    });
  }

  /// Loads recommended concerts based on user's favorite artists
  Future<void> _loadRecs(List<String> artists) async {
    if (artists.isEmpty) return;
    _topArtist = artists.first;
    List<ConcertDetail> found = [];
    final res = await Future.wait(
      artists.take(3).map((a) => _tmService.searchEventsByKeyword(a, _country)),
    );
    for (var list in res) found.addAll(list);
    if (mounted) setState(() => _recommended = _dedupe(found));
  }

  List<ConcertDetail> _dedupe(List<ConcertDetail> ev) {
    final seen = <String>{};
    return ev.where((e) => seen.add(e.name.toLowerCase())).toList();
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _isSearching = false;
        _searchResults = [];
      } else {
        _isSearching = true;
        _searchResults = _cached
            .where(
              (c) =>
                  c.name.toLowerCase().contains(q) ||
                  c.venue.toLowerCase().contains(q),
            )
            .toList();
      }
    });
  }

  /// Shares concert details via system share sheet
  void _share(ConcertDetail c) {
    Share.share(
      '¡Mira este planazo en Vibra! 🎸\n${c.name}\n📅 ${DateFormat('d MMM').format(c.date)}\n📍 ${c.venue}\n${c.ticketUrl}',
    );
  }

  /// Toggles like status for a concert
  void _like(ConcertDetail c) {
    HapticFeedback.lightImpact();
    setState(
      () => _likedIds.contains(c.name)
          ? _likedIds.remove(c.name)
          : _likedIds.add(c.name),
    );
    _dbService.toggleFavorite(c.name, {
      'name': c.name,
      'date': c.date.toIso8601String(),
      'imageUrl': c.imageUrl,
      'venue': c.venue,
    });
  }

  /// Toggles save status for a concert and shows confirmation
  void _save(ConcertDetail c) {
    HapticFeedback.mediumImpact();
    setState(
      () => _savedIds.contains(c.name)
          ? _savedIds.remove(c.name)
          : _savedIds.add(c.name),
    );
    _dbService.toggleSaved(c.name, {
      'name': c.name,
      'date': c.date.toIso8601String(),
      'imageUrl': c.imageUrl,
      'venue': c.venue,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_savedIds.contains(c.name) ? "Guardado" : "Eliminado"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onStateChange(ConcertDetail c, bool l, bool s) {
    setState(() {
      if (l)
        _likedIds.add(c.name);
      else
        _likedIds.remove(c.name);
      if (s)
        _savedIds.add(c.name);
      else
        _savedIds.remove(c.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.primaryAccent;
    final scaffoldBg = isDarkMode
        ? AppColors.darkScaffoldBackground
        : AppColors.lightScaffoldBackground;
    final primaryText = isDarkMode
        ? AppColors.darkPrimaryText
        : AppColors.lightPrimaryText;
    final secondaryText = isDarkMode
        ? AppColors.darkSecondaryText
        : Colors.grey.shade600;
    final hintText = isDarkMode
        ? Colors.white.withOpacity(0.4)
        : Colors.grey.shade400;
    final searchBarBg = isDarkMode
        ? AppColors.darkCardBackground
        : Colors.grey.shade200;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppSizes.appBarHeight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: AppSizes.searchBarHeight,
                    decoration: BoxDecoration(
                      color: searchBarBg,
                      borderRadius: BorderRadius.circular(
                        AppBorders.radiusCircular,
                      ),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.08)
                            : Colors.grey.shade300,
                        width: AppBorders.borderWidthThin,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(AppColors.opacityHigh)
                              : Colors.grey.withOpacity(
                                  AppColors.opacityMedium,
                                ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: AppTypography.fontSizeMedium + 1,
                      ),
                      cursorColor: accentColor,
                      decoration: InputDecoration(
                        hintText: l10n.homeSearchHint(_country),
                        hintStyle: TextStyle(
                          color: hintText,
                          fontSize: AppTypography.fontSizeMedium,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: hintText,
                          size: AppSizes.iconSizeMedium + 2,
                        ),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: secondaryText,
                                  size: AppSizes.iconSizeMedium,
                                ),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppTypography.fontSizeMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                GestureDetector(
                  onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                  child: CircleAvatar(
                    radius: AppSizes.avatarRadiusLarge,
                    backgroundColor: Theme.of(context).cardColor,
                    backgroundImage: widget.userProfile['photoURL'] != null
                        ? NetworkImage(widget.userProfile['photoURL'])
                        : null,
                    child: widget.userProfile['photoURL'] == null
                        ? Icon(
                            Icons.person,
                            color: primaryText,
                            size: AppSizes.iconSizeLarge,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isSearching
          ? ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _searchResults.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) =>
                  ConcertListCard(concert: _searchResults[index]),
            )
          : FutureBuilder<List<ConcertDetail>>(
              future: _concertsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _cached.isEmpty)
                  return Center(
                    child: CircularProgressIndicator(color: accentColor),
                  );
                if (snapshot.hasError ||
                    (_cached.isEmpty &&
                        (!snapshot.hasData || snapshot.data!.isEmpty))) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_rounded,
                          color: secondaryText.withOpacity(0.5),
                          size: 50,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.homeErrorNoEvents(_country),
                          style: TextStyle(
                            color: secondaryText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _country = 'ES';
                              _reloadAll();
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: accentColor.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            l10n.homeBtnRetryCountry,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.homeGreeting(
                                widget.userProfile['displayName'] ?? 'Usuario',
                              ),
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              l10n.homeVibeTitle(_vibe),
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        // SECCIÓN 1: RECOMENDACIONES / TENDENCIAS (Index 2)
                        if (index == 2) {
                          final list = _recommended.isNotEmpty
                              ? _recommended
                              : _cached.take(8).toList();
                          final title = _recommended.isNotEmpty
                              ? l10n.homeSectionForYou
                              : l10n.homeSectionTrends(_country);
                          return list.isNotEmpty
                              ? HorizontalConcertSection(
                                  title: title,
                                  subtitle: _recommended.isNotEmpty
                                      ? l10n.homeSectionForYouSub(_topArtist)
                                      : l10n.homeSectionTrendsSub,
                                  concerts: list,
                                  likedIds: _likedIds,
                                  savedIds: _savedIds,
                                  onLike: _like,
                                  onSave: _save,
                                  onShare: _share,
                                  onStateChange: _onStateChange,
                                )
                              : const SizedBox.shrink();
                        }
                        // SECCIÓN 2: FIN DE SEMANA (Index 5)
                        if (index == 5)
                          return _weekend.isNotEmpty
                              ? HorizontalConcertSection(
                                  title: l10n.homeSectionWeekend,
                                  subtitle: l10n.homeSectionWeekendSub,
                                  concerts: _weekend,
                                  likedIds: _likedIds,
                                  savedIds: _savedIds,
                                  onLike: _like,
                                  onSave: _save,
                                  onShare: _share,
                                  onStateChange: _onStateChange,
                                )
                              : const SizedBox.shrink();
                        // SECCIÓN 3: SEGUNDA VIBRA (Index 8)
                        if (index == 8)
                          return _secondary.isNotEmpty
                              ? HorizontalConcertSection(
                                  title: l10n.homeVibeTitle(_secVibeTitle),
                                  subtitle: l10n.homeSectionDiscoverSub,
                                  concerts: _secondary,
                                  likedIds: _likedIds,
                                  savedIds: _savedIds,
                                  onLike: _like,
                                  onSave: _save,
                                  onShare: _share,
                                  onStateChange: _onStateChange,
                                )
                              : const SizedBox.shrink();
                        // SECCIÓN 4: COLECCIONES (Index 11)
                        if (index == 11)
                          return CollectionsCarousel(
                            countryCode: _country,
                            city: _city,
                          );

                        int i = index;
                        if (index > 2) i--;
                        if (index > 5) i--;
                        if (index > 8) i--;
                        if (index > 11) i--;
                        if (i >= _cached.length) return null;

                        final c = _cached[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: ConcertCard(
                            concert: c,
                            isLiked: _likedIds.contains(c.name),
                            isSaved: _savedIds.contains(c.name),
                            onLikeToggle: () => _like(c),
                            onSaveToggle: () => _save(c),
                            onShare: () => _share(c),
                            onStateChangedFromDetail: (l, s) =>
                                _onStateChange(c, l, s),
                          ),
                        );
                      }, childCount: _cached.length + 4),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: _hasMore
                              ? (_loading
                                    ? CircularProgressIndicator(
                                        color: accentColor,
                                      )
                                    : TextButton(
                                        onPressed: () =>
                                            _loadData(keyword: _keyword),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          backgroundColor: Theme.of(
                                            context,
                                          ).cardColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            side: BorderSide(
                                              color: secondaryText.withOpacity(
                                                0.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          l10n.homeBtnShowMore,
                                          style: TextStyle(
                                            color: primaryText,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ))
                              : Text(
                                  l10n.homeTextEnd,
                                  style: TextStyle(
                                    color: secondaryText.withOpacity(0.5),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: scaffoldBg,
        selectedItemColor: accentColor,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (i) {
          if (i == 1)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CalendarScreen(countryCode: _country, city: _city),
              ),
            );
          if (i == 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedEventsScreen()),
            );
          if (i == 3)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TicketScreen(tickets: myTickets),
              ),
            );
          setState(() => _currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: '',
          ),
        ],
      ),
      endDrawer: HomeDrawer(
        userProfile: widget.userProfile,
        authSource: widget.authSource,
        currentCountryCode: _country,
        currentCity: _city,
        onRegionChanged: (code, city) {
          if (code != _country || city != _city) {
            setState(() {
              _country = code;
              _city = city;
              _cached.clear();
              _recommended.clear();
              _weekend.clear();
              _secondary.clear();
              _page = 0;
            });
            _reloadAll();
          }
        },
      ),
    );
  }
}
