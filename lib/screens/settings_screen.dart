import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Color accentColor = const Color(0xFF54FF78); 
  final Color backgroundColor = const Color(0xFF0C0C0C);

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Configuración",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        children: [

          _buildHeader("Notificaciones"),
          _buildCard([
            _switchTile(Icons.notifications, "Notificaciones generales"),
            _divider(),
            _switchTile(Icons.event_available, "Recordatorios de eventos"),
            _divider(),
            _switchTile(Icons.new_releases, "Lanzamiento de entradas"),
            _divider(),
            _switchTile(Icons.auto_awesome, "Recomendaciones"),
          ]),

          const SizedBox(height: 28),

          _buildHeader("Privacidad"),
          _buildCard([
            _linkTile(Icons.location_on, "Permisos de ubicación"),
            _divider(),
            _linkTile(Icons.shield, "Datos compartidos"),
            _divider(),
            _linkTile(Icons.download, "Descargar mis datos"),
            _divider(),
            _linkTile(Icons.delete_forever, "Eliminar cuenta"),
          ]),

          const SizedBox(height: 28),

          _buildHeader("Preferencias"),
          _buildCard([
            _linkTile(Icons.language, "Idioma"),
            _divider(),
            _linkTile(Icons.dark_mode, "Tema oscuro / claro"),
            _divider(),
            _switchTile(Icons.text_fields, "Texto grande"),
            _divider(),
            _switchTile(Icons.play_circle_outline, "Autoplay previews"),
          ]),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Headers más grandes y modernos
  // ------------------------------------------------------------
  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Card con sombra suave
  // ------------------------------------------------------------
  Widget _buildCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Column(children: children),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Divider fino tipo iOS
  // ------------------------------------------------------------
  Widget _divider() {
    return Divider(
      color: Colors.white.withOpacity(0.08),
      height: 1,
      thickness: 0.4,
      indent: 50,
      endIndent: 14,
    );
  }

  // ------------------------------------------------------------
  // Tile con flecha
  // ------------------------------------------------------------
  Widget _linkTile(IconData icon, String text) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.95), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 22),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Tile con switch
  // ------------------------------------------------------------
  Widget _switchTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.95), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: true,
              onChanged: (_) {},
              activeColor: accentColor,
              activeTrackColor: accentColor.withOpacity(0.3),
              inactiveThumbColor: Colors.white54,
              inactiveTrackColor: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }
}
