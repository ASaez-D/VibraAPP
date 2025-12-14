import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? spotifyName;
  String? spotifyEmail;
  String? spotifyImageUrl;
  String? spotifyProfileUrl; // URL al perfil de Spotify

  @override
  void initState() {
    super.initState();
    _loadSpotifyProfile();
  }

  Future<void> _loadSpotifyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('spotify_token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final profile = json.decode(response.body);
        setState(() {
          spotifyName = profile['display_name'];
          spotifyEmail = profile['email'];
          spotifyProfileUrl = profile['external_urls']?['spotify']; // link al perfil
          spotifyImageUrl = (profile['images'] as List).isNotEmpty
              ? profile['images'][0]['url']
              : null;
        });
      }
    }
  }

  // Función para abrir URL de Spotify
  Future<void> _launchSpotify() async {
    if (spotifyProfileUrl != null) {
      final uri = Uri.parse(spotifyProfileUrl!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        print("No se pudo abrir Spotify");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = Theme.of(context).colorScheme.onBackground;
    final secondaryTextColor =
        Theme.of(context).colorScheme.onBackground.withOpacity(0.7);

    final avatarBgColor = isDark ? Colors.white10 : Colors.black12;
    final avatarIconColor = isDark ? Colors.white54 : Colors.black54;

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
                child: spotifyImageUrl != null
                    ? Image.network(
                        spotifyImageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.account_circle,
                        size: 60, color: avatarIconColor),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // INFORMACIÓN DE SPOTIFY
          Text(
            spotifyName != null ? "Nombre: $spotifyName" : "Cargando...",
            style: TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            spotifyEmail != null ? "Correo: $spotifyEmail" : "",
            style: TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
          const SizedBox(height: 20),

          Divider(color: secondaryTextColor),
          const SizedBox(height: 10),

          // ESTADO DE VINCULACIÓN
          Row(
            children: [
              Icon(Icons.music_note, color: secondaryTextColor),
              const SizedBox(width: 10),
              Text(
                "Vinculado a Spotify",
                style: TextStyle(color: secondaryTextColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // LINK A SPOTIFY
          if (spotifyProfileUrl != null)
            TextButton.icon(
              onPressed: _launchSpotify,
              icon: const Icon(Icons.open_in_new),
              label: const Text("Abrir perfil en Spotify"),
            ),
        ],
      ),
    );
  }
}
