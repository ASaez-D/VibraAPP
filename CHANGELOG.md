Changelog - VibraAPP
Todos los cambios notables en este proyecto se documentan en este archivo siguiendo un estándar técnico de versiones y omitiendo fechas por requisitos de entrega.

[v1.0.0] - Versión Final (Optimización y Reconocimiento)
Esta versión representa la culminación del proyecto, integrando reconocimiento de audio avanzado y una interfaz altamente optimizada.

Añadido
ACR Integration (Shazam Upgrade): Implementación del sistema de reconocimiento de música en tiempo real mediante huella digital de audio.

Sistema de Regiones: Lógica completa para el filtrado de eventos por países y regiones geográficas.

Mapa Final: Actualización definitiva de la lógica de mapas y geolocalización.

Traducciones Finales: Pulido de las cadenas de texto en los 6 idiomas soportados.

Modificado
Optimización de Rendimiento: Refactorización profunda de la HomeScreen y la HomePage para minimizar el consumo de recursos.

Refactorización de Servicios: Limpieza técnica de los servicios de TicketMaster, Shazam/ACR y File Logger.

Clean Code: Limpieza integral de las pantallas de Tests, Home y lógica de Services.

Arreglado
Estabilidad General: Resolución de bugs tras la integración de ramas y optimización de las peticiones asíncronas.

[v0.9.0] - Internacionalización y Persistencia
Fase enfocada en el soporte global y la gestión de datos en la nube con Firebase.

Añadido
Soporte Multiidioma (l10n): Localización completa de la app en 6 lenguajes.

Preferencias de Usuario: Integración de Firebase para persistir ajustes de Spotify, Google y configuración general.

SavesEvents: Funcionalidad para guardar conciertos en la cuenta del usuario.

Arreglado
API Spotify: Solución de errores en el manejo de tokens y respuestas del endpoint de Spotify.

Localización: Corrección de bugs en las traducciones dinámicas y carga de idiomas.

Help Screen: Reparación y ajuste de la interfaz de soporte al usuario.

[v0.8.0] - Refinamiento de UI y Estructura
Mejoras visuales y refactorización de los componentes de pantalla.

Añadido
Modo Claro: Soporte para tema visual claro (Light Mode).

Assets: Actualización de recursos gráficos e imágenes de alta resolución.

Modificado
Limpieza de Pantallas: Refactorización de código en:

Login_Screen y Account_Screen

Calendar_Screen y ConcertDetail

Customize_Profile

Interfaz de Cuenta: Rediseño estético del perfil de usuario y fix en la carga de fotos.

[v0.7.0] - Funcionalidades Core y Permisos
Desarrollo de la lógica central de negocio y gestión de seguridad.

Añadido
Gestión de Permisos: Implementación de lógica para acceso a ubicación y datos compartidos.

Navegación Lateral: Menú funcional con gestión de sesiones.

Arreglado
Google Maps: Sincronización de mapas con los filtros de fecha del calendario.

Transacciones: Ajuste de precios y botones de compra en la vista de detalle.

[v0.6.0] - Integración TicketMaster
Conexión con proveedores externos de eventos.

Añadido
API TicketMaster: Mapeo y conexión con el endpoint oficial de eventos.

Vistas de Eventos: Creación de Ticket_Screen y Calendar_Screen.

[v0.5.0] - Autenticación e Inicio
Configuración inicial y acceso de usuarios.

Añadido
Auth Multi-proveedor: Implementación de login con Spotify y Google.

Arquitectura Base: Estructuración del proyecto en carpetas y definición de estilos globales.

[v0.1.0] - Inicialización
Añadido
Creación del repositorio y estructura base del proyecto.