/// Constantes de texto de la aplicación
/// Centraliza strings que no requieren internacionalización
library;

class AppTextConstants {
  AppTextConstants._();

  // Información de la aplicación
  static const String appVersion = '1.0.0';
  static const String appName = 'Vibra';

  // Contacto y soporte
  static const String supportEmail = 'vibra@support.com';
  static const String supportEmailSubject = 'Soporte Vibra App';

  // URLs y enlaces
  static const String placeholderImageUrl =
      'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600&auto=format&fit=crop';
  static const String defaultUserIconUrl =
      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';

  // Códigos de país por defecto
  static const String defaultCountryCode = 'ES';

  // Días de la semana (abreviados, no requieren i18n para calendario)
  static const List<String> weekdayAbbreviations = [
    'L',
    'M',
    'X',
    'J',
    'V',
    'S',
    'D',
  ];

  // Mensajes de error técnicos (para logging)
  static const String errorFailedToLaunchUrl = 'Failed to launch URL';
  static const String errorFailedToOpenEmail = 'Failed to open email client';
  static const String errorNetworkRequest = 'Network request failed';
  static const String errorDataParsing = 'Data parsing error';
}
