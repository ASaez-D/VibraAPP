# 🎵 Vibra - Tu Música, Tu Momento

<div align="center">
  <img src="https://via.placeholder.com/1200x300?text=Vibra+App+Banner" alt="Banner Vibra" width="100%">
</div>

## Insignias

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
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
* [Acceso al proyecto](#acceso-al-proyecto)
* [Tecnologías utilizadas](#tecnologías-utilizadas)
* [Personas Contribuyentes](#personas-contribuyentes)
* [Personas-Desarrolladores del Proyecto](#personas-desarrolladores-del-proyecto)
* [Licencia](#licencia)
* [Conclusión](#conclusión)

---

## Descripción del proyecto

**Vibra** es una aplicación móvil multiplataforma desarrollada en Flutter que revoluciona la forma en que los usuarios descubren y asisten a eventos musicales en vivo.

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
| **📅 Gestión de Eventos** | Búsqueda avanzada, detalle de conciertos con mapas y guardado en "Favoritos". |
| **🔔 Notificaciones Smart** | Sistema simulado de alertas para recordatorios de fechas y lanzamiento de tickets con previsualización en UI. |
| **⚙️ Ajustes y Privacidad** | Modo Oscuro/Claro, descarga de datos personales (GDPR) y eliminación de cuenta segura. |

### 📱 Demostración (Screenshots)

> *Nota: Inserta aquí GIFs o capturas de pantalla de tu emulador.*

| Pantalla de Inicio | Detalle de Evento | Ajustes y Notificaciones |
|:---:|:---:|:---:|
| <img src="https://via.placeholder.com/200x400?text=Home" width="200"> | <img src="https://via.placeholder.com/200x400?text=Detail" width="200"> | <img src="https://via.placeholder.com/200x400?text=Settings" width="200"> |

---

## Acceso al proyecto

Para ejecutar este proyecto localmente, sigue estos pasos:

### Prerrequisitos
* [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado.
* Un editor de código (VS Code o Android Studio).
* Un dispositivo físico o emulador (Android/iOS).

### Instalación

1.  **Clonar el repositorio:**
    ```bash
    git clone [https://github.com/tu-usuario/vibra-app.git](https://github.com/tu-usuario/vibra-app.git)
    ```

2.  **Instalar dependencias:**
    ```bash
    cd vibra-app
    flutter pub get
    ```

3.  **Generar archivos de traducción:**
    Es necesario ejecutar este comando cada vez que se actualizan los archivos `.arb`.
    ```bash
    flutter gen-l10n
    ```

4.  **Ejecutar la aplicación:**
    ```bash
    flutter run
    ```

---

## Tecnologías utilizadas

El proyecto está construido utilizando una arquitectura escalable y las siguientes tecnologías:

* **Framework:** [Flutter](https://flutter.dev/) (Lenguaje Dart).
* **Gestión de Estado:** `provider` (Arquitectura MVVM/Clean).
* **Backend as a Service:**
    * `firebase_auth`: Gestión de usuarios.
    * `cloud_firestore`: Base de datos NoSQL para eventos y usuarios.
* **Internacionalización:** `flutter_localizations` & `intl`.
* **Paquetes Clave:**
    * `permission_handler`: Gestión de permisos de notificaciones.
    * `share_plus`: Compartir eventos y exportar datos.
    * `url_launcher`: Abrir mapas y correos electrónicos.
    * `path_provider`: Gestión de archivos temporales.

---

## Personas Contribuyentes

Agradecemos a las herramientas y comunidades open source que hacen posible este desarrollo.

* Comunidad de Flutter & Dart.
* Documentación de Firebase.
* Iconos proporcionados por Material Design.

---

## Personas-Desarrolladores del Proyecto

Este proyecto ha sido desarrollado como parte del módulo **Desarrollo de Aplicaciones Multiplataforma (PMDM)**.

* **[Tu Nombre]** - *Product Owner & Lead Developer* - [Enlace a tu GitHub/LinkedIn]
* **[Nombre Compañero/a si hay]** - *Scrum Master & Developer*

---

## Licencia

Este proyecto está bajo la Licencia MIT - mira el archivo [LICENSE.md](LICENSE.md) para más detalles.

---

## Conclusión

**Vibra** representa la aplicación práctica de la metodología Scrum en un entorno de desarrollo móvil moderno. A través de este proyecto, se ha logrado implementar una arquitectura robusta, gestionar deuda técnica con herramientas de calidad (SonarLint) y crear una experiencia de usuario centrada en la accesibilidad (multi-idioma) y la privacidad del usuario.