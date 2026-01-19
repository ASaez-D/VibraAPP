# 🎵 Vibra - Tu Música, Tu Momento

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Scrum](https://img.shields.io/badge/Metodología-Scrum-brightgreen?style=for-the-badge)

## 📄 Descripción General (Fase 0)

**Vibra** es una aplicación móvil desarrollada en Flutter diseñada para revolucionar la forma en que los usuarios descubren y asisten a eventos musicales en vivo. Conecta a los fans con sus artistas favoritos y las tendencias locales.

### 🎯 Objetivos

**Objetivo General:**
Centralizar la experiencia de descubrimiento de conciertos, facilitando la compra de entradas y la socialización en torno a la música en vivo.

**Objetivos Específicos:**
* Personalizar el feed de eventos basándose en los gustos musicales del usuario (integración con Spotify).
* Permitir guardar y gestionar eventos favoritos y entradas.
* Notificar al usuario sobre lanzamientos de tickets y recordatorios de fechas.

### 🔭 Alcance del Proyecto
Esta primera versión (MVP) incluirá:
* Autenticación (Google, Spotify, Email).
* Feed de eventos personalizado ("Solo para ti", "Tendencias", "Tus Artistas").
* Buscador avanzado por país y artista.
* Gestión de perfil, ajustes (idioma/tema) y eventos guardados.
* Sistema de notificaciones simulado (General, Recordatorios, Tickets).

> **Nota:** No se incluirá la pasarela de pagos real ni el chat social en tiempo real en esta primera iteración.

---

## 🧠 Análisis de Requisitos (Fase 1)

### Contexto
Los amantes de la música a menudo se pierden conciertos por falta de información centralizada o notificaciones tardías. Vibra resuelve esto ofreciendo una agenda personalizada y alertas proactivas.

### ⚙️ Requisitos Funcionales (RF)

| ID | Descripción |
|----|-------------|
| **RF1** | Login social (Spotify/Google) y gestión de sesión persistente. |
| **RF2** | Visualización de eventos categorizados (Tendencias, Fin de semana, Colecciones). |
| **RF3** | Detalle de evento con ubicación (Mapa), fecha, precios y enlace de compra. |
| **RF4** | Funcionalidad de "Guardar" eventos en una lista personal. |
| **RF5** | Configuración de preferencias: cambio de idioma (i18n) y tema (Claro/Oscuro). |
| **RF6** | Gestión de permisos y simulación de notificaciones push. |

### 🧩 Requisitos No Funcionales (RNF)

| ID | Descripción |
|----|-------------|
| **RNF1** | Internacionalización completa (6 idiomas: ES, EN, DE, FR, PT, CA). |
| **RNF2** | Persistencia de datos locales (SharedPreferences) para ajustes de usuario. |
| **RNF3** | Interfaz responsiva y adaptada a Modo Oscuro nativo. |
| **RNF4** | Arquitectura escalable basada en Providers. |

### 👤 Historias de Usuario Iniciales
* **HU1:** Como **fan de la música**, quiero **iniciar sesión con Spotify** para que la app conozca mis gustos automáticamente.
* **HU2:** Como **usuario**, quiero **recibir una notificación** 5 minutos antes de que salgan las entradas de mi artista favorito.
* **HU3:** Como **turista**, quiero **cambiar el país de búsqueda** para ver conciertos en mi destino de viaje.
* **HU4:** Como **usuario preocupado por la privacidad**, quiero **poder descargar mis datos** o eliminar mi cuenta fácilmente desde la app.

---

## 🗓️ Planificación y Backlog (Fase 2)

### 🧭 Roadmap
1.  **Hito 1: Core & UI:** Estructura base, navegación, internacionalización y diseño de pantallas (Home, Detail, Settings).
2.  **Hito 2: Datos & Auth:** Conexión con Firebase Auth y Firestore, gestión de estado con Provider.
3.  **Hito 3: Features:** Lógica de guardado, búsqueda dinámica y sistema de notificaciones.
4.  **Hito 4: Refactorización:** Limpieza de código (SonarLint), gestión de errores y lanzamiento.

### 🧱 Product Backlog Priorizado

| ID | Historia / Tarea | Prioridad | Esfuerzo | Criterios de Aceptación |
|----|------------------|-----------|----------|-------------------------|
| **T1** | Configuración i18n | Alta 🔴 | Medio | Soporte funcional para 6 idiomas mediante archivos .arb. |
| **T2** | Pantalla Home | Alta 🔴 | Alto | Scroll vertical/horizontal, secciones dinámicas. |
| **T3** | Lógica de Settings | Media 🟡 | Medio | Persistencia de tema y notificaciones con previsualización. |
| **T4** | Eliminar Cuenta | Alta 🔴 | Bajo | Borrado en Auth y Firestore con confirmación de seguridad. |

---

## 🚀 Desarrollo y Metodología (Fase 3)

### 🛠️ Stack Tecnológico
* **Framework:** Flutter (Dart).
* **Gestión de Estado:** Provider.
* **Backend (BaaS):** Firebase (Authentication, Firestore).
* **Localización:** `flutter_localizations` & `intl`.
* **Paquetes Clave:** `permission_handler`, `url_launcher`, `share_plus`, `path_provider`.

### 🧪 Calidad y Pruebas (QA)
* **Análisis Estático:** Uso de **SonarLint** para mantener la deuda técnica bajo mínimos (Ratio < 5%).
* **Clean Code:** Separación estricta entre UI (`screens`, `widgets`) y Lógica (`providers`, `services`).
* **UX/UI:** Feedback visual inmediato (SnackBar, Dialogs) para acciones del usuario (guardar, errores, permisos).

---

## 📦 Instalación y Configuración

1.  **Clonar el repositorio:**
    ```bash
    git clone [https://github.com/tu-usuario/vibra-app.git](https://github.com/tu-usuario/vibra-app.git)
    ```
2.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```
3.  **Generar traducciones (si se modifican los .arb):**
    ```bash
    flutter gen-l10n
    ```
4.  **Ejecutar la aplicación:**
    ```bash
    flutter run
    ```

---

## 👥 Equipo

* **Product Owner:** [Tu Nombre]
* **Lead Developer:** [Tu Nombre]

---
*Proyecto Intermodular - Desarrollo de Aplicaciones Multiplataforma*