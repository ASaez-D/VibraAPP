import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:provider/provider.dart'; // <--- 1. IMPORTANTE
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart'; // <--- 2. IMPORTANTE
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
              child: Text("Ajustes", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
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
          // USAMOS l10n PARA LOS HEADERS
          _buildHeader("Notificaciones", isDark), 
          _buildCard(
            children: [
              _switchTile(
                Icons.notifications,
                "Notificaciones generales",
                isDark,
                accentColor,
                value: _generalNotifications,
                onChanged: _toggleGeneralNotifications,
              ),
              _divider(isDark),
              _switchTile(
                Icons.event_available,
                "Recordatorios de eventos",
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
                "Lanzamiento de entradas",
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

          _buildHeader("Privacidad", isDark),
          _buildCard(
            children: [
              _linkTile(context, Icons.location_on, "Permisos de ubicación", isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.shield, "Datos compartidos", isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.download, "Descargar mis datos", isDark, chevronColor),
              _divider(isDark),
              _linkTile(context, Icons.delete_forever, "Eliminar cuenta", isDark, chevronColor),
            ],
            cardColor: cardColor,
          ),
          const SizedBox(height: 28),

          _buildHeader("Preferencias", isDark),
          ValueListenableBuilder<double>(
            valueListenable: textScaleNotifier,
            builder: (context, scale, child) {
              return _buildCard(
                children: [
                  _languageSelectorTile(context, l10n, isDark, chevronColor),
                  _divider(isDark),
                  _themeSwitcherTile(context, isDark, accentColor),
                  _divider(isDark),
                  _switchTile(
                    Icons.text_fields,
                    "Texto grande",
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
    // Detectamos el idioma actual para mostrarlo a la derecha
    final currentLang = Localizations.localeOf(context).languageCode.toUpperCase();
    
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
              currentLang,
              style: TextStyle(color: contentColor.withOpacity(0.5), fontSize: 14),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: chevronColor, size: 22),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Español"),
                trailing: langProvider.locale.languageCode == 'es' ? Icon(Icons.check, color: accentColor) : null,
                onTap: () {
                  langProvider.changeLanguage(const Locale('es'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("English"),
                trailing: langProvider.locale.languageCode == 'en' ? Icon(Icons.check, color: accentColor) : null,
                onTap: () {
                  langProvider.changeLanguage(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _themeSwitcherTile(BuildContext context, bool isDark, Color accentColor) {
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
                  isCurrentlyDark ? "Modo oscuro" : "Modo claro",
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
        if (text == "Permisos de ubicación") {
          AppSettings.openAppSettings(type: AppSettingsType.location);
        } else if (text == "Datos compartidos") {
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
      appBar: AppBar(title: Text(l10n.accountConnection)),
      body: const Center(child: Text("Información de privacidad")),
    );
  }
}