/// Helper de temas para obtener colores según el modo (dark/light)
library;

import 'package:flutter/material.dart';
import 'app_constants.dart';

/// Clase helper para obtener colores del tema actual
class AppTheme {
  final bool isDarkMode;

  AppTheme(BuildContext context)
    : isDarkMode = Theme.of(context).brightness == Brightness.dark;

  // Colores de fondo
  Color get scaffoldBackground => isDarkMode
      ? AppColors.darkScaffoldBackground
      : AppColors.lightScaffoldBackground;

  Color get cardBackground =>
      isDarkMode ? AppColors.darkCardBackground : AppColors.lightCardBackground;

  Color get surfaceBackground => isDarkMode
      ? AppColors.darkSurfaceBackground
      : AppColors.lightScaffoldBackground;

  // Colores de texto
  Color get primaryText =>
      isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText;

  Color get secondaryText =>
      isDarkMode ? AppColors.darkSecondaryText : Colors.grey.shade600;

  // Colores de acento
  Color get accentColor => AppColors.primaryAccent;

  // Colores de borde
  Color get borderColor => isDarkMode
      ? Colors.white.withValues(alpha: AppColors.opacityLow)
      : Colors.grey.shade300;

  Color get dividerColor => isDarkMode ? Colors.white10 : Colors.grey.shade100;

  // Colores de iconos
  Color get iconBackground =>
      isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200;

  Color get iconColor => primaryText;

  // Colores de sombra
  Color get shadowColor => isDarkMode
      ? Colors.black.withValues(alpha: 0.5)
      : Colors.black.withValues(alpha: AppColors.opacityMedium);

  // Colores de estado
  Color get disabledColor =>
      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

  Color get success => AppColors.success;
  Color get error => AppColors.error;

  Color get pastDateColor => isDarkMode ? Colors.white38 : Colors.grey.shade400;

  // Colores de rango (para calendario)
  Color get rangeColor =>
      AppColors.primaryAccent.withValues(alpha: AppColors.opacityHigh);

  Color get inactiveChipColor => isDarkMode
      ? AppColors.primaryAccent.withValues(alpha: AppColors.opacityHigh)
      : Colors.grey.shade300;

  // Sombras
  List<BoxShadow> get cardShadow => isDarkMode
      ? []
      : [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ];
}
