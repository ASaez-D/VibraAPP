// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Vibra';

  @override
  String get loginSpotify => 'Mit Spotify anmelden';

  @override
  String get loginGoogle => 'Mit Google anmelden';

  @override
  String get loginLoading => 'Lädt...';

  @override
  String get loginTerms =>
      'Wenn du fortfährst, akzeptierst du unsere AGB und Datenschutzrichtlinie.';

  @override
  String loginError(String error) {
    return 'Anmeldefehler: $error';
  }

  @override
  String homeSearchHint(String country) {
    return 'Suche in $country...';
  }

  @override
  String homeGreeting(String name) {
    return 'Hallo, $name';
  }

  @override
  String homeVibeTitle(String vibe) {
    return 'Entdecke $vibe';
  }

  @override
  String get vibeBest => 'das Beste';

  @override
  String get homeSectionArtists => 'DEINE KÜNSTLER';

  @override
  String get homeSectionArtistsSub => 'Basierend auf deinem Hörverlauf';

  @override
  String get homeSectionForYou => 'NUR FÜR DICH';

  @override
  String homeSectionForYouSub(String artist) {
    return 'Weil du $artist hörst...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TRENDS IN $country';
  }

  @override
  String get homeSectionTrendsSub => 'Das Beliebteste der Woche';

  @override
  String get homeSectionWeekend => 'ENDLICH WOCHENENDE!';

  @override
  String get homeSectionWeekendSub => 'Pläne für dieses Wochenende';

  @override
  String get homeSectionDiscover => 'ENTDECKE MEHR';

  @override
  String get homeSectionDiscoverSub => 'Erkunde neue Genres';

  @override
  String get homeSectionCollections => 'VIBES ERKUNDEN';

  @override
  String get homeSectionCollectionsSub => 'Finde deinen perfekten Plan';

  @override
  String get homeBtnShowMore => 'Mehr Events anzeigen';

  @override
  String get homeBtnViewAll => 'Alle Events ansehen';

  @override
  String homeTextNoMore(String keyword) {
    return 'Keine weiteren Events für $keyword';
  }

  @override
  String get homeTextEnd => 'Du bist am Ende angekommen!';

  @override
  String homeErrorNoEvents(String country) {
    return 'Keine Events in $country gefunden';
  }

  @override
  String get homeBtnRetryCountry => 'Events in Spanien ansehen';

  @override
  String get homeSearchNoResults => 'Wir konnten nichts finden';

  @override
  String get homeSearchClear => 'Suche löschen';

  @override
  String get menuAccount => 'Mein Konto';

  @override
  String get menuSaved => 'Gespeicherte Events';

  @override
  String get menuSettings => 'Einstellungen';

  @override
  String get menuHelp => 'Hilfe';

  @override
  String get menuLogout => 'Abmelden';

  @override
  String get menuEditProfile => 'Profil bearbeiten';

  @override
  String prefsTitle(String name) {
    return 'Hi, $name! 🎧';
  }

  @override
  String get prefsSubtitle => 'Personalisiere deinen Feed. Was bewegt dich?';

  @override
  String get prefsSearchHint => 'Künstler suchen (z.B. Bad Bunny)...';

  @override
  String get prefsYourArtists => 'Deine Künstler:';

  @override
  String get prefsGenres => 'Genres und Stile:';

  @override
  String get prefsBtnStart => 'Loslegen';

  @override
  String get accountTitle => 'Mein Konto';

  @override
  String get accountConnection => 'AKTIVE VERBINDUNG';

  @override
  String get accountLinked => 'Konto erfolgreich verknüpft';

  @override
  String accountOpenProfile(String service) {
    return 'Profil in $service öffnen';
  }

  @override
  String get calendarTitle => 'Wann willst du ausgehen?';

  @override
  String get calendarToday => 'Heute';

  @override
  String get calendarTomorrow => 'Morgen';

  @override
  String get calendarWeek => 'Diese Woche';

  @override
  String get calendarMonth => 'Nächste 30 Tage';

  @override
  String get calendarBtnSelect => 'DATUM WÄHLEN';

  @override
  String get rangeTitle => 'VERFÜGBARE EVENTS';

  @override
  String get detailEventTitle => 'Event';

  @override
  String get detailBtnLike => 'Gefällt mir';

  @override
  String get detailBtnSave => 'Speichern';

  @override
  String get detailBtnSaved => 'Gespeichert';

  @override
  String get detailBtnShare => 'Teilen';

  @override
  String get detailInfoTitle => 'Information';

  @override
  String get detailAgeRestricted => 'Ab 18 Jahren (Ausweis erforderlich).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organisiert von $venue';
  }

  @override
  String get detailLocationTitle => 'Ort';

  @override
  String get detailDoorsOpen => 'Einlass';

  @override
  String get detailViewMap => 'Karte ansehen';

  @override
  String get detailRelatedEvents => 'Andere Termine / Tour';

  @override
  String get detailCheckPrices => 'Preise prüfen';

  @override
  String get detailFree => 'GRATIS';

  @override
  String get detailCheckWeb => 'Auf Webseite prüfen';

  @override
  String get detailBtnBuy => 'TICKETS KAUFEN';

  @override
  String get editProfileChangePhoto => 'Foto ändern';

  @override
  String get editProfileName => 'Name';

  @override
  String get editProfileNickname => 'Spitzname';

  @override
  String get editProfileSave => 'Speichern';

  @override
  String get editProfileCancel => 'Abbrechen';

  @override
  String get editProfileSuccess => 'Profil erfolgreich aktualisiert';

  @override
  String get editProfileImageNotImplemented =>
      'Bild-Upload noch nicht implementiert';

  @override
  String get helpSearchHint => 'Hilfe suchen...';

  @override
  String get helpMainSubtitle => 'Wie können wir dir heute helfen?';

  @override
  String get helpSectionFaq => 'HÄUFIGE FRAGEN';

  @override
  String get helpSectionTutorials => 'SCHNELLSTART';

  @override
  String get helpSectionSupport => 'SUPPORT & RECHTLICHES';

  @override
  String get helpFaq1Q => 'Wie kaufe ich ein Ticket?';

  @override
  String get helpFaq1A =>
      'Gehe zum Konzert und tippe auf „Ticket kaufen“. Wähle die Zahlungsart und bestätige.';

  @override
  String get helpFaq2Q => 'Wie verwalte ich meine Benachrichtigungen?';

  @override
  String get helpFaq2A =>
      'Im Bereich Benachrichtigungen kannst du Alarme für Konzerte und Künstler aktivieren.';

  @override
  String get helpFaq3Q => 'Freunde einladen';

  @override
  String get helpFaq3A =>
      'Tippe auf der Eventseite auf „Freunde einladen“, um eine direkte Benachrichtigung zu senden.';

  @override
  String get helpTut1 => 'Kaufanleitung';

  @override
  String get helpTut2 => 'Tickets nutzen';

  @override
  String get helpTut3 => 'Kalender synchronisieren';

  @override
  String get helpSupportContact => 'Support kontaktieren';

  @override
  String get helpSupportReport => 'Problem melden';

  @override
  String get helpSupportTerms => 'Allgemeine Geschäftsbedingungen';

  @override
  String get savedEmptyTitle => 'Du hast keine gespeicherten Konzerte';

  @override
  String get savedEmptySub => 'Tippe auf das Speicher-Icon auf der Startseite!';

  @override
  String get savedPriceInfo => 'Mehr sehen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsHeaderNotifications => 'Benachrichtigungen';

  @override
  String get settingsGeneralNotifications => 'Allgemeine Benachrichtigungen';

  @override
  String get settingsEventReminders => 'Event-Erinnerungen';

  @override
  String get settingsTicketReleases => 'Ticket-Veröffentlichungen';

  @override
  String get settingsHeaderPrivacy => 'Datenschutz';

  @override
  String get settingsLocationPermissions => 'Standortberechtigungen';

  @override
  String get settingsSharedData => 'Geteilte Daten';

  @override
  String get settingsDownloadData => 'Meine Daten herunterladen';

  @override
  String get settingsDeleteAccount => 'Konto löschen';

  @override
  String get settingsHeaderPrefs => 'Präferenzen';

  @override
  String get settingsThemeMode => 'Dunkelmodus';

  @override
  String get settingsLargeText => 'Großer Text';

  @override
  String get settingsDialogAjustes => 'Einstellungen';

  @override
  String get commonError => 'Ein Fehler ist aufgetreten';

  @override
  String get commonSuccess => 'Erfolgreich gespeichert';

  @override
  String get privacyTransparencyTitle => 'Datentransparenz';

  @override
  String get privacyTransparencyDesc =>
      'Bei Vibra schätzen wir deine Privatsphäre. Hier siehst du, welche Daten geteilt werden.';

  @override
  String get privacyProfile => 'Öffentliches Profil';

  @override
  String get privacyProfileDesc =>
      'Dein Name und Foto sind sichtbar, wenn du Events teilst.';

  @override
  String get privacyLocation => 'Standort';

  @override
  String get privacyLocationDesc =>
      'Wird nur verwendet, um Konzerte in der Nähe anzuzeigen.';

  @override
  String get privacyAnalytics => 'Analysen';

  @override
  String get privacyAnalyticsDesc =>
      'Anonyme Nutzungsdaten zur Verbesserung der App.';

  @override
  String get dialogDeleteTitle => 'Konto löschen?';

  @override
  String get dialogDeleteBody =>
      'Diese Aktion ist unwiderruflich. Alle Daten und Tickets werden gelöscht.';

  @override
  String get dialogDeleteBtn => 'Löschen';

  @override
  String get dialogCancel => 'Abbrechen';

  @override
  String get dialogGenerating => 'Datei wird erstellt...';

  @override
  String get dialogError => 'Ein unerwarteter Fehler ist aufgetreten.';

  @override
  String get snackDeleteSuccess => 'Dein Konto wurde gelöscht.';

  @override
  String get snackDeleteReauth =>
      'Aus Sicherheitsgründen bitte abmelden und erneut anmelden, um das Konto zu löschen.';

  @override
  String get shareDataText => 'Hier sind deine exportierten Daten von Vibra.';

  @override
  String get dialogPermissionTitle => 'Berechtigungen erforderlich';

  @override
  String get dialogPermissionContent =>
      'Um diese Benachrichtigungen zu aktivieren, musst du die Erlaubnis in den Systemeinstellungen geben.';

  @override
  String get dialogSettingsBtn => 'Einstellungen';

  @override
  String get notifPreviewTitle => 'Benachrichtigungsvorschau';

  @override
  String get notifPreviewBody =>
      'So sehen Alarme auf deinem Sperrbildschirm aus:';

  @override
  String get btnActivate => 'Aktivieren';

  @override
  String get notifGeneralTitle => 'Neuigkeiten bei Vibra';

  @override
  String get notifGeneralBody =>
      'Die App wurde aktualisiert! Entdecke den neuen Dunkelmodus und Verbesserungen.';

  @override
  String get notifReminderTitle => '📅 Es ist morgen!';

  @override
  String get notifReminderBody =>
      'Dein gespeichertes Event \'Bad Bunny - World Tour\' ist morgen. Hast du deine Tickets?';

  @override
  String get notifTicketsTitle => '🎟️ Tickets verfügbar';

  @override
  String get notifTicketsBody =>
      'Beeil dich! Neue Tickets für \'Taylor Swift\' sind verfügbar. Verpasse sie nicht!';

  @override
  String get timeNow => 'Jetzt';

  @override
  String get time5min => 'Vor 5 Min.';

  @override
  String get time1min => 'Vor 1 Min.';

  @override
  String get regionTitle => 'Wähle deine Region';

  @override
  String get regionSearchHint => 'Land suchen...';

  @override
  String regionExplore(String name) {
    return 'Entdecke $name';
  }

  @override
  String get regionDialogCityBody =>
      'Suchst du Konzerte in einer bestimmten Stadt?';

  @override
  String get regionDialogCityHint => 'Bsp: Berlin, München...';

  @override
  String get regionBtnWholeCountry => 'Ganzes Land ansehen';

  @override
  String get regionBtnApply => 'Anwenden';

  @override
  String get regionOptionWholeCountry => 'Ganzes Land';

  @override
  String regionOptionWholeCountrySub(String name) {
    return 'Konzerte in ganz $name ansehen';
  }

  @override
  String get regionHeaderPopular => 'BELIEBTE STÄDTE';

  @override
  String get regionHeaderOther => 'ANDERER ORT';

  @override
  String get regionOptionManual => 'Andere Stadt eingeben...';

  @override
  String get regionManualTitle => 'Stadt eingeben';

  @override
  String get regionManualHint => 'Bsp: Stuttgart';

  @override
  String get regionManualSearch => 'Suchen';

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
}
