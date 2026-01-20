import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';
import 'login_screen.dart';
import '../models/user_account.dart';

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
  late UserAccount _user;
  
  @override
  void initState() {
    super.initState();
    _user = UserAccount.fromMap(widget.userProfile);
  }

  // --- LÓGICA ---

  Future<void> _handleLaunchUrl() async {
    if (_user.profileUrl == null) return;
    final uri = Uri.parse(_user.profileUrl!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) _showErrorSnackBar(AppLocalizations.of(context)!.commonError);
    }
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint("Error saliendo: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // --- BUILD ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final theme = _AccountScreenTheme(isDark);
    final source = _AuthSourceInfo(widget.authSource);

    return Scaffold(
      backgroundColor: theme.scaffoldBg,
      appBar: _buildAppBar(l10n, theme),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildAvatar(source.color, theme.cardBg, theme.secondaryText),
            const SizedBox(height: 20),
            _buildUserInfo(theme),
            const SizedBox(height: 40),
            _buildConnectionCard(l10n, theme, source),
            const SizedBox(height: 50),
            _buildLogoutButton(l10n),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES ---

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n, _AccountScreenTheme theme) {
    return AppBar(
      backgroundColor: theme.scaffoldBg,
      elevation: 0,
      centerTitle: true,
      title: Text(l10n.accountTitle, 
        style: GoogleFonts.montserrat(color: theme.textColor, fontWeight: FontWeight.w700, fontSize: 17)),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: theme.textColor, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAvatar(Color accentColor, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Cambio: withOpacity -> withValues
        border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 2),
      ),
      child: CircleAvatar(
        radius: 55,
        backgroundColor: bg,
        backgroundImage: _user.imageUrl != null ? NetworkImage(_user.imageUrl!) : null,
        child: _user.imageUrl == null 
          ? Icon(Icons.person, size: 50, color: iconColor) 
          : null,
      ),
    );
  }

  Widget _buildUserInfo(_AccountScreenTheme theme) {
    return Column(
      children: [
        Text(_user.displayName,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(color: theme.textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(_user.email,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(color: theme.secondaryText, fontSize: 14)),
      ],
    );
  }

  Widget _buildConnectionCard(AppLocalizations l10n, _AccountScreenTheme theme, _AuthSourceInfo source) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.borderColor),
        boxShadow: theme.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.accountConnection.toUpperCase(),
            style: GoogleFonts.montserrat(color: theme.secondaryText, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildSourceIcon(source),
              const SizedBox(width: 16),
              Expanded(child: _buildSourceText(l10n, theme, source)),
              Icon(Icons.check_circle, color: source.color, size: 20),
            ],
          ),
          if (_user.profileUrl != null) ...[
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 15),
            _buildExternalProfileButton(l10n, source),
          ]
        ],
      ),
    );
  }

  Widget _buildSourceIcon(_AuthSourceInfo source) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Cambio: withOpacity -> withValues
        color: source.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(source.icon, color: source.color, size: 26),
    );
  }

  Widget _buildSourceText(AppLocalizations l10n, _AccountScreenTheme theme, _AuthSourceInfo source) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(source.name, 
          style: GoogleFonts.montserrat(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(l10n.accountLinked, 
          style: GoogleFonts.montserrat(color: theme.secondaryText, fontSize: 12)),
      ],
    );
  }

  Widget _buildExternalProfileButton(AppLocalizations l10n, _AuthSourceInfo source) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: _handleLaunchUrl,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          // Cambio: withOpacity -> withValues
          backgroundColor: source.color.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(l10n.accountOpenProfile(source.name),
          style: GoogleFonts.montserrat(color: source.color, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildLogoutButton(AppLocalizations l10n) {
    return TextButton(
      onPressed: _handleLogout,
      style: TextButton.styleFrom(
        foregroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          // Cambio: withOpacity -> withValues
          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3))
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.logout, size: 20),
          const SizedBox(width: 10),
          Text(l10n.menuLogout, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 15)),
        ],
      ),
    );
  }
}

// --- HELPER CLASSES ---

class _AccountScreenTheme {
  final Color textColor;
  final Color secondaryText;
  final Color cardBg;
  final Color scaffoldBg;
  final Color borderColor;
  final List<BoxShadow> shadow;

  _AccountScreenTheme(bool isDark)
      : textColor = isDark ? Colors.white : const Color(0xFF222222),
        secondaryText = isDark ? Colors.white54 : Colors.grey[600]!,
        cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white,
        scaffoldBg = isDark ? const Color(0xFF0E0E0E) : const Color(0xFFF7F7F7),
        borderColor = isDark ? Colors.white10 : Colors.grey.shade300,
        // Cambio: withOpacity -> withValues
        shadow = isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))];
}

class _AuthSourceInfo {
  final String name;
  final Color color;
  final IconData icon;

  _AuthSourceInfo(String source)
      : name = source == 'spotify' ? 'Spotify' : 'Google',
        color = source == 'spotify' ? const Color(0xFF1DB954) : const Color(0xFF4285F4),
        icon = source == 'spotify' ? Icons.music_note : Icons.g_mobiledata;
}