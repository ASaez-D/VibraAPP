# Guía de Uso de Entornos - VibraAPP

## 📋 Descripción

VibraAPP ahora soporta múltiples entornos de ejecución: **Development**, **Pre-Production** y **Production**.

## 🗂️ Archivos de Entorno

### Archivos Creados

- **`.env.dev`** - Entorno de desarrollo (credenciales actuales)
- **`.env.pre`** - Entorno de pre-producción (placeholders)
- **`.env.prod`** - Entorno de producción (placeholders)
- **`.env.example`** - Plantilla para nuevos desarrolladores

### Protección de Credenciales

Todos los archivos `.env*` están protegidos en `.gitignore` y **NO se subirán a Git**.

## 🚀 Cómo Cambiar de Entorno

### Opción 1: Modificar `main.dart` (Recomendado)

Edita el archivo `lib/main.dart` y cambia el entorno en la línea de inicialización:

```dart
// Para DEVELOPMENT
await EnvironmentConfig.initialize(Environment.development);

// Para PRE-PRODUCTION
await EnvironmentConfig.initialize(Environment.preProduction);

// Para PRODUCTION
await EnvironmentConfig.initialize(Environment.production);
```

### Opción 2: Configuración por Build Flavor (Avanzado)

Para configurar automáticamente según el flavor de compilación, puedes usar:

```bash
# Development
flutter run --dart-define=ENVIRONMENT=dev

# Pre-production
flutter run --dart-define=ENVIRONMENT=pre

# Production
flutter run --dart-define=ENVIRONMENT=prod
```

Y modificar `main.dart`:

```dart
const envString = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
final env = envString == 'prod'
    ? Environment.production
    : envString == 'pre'
        ? Environment.preProduction
        : Environment.development;

await EnvironmentConfig.initialize(env);
```

## 🔑 Configurar Credenciales

### Para Pre-Producción

1. Abre `.env.pre`
2. Reemplaza los placeholders `TU_*_PRE` con tus credenciales reales
3. Guarda el archivo

### Para Producción

1. Abre `.env.prod`
2. Reemplaza los placeholders `TU_*_PROD` con tus credenciales reales
3. Guarda el archivo

## 📦 Variables Disponibles

Todas las variables se acceden a través de `EnvironmentConfig`:

```dart
import 'package:vibra_project/config/environment_config.dart';

// Spotify
EnvironmentConfig.spotifyClientId
EnvironmentConfig.spotifyClientSecret

// Ticketmaster
EnvironmentConfig.ticketmasterApiKey
EnvironmentConfig.ticketmasterConsumerKey
EnvironmentConfig.ticketmasterConsumerSecret

// ACRCloud
EnvironmentConfig.acrCloudHost
EnvironmentConfig.acrCloudAccessKey
EnvironmentConfig.acrCloudAccessSecret

// Información del entorno
EnvironmentConfig.currentEnvironment
EnvironmentConfig.environmentName
EnvironmentConfig.isDevelopment
EnvironmentConfig.isPreProduction
EnvironmentConfig.isProduction
```

## 🔧 Servicios Actualizados

Los siguientes servicios ahora usan `EnvironmentConfig`:

- ✅ `SpotifyAuth`
- ✅ `SpotifyAPIService`
- ✅ `TicketmasterService`
- ✅ `SongRecognitionService`

## 🔒 Seguridad

> [!CAUTION]
> **NUNCA** subas archivos `.env` con credenciales reales a Git.

- Los archivos `.env*` están en `.gitignore`
- Usa `.env.example` como plantilla para compartir
- Mantén credenciales de producción seguras

## 📝 Para Nuevos Desarrolladores

1. Copia `.env.example` a `.env.dev`
2. Solicita las credenciales al equipo
3. Rellena las variables en `.env.dev`
4. Ejecuta la app normalmente

## 🧪 Testing

Para tests, puedes crear un archivo `.env.test` adicional con credenciales de prueba.

## ❓ Preguntas Frecuentes

**¿Puedo usar el mismo Firebase para todos los entornos?**
Sí, por defecto todos usan el mismo proyecto Firebase. Si quieres separar, descomenta `FIREBASE_PROJECT_ID` en cada `.env`.

**¿Cómo sé en qué entorno estoy?**

```dart
print(EnvironmentConfig.environmentName); // "Development", "Pre-Production", o "Production"
```

**¿Necesito diferentes credenciales de API para cada entorno?**
No es obligatorio, pero es recomendado para producción para:

- Separar quotas de API
- Mejor tracking de uso
- Mayor seguridad
