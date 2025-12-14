import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
// Asegúrate de que esta importación apunte correctamente a main.dart
import '../main.dart'; 

// -----------------------------------------------------------------
// Definición de la pantalla principal de Configuración
// -----------------------------------------------------------------
class SettingsScreen extends StatelessWidget {
  final Color accentColor = const Color(0xFF54FF78);

  const SettingsScreen({super.key});

  // Función para obtener el valor actual del interruptor de texto grande
  // Es TRUE si la escala es mayor a 1.0 (es decir, está activo)
  bool _isLargeTextActive() {
    return textScaleNotifier.value > 1.0;
  }

  // Función para cambiar el estado de la escala de texto global
  void _toggleLargeText(bool newValue) {
    // 1.3 es un buen factor de escalado para "grande"
    textScaleNotifier.value = newValue ? 1.3 : 1.0; 
  }

  @override
  Widget build(BuildContext context) {
    // Detectamos si estamos en modo oscuro para ajustar los textos
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Definimos colores dinámicos
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.05);
    final leadingIconColor = isDark ? Colors.white : Colors.black;
    final chevronColor = isDark ? Colors.white24 : Colors.black54;


    return Scaffold(
      // USAMOS EL COLOR DEL TEMA (Blanco o Negro definido en main.dart)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Configuración",
          style: TextStyle(
            color: textColor, // Color dinámico
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: leadingIconColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        children: [
          _buildHeader("Notificaciones", isDark), // Pasamos isDark
          _buildCard(
            children: [
              // Los switches de Notificaciones tienen un valor fijo (simulado) y onChanged vacío,
              // pero ahora usan la versión refactorizada de _switchTile
              _switchTile(Icons.notifications, "Notificaciones generales", isDark, accentColor, value: true, onChanged: (_){}),
              _divider(isDark),
              _switchTile(Icons.event_available, "Recordatorios de eventos", isDark, accentColor, value: true, onChanged: (_){}),
              _divider(isDark),
              _switchTile(Icons.new_releases, "Lanzamiento de entradas", isDark, accentColor, value: false, onChanged: (_){}),
            ],
            cardColor: cardColor, // Pasamos el color de tarjeta dinámico
          ),
          const SizedBox(height: 28),

          _buildHeader("Privacidad", isDark),
          _buildCard(
            children: [
              _linkTile(context, Icons.location_on, "Permisos de ubicación", isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.shield, "Datos compartidos", isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.download, "Descargar mis datos", isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.delete_forever, "Eliminar cuenta", isDark, chevronColor),
            ],
            cardColor: cardColor,
          ),
          const SizedBox(height: 28),

          _buildHeader("Preferencias", isDark),
          // USAMOS ValueListenableBuilder para escuchar cambios en la escala de texto y actualizar el switch
          ValueListenableBuilder<double>(
            valueListenable: textScaleNotifier,
            builder: (context, scale, child) {
              return _buildCard(
                children: [
                  _linkTile(context, Icons.language, "Idioma", isDark, chevronColor),
                  _divider(isDark),
                  // BOTÓN DE CAMBIO DE TEMA
                  _themeSwitcherTile(context, isDark, accentColor),
                  _divider(isDark),
                  // SWITCH DE TEXTO GRANDE (AHORA CON FUNCIONALIDAD)
                  _switchTile(
                    Icons.text_fields, 
                    "Texto grande", 
                    isDark, 
                    accentColor,
                    value: _isLargeTextActive(), // Usa la función de estado
                    onChanged: _toggleLargeText, // Usa la función de cambio
                  ),
                ],
                cardColor: cardColor,
              );
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // WIDGET ESPECÍFICO PARA CAMBIAR EL TEMA (Refactorizado para ser limpio)
  // ------------------------------------------------------------
  Widget _themeSwitcherTile(BuildContext context, bool isDark, Color accentColor) {
    // Usamos ValueListenableBuilder para escuchar el tema
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final bool isCurrentlyDark = mode == ThemeMode.dark || (mode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);
        
        return InkWell(
          onTap: () {
            // Cambiamos el tema al opuesto al actual
            themeNotifier.value = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Icon(isCurrentlyDark ? Icons.dark_mode : Icons.light_mode, 
                    color: isCurrentlyDark ? Colors.white.withOpacity(0.95) : Colors.black87, 
                    size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Tema oscuro / claro",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                 // Usamos un Switch real para mejor UX
                Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: isCurrentlyDark, 
                    onChanged: (newValue) {
                      themeNotifier.value = newValue ? ThemeMode.dark : ThemeMode.light;
                    },
                    activeColor: accentColor,
                    activeTrackColor: accentColor.withOpacity(0.3),
                    inactiveThumbColor: isDark ? Colors.white54 : Colors.grey,
                    inactiveTrackColor: isDark ? Colors.white12 : Colors.grey.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // Headers más grandes y modernos (Adaptado al tema)
  // ------------------------------------------------------------
  Widget _buildHeader(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Card con sombra suave (Adaptado al tema)
  // ------------------------------------------------------------
  Widget _buildCard({required List<Widget> children, required Color cardColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: cardColor, // Color dinámico
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
  // Divider fino tipo iOS (Adaptado al tema)
  // ------------------------------------------------------------
  Widget _divider(bool isDark) {
    return Divider(
      color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
      height: 1,
      thickness: 0.4,
      indent: 50,
      endIndent: 14,
    );
  }

  // ------------------------------------------------------------
  // Tile con flecha (CORREGIDO Y CON NAVEGACIÓN - Adaptado al tema)
  // ------------------------------------------------------------
  Widget _linkTile(BuildContext context, IconData icon, String text, bool isDark, Color chevronColor) {
    final contentColor = isDark ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        if (text == "Permisos de ubicación") {
          AppSettings.openAppSettings(type: AppSettingsType.location);
        } else if (text == "Datos compartidos") {
          // NAVEGACIÓN: Ir a la pantalla de datos compartidos
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SharedDataScreen()),
          );
        } else {
          // Aquí puedes agregar lógica para las otras opciones (Idioma, Descargar, Eliminar)
          debugPrint("Tocaste: $text");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: contentColor.withOpacity(0.95), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: chevronColor, size: 22),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Tile con switch (REFECTORIZADO para recibir 'value' y 'onChanged')
  // ------------------------------------------------------------
  Widget _switchTile(
    IconData icon, 
    String text, 
    bool isDark, 
    Color accentColor,
    {
      // NUEVOS PARÁMETROS REQUERIDOS
      required bool value, 
      required ValueChanged<bool> onChanged
    }) {
    final contentColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: contentColor.withOpacity(0.95), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: contentColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value, // Utiliza el valor pasado
              onChanged: onChanged, // Utiliza la función pasada
              activeColor: accentColor,
              activeTrackColor: accentColor.withOpacity(0.3),
              inactiveThumbColor: isDark ? Colors.white54 : Colors.grey,
              inactiveTrackColor: isDark ? Colors.white12 : Colors.grey.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Pantalla de Datos Compartidos (Se mantuvo igual, pero ahora se beneficia de la escala de texto global)
// ------------------------------------------------------------
class SharedDataScreen extends StatelessWidget {
  const SharedDataScreen({super.key});

  // Widget auxiliar para las tarjetas de información (Adaptado al tema)
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String content,
    required bool isDark,
  }) {
    final textColor = isDark ? Colors.white : Colors.black;
    final contentColor = isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7);
    final cardColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.1);
    final accentColor = const Color(0xFF54FF78);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
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
              color: contentColor,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Datos compartidos",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                "• Preferencias Musicales: Sincronización con Spotify para recomendarte conciertos.\n"
                "• Historial de Compras: Solo registramos el historial de las entradas adquiridas (fecha, evento, cantidad).",
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // SECCIÓN 2: TERCEROS (INTEGRACIONES)
          _buildInfoCard(
            title: "Servicios de terceros y Compra",
            icon: Icons.hub_outlined,
            content:
                "• Plataformas de Streaming: Conectamos con tu proveedor (ej. Spotify) solo para leer tus artistas favoritos.\n"
                "• Proceso de Compra: La aplicación te redirige a una plataforma web externa para finalizar el pago. Vibra no almacena ni procesa tu información financiera.",
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // SECCIÓN 3: INTERACCIÓN SOCIAL
          _buildInfoCard(
            title: "Interacción con otros usuarios",
            icon: Icons.people_outline,
            content:
                "• Invitaciones: Al invitar o regalar entradas, compartimos los detalles del evento con los contactos que selecciones.\n"
                "• Privacidad: Tus datos personales no son visibles para otros usuarios salvo que tú lo autorices explícitamente.",
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // SECCIÓN 4: SEGURIDAD Y RGPD
          _buildInfoCard(
            title: "Seguridad y Control (RGPD)",
            icon: Icons.security,
            content:
                "• Encriptación: Toda tu información sensible viaja cifrada mediante protocolos seguros.\n"
                "• Tus derechos: Tienes control total para descargar tus datos o eliminar tu cuenta permanentemente desde los ajustes.",
            isDark: isDark,
          ),

          const SizedBox(height: 30),

          // Nota final de transparencia
          Center(
            child: Text(
              "Tu privacidad es nuestra prioridad en Vibra.",
              style: TextStyle(
                color: textColor.withOpacity(0.5),
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