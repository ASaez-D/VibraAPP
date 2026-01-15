// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

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
  String get menuAccount => 'Mi Cuenta';

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
    return '¡Hola, $name! 🎧';
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
      'Ve al concierto que t\'interese y pulsa en “Comprar entrada”. Podrás elegir el método de pago y confirmar.';

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
}
