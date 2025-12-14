import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A1A), // Fondo oscuro igual a HomeScreen

      // 🔝 AppBar personalizado (Igual a HomeScreen)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Botón atrás (opcional, por si es una pantalla secundaria)
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white10,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 10),

                // 🔍 Barra de búsqueda
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar ayuda...',
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.search, color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 8),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // 👤 Icono perfil (Consistencia visual)
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

      // 📜 CUERPO
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Título Principal
            const Text(
              'Centro de Ayuda',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '¿En qué podemos ayudarte hoy?',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),

            const SizedBox(height: 24),

            // SECCIÓN 1: FAQ
            _sectionHeader("PREGUNTAS FRECUENTES"),
            const SizedBox(height: 12),
            
            _faqItem(
              "¿Cómo compro una entrada?",
              "Ve al concierto que te interese y pulsa en “Comprar entrada”. Podrás elegir el método de pago y confirmar.",
            ),
            _faqItem(
              "¿Cómo gestiono mis notificaciones?",
              "En el apartado Notificaciones podrás habilitar avisos de conciertos, artistas y recomendaciones.",
            ),
            _faqItem(
              "Invitar amigos",
              "En la página del evento, pulsa “Invitar amigos” para enviarles una notificación directa.",
            ),

            const SizedBox(height: 24),

            // SECCIÓN 2: Tutoriales
            _sectionHeader("TUTORIALES RÁPIDOS"),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF242323),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _simpleListItem(Icons.shopping_cart_outlined, "Guía de compra"),
                  _divider(),
                  _simpleListItem(Icons.confirmation_number_outlined, "Usar tus tickets"),
                  _divider(),
                  _simpleListItem(Icons.calendar_today_outlined, "Sincronizar calendario"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SECCIÓN 3: Soporte y Políticas
            _sectionHeader("SOPORTE Y LEGAL"),
            const SizedBox(height: 12),
            
            // Tarjetas pequeñas en Grid o Columna
            _supportCard(Icons.email_outlined, "Contactar Soporte", "support@tuapp.com"),
            const SizedBox(height: 10),
            _supportCard(Icons.bug_report_outlined, "Reportar Problema", "Envíanos detalles del error"),
            const SizedBox(height: 10),
            _supportCard(Icons.article_outlined, "Términos y condiciones", "Lee nuestras normas"),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES (Estilo Home) ---

  // Texto pequeño estilo "RECOMENDACIONES"
  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  // Item de FAQ estilo Card Oscura
  Widget _faqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF242323), // Color de las cards del Home
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent), // Quitar lineas por defecto
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white54,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Item simple para listas (Tutoriales)
  Widget _simpleListItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
      onTap: () {},
    );
  }

  // Divisor sutil dentro de cards
  Widget _divider() {
    return const Divider(
      height: 1,
      color: Colors.white10,
      indent: 16,
      endIndent: 16,
    );
  }

  // Tarjeta de soporte (Similar a "Tus artistas" pero en bloque)
  Widget _supportCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF242323),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
        ],
      ),
    );
  }
}