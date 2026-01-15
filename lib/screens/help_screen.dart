import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Necesario para abrir el correo
import '../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  // Función para abrir el correo
  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'vibra@support.com',
      query: 'subject=Soporte Vibra App', // Asunto opcional por defecto
    );

    try {
      if (!await launchUrl(emailUri)) {
        throw Exception('No se pudo lanzar el correo');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No se pudo abrir la aplicación de correo. Escribe a vibra@support.com"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Paleta de colores Premium
    final Color bgColor = isDark ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7);
    final Color cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF222222);
    final Color subTextColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final Color accentColor = const Color(0xFF54FF78);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.menuHelp,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // 1. CABECERA GRANDE
          const SizedBox(height: 10),
          Text(
            l10n.helpMainSubtitle, // "¿En qué podemos ayudarte?"
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 30),

          // 2. PREGUNTAS FRECUENTES (Estilo Acordeón Limpio)
          Text(
            l10n.helpSectionFaq.toUpperCase(),
            style: TextStyle(
              color: subTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _FaqTile(question: l10n.helpFaq1Q, answer: l10n.helpFaq1A, textColor: textColor, subTextColor: subTextColor),
                Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade100),
                _FaqTile(question: l10n.helpFaq2Q, answer: l10n.helpFaq2A, textColor: textColor, subTextColor: subTextColor),
                Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade100),
                _FaqTile(question: l10n.helpFaq3Q, answer: l10n.helpFaq3A, textColor: textColor, subTextColor: subTextColor, isLast: true),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 3. SOPORTE Y CONTACTO (Botones Grandes - Con funcionalidad de Email)
          Text(
            l10n.helpSectionSupport.toUpperCase(),
            style: TextStyle(
              color: subTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          _SupportButton(
            icon: Icons.email_outlined,
            title: l10n.helpSupportContact,
            subtitle: "vibra@support.com",
            accentColor: accentColor,
            cardColor: cardColor,
            textColor: textColor,
            onTap: () => _sendEmail(context), // Abre el correo
          ),
          const SizedBox(height: 12),
          _SupportButton(
            icon: Icons.bug_report_outlined,
            title: l10n.helpSupportReport,
            subtitle: "Reportar error técnico",
            accentColor: Colors.orangeAccent,
            cardColor: cardColor,
            textColor: textColor,
            onTap: () => _sendEmail(context), // Abre el correo
          ),
          
          const SizedBox(height: 40),
          Center(
            child: Text(
              "Vibra App v1.0.0",
              style: TextStyle(color: subTextColor.withOpacity(0.3), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGETS AUXILIARES
// -----------------------------------------------------------------------------

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final Color textColor;
  final Color subTextColor;
  final bool isLast;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.textColor,
    required this.subTextColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        iconColor: textColor,
        collapsedIconColor: subTextColor,
        title: Text(
          question,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              color: subTextColor,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onTap;

  const _SupportButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: textColor.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: textColor.withOpacity(0.3), size: 14),
          ],
        ),
      ),
    );
  }
}