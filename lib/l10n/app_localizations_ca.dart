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
  String get loginSpotify => 'Inicia amb Spotify';

  @override
  String get loginGoogle => 'Inicia amb Google';

  @override
  String get loginLoading => 'Carregant...';

  @override
  String get loginTerms =>
      'En continuar, acceptes els nostres Termes i Política de privadesa.';

  @override
  String loginError(String error) {
    return 'Error en iniciar sessió: $error';
  }

  @override
  String homeSearchHint(String country) {
    return 'Cerca a $country...';
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
    return 'Perquè escoltes a $artist...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TENDÈNCIES A $country';
  }

  @override
  String get homeSectionTrendsSub => 'El més popular de la setmana';

  @override
  String get homeSectionWeekend => 'JA ÉS FINDE!';

  @override
  String get homeSectionWeekendSub => 'Plans per a aquest cap de setmana';

  @override
  String get homeSectionDiscover => 'DESCOBREIX MÉS';

  @override
  String get homeSectionDiscoverSub => 'Explora nous gèneres';

  @override
  String get homeSectionCollections => 'EXPLORA VIBRAS';

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
  String get prefsSearchHint => 'Cerca artista (ex: Bad Bunny)...';

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
  String get calendarBtnSelect => 'ESCOLLIR DATA';

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
  String get detailDoorsOpen => 'Obertura portes';

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
      'Ves al concert que t\'interessi i prem “Comprar entrada”. Podràs triar el mètode de pagament i confirmar.';

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
  String get helpTut2 => 'Utilitzar les teves entrades';

  @override
  String get helpTut3 => 'Sincronitzar calendari';

  @override
  String get helpSupportContact => 'Contactar Suport';

  @override
  String get helpSupportReport => 'Reportar Problema';

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
  String get settingsDialogAjustes => 'Ajustos';

  @override
  String get commonError => 'Hi ha hagut un error';

  @override
  String get commonSuccess => 'Desat amb èxit';

  @override
  String get privacyTransparencyTitle => 'Transparència de Dades';

  @override
  String get privacyTransparencyDesc =>
      'A Vibra, valorem la teva privadesa. Aquí et mostrem quina informació es comparteix i amb quina finalitat.';

  @override
  String get privacyProfile => 'Perfil Públic';

  @override
  String get privacyProfileDesc =>
      'El teu nom i foto són visibles si comparteixes esdeveniments.';

  @override
  String get privacyLocation => 'Ubicació';

  @override
  String get privacyLocationDesc =>
      'Només s\'utilitza per mostrar-te concerts propers.';

  @override
  String get privacyAnalytics => 'Analítiques';

  @override
  String get privacyAnalyticsDesc =>
      'Dades anònimes d\'ús per millorar l\'app.';

  @override
  String get dialogDeleteTitle => 'Eliminar compte?';

  @override
  String get dialogDeleteBody =>
      'Aquesta acció és irreversible. S\'esborraran totes les teves dades i entrades.';

  @override
  String get dialogDeleteBtn => 'Eliminar';

  @override
  String get dialogCancel => 'Cancel·lar';

  @override
  String get dialogGenerating => 'Generant arxiu...';

  @override
  String get dialogError => 'Ha ocorregut un error inesperat.';

  @override
  String get snackDeleteSuccess => 'El teu compte ha estat eliminat.';

  @override
  String get snackDeleteReauth =>
      'Per seguretat, tanca sessió i torna a entrar per eliminar el compte.';

  @override
  String get shareDataText => 'Aquí tens les teves dades exportades de Vibra.';

  @override
  String get dialogPermissionTitle => 'Permisos necessaris';

  @override
  String get dialogPermissionContent =>
      'Per activar aquestes notificacions, necessites donar permís als ajustos del sistema.';

  @override
  String get dialogSettingsBtn => 'Ajustos';

  @override
  String get notifPreviewTitle => 'Vista prèvia de notificació';

  @override
  String get notifPreviewBody =>
      'Així és com veuràs les alertes a la teva pantalla de bloqueig:';

  @override
  String get btnActivate => 'Activar';

  @override
  String get notifGeneralTitle => 'Novetats Vibra';

  @override
  String get notifGeneralBody =>
      'L\'app s\'ha actualitzat! Descobreix el nou mode fosc i millores.';

  @override
  String get notifReminderTitle => '📅 És demà!';

  @override
  String get notifReminderBody =>
      'El teu esdeveniment desat \'Bad Bunny - World Tour\' és demà. Tens les teves entrades?';

  @override
  String get notifTicketsTitle => '🎟️ Entrades Disponibles';

  @override
  String get notifTicketsBody =>
      'Corre! Han sortit noves entrades per \'Taylor Swift\'. No te les perdis!';

  @override
  String get timeNow => 'Ara';

  @override
  String get time5min => 'Fa 5 min';

  @override
  String get time1min => 'Fa 1 min';

  @override
  String get regionTitle => 'Selecciona la teva Regió';

  @override
  String get regionSearchHint => 'Cerca país...';

  @override
  String regionExplore(String name) {
    return 'Explora $name';
  }

  @override
  String get regionDialogCityBody =>
      'Busques concerts en una ciutat específica?';

  @override
  String get regionDialogCityHint => 'Ex: Madrid, Barcelona...';

  @override
  String get regionBtnWholeCountry => 'Veure tot el país';

  @override
  String get regionBtnApply => 'Aplicar';

  @override
  String get regionOptionWholeCountry => 'Tot el país';

  @override
  String regionOptionWholeCountrySub(String name) {
    return 'Veure concerts a tot $name';
  }

  @override
  String get regionHeaderPopular => 'CIUTATS POPULARS';

  @override
  String get regionHeaderOther => 'ALTRA UBICACIÓ';

  @override
  String get regionOptionManual => 'Escriure una altra ciutat...';

  @override
  String get regionManualTitle => 'Escriure ciutat';

  @override
  String get regionManualHint => 'Ex: Benidorm';

  @override
  String get regionManualSearch => 'Cercar';

  @override
  String get songRecListening => 'Escoltant...';

  @override
  String get songRecCancel => 'Cancel·lar';

  @override
  String get songRecRetry => 'Reintentar';

  @override
  String get songRecOpenSpotify => 'OBRIR A SPOTIFY';

  @override
  String get songRecTryAgain => 'Tornar a provar';

  @override
  String get songRecClose => 'Tancar';

  @override
  String get nearbyEventsTitle => 'Esdeveniments Propers';

  @override
  String get nearbyEventsPermissionDenied =>
      'Es requereixen permisos d\'ubicació.';

  @override
  String get nearbyEventsPermissionPermanentlyDenied =>
      'Permisos d\'ubicació denegats permanentment. Si us plau, habilita\'ls als ajustos.';

  @override
  String get nearbyEventsLocationError =>
      'No s\'ha pogut obtenir la ubicació actual.';

  @override
  String nearbyEventsRadius(int km) {
    return 'Radi de cerca: $km km';
  }

  @override
  String get nearbyEventsNoEvents => 'No s\'han trobat esdeveniments propers.';

  @override
  String get nearbyEventsViewDetails => 'Veure Detalls';

  @override
  String get songRecUpcomingEvents => 'PROPERS ESDEVENIMENTS';

  @override
  String get songRecNoEvents => 'No hi ha concerts propers.';

  @override
  String get songRecErrorLoadingEvents =>
      'No s\'ha pogut carregar la info de concerts.';

  @override
  String get songRecNoMatch => 'No s\'ha trobat cap coincidència.';

  @override
  String get songRecErrorInit => 'No s\'ha pogut iniciar el reconeixement.';

  @override
  String get songRecNoResponse => 'No s\'ha rebut resposta.';

  @override
  String get songRecErrorGeneric => 'Error desconegut';

  @override
  String get songRecOpenSpotifyError => 'No s\'ha pogut obrir Spotify';

  @override
  String get songRecOpenTicket => 'Obrir';

  @override
  String songRecSearchArtistEvents(Object artist) {
    return 'Cercant esdeveniments de $artist...';
  }

  @override
  String get nearbyEventsMusicOnly => 'Només Música';

  @override
  String get nearbyEventsLocationDisabled => 'Ubicació desactivada.';

  @override
  String nearbyEventsCount(int count) {
    return '$count esdeveniments';
  }

  @override
  String get nearbyEventsDaysAhead => 'Propers dies:';

  @override
  String get nearbyEventsTimeRange30Days => '30 dies';

  @override
  String get nearbyEventsTimeRange60Days => '60 dies';

  @override
  String get nearbyEventsTimeRange3Months => '3 mesos';

  @override
  String get nearbyEventsTimeRange6Months => '6 mesos';

  @override
  String get nearbyEventsTimeRange1Year => '1 any';

  @override
  String get nearbyEventsRetry => 'Reintentar';

  @override
  String get nearbyEventsLoadError => 'Error en carregar esdeveniments.';

  @override
  String get songRecNoDatesAvailable => 'No hi ha dates disponibles.';

  @override
  String get songRecListenAgain => 'Escoltar de nou';

  @override
  String get commonMonthShort1 => 'GEN';

  @override
  String get commonMonthShort2 => 'FEB';

  @override
  String get commonMonthShort3 => 'MAR';

  @override
  String get commonMonthShort4 => 'ABR';

  @override
  String get commonMonthShort5 => 'MAI';

  @override
  String get commonMonthShort6 => 'JUN';

  @override
  String get commonMonthShort7 => 'JUL';

  @override
  String get commonMonthShort8 => 'AGO';

  @override
  String get commonMonthShort9 => 'SET';

  @override
  String get commonMonthShort10 => 'OCT';

  @override
  String get commonMonthShort11 => 'NOV';

  @override
  String get commonMonthShort12 => 'DES';
}
