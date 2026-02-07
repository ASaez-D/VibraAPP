import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/login_screen.dart';
import '../screens/permission_manager_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../main.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final Color accentColor = const Color(0xFF54FF78); // Replaced by AppColors.primaryAccent

  bool _generalNotifications = false;
  bool _eventReminders = false;
  bool _ticketReleases = false;

  @override
  void initState() {
    super.initState();
    _checkInitialNotificationStatus();
  }

  Future<void> _checkInitialNotificationStatus() async {
    final status = await Permission.notification.status;
    if (mounted) {
      setState(() {
        if (status.isGranted) {
          _generalNotifications = true;
        }
      });
    }
  }

  // --- LÓGICA DE NOTIFICACIONES ---
  void _handleNotificationToggle(String type, bool currentValue) {
    if (currentValue) {
      setState(() {
        if (type == 'general') _generalNotifications = false;
        if (type == 'reminders') _eventReminders = false;
        if (type == 'tickets') _ticketReleases = false;
      });
      return;
    }
    _showNotificationPreviewSheet(type);
  }

  void _showNotificationPreviewSheet(String type) {
    final l10n = AppLocalizations.of(context)!;
    final theme = AppTheme(context);
    // final isDark = Theme.of(context).brightness == Brightness.dark; // Unused

    String title = "";
    String body = "";
    IconData icon = Icons.notifications;
    String time = l10n.timeNow;

    if (type == 'general') {
      title = l10n.notifGeneralTitle;
      body = l10n.notifGeneralBody;
      icon = Icons.info_outline;
      time = "10:30";
    } else if (type == 'reminders') {
      title = l10n.notifReminderTitle;
      body = l10n.notifReminderBody;
      icon = Icons.event_available;
      time = l10n.time5min;
    } else if (type == 'tickets') {
      title = l10n.notifTicketsTitle;
      body = l10n.notifTicketsBody;
      icon = Icons.confirmation_number_outlined;
      time = l10n.time1min;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: theme.scaffoldBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            border: Border(top: BorderSide(color: theme.borderColor, width: 1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                l10n.notifPreviewTitle,
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: AppTypography.fontWeightBold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.notifPreviewBody,
                style: TextStyle(
                  color: theme.secondaryText,
                  fontSize: AppTypography.fontSizeRegular,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(AppBorders.radiusLarge),
                  boxShadow: theme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.music_note,
                            size: 12,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          "VIBRA",
                          style: TextStyle(
                            color: theme.primaryText.withValues(alpha: 0.7),
                            fontSize: 11,
                            fontWeight: AppTypography.fontWeightBold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          time,
                          style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: theme.primaryText,
                                  fontWeight: AppTypography.fontWeightBold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                body,
                                style: TextStyle(
                                  color: theme.secondaryText,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: theme.isDarkMode
                                ? Colors.white10
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: theme.primaryText, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        l10n.dialogCancel,
                        style: TextStyle(color: theme.secondaryText),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _requestPermissionAndEnable(type);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.btnActivate,
                        style: const TextStyle(
                          fontWeight: AppTypography.fontWeightBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _requestPermissionAndEnable(String type) async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      setState(() {
        if (type == 'general') _generalNotifications = true;
        if (type == 'reminders') _eventReminders = true;
        if (type == 'tickets') _ticketReleases = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Notificaciones activadas"),
            backgroundColor: AppColors.primaryAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(20),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }

  Future<bool> _showPermissionDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(l10n.dialogPermissionTitle),
              content: Text(l10n.dialogPermissionContent),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    l10n.dialogCancel,
                    style: const TextStyle(color: AppColors.primaryAccent),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(
                    l10n.dialogSettingsBtn,
                    style: const TextStyle(
                      color: AppColors.primaryAccent,
                      fontWeight: AppTypography.fontWeightBold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    openAppSettings();
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _handleDownloadData() async {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primaryAccent),
              const SizedBox(height: 16),
              Text(
                l10n.dialogGenerating,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    try {
      await Future.delayed(const Duration(seconds: 1));
      final Map<String, dynamic> userData = {
        "app": "Vibra",
        "date": DateTime.now().toString(),
      };
      final String jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(userData);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/vibra_data.json');
      await file.writeAsString(jsonString);
      if (mounted) Navigator.pop(context);
      await Share.shareXFiles([XFile(file.path)], text: l10n.shareDataText);
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.dialogError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          title: Text(
            l10n.dialogDeleteTitle,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            l10n.dialogDeleteBody,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                l10n.dialogCancel,
                style: const TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(
                l10n.dialogDeleteBtn,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (confirm != true || !mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      ),
    );
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        await user.delete();
        if (mounted) {
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (r) => false,
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.snackDeleteSuccess)));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorDialog(
          e.code == 'requires-recent-login'
              ? l10n.snackDeleteReauth
              : l10n.dialogError,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorDialog(l10n.dialogError);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  bool _isLargeTextActive() {
    return textScaleNotifier.value > 1.0;
  }

  void _toggleLargeText(bool newValue) {
    textScaleNotifier.value = newValue ? 1.3 : 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = AppTheme(context);
    final isDark = theme.isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.menuSettings,
          style: TextStyle(
            color: theme.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.primaryText,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        children: [
          _buildHeader(l10n.settingsHeaderNotifications, isDark),
          _buildCard(
            children: [
              _switchTile(
                Icons.notifications,
                l10n.settingsGeneralNotifications,
                theme,
                value: _generalNotifications,
                onChanged: (val) =>
                    _handleNotificationToggle('general', _generalNotifications),
              ),
              _divider(theme),
              _switchTile(
                Icons.event_available,
                l10n.settingsEventReminders,
                theme,
                value: _eventReminders,
                onChanged: (val) =>
                    _handleNotificationToggle('reminders', _eventReminders),
              ),
              _divider(theme),
              _switchTile(
                Icons.new_releases,
                l10n.settingsTicketReleases,
                theme,
                value: _ticketReleases,
                onChanged: (val) =>
                    _handleNotificationToggle('tickets', _ticketReleases),
              ),
            ],
            theme: theme,
          ),
          const SizedBox(height: 28),
          _buildHeader(l10n.settingsHeaderPrivacy, isDark),
          _buildCard(
            children: [
              _linkTile(
                context,
                Icons.location_on,
                l10n.settingsLocationPermissions,
                theme,
              ),
              _divider(theme),
              _linkTile(context, Icons.shield, l10n.settingsSharedData, theme),
              _divider(theme),
              _linkTile(
                context,
                Icons.download,
                l10n.settingsDownloadData,
                theme,
              ),
              _divider(theme),
              _linkTile(
                context,
                Icons.delete_forever,
                l10n.settingsDeleteAccount,
                theme,
              ),
            ],
            theme: theme,
          ),
          const SizedBox(height: 28),
          _buildHeader(l10n.settingsHeaderPrefs, isDark),
          ValueListenableBuilder<double>(
            valueListenable: textScaleNotifier,
            builder: (context, scale, child) {
              return _buildCard(
                children: [
                  _languageSelectorTile(context, l10n, theme),
                  _divider(theme),
                  _themeSwitcherTile(context, theme, l10n),
                  _divider(theme),
                  _switchTile(
                    Icons.text_fields,
                    l10n.settingsLargeText,
                    theme,
                    value: _isLargeTextActive(),
                    onChanged: _toggleLargeText,
                  ),
                ],
                theme: theme,
              );
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildHeader(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.6)
              : Colors.black.withValues(alpha: 0.6),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children, required AppTheme theme}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.cardBackground,
        border: Border.all(color: theme.borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(AppTheme theme) {
    return Divider(
      color: theme.dividerColor,
      height: 1,
      thickness: 0.4,
      indent: 50,
      endIndent: 14,
    );
  }

  Widget _switchTile(
    IconData icon,
    String text,
    AppTheme theme, {
    required bool value,
    required Function(bool) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: theme.primaryText.withValues(alpha: 0.95),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Transform.scale(
              scale: 0.85,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primaryAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linkTile(
    BuildContext context,
    IconData icon,
    String text,
    AppTheme theme,
  ) {
    return InkWell(
      onTap: () {
        if (text == AppLocalizations.of(context)!.settingsLocationPermissions)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PermissionManagerScreen(),
            ),
          );
        else if (text == AppLocalizations.of(context)!.settingsSharedData)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SharedDataScreen()),
          );
        else if (text == AppLocalizations.of(context)!.settingsDownloadData)
          _handleDownloadData();
        else if (text == AppLocalizations.of(context)!.settingsDeleteAccount)
          _handleDeleteAccount();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: theme.primaryText.withValues(alpha: 0.95),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              text == AppLocalizations.of(context)!.settingsDownloadData
                  ? Icons.download_rounded
                  : Icons.chevron_right_rounded,
              color: theme.secondaryText,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageSelectorTile(
    BuildContext context,
    AppLocalizations l10n,
    AppTheme theme,
  ) {
    final langProvider = Provider.of<LanguageProvider>(context);
    return InkWell(
      onTap: () => _showLanguagePicker(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.language,
              color: theme.primaryText.withValues(alpha: 0.95),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.settingsLanguage,
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              langProvider.locale.languageCode.toUpperCase(),
              style: TextStyle(color: theme.secondaryText, fontSize: 14),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.secondaryText,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  l10n.settingsLanguage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _languageListTile(context, langProvider, "Español", 'es'),
              _languageListTile(context, langProvider, "English", 'en'),
              _languageListTile(context, langProvider, "Français", 'fr'),
              _languageListTile(context, langProvider, "Português", 'pt'),
              _languageListTile(context, langProvider, "Català", 'ca'),
              _languageListTile(context, langProvider, "Deutsch", 'de'),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _languageListTile(
    BuildContext context,
    LanguageProvider provider,
    String name,
    String code,
  ) {
    final isSelected = provider.locale.languageCode == code;
    final accentColor = const Color(0xFF54FF78);
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: accentColor)
          : null,
      onTap: () {
        provider.setLocale(Locale(code));
        Navigator.pop(context);
      },
    );
  }

  Widget _themeSwitcherTile(
    BuildContext context,
    AppTheme theme,
    AppLocalizations l10n,
  ) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final bool isCurrentlyDark =
            mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(
            children: [
              Icon(
                isCurrentlyDark ? Icons.dark_mode : Icons.light_mode,
                color: theme.primaryText.withValues(alpha: 0.95),
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.settingsThemeMode,
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: isCurrentlyDark,
                  onChanged: (v) => themeNotifier.value = v
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  activeColor: AppColors.primaryAccent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SharedDataScreen extends StatelessWidget {
  const SharedDataScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.05);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          l10n.settingsSharedData,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(color: textColor),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 48,
                  color: textColor.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.privacyTransparencyTitle,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.privacyTransparencyDesc,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _infoTile(
            Icons.person_outline,
            l10n.privacyProfile,
            l10n.privacyProfileDesc,
            isDark,
          ),
          _infoTile(
            Icons.location_on_outlined,
            l10n.privacyLocation,
            l10n.privacyLocationDesc,
            isDark,
          ),
          _infoTile(
            Icons.analytics_outlined,
            l10n.privacyAnalytics,
            l10n.privacyAnalyticsDesc,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white : Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
