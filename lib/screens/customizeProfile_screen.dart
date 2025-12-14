import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomizeProfileScreen extends StatefulWidget {
  const CustomizeProfileScreen({super.key});

  @override
  State<CustomizeProfileScreen> createState() => _CustomizeProfileScreenState();
}

class _CustomizeProfileScreenState extends State<CustomizeProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  String? _userImageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _pickImage() {
    // Aquí se implementaría la selección de imagen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Funcionalidad de subir imagen no implementada"))
    );
  }

  void _saveChanges() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil actualizado correctamente"))
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color accentColor = Colors.greenAccent.shade700; // Mismo verde que LoginScreen
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7);
    final Color cardBg = isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
    final Color primaryText = isDarkMode ? Colors.white : const Color(0xFF222222);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
        title: Text("Editar perfil", style: TextStyle(color: primaryText, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: cardBg,
                  backgroundImage: _userImageUrl != null ? NetworkImage(_userImageUrl!) : null,
                  child: _userImageUrl == null ? Icon(Icons.person, color: primaryText, size: 50) : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _pickImage,
              child: Text("Cambiar foto", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nombre",
                filled: true,
                fillColor: cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: "Apodo",
                filled: true,
                fillColor: cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Guardar", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text("Cancelar", style: TextStyle(color: primaryText, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
