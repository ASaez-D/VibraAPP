import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:provider/provider.dart'; 
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart'; 
import '../main.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Color accentColor = const Color(0xFF54FF78);

  bool _generalNotifications = true;
  bool _eventReminders = true;
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
        _generalNotifications = status.isGranted;
      });
    }
  }

  Future<void> _toggleGeneralNotifications(bool newValue) async {
    if (newValue) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        setState(() => _generalNotifications = true);
      } else if (status.isPermanentlyDenied || status.isDenied) {
        final bool shouldOpenSettings = await _showPermissionDialog();
        if (shouldOpenSettings) {
          await openAppSettings();
        }
        final updatedStatus = await Permission.notification.status;
        setState(() => _generalNotifications = updatedStatus.isGranted);
      } else {
        setState(() => _generalNotifications = false);
      }
    } else {
      setState(() => _generalNotifications = false);
    }
  }

  Future<bool> _showPermissionDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.helpSectionSupport),
          content: Text(l10n.loginTerms),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.editProfileCancel, style: TextStyle(color: accentColor)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(l10n.settingsDialogAjustes, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ) ?? false;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.05);
    final leadingIconColor = isDark ? Colors.white : Colors.black;
    final chevronColor = isDark ? Colors.white24 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.menuSettings,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: leadingIconColor, size: 20),
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
                isDark,
                accentColor,
                value: _generalNotifications,
                onChanged: _toggleGeneralNotifications,
              ),
              _divider(isDark),
              _switchTile(
                Icons.event_available,
                l10n.settingsEventReminders,
                isDark,
                accentColor,
                value: _eventReminders,
                onChanged: (newValue) {
                  setState(() => _eventReminders = newValue);
                },
              ),
              _divider(isDark),
              _switchTile(
                Icons.new_releases,
                l10n.settingsTicketReleases,
                isDark,
                accentColor,
                value: _ticketReleases,
                onChanged: (newValue) {
                  setState(() => _ticketReleases = newValue);
                },
              ),
            ],
            cardColor: cardColor,
          ),
          const SizedBox(height: 28),

          _buildHeader(l10n.settingsHeaderPrivacy, isDark),
          _buildCard(
            children: [
              _linkTile(context, Icons.location_on, l10n.settingsLocationPermissions, isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.shield, l10n.settingsSharedData, isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.download, l10n.settingsDownloadData, isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.delete_forever, l10n.settingsDeleteAccount, isDark, chevronColor),
            ],
            cardColor: cardColor,
          ),
          const SizedBox(height: 28),

          _buildHeader(l10n.settingsHeaderPrefs, isDark),
          ValueListenableBuilder<double>(
            valueListenable: textScaleNotifier,
            builder: (context, scale, child) {
              return _buildCard(
                children: [
                  _languageSelectorTile(context, l10n, isDark, chevronColor),
                  _divider(isDark),
                  _themeSwitcherTile(context, isDark, accentColor, l10n),
                  _divider(isDark),
                  _switchTile(
                    Icons.text_fields,
                    l10n.settingsLargeText,
                    isDark,
                    accentColor,
                    value: _isLargeTextActive(),
                    onChanged: _toggleLargeText,
                  ),
                ],
                cardColor: cardColor,
              );
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _languageSelectorTile(BuildContext context, AppLocalizations l10n, bool isDark, Color chevronColor) {
    final contentColor = isDark ? Colors.white : Colors.black;
    final langProvider = Provider.of<LanguageProvider>(context);
    final String currentLangLabel = _getLanguageName(langProvider.locale.languageCode);
    
    return InkWell(
      onTap: () => _showLanguagePicker(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.language, color: contentColor.withOpacity(0.95), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.settingsLanguage, 
                style: TextStyle(color: contentColor, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              currentLangLabel,
              style: TextStyle(color: contentColor.withOpacity(0.5), fontSize: 14),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: chevronColor, size: 22),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en': return "English";
      case 'fr': return "Français";
      case 'pt': return "Português";
      case 'ca': return "Català";
      case 'de': return "Deutsch";
      default: return "Español";
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(l10n.settingsLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _languageListTile(BuildContext context, LanguageProvider provider, String name, String code) {
    final isSelected = provider.locale.languageCode == code;
    return ListTile(
      title: Text(name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? Icon(Icons.check_circle, color: accentColor) : null,
      onTap: () {
        provider.setLocale(Locale(code));
        Navigator.pop(context);
      },
    );
  }

  Widget _themeSwitcherTile(BuildContext context, bool isDark, Color accentColor, AppLocalizations l10n) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final bool isCurrentlyDark = mode == ThemeMode.dark || (mode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(
            children: [
              Icon(isCurrentlyDark ? Icons.dark_mode : Icons.light_mode,
                  color: isCurrentlyDark ? Colors.white.withOpacity(0.95) : Colors.black87,
                  size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.settingsThemeMode,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: isCurrentlyDark,
                  onChanged: (newValue) {
                    themeNotifier.value = newValue ? ThemeMode.dark : ThemeMode.light;
                  },
                  activeColor: accentColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children, required Color cardColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: cardColor,
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
      height: 1,
      thickness: 0.4,
      indent: 50,
      endIndent: 14,
    );
  }

  Widget _linkTile(BuildContext context, IconData icon, String text, bool isDark, Color chevronColor) {
    final contentColor = isDark ? Colors.white : Colors.black;
    return InkWell(
      onTap: () {
        if (text == AppLocalizations.of(context)!.settingsLocationPermissions) {
          AppSettings.openAppSettings(type: AppSettingsType.location);
        } else if (text == AppLocalizations.of(context)!.settingsSharedData) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SharedDataScreen()));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: contentColor.withOpacity(0.95), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: contentColor, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: chevronColor, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(IconData icon, String text, bool isDark, Color accentColor, {required bool value, required ValueChanged<bool> onChanged}) {
    final contentColor = isDark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: contentColor.withOpacity(0.95), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: contentColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class SharedDataScreen extends StatelessWidget {
  const SharedDataScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSharedData)),
      body: const Center(child: Text("Privacy Info")),
    );
  }
}