import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  // Quitar const del constructor
  SocialScreen({super.key});

  // Morado aún más oscuro
  final Color accentColor = Colors.deepPurple.shade900;
  final Color backgroundColor = const Color(0xFF0E0E1A);

  final List<Map<String, dynamic>> friends = const [
    {"name": "Ana García", "status": "En línea", "img": "https://i.pravatar.cc/150?u=1"},
    {"name": "Carlos Ruiz", "status": "Escuchando Jazz", "img": "https://i.pravatar.cc/150?u=2"},
    {"name": "Laura M.", "status": "Desconectado", "img": "https://i.pravatar.cc/150?u=3"},
    {"name": "David V.", "status": "En el concierto de Vecinos", "img": "https://i.pravatar.cc/150?u=4"},
    {"name": "Sofía L.", "status": "En línea", "img": "https://i.pravatar.cc/150?u=5"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Mis Amigos",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Buscar amigo...",
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1B1B2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: friends.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
              itemBuilder: (context, index) {
                final friend = friends[index];
                final isOnline = friend['status'] == "En línea";

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0013), // 🔥 un solo color morado oscuro
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(friend['img']),
                          backgroundColor: Colors.grey[800],
                        ),
                        if (isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: backgroundColor, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      friend['name'],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      friend['status'],
                      style: TextStyle(
                          color: isOnline ? accentColor : Colors.white54, fontSize: 13),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded,
                          color: Colors.white54, size: 22),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
