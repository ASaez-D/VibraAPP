import 'package:flutter/material.dart';

class CustomizeProfileScreen extends StatelessWidget {
  const CustomizeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Editar Perfil",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Pantalla de Editar Perfil",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
