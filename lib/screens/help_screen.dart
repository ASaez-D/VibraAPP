import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1A1A), 

      // 🔝 AppBar personalizado
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: l10n.helpSearchHint, // "Buscar ayuda..."
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(top: 8),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

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

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Título Principal
            Text(
              l10n.menuHelp, // "Ayuda" / "Help"
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.helpMainSubtitle, // "¿En qué podemos ayudarte hoy?"
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),

            const SizedBox(height: 24),

            // SECCIÓN 1: FAQ
            _sectionHeader(l10n.helpSectionFaq),
            const SizedBox(height: 12),
            
            _faqItem(l10n.helpFaq1Q, l10n.helpFaq1A),
            _faqItem(l10n.helpFaq2Q, l10n.helpFaq2A),
            _faqItem(l10n.helpFaq3Q, l10n.helpFaq3A),

            const SizedBox(height: 24),

            // SECCIÓN 2: Tutoriales
            _sectionHeader(l10n.helpSectionTutorials),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF242323),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _simpleListItem(Icons.shopping_cart_outlined, l10n.helpTut1),
                  _divider(),
                  _simpleListItem(Icons.confirmation_number_outlined, l10n.helpTut2),
                  _divider(),
                  _simpleListItem(Icons.calendar_today_outlined, l10n.helpTut3),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SECCIÓN 3: Soporte y Políticas
            _sectionHeader(l10n.helpSectionSupport),
            const SizedBox(height: 12),
            
            _supportCard(Icons.email_outlined, l10n.helpSupportContact, "support@tuapp.com"),
            const SizedBox(height: 10),
            _supportCard(Icons.bug_report_outlined, l10n.helpSupportReport, "Envíanos detalles"),
            const SizedBox(height: 10),
            _supportCard(Icons.article_outlined, l10n.helpSupportTerms, "Lee nuestras normas"),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

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

  Widget _faqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF242323),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
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

  Widget _simpleListItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
      onTap: () {},
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color: Colors.white10,
      indent: 16,
      endIndent: 16,
    );
  }

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