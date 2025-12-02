import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E1A), // negro-morado
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Ayuda",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Preguntas Frecuentes"),
          _faqItem(
            "¿Cómo compro una entrada?",
            "Ve al concierto que te interese y pulsa en “Comprar entrada”. Podrás elegir el método de pago y confirmar.",
          ),
          _faqItem(
            "¿Cómo activo o desactivo notificaciones?",
            "En el apartado Notificaciones podrás habilitar avisos de conciertos, artistas y recomendaciones.",
          ),
          _faqItem(
            "¿Cómo guardo conciertos en mi calendario?",
            "Cuando entras a un concierto, encontrarás el botón “Añadir al calendario”.",
          ),
          _faqItem(
            "¿Cómo invito amigos a un concierto?",
            "En la página del evento, pulsa “Invitar amigos” para enviarles una notificación o mensaje.",
          ),
          _faqItem(
            "No me llega el código de verificación",
            "Asegúrate de que tu email es correcto y revisa la carpeta de spam.",
          ),
          const SizedBox(height: 24),
          _sectionTitle("Tutoriales rápidos"),
          _tutorialItem(Icons.shopping_cart, "Comprar entradas paso a paso"),
          _tutorialItem(Icons.people_alt, "Invitar amigos a un concierto"),
          _tutorialItem(Icons.calendar_month, "Usar tu calendario de eventos"),
          _tutorialItem(Icons.notifications_active, "Configurar notificaciones"),
          const SizedBox(height: 24),
          _sectionTitle("Centro de Soporte"),
          _supportItem(Icons.email, "Correo de soporte", "support@tuapp.com"),
          _supportItem(Icons.bug_report, "Reportar un problema",
              "Describe el error y adjunta una captura si es posible."),
          _supportItem(Icons.help_center, "Asistencia",
              "Si necesitas ayuda inmediata, nuestro equipo está aquí."),
          const SizedBox(height: 24),
          _sectionTitle("Políticas y Documentación"),
          _policyItem("Términos y condiciones"),
          _policyItem("Política de privacidad"),
          _policyItem("Normas de la comunidad"),
        ],
      ),
    );
  }

  // --- WIDGETS ---
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700, Colors.purple.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white70,
        title: Text(
          question,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tutorialItem(IconData icon, String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.purpleAccent),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }

  Widget _supportItem(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.purpleAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
      onTap: () {},
    );
  }

  Widget _policyItem(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.description, color: Colors.white54),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}
