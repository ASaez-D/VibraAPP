import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_constants.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  // Mantenemos accentColor ya que es el color de marca (verde)
  final Color accentColor = Colors.greenAccent;

  // Datos de ejemplo
  final List<Map<String, dynamic>> friends = const [
    {
      "name": "Ana García",
      "status": "En línea",
      "img": "https://i.pravatar.cc/150?u=1",
    },
    {
      "name": "Carlos Ruiz",
      "status": "Escuchando Jazz",
      "img": "https://i.pravatar.cc/150?u=2",
    },
    {
      "name": "Laura M.",
      "status": "Desconectado",
      "img": "https://i.pravatar.cc/150?u=3",
    },
    {
      "name": "David V.",
      "status": "En el concierto de Vecinos",
      "img": "https://i.pravatar.cc/150?u=4",
    },
    {
      "name": "Sofía L.",
      "status": "En línea",
      "img": "https://i.pravatar.cc/150?u=5",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Obtener el estado del tema y los colores dinámicos
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colores base dinámicos
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.grey[600] : Colors.grey[700];
    final searchFieldColor = isDarkMode
        ? const Color(0xFF1C1C1E)
        : Colors.grey[200];

    // --- CAMBIO AQUÍ: Uso de withValues en lugar de withOpacity ---
    final listTileDividerColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.1);

    final trailingIconColor = isDarkMode ? Colors.white54 : Colors.black45;

    // Color de fondo del Scaffold
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    // Color del fondo de la AppBar
    final appBarBgColor = Theme.of(context).appBarTheme.backgroundColor;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          l10n.socialTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: primaryTextColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt_1_rounded, color: primaryTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              style: TextStyle(color: primaryTextColor),
              decoration: InputDecoration(
                hintText: l10n.socialSearchHint,
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.search, color: hintColor),
                filled: true,
                fillColor: searchFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorders.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Lista de amigos
          Expanded(
            child: ListView.separated(
              itemCount: friends.length,
              separatorBuilder: (context, index) =>
                  Divider(color: listTileDividerColor, height: 1),
              itemBuilder: (context, index) {
                final friend = friends[index];
                // Check if status is "En línea" (hardcoded in data) to use localized version
                // For demo purposes we can leave the data as is or try to map it
                // But specifically for the online check logic:
                final isOnline = friend['status'] == "En línea";
                final displayStatus = isOnline
                    ? l10n.socialStatusOnline
                    : friend['status'];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: AppSizes.avatarSizeMedium / 2,
                        backgroundImage: NetworkImage(friend['img']),
                        backgroundColor: Colors.grey[800],
                      ),
                      if (isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: scaffoldBgColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    friend['name'],
                    style: TextStyle(
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppTypography.fontSizeRegular,
                    ),
                  ),
                  subtitle: Text(
                    displayStatus,
                    style: TextStyle(
                      color: isOnline ? accentColor : hintColor,
                      fontSize: AppTypography.fontSizeSmall,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: trailingIconColor,
                      size: AppSizes.iconSizeMedium,
                    ),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
