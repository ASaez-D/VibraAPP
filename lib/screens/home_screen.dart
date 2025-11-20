import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String displayName;

  const HomeScreen({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A1A), // Fondo oscuro

      // 🔝 AppBar personalizado
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // 🔍 Barra de búsqueda
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.search, color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 6),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // 👤 Icono perfil
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white10,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),

      // 📜 CUERPO PRINCIPAL
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Saludo con el nombre
            Text(
              '¡Hola, $displayName! 👋',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              'RECOMENDACIONES',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            // 🎟️ Card de recomendación (SIN IMÁGENES)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF242323),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'De tus artistas:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),

                  const Text(
                    'Concierto destacado',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Fecha por confirmar',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.account_circle,
                                color: Colors.white54, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Kassandra',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      const Icon(Icons.favorite_border,
                          color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      const Icon(Icons.share,
                          color: Colors.white70, size: 18),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 👥 Sección "Tus artistas"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Tus artistas',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Quien escuchas y sigues',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white10,
                  child: Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 14),
                ),
              ],
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // ⚫ Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1B1A1A),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
