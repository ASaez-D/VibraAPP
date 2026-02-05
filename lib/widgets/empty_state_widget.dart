/// Widget para mostrar estados vacíos de forma consistente
library;

import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

/// Widget reutilizable para estados vacíos
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade700;
    final subtitleColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade500;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppSizes.iconSizeMassive,
            color:
                iconColor ??
                (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade400),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: AppTypography.fontSizeLarge,
              fontWeight: AppTypography.fontWeightBold,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: TextStyle(
                color: subtitleColor,
                fontSize: AppTypography.fontSizeMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
