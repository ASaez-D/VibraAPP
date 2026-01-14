import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import 'login_screen.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final String authSource;

  const AccountScreen({
    super.key,
    required this.userProfile,
    required this.authSource,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? displayName;
  String? email;
  String? imageUrl;
  String? profileUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final profile = widget.userProfile;
    setState(() {
      displayName = profile['displayName'] ?? 'Usuario Vibra';
      email = profile['email'] ?? 'correo@oculto.com';
      imageUrl = profile['photoURL'];
      profileUrl = profile['profileUrl']; 
    });
  }
  
  Future<void> _launchProfileUrl() async {
    if (profileUrl != null && profileUrl!.isNotEmpty) {
      final uri = Uri.parse(profileUrl!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          // Usamos un texto genérico de error si falla
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(AppLocalizations.of(context)!.commonError)),
          );
        }
      }
    }
  }

  Future<void> _logout() async {
    try {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
        }
    } catch (e) {
        print("Error saliendo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. Acceso a traducciones
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Paleta de colores VIBRA
    final textColor = isDark ? Colors.white : const Color(0xFF222222);
    final secondaryText = isDark ? Colors.white54 : Colors.grey[600];
    final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final scaffoldBg = isDark ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7);
    final borderColor = isDark ? Colors.white10 : Colors.grey.shade300;

    // Configuración del servicio
    final bool isSpotify = widget.authSource == 'spotify';
    final String serviceName = isSpotify ? 'Spotify' : 'Google';
    final Color serviceColor = isSpotify ? const Color(0xFF1DB954) : const Color(0xFF4285F4);
    final IconData serviceIcon = isSpotify ? Icons.music_note : Icons.g_mobiledata;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.accountTitle, // "Mi Cuenta"
          style: GoogleFonts.montserrat(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // --- 1. AVATAR ---
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: serviceColor.withOpacity(0.5), width: 2),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: cardBg,
                backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? NetworkImage(imageUrl!)
                    : null,
                child: (imageUrl == null || imageUrl!.isEmpty)
                    ? Icon(Icons.person, size: 50, color: secondaryText)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            // --- 2. TEXTOS ---
            Text(
              displayName!,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              email!,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 40),

            // --- 3. TARJETA DE VINCULACIÓN ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor),
                boxShadow: isDark 
                  ? [] 
                  : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accountConnection, // "CONEXIÓN ACTIVA"
                    style: GoogleFonts.montserrat(
                      color: secondaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: serviceColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(serviceIcon, color: serviceColor, size: 26),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceName,
                              style: GoogleFonts.montserrat(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.accountLinked, // "Cuenta vinculada correctamente"
                              style: GoogleFonts.montserrat(
                                color: secondaryText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.check_circle, color: serviceColor, size: 20),
                    ],
                  ),
                  
                  // Botón Perfil Externo
                  if (profileUrl != null && profileUrl!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _launchProfileUrl,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: serviceColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          l10n.accountOpenProfile(serviceName), // "Abrir perfil en Spotify"
                          style: GoogleFonts.montserrat(
                            color: serviceColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),

            const SizedBox(height: 50),

            // --- 4. BOTÓN CERRAR SESIÓN ---
            TextButton(
              onPressed: _logout,
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.3))
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    l10n.menuLogout, // "Cerrar Sesión"
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}