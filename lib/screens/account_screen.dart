import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Obtener colores del tema para asegurar la adaptación
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = Theme.of(context).colorScheme.onBackground;
    final secondaryTextColor = Theme.of(context).colorScheme.onBackground.withOpacity(0.7);
    
    // El color de fondo y AppBar ahora usan los colores del tema.
    // El color de acento del botón, 0xFF54FF78 (verde brillante), lo mantenemos.
    const Color accentButtonColor = Color(0xFF54FF78);
    
    // Colores del avatar
    final avatarBgColor = isDark ? Colors.white10 : Colors.black12;
    final avatarIconColor = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      // Usar el color de fondo del tema
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        // Usar el color de fondo del AppBar del tema
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Cuenta",
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
          // AVATAR
          CircleAvatar(
            radius: 50,
            backgroundColor: avatarBgColor,
            child: Icon(Icons.account_circle, size: 60, color: avatarIconColor),
          ),
          const SizedBox(height: 20),
          
          // INFORMACIÓN
          Text(
            "Nombre: Kassandra",
            style: TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Correo: kassandra@email.com",
            style: TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Usuario: @kassandra",
            style: TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
          const SizedBox(height: 30),
          
          // BOTÓN
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              // Usar el color de acento fijo (verde)
              backgroundColor: accentButtonColor,
              // El texto siempre debe ser negro sobre este verde brillante
              foregroundColor: Colors.black, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Editar información",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}