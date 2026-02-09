import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../screens/settings_screen.dart';
import '../screens/help_screen.dart';
import '../screens/account_screen.dart';

import '../screens/login_screen.dart';
import '../screens/region_screen.dart';
import '../widgets/song_recognition_dialog.dart';
import '../screens/events_map_screen.dart';
import '../services/auth_services.dart';
import '../services/spotify_auth.dart';

class HomeDrawer extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final String authSource;
  final String currentCountryCode;
  final String? currentCity;
  // Callback para avisar al Home que la región cambió
  final Function(String code, String? city) onRegionChanged;

  const HomeDrawer({
    super.key,
    required this.userProfile,
    required this.authSource,
    required this.currentCountryCode,
    required this.currentCity,
    required this.onRegionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDarkMode ? Colors.white : Colors.black;
    final accentColor = Colors.greenAccent;
    final scaffoldBg = isDarkMode
        ? const Color(0xFF0E0E0E)
        : const Color(0xFFF7F7F7);
    final dividerColor = isDarkMode ? Colors.white12 : Colors.grey.shade300;

    final String displayName = userProfile['displayName'] ?? 'Usuario';
    final String photoUrl = userProfile['photoURL'] ?? '';
    final bool isLinked = photoUrl.isNotEmpty;
    final bool isSpotify = authSource == 'spotify';
    final Color serviceColor = isSpotify
        ? const Color(0xFF1DB954)
        : const Color(0xFF4285F4);
    final IconData fallbackIcon = isSpotify
        ? Icons.music_note
        : Icons.account_circle;

    return Drawer(
      backgroundColor: scaffoldBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: serviceColor,
                          backgroundImage: isLinked
                              ? NetworkImage(photoUrl)
                              : null,
                          child: !isLinked
                              ? Icon(fallbackIcon, color: primaryText, size: 20)
                              : null,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),

            _menuItem(
              context,
              l10n.menuAccount,
              Icons.account_circle,
              AccountScreen(userProfile: userProfile, authSource: authSource),
            ),

            // --- LÓGICA DE REGIÓN ---
            ListTile(
              leading: Icon(Icons.public, color: primaryText.withOpacity(0.8)),
              title: Text("Región", style: TextStyle(color: primaryText)),
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  currentCity != null
                      ? "$currentCountryCode - $currentCity"
                      : currentCountryCode,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RegionScreen(currentCountryCode: currentCountryCode),
                  ),
                );

                if (result != null && result is Map) {
                  onRegionChanged(result['code'], result['city']);
                }
              },
            ),

            ListTile(
              leading: Icon(
                Icons.music_note_rounded,
                color: primaryText.withOpacity(0.8),
              ),
              title: Text(
                "Identificar Canción",
                style: TextStyle(color: primaryText),
              ),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (_) => const SongRecognitionDialog(),
                );
              },
            ),

            _menuItem(
              context,
              l10n.nearbyEventsTitle,
              Icons.map_outlined,
              const EventsMapScreen(),
            ),

            _menuItem(
              context,
              l10n.menuSettings,
              Icons.settings,
              const SettingsScreen(),
            ),
            _menuItem(
              context,
              l10n.menuHelp,
              Icons.help_outline,
              const HelpScreen(),
            ),

            const Spacer(),
            Divider(color: dividerColor),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                l10n.menuLogout,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                
                // Cerrar sesión en servicios
                await AuthServices().signOut();
                await SpotifyAuth.logout();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDarkMode ? Colors.white : Colors.black;
    return ListTile(
      leading: Icon(icon, color: primaryText.withOpacity(0.8)),
      title: Text(title, style: TextStyle(color: primaryText)),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}
