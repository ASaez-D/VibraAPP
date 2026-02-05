import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/app_localizations.dart';
import 'login_screen.dart';
import '../models/user_account.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../utils/app_logger.dart';
import '../utils/text_constants.dart';

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

  /// Abre el perfil externo del usuario (Spotify o Google)
  Future<void> _handleLaunchUrl() async {
    if (_user.profileUrl == null) return;

    final uri = Uri.parse(_user.profileUrl!);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception(AppTextConstants.errorFailedToLaunchUrl);
      }
    } catch (error, stackTrace) {
      AppLogger.error('Failed to launch profile URL', error, stackTrace);
      if (mounted)
        _showErrorSnackBar(AppLocalizations.of(context)!.commonError);
    }
  }

  /// Cierra sesión y navega a la pantalla de login
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (error, stackTrace) {
      AppLogger.error('Error during logout', error, stackTrace);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // --- BUILD ---

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = AppTheme(context);
    final authSourceInfo = _AuthSourceInfo(widget.authSource);

    return Scaffold(
      backgroundColor: theme.scaffoldBackground,
      appBar: _buildAppBar(localizations, theme),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxxl),
            _buildAvatar(authSourceInfo.color, theme),
            const SizedBox(height: AppSpacing.xl),
            _buildUserInfo(theme),
            const SizedBox(height: AppSpacing.huge),
            _buildConnectionCard(localizations, theme, authSourceInfo),
            const SizedBox(height: AppSpacing.huge + AppSpacing.md),
            _buildLogoutButton(localizations),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES ---

  PreferredSizeWidget _buildAppBar(
    AppLocalizations localizations,
    AppTheme theme,
  ) {
    return AppBar(
      backgroundColor: theme.scaffoldBackground,
      elevation: 0,
      centerTitle: true,
      title: Text(
        localizations.accountTitle,
        style: GoogleFonts.montserrat(
          color: theme.primaryText,
          fontWeight: AppTypography.fontWeightBold,
          fontSize: 17,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: theme.primaryText,
          size: AppSizes.iconSizeMedium,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAvatar(Color accentColor, AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: accentColor.withValues(alpha: AppColors.opacityHigh + 0.1),
          width: AppBorders.borderWidthThick,
        ),
      ),
      child: CircleAvatar(
        radius: AppSizes.avatarSizeMedium,
        backgroundColor: theme.cardBackground,
        backgroundImage: _user.imageUrl != null
            ? NetworkImage(_user.imageUrl!)
            : null,
        child: _user.imageUrl == null
            ? Icon(
                Icons.person,
                size: AppSizes.iconSizeGiant,
                color: theme.secondaryText,
              )
            : null,
      ),
    );
  }

  Widget _buildUserInfo(AppTheme theme) {
    return Column(
      children: [
        Text(
          _user.displayName,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: theme.primaryText,
            fontSize: AppTypography.fontSizeExtraLarge,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm - 2),
        Text(
          _user.email,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: theme.secondaryText,
            fontSize: AppTypography.fontSizeMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionCard(
    AppLocalizations localizations,
    AppTheme theme,
    _AuthSourceInfo authSourceInfo,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(AppBorders.radiusRound),
        border: Border.all(color: theme.borderColor),
        boxShadow: theme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.accountConnection.toUpperCase(),
            style: GoogleFonts.montserrat(
              color: theme.secondaryText,
              fontSize: 11,
              fontWeight: AppTypography.fontWeightBold,
              letterSpacing: AppTypography.letterSpacingWide,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildSourceIcon(authSourceInfo),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _buildSourceText(localizations, theme, authSourceInfo),
              ),
              Icon(
                Icons.check_circle,
                color: authSourceInfo.color,
                size: AppSizes.iconSizeMedium,
              ),
            ],
          ),
          if (_user.profileUrl != null) ...[
            const SizedBox(height: AppSpacing.xl),
            const Divider(color: Colors.white10),
            const SizedBox(height: 15),
            _buildExternalProfileButton(localizations, authSourceInfo),
          ],
        ],
      ),
    );
  }

  Widget _buildSourceIcon(_AuthSourceInfo authSourceInfo) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: authSourceInfo.color.withValues(alpha: AppColors.opacityMedium),
        borderRadius: BorderRadius.circular(AppBorders.radiusLarge),
      ),
      child: Icon(
        authSourceInfo.icon,
        color: authSourceInfo.color,
        size: AppSizes.iconSizeExtraLarge,
      ),
    );
  }

  Widget _buildSourceText(
    AppLocalizations localizations,
    AppTheme theme,
    _AuthSourceInfo authSourceInfo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          authSourceInfo.name,
          style: GoogleFonts.montserrat(
            color: theme.primaryText,
            fontSize: AppTypography.fontSizeLarge,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
        Text(
          localizations.accountLinked,
          style: GoogleFonts.montserrat(
            color: theme.secondaryText,
            fontSize: AppTypography.fontSizeSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildExternalProfileButton(
    AppLocalizations localizations,
    _AuthSourceInfo authSourceInfo,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: _handleLaunchUrl,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          backgroundColor: authSourceInfo.color.withValues(
            alpha: AppColors.opacityMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorders.radiusMedium),
          ),
        ),
        child: Text(
          localizations.accountOpenProfile(authSourceInfo.name),
          style: GoogleFonts.montserrat(
            color: authSourceInfo.color,
            fontWeight: AppTypography.fontWeightSemiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(AppLocalizations localizations) {
    return TextButton(
      onPressed: _handleLogout,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.errorColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxxl,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorders.radiusCircular),
          side: BorderSide(
            color: AppColors.errorColor.withValues(
              alpha: AppColors.opacityVeryHigh,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.logout, size: AppSizes.iconSizeMedium),
          const SizedBox(width: AppSpacing.md),
          Text(
            localizations.menuLogout,
            style: GoogleFonts.montserrat(
              fontWeight: AppTypography.fontWeightSemiBold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// --- HELPER CLASSES ---

/// Helper class para obtener colores del tema de la pantalla de cuenta
// --- HELPER CLASSES ---

// Helper class removed as it is no longer used. AppTheme is used directly.

class _AuthSourceInfo {
  final String name;
  final Color color;
  final IconData icon;

  _AuthSourceInfo(String source)
    : name = source == 'spotify' ? 'Spotify' : 'Google',
      color = source == 'spotify'
          ? const Color(0xFF1DB954)
          : const Color(0xFF4285F4),
      icon = source == 'spotify' ? Icons.music_note : Icons.g_mobiledata;
}
