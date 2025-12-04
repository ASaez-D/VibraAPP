import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

// Definición de la pantalla principal de Configuración
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
            // Se pasa context para la navegación y se usa la nueva sintaxis de AppSettings
            _linkTile(context, Icons.location_on, "Permisos de ubicación"),
            _divider(),
            _linkTile(context, Icons.shield, "Datos compartidos"),
            _divider(),
            _linkTile(context, Icons.download, "Descargar mis datos"),
            _divider(),
            _linkTile(context, Icons.delete_forever, "Eliminar cuenta"),
          ]),
          const SizedBox(height: 28),
          _buildHeader("Preferencias"),
          _buildCard([
            _linkTile(context, Icons.language, "Idioma"),
            _divider(),
            _linkTile(context, Icons.dark_mode, "Tema oscuro / claro"),
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
  // Tile con flecha (CORREGIDO Y CON NAVEGACIÓN)
  // ------------------------------------------------------------
  Widget _linkTile(BuildContext context, IconData icon, String text) {
    return InkWell(
      onTap: () {
        if (text == "Permisos de ubicación") {
          // CORRECCIÓN: Sintaxis actualizada para app_settings ^5.0.0
          AppSettings.openAppSettings(type: AppSettingsType.location);
        } else if (text == "Datos compartidos") {
          // NAVEGACIÓN: Ir a la pantalla de datos compartidos
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SharedDataScreen()),
          );
        } else {
          // Aquí puedes agregar lógica para las otras opciones
          debugPrint("Tocaste: $text");
        }
      },
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

// ------------------------------------------------------------
// Pantalla de Datos Compartidos (Adaptada a Vibra y SIN pasarela de pago directa)
// ------------------------------------------------------------
class SharedDataScreen extends StatelessWidget {
  const SharedDataScreen({super.key});

  // Widget auxiliar para las tarjetas de información
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF54FF78), size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0C0C),
        elevation: 0,
        title: const Text(
          "Datos compartidos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFF0C0C0C),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // SECCIÓN 1: DATOS RECOLECTADOS
          _buildInfoCard(
            title: "Datos que recolectamos",
            icon: Icons.folder_shared_outlined,
            content:
                "• Perfil de usuario: Información básica para gestionar tu cuenta y agenda de eventos.\n"
                "• Preferencias Musicales: Sincronización con tus plataformas de streaming para recomendarte conciertos.\n"
                "• Historial de Compras: Solo registramos el historial de las entradas adquiridas (fecha, evento, cantidad).",
          ),

          const SizedBox(height: 16),

          // SECCIÓN 2: TERCEROS (INTEGRACIONES) - TEXTO MODIFICADO
          _buildInfoCard(
            title: "Servicios de terceros y Compra",
            icon: Icons.hub_outlined,
            content:
                "• Plataformas de Streaming: Conectamos con tu proveedor (ej. Spotify) solo para leer tus artistas favoritos.\n"
                "• Proceso de Compra: La aplicación te redirige a una plataforma web externa para finalizar el pago. Vibra no almacena ni procesa tu información financiera.",
          ),

          const SizedBox(height: 16),

          // SECCIÓN 3: INTERACCIÓN SOCIAL
          _buildInfoCard(
            title: "Interacción con otros usuarios",
            icon: Icons.people_outline,
            content:
                "• Invitaciones: Al invitar o regalar entradas, compartimos los detalles del evento con los contactos que selecciones.\n"
                "• Privacidad: Tus datos personales no son visibles para otros usuarios salvo que tú lo autorices explícitamente.",
          ),

          const SizedBox(height: 16),

          // SECCIÓN 4: SEGURIDAD Y RGPD
          _buildInfoCard(
            title: "Seguridad y Control (RGPD)",
            icon: Icons.security,
            content:
                "• Encriptación: Toda tu información sensible viaja cifrada mediante protocolos seguros.\n"
                "• Tus derechos: Tienes control total para descargar tus datos o eliminar tu cuenta permanentemente desde los ajustes.",
          ),

          const SizedBox(height: 30),

          // Nota final de transparencia
          Center(
            child: Text(
              "Tu privacidad es nuestra prioridad en Vibra.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}