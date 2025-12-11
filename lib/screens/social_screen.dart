import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  // Mantenemos accentColor ya que es el color de marca (verde)
  final Color accentColor = Colors.greenAccent; 
  // ELIMINADO: final Color backgroundColor = const Color(0xFF0E0E0E);

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
    // 1. Obtener el estado del tema y los colores dinámicos
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Colores base dinámicos
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey[600] : Colors.grey[700];
    final searchFieldColor = isDark ? const Color(0xFF1C1C1E) : Colors.grey[200];
    final listTileDividerColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.1);
    final trailingIconColor = isDark ? Colors.white54 : Colors.black45;
    
    // Color de fondo del Scaffold (se usa el del tema global: blanco o negro)
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor; 
    
    // Color del fondo de la AppBar (se usa el del tema global)
    final appBarBgColor = Theme.of(context).appBarTheme.backgroundColor;


    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        elevation: 0,
        title: Text(
          "Mis Amigos",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 22, 
            color: mainTextColor // Color dinámico
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt_1_rounded, color: mainTextColor), // Icono dinámico
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
              style: TextStyle(color: mainTextColor), // Texto de entrada dinámico
              decoration: InputDecoration(
                hintText: "Buscar amigo...",
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.search, color: hintColor),
                filled: true,
                fillColor: searchFieldColor, // Color de relleno dinámico
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
              separatorBuilder: (context, index) => Divider(color: listTileDividerColor, height: 1), // Divisor dinámico
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
                        backgroundColor: Colors.grey[800], // Este color está bien en ambos modos
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
                              // El borde debe contrastar con el fondo del Scaffold
                              border: Border.all(color: scaffoldBgColor, width: 2), 
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Nombre
                  title: Text(
                    friend['name'],
                    style: TextStyle(
                      color: mainTextColor, // Color dinámico
                      fontWeight: FontWeight.bold, 
                      fontSize: 16
                    ),
                  ),
                  // Estado
                  subtitle: Text(
                    friend['status'],
                    style: TextStyle(
                      // Si está en línea, usa el color de marca (verde). Si no, usa un gris dinámico.
                      color: isOnline ? accentColor : hintColor, 
                      fontSize: 13,
                    ),
                  ),
                  // Botón de chat
                  trailing: IconButton(
                    icon: Icon(Icons.chat_bubble_outline_rounded, color: trailingIconColor, size: 22), // Icono dinámico
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