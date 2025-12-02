import 'dart:ui';
import 'package:flutter/material.dart';

class CustomizeProfileScreen extends StatelessWidget {
  final Color accentColor = const Color(0xFF54FF78);
  final Color backgroundColor = const Color(0xFF0C0C0C);

  const CustomizeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Editar perfil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
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
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(20),
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
          _buildField(title: "Nombre", placeholder: "Tu nombre"),
          _buildField(title: "Usuario", placeholder: "@usuario"),
          _buildField(title: "Correo electrónico", placeholder: "correo@example.com"),
          _buildField(title: "Fecha de nacimiento", placeholder: "DD / MM / AAAA"),

          const SizedBox(height: 30),

          // BOTÓN GUARDAR
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
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
  // INPUT FIELD iOS AESTHETIC
  // ------------------------------------------------------------
  Widget _buildField({required String title, required String placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Text(
                placeholder,
                style: const TextStyle(
                  color: Colors.white54,
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
