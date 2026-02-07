/// Constantes centralizadas de la aplicación
/// Elimina números mágicos y facilita el mantenimiento
library;

import 'package:flutter/material.dart';

/// Constantes de colores del tema
class AppColors {
  AppColors._(); // Constructor privado para prevenir instanciación

  // Colores principales
  static const Color primaryAccent = Color(0xFF54FF78);
  static const Color secondaryAccent = Color(0xFF1DB954); // Spotify green

  // Modo oscuro
  static const Color darkScaffoldBackground = Color(0xFF0E0E0E);
  static const Color darkCardBackground = Color(0xFF1C1C1E);
  static const Color darkSurfaceBackground = Color(0xFF252525);
  static const Color darkPrimaryText = Colors.white;
  static const Color darkSecondaryText = Colors.white54;

  // Modo claro
  static const Color lightScaffoldBackground = Color(0xFFF7F7F7);
  static const Color lightCardBackground = Colors.white;
  static const Color lightPrimaryText = Color(0xFF222222);

  // Colores de estado
  static const Color error = Colors.redAccent;
  static const Color warning = Colors.orangeAccent;
  static const Color success = primaryAccent;

  static const Color errorColor = Colors.redAccent;
  static const Color warningColor = Colors.orangeAccent;
  static const Color successColor = primaryAccent;

  // Opacidades comunes
  static const double opacityLow = 0.05;
  static const double opacityMedium = 0.1;
  static const double opacityHigh = 0.2;
  static const double opacityVeryHigh = 0.3;

  static const double opacityGlass = 0.95;

  // Song Recognition
  static const Color listeningPulseStart = Colors.redAccent;
  static const Color listeningPulseEnd = Colors.deepOrange;
  static const Color glassmorphismStart = Color(0xFF1E1E1E);
  static const Color glassmorphismEnd = Color(0xFF2C2C2C);
}

/// Constantes de tipografía
class AppTypography {
  AppTypography._();

  // Tamaños de fuente
  static const double fontSizeExtraSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeExtraLarge = 22.0;
  static const double fontSizeTitle = 28.0;
  static const double fontSizeHero = 30.0;

  // Pesos de fuente
  static const FontWeight fontWeightRegular = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;
  static const FontWeight fontWeightBlack = FontWeight.w900;

  // Espaciado de letras
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.5;
  static const double letterSpacingWide = 1.0;
  static const double letterSpacingExtraWide = 1.5;
}

/// Constantes de espaciado
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 30.0;
  static const double huge = 40.0;
}

/// Constantes de bordes y radios
class AppBorders {
  AppBorders._();

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 20.0;
  static const double radiusRound = 24.0;
  static const double radiusCircular = 30.0;

  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 1.5;
  static const double borderWidthThick = 2.0;
}

/// Constantes de animaciones
class AppAnimations {
  AppAnimations._();

  // Duraciones
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationSnackbar = Duration(milliseconds: 800);
  static const Duration durationOneSecond = Duration(seconds: 1);

  // Escalas
  static const double scaleNormal = 1.0;
  static const double scalePressed = 1.2;

  // Curvas
  static const Curve curveDefault = Curves.easeOutBack;
  static const Curve curveSmooth = Curves.easeInOut;
}

/// Constantes de tamaños
class AppSizes {
  AppSizes._();

  // Tamaños de iconos
  static const double iconSizeSmall = 12.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeExtraLarge = 26.0;
  static const double iconSizeHuge = 48.0;
  static const double iconSizeGiant = 50.0;
  static const double iconSizeMassive = 60.0;

  // Tamaños de avatar
  static const double avatarSizeSmall = 40.0;
  static const double avatarSizeMedium = 55.0;
  static const double avatarSizeLarge = 80.0;

  // Tamaños de botones
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 54.0;
  static const double buttonHeightLarge = 60.0;

  // Tamaños de tarjetas
  static const double cardHeightSmall = 120.0;
  static const double cardHeightMedium = 145.0;
  static const double cardHeightLarge = 180.0;

  // Anchos de imagen
  static const double imageWidthSmall = 80.0;
  static const double imageWidthMedium = 100.0;
  static const double imageWidthLarge = 115.0;

  // Cache de imágenes
  static const int imageCacheWidth = 300;
  static const int imageCacheHeight = 300;

  // Tamaños de UI específicos
  static const double appBarHeight = 80.0;
  static const double searchBarHeight = 50.0;
  static const double avatarRadiusLarge = 22.0;
  static const double avatarRadiusSmall = 18.0;
}

/// Constantes de grid y layout
class AppLayout {
  AppLayout._();

  static const int calendarGridColumns = 7;
  static const double calendarGridSpacing = 8.0;

  static const double listSeparatorHeight = 16.0;
  static const double listSeparatorHeightLarge = 20.0;

  static const EdgeInsets paddingScreenHorizontal = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const EdgeInsets paddingScreenAll = EdgeInsets.all(20.0);
  static const EdgeInsets paddingCardAll = EdgeInsets.all(16.0);
}

/// Constantes de tiempo
class AppTime {
  AppTime._();

  static const int daysInWeek = 7;
  static const int daysInMonth = 30;
  static const int daysInThreeMonths = 90;
  static const int monthsToShow = 12;
}

/// Constantes heredadas (mantener compatibilidad)
class AppDesign {
  static const Color backgroundColor = AppColors.darkScaffoldBackground;
  static const double logoSize = 110.0;
  static const double horizontalPadding = 32.0;
  static const double borderRadius = AppBorders.radiusCircular;
}
