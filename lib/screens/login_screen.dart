import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/spotify_auth.dart';
import '../services/google_auth.dart';
import '../services/user_data_service.dart';
import '../utils/app_constants.dart';
import 'home_screen.dart';
import 'music_preferences_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Principio: Nombres descriptivos
  bool _isProcessingSpotify = false;
  bool _isProcessingGoogle = false;

  // Instancias de servicios (Dependency Inversion / Single Responsibility)
  final _userDataService = UserDataService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.darkScaffoldBackground,
      body: Center(
        child: SingleChildScrollView(
          // Mejora de usabilidad para pantallas pequeñas
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: AppSpacing.xl),
              _buildTitle(l10n.appTitle),
              const SizedBox(height: 50),

              _buildSpotifyButton(l10n),
              const SizedBox(height: 25),
              _buildDivider(),
              const SizedBox(height: 25),
              _buildGoogleButton(l10n),

              const SizedBox(height: 40),
              _buildTermsText(l10n.loginTerms),
            ],
          ),
        ),
      ),
    );
  }

  // --- MÉTODOS DE UI (Con una sola responsabilidad) ---

  Widget _buildLogo() {
    return SizedBox(
      height: 110,
      width: 110,
      child: Image.asset('assets/vibraLogo.png', fit: BoxFit.cover),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 42,
        fontWeight: AppTypography.fontWeightBlack,
        fontFamily: 'Montserrat',
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(
          child: Divider(color: Colors.white24, thickness: 1, endIndent: 10),
        ),
        Text('o', style: TextStyle(color: Colors.white54, fontSize: 14)),
        Expanded(
          child: Divider(color: Colors.white24, thickness: 1, indent: 10),
        ),
      ],
    );
  }

  Widget _buildTermsText(String terms) {
    return Text(
      terms,
      style: const TextStyle(color: Colors.white38, fontSize: 12, height: 1.4),
      textAlign: TextAlign.center,
    );
  }

  // --- LÓGICA DE NEGOCIO  ---

  Future<void> _handleSpotifyLogin(AppLocalizations l10n) async {
    setState(() => _isProcessingSpotify = true);
    try {
      final profile = await SpotifyAuth().login();
      if (profile == null) return;

      final userMap = _mapSpotifyToUser(profile);
      await _userDataService.saveUserFromMap(userMap);

      if (!mounted) return;
      _navigateToHome(userMap, 'spotify', profile['access_token']);
    } catch (e) {
      _showErrorSnackBar(l10n.loginError(e.toString()));
    } finally {
      if (mounted) setState(() => _isProcessingSpotify = false);
    }
  }

  Future<void> _handleGoogleLogin(AppLocalizations l10n) async {
    setState(() => _isProcessingGoogle = true);
    try {
      final profile = await GoogleAuth().login();
      if (profile == null) return;

      final userMap = _mapGoogleToUser(profile);
      await _userDataService.saveUserFromMap(userMap);

      final prefs = await _userDataService.getUserPreferences();
      final bool hasPreferences =
          prefs != null && prefs['preferencesSet'] == true;

      if (!mounted) return;

      if (hasPreferences) {
        _navigateToHome(userMap, 'google');
      } else {
        _navigateToPreferences(userMap);
      }
    } catch (e) {
      _showErrorSnackBar(l10n.loginError(e.toString()));
    } finally {
      if (mounted) setState(() => _isProcessingGoogle = false);
    }
  }

  // --- MAPPERS (Evitan bloques gigantes de código en los botones) ---

  Map<String, dynamic> _mapSpotifyToUser(Map<String, dynamic> profile) {
    String? photoUrl;
    if (profile['images'] is List && (profile['images'] as List).isNotEmpty) {
      photoUrl = profile['images'][0]['url'];
    }
    return {
      'id': profile['id'],
      'displayName': profile['display_name'] ?? 'Usuario',
      'email': profile['email'],
      'photoURL': photoUrl,
      'profileUrl': profile['external_urls']?['spotify'],
    };
  }

  Map<String, dynamic> _mapGoogleToUser(Map<String, dynamic> profile) {
    return {
      'displayName': profile['displayName'] ?? 'Usuario',
      'email': profile['email'],
      'photoURL': profile['photoURL'],
      'uid': profile['uid'],
    };
  }

  // --- NAVEGACIÓN Y UTILS ---

  void _navigateToHome(
    Map<String, dynamic> profile,
    String source, [
    String? token,
  ]) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          userProfile: profile,
          authSource: source,
          spotifyAccessToken: token,
        ),
      ),
    );
  }

  void _navigateToPreferences(Map<String, dynamic> profile) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MusicPreferencesScreen(userProfile: profile, authSource: 'google'),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // --- BOTONES COMPUESTOS ---

  Widget _buildSpotifyButton(AppLocalizations l10n) {
    return _LoginButton(
      text: _isProcessingSpotify ? l10n.loginLoading : l10n.loginSpotify,
      iconPath: 'assets/spotifyLogo.png',
      gradientColors: [
        Colors.greenAccent.shade700,
        Colors.greenAccent.shade400,
      ],
      textColor: Colors.black,
      onPressed: _isProcessingSpotify ? null : () => _handleSpotifyLogin(l10n),
    );
  }

  Widget _buildGoogleButton(AppLocalizations l10n) {
    return _LoginButton(
      text: _isProcessingGoogle ? l10n.loginLoading : l10n.loginGoogle,
      iconPath: 'assets/googleLogo.png',
      gradientColors: [Colors.blueAccent.shade700, Colors.blueAccent.shade400],
      isGoogle: true,
      onPressed: _isProcessingGoogle ? null : () => _handleGoogleLogin(l10n),
    );
  }
}

// --- COMPONENTE REUTILIZABLE ---

class _LoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final List<Color> gradientColors;
  final VoidCallback? onPressed;
  final Color textColor;
  final bool isGoogle;

  const _LoginButton({
    required this.text,
    required this.iconPath,
    required this.gradientColors,
    this.onPressed,
    this.textColor = Colors.white,
    this.isGoogle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(AppBorders.radiusExtraLarge),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorders.radiusExtraLarge),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(width: AppSpacing.md),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: AppTypography.fontWeightBold,
                fontSize: AppTypography.fontSizeRegular,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 26,
      height: 26,
      decoration: isGoogle
          ? const BoxDecoration(color: Colors.white, shape: BoxShape.circle)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Image.asset(iconPath, fit: BoxFit.contain),
      ),
    );
  }
}
