import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  // Acepta el perfil completo y la fuente de autenticación
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
  String? profileUrl; // URL al perfil externo (Spotify/Google)

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Carga los datos directamente desde los argumentos
  }

  // Lógica de carga modificada para usar los datos pasados en el constructor
  void _loadProfileData() {
    final profile = widget.userProfile;
    setState(() {
      // Extraemos los campos comunes
      displayName = profile['displayName'];
      email = profile['email'];
      imageUrl = profile['photoURL'];
      
      // El campo 'profileUrl' (link externo) solo lo usa Spotify
      profileUrl = profile['profileUrl']; 
    });
  }
  
  // Función para abrir URL de Spotify o Google
  Future<void> _launchProfileUrl() async {
    if (profileUrl != null && profileUrl!.isNotEmpty) {
      final uri = Uri.parse(profileUrl!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // En un entorno de producción, aquí podrías mostrar un SnackBar al usuario
        print("No se pudo abrir el perfil externo: $profileUrl");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = primaryTextColor.withOpacity(0.7);

    final avatarBgColor = isDark ? Colors.white10 : Colors.black12;
    final avatarIconColor = isDark ? Colors.white54 : Colors.black54;

    // Texto y colores dinámicos para la vinculación
    final String serviceName = widget.authSource == 'spotify' ? 'Spotify' : 'Google';
    final Color serviceColor = widget.authSource == 'spotify' ? const Color(0xFF1DB954) : const Color(0xFF4285F4);
    final IconData serviceIcon = widget.authSource == 'spotify' ? Icons.music_note : Icons.link;


    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Cuenta",
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
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

          // AVATAR CON AJUSTE DE ZOOM
          Center(
            child: ClipOval(
              child: Container(
                width: 100,
                height: 100,
                color: avatarBgColor,
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.account_circle,
                        size: 60, color: avatarIconColor),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // INFORMACIÓN DE CUENTA
          Text(
            displayName != null ? "Nombre: $displayName" : "Cargando...",
            style: TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            email != null ? "Correo: $email" : "",
            style: TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
          const SizedBox(height: 20),

          Divider(color: secondaryTextColor),
          const SizedBox(height: 10),

          // ESTADO DE VINCULACIÓN
          Row(
            children: [
              Icon(serviceIcon, color: serviceColor),
              const SizedBox(width: 10),
              Text(
                "Vinculado a $serviceName",
                style: TextStyle(color: secondaryTextColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // LINK AL PERFIL EXTERNO
          if (profileUrl != null && profileUrl!.isNotEmpty)
            TextButton.icon(
              onPressed: _launchProfileUrl,
              icon: Icon(Icons.open_in_new, color: serviceColor),
              label: Text("Abrir perfil en $serviceName", style: TextStyle(color: serviceColor)),
            ),
        ],
      ),
    );
  }
}