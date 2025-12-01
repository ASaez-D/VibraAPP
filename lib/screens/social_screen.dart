import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  final Color accentColor = Colors.greenAccent;
  final Color backgroundColor = const Color(0xFF0E0E0E);

  // Datos de ejemplo
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
        backgroundColor: backgroundColor,
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
          // Barra de búsqueda simple
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Buscar amigo...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF1C1C1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Lista de amigos
          Expanded(
            child: ListView.separated(
              itemCount: friends.length,
              separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
              itemBuilder: (context, index) {
                final friend = friends[index];
                final isOnline = friend['status'] == "En línea";

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  // Avatar con indicador de estado
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
                  // Nombre
                  title: Text(
                    friend['name'],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Estado
                  subtitle: Text(
                    friend['status'],
                    style: TextStyle(
                      color: isOnline ? accentColor : Colors.grey[500],
                      fontSize: 13,
                    ),
                  ),
                  // Botón de chat
                  trailing: IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white54, size: 22),
                    onPressed: () {},
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