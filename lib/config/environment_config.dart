/// Configuración de entornos para la aplicación
/// Gestiona diferentes entornos (development, pre-production, production)
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Enumeración de entornos disponibles
enum Environment { 
  development, 
  preProduction, 
  production 
}

/// Clase de configuración de entorno
/// Gestiona la carga y acceso a variables de entorno según el entorno activo
class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.development;
  
  /// Obtiene el entorno actual
  static Environment get currentEnvironment => _currentEnvironment;
  
  /// Verifica si estamos en desarrollo
  static bool get isDevelopment => _currentEnvironment == Environment.development;
  
  /// Verifica si estamos en pre-producción
  static bool get isPreProduction => _currentEnvironment == Environment.preProduction;
  
  /// Verifica si estamos en producción
  static bool get isProduction => _currentEnvironment == Environment.production;
  
  /// Obtiene el nombre del entorno actual
  static String get environmentName {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'Development';
      case Environment.preProduction:
        return 'Pre-Production';
      case Environment.production:
        return 'Production';
    }
  }
  
  /// Inicializa el entorno y carga el archivo .env correspondiente
  /// 
  /// [environment] El entorno a inicializar
  /// 
  /// Ejemplo:
  /// ```dart
  /// await EnvironmentConfig.initialize(Environment.development);
  /// ```
  static Future<void> initialize(Environment environment) async {
    _currentEnvironment = environment;
    
    // Cargar el archivo .env correspondiente
    String envFile;
    switch (environment) {
      case Environment.development:
        envFile = '.env.dev';
        break;
      case Environment.preProduction:
        envFile = '.env.pre';
        break;
      case Environment.production:
        envFile = '.env.prod';
        break;
    }
    
    await dotenv.load(fileName: envFile);
  }
  
  // ==================== Spotify API ====================
  
  /// Client ID de Spotify
  static String get spotifyClientId => 
      dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  
  /// Client Secret de Spotify
  static String get spotifyClientSecret => 
      dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';
  
  // ==================== Ticketmaster API ====================
  
  /// API Key de Ticketmaster
  static String get ticketmasterApiKey => 
      dotenv.env['TICKETMASTER_API_KEY'] ?? '';
  
  /// Consumer Key de Ticketmaster
  static String get ticketmasterConsumerKey => 
      dotenv.env['TICKETMASTER_CONSUMER_KEY'] ?? '';
  
  /// Consumer Secret de Ticketmaster
  static String get ticketmasterConsumerSecret => 
      dotenv.env['TICKETMASTER_CONSUMER_SECRET'] ?? '';
  
  // ==================== ACRCloud API ====================
  
  /// Host de ACRCloud
  static String get acrCloudHost => 
      dotenv.env['ACR_CLOUD_HOST'] ?? '';
  
  /// Access Key de ACRCloud
  static String get acrCloudAccessKey => 
      dotenv.env['ACR_CLOUD_ACCESS_KEY'] ?? '';
  
  /// Access Secret de ACRCloud
  static String get acrCloudAccessSecret => 
      dotenv.env['ACR_CLOUD_ACCESS_SECRET'] ?? '';
  
  // ==================== Firebase (Opcional) ====================
  
  /// Project ID de Firebase (opcional si usas proyectos separados)
  static String? get firebaseProjectId => 
      dotenv.env['FIREBASE_PROJECT_ID'];
}
