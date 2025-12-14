import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

// IMPORTS DE PANTALLAS
import 'login_screen.dart';
import 'settings_screen.dart';
import 'payments_screen.dart';
import 'customizeProfile_screen.dart';
import 'calendar_screen.dart';
import 'ticket_screen.dart';
import 'social_screen.dart';
import 'concert_detail_screen.dart';
import 'filtered_events_screen.dart';
import 'saved_events_screen.dart';

// --- NUEVOS IMPORTS ---
import 'account_screen.dart';
import 'ayuda_screen.dart';

// SERVICIOS Y MODELOS
import '../services/ticketmaster_service.dart';
import '../services/spotify_api_service.dart';
import '../models/concert_detail.dart';

class HomeScreen extends StatefulWidget {
  final String displayName;

  const HomeScreen({super.key, required this.displayName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // SERVICIOS
  final TicketmasterService _ticketmasterService = TicketmasterService();
  final SpotifyAPIService _spotifyService = SpotifyAPIService();

  // FUTURES Y ESTADO
  Future<List<ConcertDetail>>? _concertsFuture;
  late Future<List<Map<String, String>>> _artistsFuture;
  
  // ESTADO LOCAL
  final Set<String> _likedIds = {};
  final Set<String> _savedIds = {};
  
  // CACHE Y BÚSQUEDA
  List<ConcertDetail> _cachedConcerts = []; // Todos los conciertos descargados
  List<ConcertDetail> _searchResults = [];  // Resultados de búsqueda
  bool _isSearching = false;                // ¿Está buscando el usuario?
  final TextEditingController _searchController = TextEditingController();

  // Artistas para Spotify
  final List<String> _targetArtists = ["Bad Bunny", "Rosalía", "Quevedo", "Aitana", "Feid", "C. Tangana"];

  // Tickets ejemplo
  final List<Ticket> myTickets = [
    Ticket(eventName: "Concierto de Kassandra", eventDate: DateTime(2025, 12, 20), location: "Auditorio Nacional", status: "Activa"),
    Ticket(eventName: "Festival de Música", eventDate: DateTime(2026, 1, 15), location: "Estadio Central", status: "Usada"),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // Listener para la búsqueda en tiempo real
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      // 1. Cargar Conciertos (60 días)
      _concertsFuture = _ticketmasterService.getConcerts(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 60)),
      ).then((events) {
        _cachedConcerts = events; // Guardamos referencia para el buscador
        return events;
      });

      // 2. Cargar Fotos Artistas
      _artistsFuture = Future.wait(
        _targetArtists.map((name) async {
          try {
            final results = await _spotifyService.searchArtists(name);
            if (results.isNotEmpty) return results.first;
          } catch (e) {
            debugPrint("Error Spotify para $name: $e");
          }
          return {"name": name, "image": ""};
        })
      ).then((list) => list.where((item) => item["image"] != "").toList());
    });
  }

  // --- LÓGICA DE BÚSQUEDA ---
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _searchResults = [];
      } else {
        _isSearching = true;
        // Filtramos la lista cacheada por Nombre o por Venue
        _searchResults = _cachedConcerts.where((concert) {
          return concert.name.toLowerCase().contains(query) || 
                 concert.venue.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus(); // Ocultar teclado
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 1: Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen())); break;
      case 2: Navigator.push(context, MaterialPageRoute(builder: (_) => TickerScreen(tickets: myTickets))); break;
      case 3: Navigator.push(context, MaterialPageRoute(builder: (_) => const SocialScreen())); break;
    }
    setState(() => _currentIndex = index);
  }

  // --- LÓGICA DE INTERACCIÓN ---
  void _shareConcert(ConcertDetail concert) {
    final dateStr = DateFormat('d MMM yyyy').format(concert.date);
    Share.share('¡Mira este planazo en Vibra! 🎸\n${concert.name}\n📅 $dateStr\n📍 ${concert.venue}\n${concert.ticketUrl}');
  }

  void _toggleLike(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  void _toggleSave(String id) {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_savedIds.contains(id)) {
        _savedIds.remove(id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eliminado de guardados"), duration: Duration(seconds: 1)));
      } else {
        _savedIds.add(id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Guardado en tu lista"), backgroundColor: Colors.greenAccent, duration: Duration(seconds: 1)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      
      // --- APP BAR PREMIUM ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                // 1. BUSCADOR PREMIUM
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.08), width: 1), // Borde sutil
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      cursorColor: Colors.greenAccent,
                      decoration: InputDecoration(
                        hintText: 'Buscar artistas, salas...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4), size: 22),
                        suffixIcon: _searchController.text.isNotEmpty 
                          ? IconButton(
                              icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                              onPressed: _clearSearch,
                            )
                          : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // 2. AVATAR PREMIUM (GLOW + BORDE)
                Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () => Scaffold.of(context).openEndDrawer(),
                      child: Container(
                        padding: const EdgeInsets.all(2), // Espacio para el borde
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.greenAccent, width: 1.5), // Borde Neón
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFF1C1C1E),
                          child: Icon(Icons.person, color: Colors.white, size: 24),
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),

      // --- BODY CON LÓGICA DE BÚSQUEDA ---
      body: _isSearching 
        ? _buildSearchResults() // Si busca, muestra resultados
        : _buildHomeContent(),  // Si no, muestra la home normal
      
      // BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0E0E0E),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: ''),
        ],
      ),

      endDrawer: _buildDrawer(context),
    );
  }

  // --- VISTA DE RESULTADOS DE BÚSQUEDA ---
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 16),
            const Text("No hemos encontrado nada", style: TextStyle(color: Colors.white54, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        // Reutilizamos la tarjeta de lista filtrada para los resultados
        return _buildListCard(_searchResults[index]);
      },
    );
  }

  // --- VISTA NORMAL DE HOME ---
  Widget _buildHomeContent() {
    return FutureBuilder<List<ConcertDetail>>(
      future: _concertsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event_busy, color: Colors.white24, size: 50),
                const SizedBox(height: 10),
                const Text("No hay eventos disponibles", style: TextStyle(color: Colors.white54)),
                TextButton(onPressed: _loadData, child: const Text("Reintentar", style: TextStyle(color: Colors.greenAccent)))
              ],
            ),
          );
        }

        final concerts = snapshot.data!;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hola, ${widget.displayName}', style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
                    const Text('Descubre lo mejor', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 2) return _buildArtistsCarousel();
                  if (index == 6) return _buildCollectionsCarousel();
                  
                  if (index >= concerts.length) return null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: _buildDiceCard(context, concerts[index]),
                  );
                },
                childCount: concerts.length,
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }

  // ==========================================
  // WIDGETS AUXILIARES
  // ==========================================

  Widget _buildSectionHeader({required String title, required String subtitle, VoidCallback? onMoreTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1.1)),
              const SizedBox(height: 4),
              Container(height: 3, width: 40, decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          if (onMoreTap != null)
            GestureDetector(
              onTap: onMoreTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArtistsCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: "ARTISTAS TOP", subtitle: "Lo más escuchado ahora"),
        SizedBox(
          height: 110,
          child: FutureBuilder<List<Map<String, String>>>(
            future: _artistsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
              final artists = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.blueAccent])),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFF1C1C1E),
                            backgroundImage: ResizeImage(NetworkImage(artists[index]['image']!), width: 150),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(artists[index]['name']!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCollectionsCarousel() {
    final collections = [
      {"name": "Esta noche", "id": "tonight", "color": Colors.purpleAccent, "img": "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=400&auto=format&fit=crop"},
      {"name": "Urbano & Latino", "id": "KnvZfZ7vAj6", "color": const Color(0xFFFF4500), "img": "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=400&auto=format&fit=crop"},
      {"name": "Electrónica", "id": "KnvZfZ7vAvF", "color": Colors.blueAccent, "img": "https://images.unsplash.com/photo-1571266028243-3716f02d2d2e?q=80&w=400&auto=format&fit=crop"},
      {"name": "Rock & Indie", "id": "KnvZfZ7vAeA", "color": const Color(0xFF8B0000), "img": "https://images.unsplash.com/photo-1498038432885-c6f3f1b912ee?q=80&w=400&auto=format&fit=crop"},
      {"name": "Pop & Hits", "id": "KnvZfZ7vAev", "color": Colors.pinkAccent, "img": "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?q=80&w=400&auto=format&fit=crop"},
      {"name": "Jazz & Blues", "id": "KnvZfZ7vAvE", "color": Colors.amber, "img": "https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?q=80&w=400&auto=format&fit=crop"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: "EXPLORA VIBRAS", subtitle: "Encuentra tu plan ideal"),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 16), 
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final col = collections[index];
              final color = col["color"] as Color;
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FilteredEventsScreen(categoryName: col["name"] as String, categoryId: col["id"] as String, accentColor: color))),
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(col["img"] as String, fit: BoxFit.cover, cacheWidth: 400, color: Colors.black.withOpacity(0.3), colorBlendMode: BlendMode.darken, errorBuilder: (c,e,s) => Container(color: color.withOpacity(0.3))),
                        Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(0.9), color.withOpacity(0.2), Colors.black.withOpacity(0.8)], stops: const [0.0, 0.5, 1.0]))),
                        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.6), width: 1.5))),
                        Positioned(bottom: 12, left: 14, child: Row(children: [Container(height: 20, width: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(col["name"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5))])),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // --- TARJETA PRINCIPAL (HOME) ---
  Widget _buildDiceCard(BuildContext context, ConcertDetail concert) {
    final String dayNum = DateFormat('d').format(concert.date);
    final String monthName = DateFormat('MMM', 'es_ES').format(concert.date).toUpperCase().replaceAll('.', '');
    String priceLabel = concert.priceRange.isNotEmpty ? concert.priceRange.split('-')[0].trim() : "Info";
    
    String concertId = concert.name; 
    bool isLiked = _likedIds.contains(concertId);
    bool isSaved = _savedIds.contains(concertId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConcertDetailScreen(
              concert: concert,
              initialIsLiked: isLiked,
              initialIsSaved: isSaved,
              onStateChanged: (liked, saved) {
                setState(() {
                  if (liked) _likedIds.add(concertId); else _likedIds.remove(concertId);
                  if (saved) _savedIds.add(concertId); else _savedIds.remove(concertId);
                });
              },
            ),
          ),
        );
      },
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFF1C1C1E),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: concert.imageUrl.isNotEmpty
                    ? Image.network(
                        concert.imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 500, 
                        errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF2A2A2A)),
                      )
                    : Container(color: const Color(0xFF2A2A2A)),
              ),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.95)], stops: const [0.4, 0.6, 1.0]))),
              
              Positioned(top: 16, left: 16, child: Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(monthName, style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w900, height: 1)), Text(dayNum, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900, height: 1))]))),
              
              Positioned(top: 16, right: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)), child: Text(priceLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),

              Positioned(
                bottom: 20, right: 20,
                child: Row(
                  children: [
                    _AnimatedIconButton(isSelected: false, iconSelected: Icons.ios_share_rounded, iconUnselected: Icons.ios_share_rounded, colorSelected: Colors.white, onTap: () => _shareConcert(concert)),
                    const SizedBox(width: 8),
                    _AnimatedIconButton(isSelected: isLiked, iconSelected: Icons.favorite, iconUnselected: Icons.favorite_border_rounded, colorSelected: Colors.redAccent, fillColorSelected: Colors.redAccent.withOpacity(0.2), onTap: () => _toggleLike(concertId)),
                    const SizedBox(width: 8),
                    _AnimatedIconButton(isSelected: isSaved, iconSelected: Icons.bookmark, iconUnselected: Icons.bookmark_border_rounded, colorSelected: Colors.greenAccent, fillColorSelected: Colors.greenAccent.withOpacity(0.2), onTap: () => _toggleSave(concertId)),
                  ],
                ),
              ),

              Positioned(bottom: 20, left: 20, right: 150, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(concert.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.1, shadows: [Shadow(color: Colors.black, blurRadius: 10)])), const SizedBox(height: 6), Row(children: [const Icon(Icons.location_on, color: Colors.greenAccent, size: 14), const SizedBox(width: 4), Expanded(child: Text(concert.venue, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis))])])),
            ],
          ),
        ),
      ),
    );
  }

  // --- TARJETA PARA BÚSQUEDA (HORIZONTAL Y COMPACTA) ---
  Widget _buildListCard(ConcertDetail concert) {
    final day = DateFormat('d MMM').format(concert.date).toUpperCase();
    
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConcertDetailScreen(concert: concert))),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05))
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(concert.imageUrl, width: 100, height: 100, fit: BoxFit.cover, cacheWidth: 200, errorBuilder: (c,e,s) => Container(width: 100, color: Colors.grey[900])),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(concert.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(concert.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 6),
                    Text(day, style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16))
          ],
        ),
      ),
    );
  }

  // --- DRAWER ACTUALIZADO CON TUS PEDIDOS ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0E0E0E),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera del Drawer
            Padding(
              padding: const EdgeInsets.all(20), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(widget.displayName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), 
                  const SizedBox(height: 8), 
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomizeProfileScreen())), 
                    child: const Text("Editar perfil", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w500))
                  )
                ]
              )
            ),
            const Divider(color: Colors.white12),
            
            // --- NUEVO: CUENTA ---
            _menuItem(context, "Cuenta", Icons.person_outline, const AccountScreen()),

            // MIS GUARDADOS
            _menuItem(context, "Mis Guardados", Icons.bookmark, SavedEventsScreen(savedConcerts: _cachedConcerts.where((c) => _savedIds.contains(c.name)).toList())),
            
            // --- ACTUALIZADO: MÉTODOS DE PAGO ---
            _menuItem(context, "Métodos de pago", Icons.payment, const PaymentsScreen()),
            
            // CONFIGURACIÓN
            _menuItem(context, "Configuración", Icons.settings, const SettingsScreen()),
            
            // --- NUEVO: AYUDA ---
            _menuItem(context, "Ayuda", Icons.help_outline, const AyudaScreen()),
            
            const Spacer(),
            
            // CERRAR SESIÓN
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent), 
              title: const Text("Cerrar sesión", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)), 
              onTap: () { 
                Navigator.of(context).pop(); 
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); 
              }
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70), 
      title: Text(title, style: const TextStyle(color: Colors.white)), 
      onTap: () { 
        Navigator.of(context).pop(); 
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen)); 
      }
    );
  }
}

// --- WIDGET ANIMADO INTERNO ---
class _AnimatedIconButton extends StatefulWidget {
  final bool isSelected;
  final IconData iconSelected;
  final IconData iconUnselected;
  final Color colorSelected;
  final VoidCallback onTap;
  final Color? fillColorSelected;

  const _AnimatedIconButton({required this.isSelected, required this.iconSelected, required this.iconUnselected, required this.colorSelected, required this.onTap, this.fillColorSelected});

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color currentColor = widget.isSelected ? widget.colorSelected : Colors.white;
    final Color currentFill = widget.isSelected 
        ? (widget.fillColorSelected ?? widget.colorSelected.withOpacity(0.2))
        : Colors.white.withOpacity(0.15);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
        _controller.forward().then((_) => _controller.reverse());
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentFill,
            border: Border.all(color: currentColor.withOpacity(widget.isSelected ? 1.0 : 0.5), width: 1),
          ),
          child: Icon(widget.isSelected ? widget.iconSelected : widget.iconUnselected, color: currentColor, size: 18),
        ),
      ),
    );
  }
}