import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'payments_screen.dart';
import 'privacity_screen.dart';
import 'notifications_screen.dart';
import 'customizeProfile_screen.dart';
import 'calendar_screen.dart';
import 'ticket_screen.dart';
import 'social_screen.dart';
import 'help_screen.dart';

class HomeScreen extends StatefulWidget {
  final String displayName;
  const HomeScreen({super.key, required this.displayName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> recommendedItems = [
    {
      'title': 'Concierto destacado',
      'subtitle': 'De tus artistas favoritos',
      'date': 'Fecha por confirmar'
    },
    {
      'title': 'Festival de Rock',
      'subtitle': 'Lo mejor del rock nacional',
      'date': '15 Enero 2026'
    },
    {
      'title': 'Concierto de Kassandra',
      'subtitle': 'Tu artista favorito',
      'date': '20 Diciembre 2025'
    },
  ];

  List<Map<String, String>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(recommendedItems);

    _searchController.addListener(() {
      String query = _searchController.text.toLowerCase();
      setState(() {
        filteredItems = recommendedItems
            .where((item) =>
                item['title']!.toLowerCase().contains(query) ||
                item['subtitle']!.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => CalendarScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => TicketScreen(tickets: [
                  Ticket(
                      eventName: "Concierto de Kassandra",
                      eventDate: DateTime(2025, 12, 20),
                      location: "Auditorio Nacional",
                      status: "Activa"),
                  Ticket(
                      eventName: "Festival de Música",
                      eventDate: DateTime(2026, 1, 15),
                      location: "Estadio Central",
                      status: "Usada"),
                ])));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SocialScreen()));
        break;
    }

    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0710),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1A1324),
                          Color(0xFF120C18)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white54),
                        hintText: "Buscar conciertos, artistas...",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 6),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(0.4),
                          width: 1.5,
                        ),
                        color: const Color(0xFF1A1324),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.25),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¡Hola, ${widget.displayName}! 👋",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "RECOMENDADO PARA TI",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),

            // --- Mostrar los elementos filtrados ---
            ...filteredItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF25182F),
                      Color(0xFF120C18),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.18),
                      blurRadius: 12,
                      spreadRadius: 1,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['subtitle']!,
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text(
                      item['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(item['date']!,
                        style:
                            const TextStyle(color: Colors.white60, fontSize: 13)),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Tus artistas",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Lo que más escuchas",
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1324),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B0710),
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.white38,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF0B0710),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0013),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade900.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.displayName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CustomizeProfileScreen()),
                        );
                      },
                      child: const Text(
                        "Editar perfil",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24),
              _menuItem(context, "Pagos", Icons.payment, PaymentsScreen()),
              _menuItem(context, "Notificaciones", Icons.notifications,
                  NotificationsScreen()),
              _menuItem(context, "Privacidad", Icons.vpn_key, PrivacityScreen()),
              _menuItem(context, "Configuración", Icons.settings, SettingsScreen()),
              _menuItem(context, "Ayuda", Icons.help_outline, HelpScreen()),
              const Spacer(),
              const Divider(color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Cerrar sesión",
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, String title, IconData icon, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}
