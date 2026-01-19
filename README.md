# 🎵 Vibra - Tu Música, Tu Momento

<div align="center">
  <img src="https://via.placeholder.com/1200x300?text=Vibra+App+Banner" alt="Banner Vibra" width="100%">
</div>

## Insignias

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Estado-En_Desarrollo_(MVP)-orange?style=for-the-badge)

</div>

## Índice

* [Título e imagen de portada](#-vibra---tu-música-tu-momento)
* [Insignias](#insignias)
* [Descripción del proyecto](#descripción-del-proyecto)
* [Estado del proyecto](#estado-del-proyecto)
* [Características de la aplicación y demostración](#características-de-la-aplicación-y-demostración)
* [Arquitectura del Proyecto](#arquitectura-del-proyecto)
* [Acceso al proyecto](#acceso-al-proyecto)
* [Tecnologías utilizadas y Dependencias](#tecnologías-utilizadas-y-dependencias)
* [Personas-Desarrolladores del Proyecto](#personas-desarrolladores-del-proyecto)
* [Licencia](#licencia)
* [Conclusión](#conclusión)

---

## Descripción del proyecto

**Vibra** es una aplicación móvil multiplataforma desarrollada en **Flutter 3.9.2** que revoluciona la forma en que los usuarios descubren y asisten a eventos musicales en vivo.

La aplicación nace de la necesidad de centralizar la experiencia del fan: desde el descubrimiento de conciertos basado en gustos personales (integración con Spotify) hasta la gestión de entradas y alertas de lanzamientos. Vibra conecta a los fans con sus artistas favoritos y las tendencias locales de su ciudad o destino de viaje.

---

## Estado del proyecto

🚧 **Fase de Desarrollo (MVP)**

Actualmente, el proyecto se encuentra en la fase de desarrollo del Producto Mínimo Viable. Las funcionalidades "Core" (núcleo) están implementadas, mientras que características avanzadas como la pasarela de pago real y el chat social están planificadas para futuras iteraciones.

---

## Características de la aplicación y demostración

### 🌟 Funcionalidades Principales

| Característica | Descripción |
| :--- | :--- |
| **🔐 Autenticación Social** | Inicio de sesión seguro con Google, Spotify y Email (Firebase Auth). |
| **🎸 Feed Personalizado** | Algoritmo de recomendación basado en "Tus Artistas", "Tendencias" y ubicación. |
| **🌍 Internacionalización (i18n)** | Soporte completo en 6 idiomas: Español, Inglés, Alemán, Francés, Portugués y Catalán. |
| **📅 Gestión de Eventos** | Búsqueda avanzada, detalle de conciertos con mapas interactivos y guardado en "Favoritos". |
| **🔔 Notificaciones Smart** | Sistema de alertas para recordatorios de fechas y lanzamiento de tickets con previsualización interactiva en UI. |
| **⚙️ Ajustes y Privacidad** | Modo Oscuro/Claro, descarga de datos personales (GDPR) y eliminación de cuenta segura. |

### 📱 Demostración (Screenshots)

> *Nota: Inserta aquí GIFs o capturas de pantalla de tu emulador.*

| Pantalla de Inicio | Detalle de Evento | Ajustes y Notificaciones |
|:---:|:---:|:---:|
| <img src="https://via.placeholder.com/200x400?text=Home" width="200"> | <img src="https://via.placeholder.com/200x400?text=Detail" width="200"> | <img src="https://via.placeholder.com/200x400?text=Settings" width="200"> |

---

## Arquitectura del Proyecto

El proyecto sigue una arquitectura limpia y escalable basada en **Provider**, separando la lógica de negocio de la interfaz de usuario para facilitar el mantenimiento y la escalabilidad.

### Estructura de Carpetas

```text
lib/
├── l10n/                      # Archivos de internacionalización (.arb)
│   ├── app_ca.arb             # Catalán
│   ├── app_de.arb             # Alemán
│   ├── app_en.arb             # Inglés
│   ├── app_es.arb             # Español
│   ├── app_fr.arb             # Francés
│   └── app_pt.arb             # Portugués
├── models/                    # Modelos de datos (User, Event, Ticket)
├── providers/                 # Gestión de estado
│   └── language_provider.dart # Lógica de cambio de idioma
├── screens/                   # Pantallas de la aplicación (UI)
│   ├── account_screen.dart    # Perfil de usuario
│   ├── calendar_screen.dart   # Calendario de eventos
│   ├── home_screen.dart       # Pantalla principal
│   ├── login_screen.dart      # Autenticación
│   ├── settings_screen.dart   # Ajustes y Privacidad
│   └── ... (otras pantallas)
├── services/                  # Lógica de negocio externa
│   ├── auth_services.dart     # Gestión general de Auth
│   ├── google_auth.dart       # Lógica específica de Google
│   ├── spotify_api_service.dart # Conexión API Spotify
│   ├── ticketmaster_service.dart # API Eventos
│   └── user_data_service.dart # Gestión de Firestore
├── utils/                     # Utilidades y constantes
├── widgets/                   # Componentes reutilizables
└── main.dart                  # Punto de entrada de la aplicación

```

---

## Acceso al proyecto

Para ejecutar este proyecto localmente, sigue estos pasos:

### Prerrequisitos

* [Flutter SDK 3.9.2](https://www.google.com/search?q=https://flutter.dev/docs/get-started/install) instalado.
* [Dart SDK 3.9.2](https://www.google.com/search?q=https://dart.dev/get-dart).
* Un editor de código (VS Code o Android Studio).
* Un dispositivo físico o emulador (Android/iOS).

### Instalación

1. **Clonar el repositorio:**
```bash
git clone [https://github.com/tu-usuario/vibra-app.git](https://github.com/tu-usuario/vibra-app.git)

```


2. **Instalar dependencias:**
```bash
cd vibra-app
flutter pub get

```


3. **Generar archivos de traducción:**
Es necesario ejecutar este comando para compilar los archivos `.arb`.
```bash
flutter gen-l10n

```


4. **Ejecutar la aplicación:**
```bash
flutter run

```



---

## Tecnologías utilizadas y Dependencias

El proyecto está construido utilizando herramientas de vanguardia en el ecosistema móvil. A continuación, se detallan los paquetes clave utilizados en el `pubspec.yaml` (v1.0.0+1):

### Core & Framework

* **Flutter SDK:** `3.9.2`
* **Dart SDK:** `3.9.2`

### Gestión de Estado & Arquitectura

* **provider:** `^6.1.2` - Inyección de dependencias y gestión de estado reactiva.

### Backend & Servicios (Firebase & APIs)

* **firebase_core:** `^3.3.0` - Núcleo de Firebase.
* **firebase_auth:** `^5.1.4` - Autenticación segura.
* **cloud_firestore:** `^5.0.1` - Base de datos NoSQL en tiempo real.
* **google_sign_in:** `^6.2.1` - Autenticación nativa con Google.
* **flutter_web_auth_2:** `^4.1.0` - Autenticación OAuth web (Spotify).
* **http:** `^1.2.1` - Peticiones REST API.

### UI & UX

* **google_fonts:** `^6.0.0` - Tipografías personalizadas.
* **cupertino_icons:** `^1.0.8` - Iconos estilo iOS.
* **flutter_map:** `^7.0.0` - Mapas interactivos (OpenStreetMap).
* **latlong2:** `^0.9.1` - Utilidades de coordenadas geográficas.

### Funcionalidades del Sistema

* **permission_handler:** `^12.0.1` - Gestión avanzada de permisos (notificaciones, ubicación).
* **url_launcher:** `^6.1.11` - Abrir enlaces externos, correos y mapas.
* **share_plus:** `^12.0.1` - Compartir contenido y exportar archivos.
* **path_provider:** `^2.1.2` - Acceso al sistema de archivos local.
* **app_settings:** `^7.0.0` - Abrir ajustes del sistema desde la app.
* **shared_preferences:** `^2.5.4` - Persistencia de datos simple (clave-valor).

### Internacionalización

* **flutter_localizations:** (SDK) - Soporte nativo de i18n.
* **intl:** `0.20.2` - Formateo de fechas y números.

### Calidad de Código

* **SonarQube for IDE:** Extensión utilizada para análisis estático y métricas de deuda técnica.
* **logger:** `^2.3.0` - Logs estructurados y limpios en consola.
* **flutter_lints:** `^5.0.0` - Reglas de linter estándar.

---

## Personas-Desarrolladores del Proyecto

Este proyecto ha sido desarrollado por el siguiente equipo, como parte del módulo **Desarrollo de Aplicaciones Multiplataforma (DAM)**:

| Desarrollador | Roles Principales | Contacto |
| --- | --- | --- |
| **Ángel Sáez Díaz** | *Desarrollador DAM* | [GitHub](https://github.com/ASaez-D) |
| **David Cruces Manuitt** | *Desarrollador DAM* | [GitHub](https://github.com/davcruman) |
| **Marcelo Moreira Pereira** | *Desarrollador DAM* | [GitHub](https://github.com/marmormai) |

> *Agradecemos también a las comunidades open source de Flutter y Firebase por las herramientas que hacen posible este desarrollo.*

---

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE.md](https://www.google.com/search?q=LICENSE.md) para más detalles.

---

## Conclusión

**Vibra** representa la aplicación práctica de la metodología Scrum en un entorno de desarrollo móvil moderno. A través de este proyecto, el equipo conformado por Ángel, David y Marcelo ha logrado implementar una arquitectura robusta, gestionar la deuda técnica con herramientas de calidad profesional (**SonarQube**) y crear una experiencia de usuario centrada en la accesibilidad (multi-idioma con 6 locales) y la privacidad (gestión granular de permisos).

```
