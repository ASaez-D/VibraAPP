// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Vibra';

  @override
  String get loginSpotify => 'Iniciar amb Spotify';

  @override
  String get loginGoogle => 'Iniciar amb Google';

  @override
  String get loginLoading => 'Carregant...';

  @override
  String get loginTerms =>
      'En continuar, acceptes els nostres Termes i Política de privadesa.';

  @override
  String loginError(String error) {
    return 'Error en iniciar la sessió: $error';
  }

  @override
  String homeSearchHint(String country) {
    return 'Cercar a $country...';
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
  String get vibeBest => 'el millor';

  @override
  String get homeSectionArtists => 'ELS TEUS ARTISTES';

  @override
  String get homeSectionArtistsSub => 'Basat en el que més escoltes';

  @override
  String get homeSectionForYou => 'NOMÉS PER A TU';

  @override
  String homeSectionForYouSub(String artist) {
    return 'Perquè escoltes $artist...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TENDÈNCIES A $country';
  }

  @override
  String get homeSectionTrendsSub => 'El més popular de la setmana';

  @override
  String get homeSectionWeekend => 'JA ÉS CAP DE SETMANA!';

  @override
  String get homeSectionWeekendSub => 'Plans per a aquest cap de setmana';

  @override
  String get homeSectionDiscover => 'DESCOBREIX MÉS';

  @override
  String get homeSectionDiscoverSub => 'Explora nous gèneres';

  @override
  String get homeSectionCollections => 'EXPLORA VIBRES';

  @override
  String get homeSectionCollectionsSub => 'Troba el teu pla ideal';

  @override
  String get homeBtnShowMore => 'Mostrar més esdeveniments';

  @override
  String get homeBtnViewAll => 'Veure tots els esdeveniments';

  @override
  String homeTextNoMore(String keyword) {
    return 'No hi ha més esdeveniments de $keyword';
  }

  @override
  String get homeTextEnd => 'Has arribat al final!';

  @override
  String homeErrorNoEvents(String country) {
    return 'No hi ha esdeveniments a $country';
  }

  @override
  String get homeBtnRetryCountry => 'Veure esdeveniments a Espanya';

  @override
  String get homeSearchNoResults => 'No hem trobat res';

  @override
  String get homeSearchClear => 'Esborrar cerca';

  @override
  String get menuAccount => 'El meu Compte';

  @override
  String get menuSaved => 'Esdeveniments desats';

  @override
  String get menuSettings => 'Configuració';

  @override
  String get menuHelp => 'Ajuda';

  @override
  String get menuLogout => 'Tancar sessió';

  @override
  String get menuEditProfile => 'Editar perfil';

  @override
  String prefsTitle(String name) {
    return 'Hola, $name! 🎧';
  }

  @override
  String get prefsSubtitle => 'Personalitza el teu feed. Què et mou?';

  @override
  String get prefsSearchHint => 'Cercar artista (ex: Bad Bunny)...';

  @override
  String get prefsYourArtists => 'Els teus Artistes:';

  @override
  String get prefsGenres => 'Gèneres i Estils:';

  @override
  String get prefsBtnStart => 'Començar';

  @override
  String get accountTitle => 'El meu Compte';

  @override
  String get accountConnection => 'CONNEXIÓ ACTIVA';

  @override
  String get accountLinked => 'Compte vinculat correctament';

  @override
  String accountOpenProfile(String service) {
    return 'Obrir perfil a $service';
  }

  @override
  String get calendarTitle => 'Quan vols sortir?';

  @override
  String get calendarToday => 'Avui';

  @override
  String get calendarTomorrow => 'Demà';

  @override
  String get calendarWeek => 'Aquesta setmana';

  @override
  String get calendarMonth => 'Propers 30 dies';

  @override
  String get calendarBtnSelect => 'TRIAR DATA';

  @override
  String get rangeTitle => 'ESDEVENIMENTS DISPONIBLES';

  @override
  String get detailEventTitle => 'Esdeveniment';

  @override
  String get detailBtnLike => 'M\'agrada';

  @override
  String get detailBtnSave => 'Desar';

  @override
  String get detailBtnSaved => 'Desat';

  @override
  String get detailBtnShare => 'Compartir';

  @override
  String get detailInfoTitle => 'Informació';

  @override
  String get detailAgeRestricted => 'Majors de 18 anys (DNI requerit).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organitzat per $venue';
  }

  @override
  String get detailLocationTitle => 'Ubicació';

  @override
  String get detailDoorsOpen => 'Obertura de portes';

  @override
  String get detailViewMap => 'Veure mapa';

  @override
  String get detailRelatedEvents => 'Altres dates / Gira';

  @override
  String get detailCheckPrices => 'Veure preus';

  @override
  String get detailFree => 'GRATIS';

  @override
  String get detailCheckWeb => 'Consulta al web';

  @override
  String get detailBtnBuy => 'COMPRAR ENTRADES';

  @override
  String get editProfileChangePhoto => 'Canviar foto';

  @override
  String get editProfileName => 'Nom';

  @override
  String get editProfileNickname => 'Sobrenom';

  @override
  String get editProfileSave => 'Desar';

  @override
  String get editProfileCancel => 'Cancel·lar';

  @override
  String get editProfileSuccess => 'Perfil actualitzat correctament';

  @override
  String get editProfileImageNotImplemented =>
      'Funcionalitat de pujar imatge no implementada';

  @override
  String get helpSearchHint => 'Cercar ajuda...';

  @override
  String get helpMainSubtitle => 'En què et podem ajudar avui?';

  @override
  String get helpSectionFaq => 'PREGUNTES FREQÜENTS';

  @override
  String get helpSectionTutorials => 'TUTORIALS RÀPIDS';

  @override
  String get helpSectionSupport => 'SUPORT I LEGAL';

  @override
  String get helpFaq1Q => 'Com compro una entrada?';

  @override
  String get helpFaq1A =>
      'Vés al concert que t\'interessi i prem a “Comprar entrada”. Podràs triar el mètode de pagament i confirmar.';

  @override
  String get helpFaq2Q => 'Com gestiono les meves notificacions?';

  @override
  String get helpFaq2A =>
      'A l\'apartat Notificacions podràs habilitar avisos de concerts, artistes i recomanacions.';

  @override
  String get helpFaq3Q => 'Convidar amics';

  @override
  String get helpFaq3A =>
      'A la pàgina de l\'esdeveniment, prem “Convidar amics” per enviar-los una notificació directa.';

  @override
  String get helpTut1 => 'Guia de compra';

  @override
  String get helpTut2 => 'Usar els teus tiquets';

  @override
  String get helpTut3 => 'Sincronitzar calendari';

  @override
  String get helpSupportContact => 'Contactar amb Suport';

  @override
  String get helpSupportReport => 'Informar d\'un problema';

  @override
  String get helpSupportTerms => 'Termes i condicions';

  @override
  String get savedEmptyTitle => 'No tens concerts desats';

  @override
  String get savedEmptySub => 'Prem la icona de desar a la Home!';

  @override
  String get savedPriceInfo => 'Veure més';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsHeaderNotifications => 'Notificacions';

  @override
  String get settingsGeneralNotifications => 'Notificacions generals';

  @override
  String get settingsEventReminders => 'Recordatoris d\'esdeveniments';

  @override
  String get settingsTicketReleases => 'Llançament d\'entrades';

  @override
  String get settingsHeaderPrivacy => 'Privadesa';

  @override
  String get settingsLocationPermissions => 'Permisos d\'ubicació';

  @override
  String get settingsSharedData => 'Dades compartides';

  @override
  String get settingsDownloadData => 'Descarregar les meves dades';

  @override
  String get settingsDeleteAccount => 'Eliminar compte';

  @override
  String get settingsHeaderPrefs => 'Preferències';

  @override
  String get settingsThemeMode => 'Mode fosc';

  @override
  String get settingsLargeText => 'Text gran';

  @override
  String get settingsDialogAjustes => 'Configuració';

  @override
  String get commonError => 'S\'ha produït un error';

  @override
  String get commonSuccess => 'Desat amb èxit';
}
