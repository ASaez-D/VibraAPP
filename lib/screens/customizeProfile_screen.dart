import 'dart:ui';
import 'package:flutter/material.dart';

class CustomizeProfileScreen extends StatelessWidget {
  // Mantenemos accentColor ya que es el color de marca (verde)
  final Color accentColor = const Color(0xFF54FF78); 
  // ELIMINADO: final Color backgroundColor = const Color(0xFF0C0C0C);

  const CustomizeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Obtener el estado del tema y los colores dinámicos
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Colores base dinámicos
    final mainTextColor = isDark ? Colors.white : Colors.black;
    final iconColor = mainTextColor;
    
    // Color de fondo del Scaffold (se usa el del tema global: blanco o negro)
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      appBar: AppBar(
        // ELIMINADO: backgroundColor: backgroundColor
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Editar perfil",
          style: TextStyle(
            // ELIMINADO: Colors.white
            color: mainTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          // ELIMINADO: Colors.white
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [

          const SizedBox(height: 20),

          // FOTO DE PERFIL
          Center(
            child: Column(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    // ELIMINADO: Colors.white12
                    color: isDark ? Colors.white12 : Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                    // Nota: La imagen de placeholder puede necesitar un ajuste si es oscura
                    image: const DecorationImage(
                      image: AssetImage("assets/profile_placeholder.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Cambiar foto",
                    style: TextStyle(
                      // El color de marca (accentColor) se mantiene
                      color: accentColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 25),

          // --- CAMPOS ---
          // Pasamos 'isDark' a la función auxiliar
          _buildField(title: "Nombre", placeholder: "Tu nombre", isDark: isDark),
          _buildField(title: "Usuario", placeholder: "@usuario", isDark: isDark),
          _buildField(title: "Correo electrónico", placeholder: "correo@example.com", isDark: isDark),
          _buildField(title: "Fecha de nacimiento", placeholder: "DD / MM / AAAA", isDark: isDark),

          const SizedBox(height: 30),

          // BOTÓN GUARDAR
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                // El color de marca (accentColor) se mantiene
                backgroundColor: accentColor,
                // El texto en el botón de acento casi siempre es negro/oscuro
                foregroundColor: Colors.black, 
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Guardar cambios",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // INPUT FIELD iOS AESTHETIC - ADAPTADO
  // ------------------------------------------------------------
  // Se añade 'isDark' como argumento
  Widget _buildField({required String title, required String placeholder, required bool isDark}) {
    
    // Colores dinámicos del campo de texto
    final titleColor = isDark ? Colors.white70 : Colors.black54;
    final containerColor = isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.05);
    final borderColor = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.1);
    final placeholderColor = isDark ? Colors.white54 : Colors.black45;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            // ELIMINADO: Colors.white70
            color: titleColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            // El efecto de desenfoque se mantiene, ya que es un efecto visual independiente del color
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                // ELIMINADO: Colors.white.withOpacity(0.03)
                color: containerColor,
                borderRadius: BorderRadius.circular(14),
                // ELIMINADO: Colors.white.withOpacity(0.06)
                border: Border.all(color: borderColor),
              ),
              child: Text(
                placeholder,
                style: TextStyle(
                  // ELIMINADO: Colors.white54
                  color: placeholderColor,
                  fontSize: 14.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}