import 'package:flutter/material.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Detectar si el tema actual es oscuro
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Obtener colores del tema para asegurar la adaptación
    final primaryTextColor = Theme.of(context).colorScheme.onBackground;
    final secondaryTextColor = Theme.of(context).colorScheme.onBackground.withOpacity(0.7);
    final tertiaryTextColor = Theme.of(context).colorScheme.onBackground.withOpacity(0.5);
    final faqItemBgColor = isDark
        ? Colors.white.withOpacity(0.1) // Fondo más claro para modo oscuro
        : Colors.black.withOpacity(0.05); // Fondo más oscuro para modo claro

    return Scaffold(
      // Usar el color de fondo del tema
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        // Usar el color de fondo del AppBar del tema
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Ayuda",
          style: TextStyle(
            // Usar el color de texto primario
            color: primaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            // Color del icono del tema
            color: primaryTextColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          Text(
            "Preguntas frecuentes",
            style: TextStyle(
                // Usar el color de texto primario
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Pasar los colores necesarios al widget
          _faqItem(
            "¿Cómo cambio mi contraseña?",
            bgColor: faqItemBgColor,
            textColor: secondaryTextColor,
            iconColor: tertiaryTextColor,
          ),
          _faqItem(
            "¿Cómo elimino mi cuenta?",
            bgColor: faqItemBgColor,
            textColor: secondaryTextColor,
            iconColor: tertiaryTextColor,
          ),
          _faqItem(
            "¿Cómo contacto con soporte?",
            bgColor: faqItemBgColor,
            textColor: secondaryTextColor,
            iconColor: tertiaryTextColor,
          ),
          _faqItem(
            "¿Cómo ver mis tickets?",
            bgColor: faqItemBgColor,
            textColor: secondaryTextColor,
            iconColor: tertiaryTextColor,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // FAQ ITEM (Refactorizado para aceptar colores)
  // ---------------------------------------------------------
  Widget _faqItem(
    String question, {
    required Color bgColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // Color de fondo adaptado
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              question,
              style: TextStyle(
                // Color de texto adaptado
                color: textColor,
                fontSize: 14,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              // Color del icono adaptado
              color: iconColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}