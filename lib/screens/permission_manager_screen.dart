import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

class PermissionManagerScreen extends StatefulWidget {
  const PermissionManagerScreen({super.key});

  @override
  State<PermissionManagerScreen> createState() =>
      _PermissionManagerScreenState();
}

class _PermissionManagerScreenState extends State<PermissionManagerScreen>
    with WidgetsBindingObserver {
  Map<Permission, PermissionStatus> _statuses = {};
  bool _loading = true;

  final List<Permission> _permissions = [
    Permission.location,
    Permission.notification,
    Permission.camera,
    Permission.microphone,
    Permission
        .photos, // Or storage depending on Android version, handling generally
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> newStatuses = {};
    for (var perm in _permissions) {
      newStatuses[perm] = await perm.status;
    }
    if (mounted) {
      setState(() {
        _statuses = newStatuses;
        _loading = false;
      });
    }
  }

  Future<void> _requestPermission(Permission perm) async {
    final status = await perm.request();
    if (mounted) {
      setState(() {
        _statuses[perm] = status;
      });
    }
    if (status.isPermanentlyDenied) {
      _showOpenSettingsDialog();
    }
  }

  void _showOpenSettingsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dialogPermissionTitle),
        content: Text(l10n.permTip),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(l10n.permBtnSettings),
          ),
        ],
      ),
    );
  }

  String _getPermissionName(Permission perm, AppLocalizations l10n) {
    if (perm == Permission.location) return l10n.permLocation;
    if (perm == Permission.camera) return l10n.permCamera;
    if (perm == Permission.microphone) return l10n.permMicrophone;
    if (perm == Permission.notification) return l10n.permNotifications;
    if (perm == Permission.photos) return l10n.permStorage;
    return perm.toString();
  }

  String _getStatusText(PermissionStatus status, AppLocalizations l10n) {
    if (status.isGranted) return l10n.permStatusAllowed;
    if (status.isDenied) return l10n.permStatusDenied;
    if (status.isPermanentlyDenied) return l10n.permStatusPermanentlyDenied;
    if (status.isRestricted) return l10n.permStatusRestricted;
    return l10n.permStatusDenied;
  }

  Color _getStatusColor(PermissionStatus status, AppTheme theme) {
    if (status.isGranted) return AppColors.success;
    if (status.isPermanentlyDenied) return AppColors.error;
    return theme.secondaryText;
  }

  IconData _getPermissionIcon(Permission perm) {
    if (perm == Permission.location) return Icons.location_on;
    if (perm == Permission.camera) return Icons.camera_alt;
    if (perm == Permission.microphone) return Icons.mic;
    if (perm == Permission.notification) return Icons.notifications;
    if (perm == Permission.photos) return Icons.photo_library;
    return Icons.security;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = AppTheme(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.permManagerTitle,
          style: TextStyle(
            color: theme.primaryText,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _permissions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final perm = _permissions[index];
                final status = _statuses[perm] ?? PermissionStatus.denied;
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getPermissionIcon(perm),
                      color: theme.primaryText,
                    ),
                  ),
                  title: Text(
                    _getPermissionName(perm, l10n),
                    style: TextStyle(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    _getStatusText(status, l10n),
                    style: TextStyle(
                      color: _getStatusColor(status, theme),
                      fontSize: 12,
                    ),
                  ),
                  trailing: status.isGranted
                      ? Icon(Icons.check_circle, color: AppColors.success)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.cardBackground,
                            foregroundColor: theme.primaryText,
                            elevation: 0,
                            side: BorderSide(color: theme.borderColor),
                          ),
                          onPressed: () {
                            if (status.isPermanentlyDenied) {
                              openAppSettings();
                            } else {
                              _requestPermission(perm);
                            }
                          },
                          child: Text(
                            status.isPermanentlyDenied
                                ? l10n.permBtnSettings
                                : l10n.permBtnRequest,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: TextButton.icon(
          onPressed: openAppSettings,
          icon: const Icon(Icons.settings),
          label: Text(l10n.permBtnSettings),
          style: TextButton.styleFrom(foregroundColor: theme.secondaryText),
        ),
      ),
    );
  }
}
