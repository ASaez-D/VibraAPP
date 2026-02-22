// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get permManagerTitle => 'Gestor de Permisos';

  @override
  String get permLocation => 'Ubicación';

  @override
  String get permCamera => 'Cámara';

  @override
  String get permMicrophone => 'Micrófono';

  @override
  String get permNotifications => 'Notificaciones';

  @override
  String get permStorage => 'Fotos y Almacenamiento';

  @override
  String get permStatusAllowed => 'Permitido';

  @override
  String get permStatusDenied => 'Denegado';

  @override
  String get permStatusRestricted => 'Restringido';

  @override
  String get permStatusPermanentlyDenied => 'Denegado permanentemente';

  @override
  String get permTip =>
      'Para cambiar un permiso denegado permanentemente, debes ir a los ajustes del sistema.';

  @override
  String get permBtnSettings => 'Abrir Ajustes';

  @override
  String get permBtnRequest => 'Solicitar';

  @override
  String get appTitle => 'Vibra';

  @override
  String get loginSpotify => 'Iniciar con Spotify';

  @override
  String get loginGoogle => 'Iniciar con Google';

  @override
  String get loginLoading => 'Cargando...';

  @override
  String get loginTerms =>
      'Al continuar, aceptas nuestros Términos y Política de privacidad.';

  @override
  String loginError(String error) {
    return 'Error al iniciar sesión: $error';
  }

  @override
  String homeSearchHint(String country) {
    return 'Buscar en $country...';
  }

  @override
  String homeGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String homeVibeTitle(String vibe) {
    return 'Explora $vibe';
  }

  @override
  String get vibeBest => 'lo mejor';

  @override
  String get homeSectionArtists => 'TUS ARTISTAS';

  @override
  String get homeSectionArtistsSub => 'Basado en lo que más escuchas';

  @override
  String get homeSectionForYou => 'SOLO PARA TI';

  @override
  String homeSectionForYouSub(String artist) {
    return 'Porque escuchas a $artist...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TENDENCIAS EN $country';
  }

  @override
  String get homeSectionTrendsSub => 'Lo más popular de la semana';

  @override
  String get homeSectionWeekend => '¡YA ES FINDE!';

  @override
  String get homeSectionWeekendSub => 'Planes para este fin de semana';

  @override
  String get homeSectionDiscover => 'DESCUBRE MÁS';

  @override
  String get homeSectionDiscoverSub => 'Explora nuevos géneros';

  @override
  String get homeSectionCollections => 'EXPLORA VIBRAS';

  @override
  String get homeSectionCollectionsSub => 'Encuentra tu plan ideal';

  @override
  String get homeBtnShowMore => 'Mostrar más eventos';

  @override
  String get homeBtnViewAll => 'Ver todos los eventos';

  @override
  String homeTextNoMore(String keyword) {
    return 'No hay más eventos de $keyword';
  }

  @override
  String get homeTextEnd => '¡Has llegado al final!';

  @override
  String homeErrorNoEvents(String country) {
    return 'No hay eventos en $country';
  }

  @override
  String get homeBtnRetryCountry => 'Ver eventos en España';

  @override
  String get homeSearchNoResults => 'No hemos encontrado nada';

  @override
  String get homeSearchClear => 'Borrar búsqueda';

  @override
  String get menuAccount => 'Mi cuenta';

  @override
  String get menuSaved => 'Eventos guardados';

  @override
  String get menuSettings => 'Configuración';

  @override
  String get menuHelp => 'Ayuda';

  @override
  String get menuLogout => 'Cerrar sesión';

  @override
  String get menuEditProfile => 'Editar perfil';

  @override
  String prefsTitle(String name) {
    return '¡Hola, $name!';
  }

  @override
  String get prefsSubtitle => 'Personaliza tu feed. ¿Qué te mueve?';

  @override
  String get prefsSearchHint => 'Buscar artista (ej: Bad Bunny)...';

  @override
  String get prefsYourArtists => 'Tus Artistas:';

  @override
  String get prefsGenres => 'Géneros y Estilos:';

  @override
  String get prefsBtnStart => 'Comenzar';

  @override
  String get accountTitle => 'Mi Cuenta';

  @override
  String get accountConnection => 'CONEXIÓN ACTIVA';

  @override
  String get accountLinked => 'Cuenta vinculada correctamente';

  @override
  String accountOpenProfile(String service) {
    return 'Abrir perfil en $service';
  }

  @override
  String get calendarTitle => '¿Cuándo quieres salir?';

  @override
  String get calendarToday => 'Hoy';

  @override
  String get calendarTomorrow => 'Mañana';

  @override
  String get calendarWeek => 'Esta semana';

  @override
  String get calendarMonth => 'Próximos 30 días';

  @override
  String get calendarBtnSelect => 'ESCOGER FECHA';

  @override
  String get rangeTitle => 'EVENTOS DISPONIBLES';

  @override
  String get detailEventTitle => 'Evento';

  @override
  String get detailBtnLike => 'Me gusta';

  @override
  String get detailBtnSave => 'Guardar';

  @override
  String get detailBtnSaved => 'Guardado';

  @override
  String get detailBtnShare => 'Compartir';

  @override
  String get detailInfoTitle => 'Información';

  @override
  String get detailAgeRestricted => 'Mayores de 18 años (DNI requerido).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organizado por $venue';
  }

  @override
  String get detailLocationTitle => 'Ubicación';

  @override
  String get detailDoorsOpen => 'Apertura puertas';

  @override
  String get detailViewMap => 'Ver mapa';

  @override
  String get detailRelatedEvents => 'Otras fechas / Gira';

  @override
  String get detailCheckPrices => 'Ver precios';

  @override
  String get detailFree => 'GRATIS';

  @override
  String get detailCheckWeb => 'Consulta en web';

  @override
  String get detailBtnBuy => 'COMPRAR ENTRADAS';

  @override
  String get editProfileChangePhoto => 'Cambiar foto';

  @override
  String get editProfileName => 'Nombre';

  @override
  String get editProfileNickname => 'Apodo';

  @override
  String get editProfileSave => 'Guardar';

  @override
  String get editProfileCancel => 'Cancelar';

  @override
  String get editProfileSuccess => 'Perfil actualizado correctamente';

  @override
  String get editProfileImageNotImplemented =>
      'Funcionalidad de subir imagen no implementada';

  @override
  String get helpSearchHint => 'Buscar ayuda...';

  @override
  String get helpMainSubtitle => '¿En qué podemos ayudarte hoy?';

  @override
  String get helpSectionFaq => 'PREGUNTAS FRECUENTES';

  @override
  String get helpSectionTutorials => 'TUTORIALES RÁPIDOS';

  @override
  String get helpSectionSupport => 'SOPORTE Y LEGAL';

  @override
  String get helpFaq1Q => '¿Cómo compro una entrada?';

  @override
  String get helpFaq1A =>
      'Ve al concierto que te interese y pulsa en “Comprar entrada”. Podrás elegir el método de pago y confirmar.';

  @override
  String get helpFaq2Q => '¿Cómo gestiono mis notificaciones?';

  @override
  String get helpFaq2A =>
      'En el apartado Notificaciones podrás habilitar avisos de conciertos, artistas y recomendaciones.';

  @override
  String get helpFaq3Q => 'Invitar amigos';

  @override
  String get helpFaq3A =>
      'En la página del evento, pulsa “Invitar amigos” para enviarles una notificación directa.';

  @override
  String get helpTut1 => 'Guía de compra';

  @override
  String get helpTut2 => 'Usar tus tickets';

  @override
  String get helpTut3 => 'Sincronizar calendario';

  @override
  String get helpSupportContact => 'Contactar Soporte';

  @override
  String get helpSupportReport => 'Reportar Problema';

  @override
  String get helpSupportTerms => 'Términos y condiciones';

  @override
  String get savedEmptyTitle => 'No tienes conciertos guardados';

  @override
  String get savedEmptySub => '¡Dale al icono de guardar en la Home!';

  @override
  String get savedPriceInfo => 'Ver más';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsHeaderNotifications => 'Notificaciones';

  @override
  String get settingsGeneralNotifications => 'Notificaciones generales';

  @override
  String get settingsEventReminders => 'Recordatorios de eventos';

  @override
  String get settingsTicketReleases => 'Lanzamiento de entradas';

  @override
  String get settingsHeaderPrivacy => 'Privacidad';

  @override
  String get settingsLocationPermissions => 'Permisos de ubicación';

  @override
  String get settingsSharedData => 'Datos compartidos';

  @override
  String get settingsDownloadData => 'Descargar mis datos';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsHeaderPrefs => 'Preferencias';

  @override
  String get settingsThemeMode => 'Modo oscuro';

  @override
  String get settingsLargeText => 'Texto grande';

  @override
  String get settingsDialogAjustes => 'Ajustes';

  @override
  String get commonError => 'Ha ocurrido un error';

  @override
  String get commonSuccess => 'Guardado con éxito';

  @override
  String get privacyTransparencyTitle => 'Transparencia de Datos';

  @override
  String get privacyTransparencyDesc =>
      'En Vibra, valoramos tu privacidad. Aquí te mostramos qué información se comparte y con qué fin.';

  @override
  String get privacyProfile => 'Perfil Público';

  @override
  String get privacyProfileDesc =>
      'Tu nombre y foto son visibles si compartes eventos.';

  @override
  String get privacyLocation => 'Ubicación';

  @override
  String get privacyLocationDesc =>
      'Solo se usa para mostrarte conciertos cercanos.';

  @override
  String get privacyAnalytics => 'Analíticas';

  @override
  String get privacyAnalyticsDesc =>
      'Datos anónimos de uso para mejorar la app.';

  @override
  String get dialogDeleteTitle => '¿Eliminar cuenta?';

  @override
  String get dialogDeleteBody =>
      'Esta acción es irreversible. Se borrarán todos tus datos y entradas.';

  @override
  String get dialogDeleteBtn => 'Eliminar';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogGenerating => 'Generando archivo...';

  @override
  String get dialogError => 'Ocurrió un error inesperado.';

  @override
  String get snackDeleteSuccess => 'Tu cuenta ha sido eliminada.';

  @override
  String get snackDeleteReauth =>
      'Por seguridad, cierra sesión y vuelve a entrar para eliminar la cuenta.';

  @override
  String get shareDataText => 'Aquí tienes tus datos exportados de Vibra.';

  @override
  String get dialogPermissionTitle => 'Permisos necesarios';

  @override
  String get dialogPermissionContent =>
      'Para activar estas notificaciones, necesitas dar permiso en los ajustes del sistema.';

  @override
  String get dialogSettingsBtn => 'Ajustes';

  @override
  String get notifPreviewTitle => 'Vista previa de notificación';

  @override
  String get notifPreviewBody =>
      'Así es como verás las alertas en tu pantalla de bloqueo:';

  @override
  String get btnActivate => 'Activar';

  @override
  String get notifGeneralTitle => 'Novedades Vibra';

  @override
  String get notifGeneralBody =>
      '¡La app se ha actualizado! Descubre el nuevo modo oscuro y mejoras.';

  @override
  String get notifReminderTitle => '📅 ¡Es mañana!';

  @override
  String get notifReminderBody =>
      'Tu evento guardado \'Bad Bunny - World Tour\' es mañana. ¿Tienes tus entradas?';

  @override
  String get notifTicketsTitle => '🎟️ Entradas Disponibles';

  @override
  String get notifTicketsBody =>
      '¡Corre! Han salido nuevas entradas para \'Taylor Swift\'. ¡No te quedes sin ellas!';

  @override
  String get timeNow => 'Ahora';

  @override
  String get time5min => 'Hace 5 min';

  @override
  String get time1min => 'Hace 1 min';

  @override
  String get settingsPermissionManager => 'Gestor de permisos';

  @override
  String get snackNotificationsEnabled => 'Notificaciones activadas';

  @override
  String get inDevelopment => 'Próximamente';

  @override
  String get ticketScreenTitle => 'Mis Entradas';

  @override
  String get navSocial => 'Social';

  @override
  String get socialTitle => 'Mis Amigos';

  @override
  String get socialSearchHint => 'Buscar amigo...';

  @override
  String get socialStatusOnline => 'En línea';

  @override
  String get regionTitle => 'Selecciona tu Región';

  @override
  String get regionSearchHint => 'Buscar país...';

  @override
  String regionExplore(String name) {
    return 'Explora $name';
  }

  @override
  String get regionDialogCityBody =>
      '¿Buscas conciertos en una ciudad específica?';

  @override
  String get regionDialogCityHint => 'Ej: Madrid, Barcelona...';

  @override
  String get regionBtnWholeCountry => 'Ver todo el país';

  @override
  String get regionBtnApply => 'Aplicar';

  @override
  String get regionOptionWholeCountry => 'Todo el país';

  @override
  String regionOptionWholeCountrySub(String name) {
    return 'Ver conciertos en todo $name';
  }

  @override
  String get regionHeaderPopular => 'CIUDADES POPULARES';

  @override
  String get regionHeaderOther => 'OTRA UBICACIÓN';

  @override
  String get regionOptionManual => 'Escribir otra ciudad...';

  @override
  String get regionManualTitle => 'Escriure ciutat';

  @override
  String get regionManualHint => 'Ej: Benidorm';

  @override
  String get regionManualSearch => 'Buscar';

  @override
  String get songRecListening => 'Escuchando...';

  @override
  String get songRecCancel => 'Cancelar';

  @override
  String get songRecRetry => 'Reintentar';

  @override
  String get songRecOpenSpotify => 'ESCUCHAR EN SPOTIFY';

  @override
  String get songRecTryAgain => 'Intentar de nuevo';

  @override
  String get songRecClose => 'Cerrar';

  @override
  String get nearbyEventsTitle => 'Eventos Cercanos';

  @override
  String get nearbyEventsPermissionDenied =>
      'Se requieren permisos de ubicación.';

  @override
  String get nearbyEventsPermissionPermanentlyDenied =>
      'Permisos de ubicación denegados permanentemente. Por favor, habilítalos en ajustes.';

  @override
  String get nearbyEventsLocationError =>
      'No se pudo obtener la ubicación actual.';

  @override
  String nearbyEventsRadius(int km) {
    return 'Radio de búsqueda: $km km';
  }

  @override
  String get nearbyEventsNoEvents => 'No se encontraron eventos cercanos.';

  @override
  String get nearbyEventsViewDetails => 'Ver Detalles';

  @override
  String get songRecUpcomingEvents => 'PRÓXIMOS EVENTOS';

  @override
  String get songRecNoEvents => 'No hay conciertos próximos.';

  @override
  String get songRecErrorLoadingEvents =>
      'No se pudo cargar la info de conciertos.';

  @override
  String get songRecNoMatch => 'No se encontró ninguna coincidencia.';

  @override
  String get songRecErrorInit => 'No se pudo iniciar el reconocimiento.';

  @override
  String get songRecNoResponse => 'No se recibió respuesta.';

  @override
  String get songRecErrorGeneric => 'Error desconocido';

  @override
  String get songRecOpenSpotifyError => 'No se pudo abrir Spotify';

  @override
  String get songRecOpenTicket => 'Abrir';

  @override
  String songRecSearchArtistEvents(Object artist) {
    return 'Buscando eventos de $artist...';
  }

  @override
  String get nearbyEventsMusicOnly => 'Solo Música';

  @override
  String get nearbyEventsLocationDisabled => 'Ubicación desactivada.';

  @override
  String nearbyEventsCount(int count) {
    return '$count eventos';
  }

  @override
  String get nearbyEventsDaysAhead => 'Próximos días:';

  @override
  String get nearbyEventsTimeRange30Days => '30 días';

  @override
  String get nearbyEventsTimeRange60Days => '60 días';

  @override
  String get nearbyEventsTimeRange3Months => '3 meses';

  @override
  String get nearbyEventsTimeRange6Months => '6 meses';

  @override
  String get nearbyEventsTimeRange1Year => '1 año';

  @override
  String get nearbyEventsRetry => 'Reintentar';

  @override
  String get nearbyEventsLoadError => 'Error al cargar eventos.';

  @override
  String get songRecNoDatesAvailable => 'No hay fechas disponibles.';

  @override
  String get songRecListenAgain => 'Escuchar otra vez';

  @override
  String get songRecViewAllEvents => 'VER TODOS LOS EVENTOS';

  @override
  String get artistEventsSubtitle => 'Próximos conciertos a nivel global';

  @override
  String get artistEventsEmpty => 'No hay conciertos programados';

  @override
  String get commonMonthShort1 => 'ENE';

  @override
  String get commonMonthShort2 => 'FEB';

  @override
  String get commonMonthShort3 => 'MAR';

  @override
  String get commonMonthShort4 => 'ABR';

  @override
  String get commonMonthShort5 => 'MAY';

  @override
  String get commonMonthShort6 => 'JUN';

  @override
  String get commonMonthShort7 => 'JUL';

  @override
  String get commonMonthShort8 => 'AGO';

  @override
  String get commonMonthShort9 => 'SEP';

  @override
  String get commonMonthShort10 => 'OCT';

  @override
  String get commonMonthShort11 => 'NOV';

  @override
  String get commonMonthShort12 => 'DIC';

  @override
  String get downloadDataTitle => 'Exportar mis datos';

  @override
  String get downloadDataShare => 'Compartir';

  @override
  String get downloadDataSave => 'Guardar en dispositivo';

  @override
  String get downloadDataSaved => 'Datos guardados correctamente';
}
