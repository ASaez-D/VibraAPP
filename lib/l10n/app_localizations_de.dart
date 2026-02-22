// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get permManagerTitle => 'Berechtigungsmanager';

  @override
  String get permLocation => 'Standort';

  @override
  String get permCamera => 'Kamera';

  @override
  String get permMicrophone => 'Mikrofon';

  @override
  String get permNotifications => 'Benachrichtigungen';

  @override
  String get permStorage => 'Fotos & Speicher';

  @override
  String get permStatusAllowed => 'Erlaubt';

  @override
  String get permStatusDenied => 'Verweigert';

  @override
  String get permStatusRestricted => 'Eingeschränkt';

  @override
  String get permStatusPermanentlyDenied => 'Dauerhaft verweigert';

  @override
  String get permTip =>
      'Um eine dauerhaft verweigerte Berechtigung zu ändern, müssen Sie zu den Systemeinstellungen gehen.';

  @override
  String get permBtnSettings => 'Einstellungen öffnen';

  @override
  String get permBtnRequest => 'Anfragen';

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
  String get settingsPermissionManager => 'Berechtigungsmanager';

  @override
  String get snackNotificationsEnabled => 'Benachrichtigungen aktiviert';

  @override
  String get inDevelopment => 'Demnächst';

  @override
  String get ticketScreenTitle => 'Meine Tickets';

  @override
  String get navSocial => 'Sozial';

  @override
  String get socialTitle => 'Meine Freunde';

  @override
  String get socialSearchHint => 'Freund suchen...';

  @override
  String get socialStatusOnline => 'Online';

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
  String get songRecListening => 'Zuhören...';

  @override
  String get songRecCancel => 'Abbrechen';

  @override
  String get songRecRetry => 'Wiederholen';

  @override
  String get songRecOpenSpotify => 'IN SPOTIFY ÖFFNEN';

  @override
  String get songRecTryAgain => 'Erneut versuchen';

  @override
  String get songRecClose => 'Schließen';

  @override
  String get nearbyEventsTitle => 'Events in der Nähe';

  @override
  String get nearbyEventsPermissionDenied =>
      'Standortberechtigung erforderlich.';

  @override
  String get nearbyEventsPermissionPermanentlyDenied =>
      'Standortberechtigung dauerhaft verweigert. Bitte in den Einstellungen aktivieren.';

  @override
  String get nearbyEventsLocationError =>
      'Aktueller Standort konnte nicht abgerufen werden.';

  @override
  String nearbyEventsRadius(int km) {
    return 'Suchradius: $km km';
  }

  @override
  String get nearbyEventsNoEvents => 'Keine Events in der Nähe gefunden.';

  @override
  String get nearbyEventsViewDetails => 'Details anzeigen';

  @override
  String get songRecUpcomingEvents => 'NÄCHSTE EVENTS';

  @override
  String get songRecNoEvents => 'Keine kommenden Konzerte.';

  @override
  String get songRecErrorLoadingEvents =>
      'Konzertinfos konnten nicht geladen werden.';

  @override
  String get songRecNoMatch => 'Keine Übereinstimmung gefunden.';

  @override
  String get songRecErrorInit => 'Erkennung konnte nicht gestartet werden.';

  @override
  String get songRecNoResponse => 'Keine Antwort erhalten.';

  @override
  String get songRecErrorGeneric => 'Unbekannter Fehler';

  @override
  String get songRecOpenSpotifyError => 'Spotify konnte nicht geöffnet werden';

  @override
  String get songRecOpenTicket => 'Öffnen';

  @override
  String songRecSearchArtistEvents(Object artist) {
    return 'Suche Events für $artist...';
  }

  @override
  String get nearbyEventsMusicOnly => 'Nur Musik';

  @override
  String get nearbyEventsLocationDisabled => 'Standort deaktiviert.';

  @override
  String nearbyEventsCount(int count) {
    return '$count Events';
  }

  @override
  String get nearbyEventsDaysAhead => 'Nächste Tage:';

  @override
  String get nearbyEventsTimeRange30Days => '30 Tage';

  @override
  String get nearbyEventsTimeRange60Days => '60 Tage';

  @override
  String get nearbyEventsTimeRange3Months => '3 Monate';

  @override
  String get nearbyEventsTimeRange6Months => '6 Monate';

  @override
  String get nearbyEventsTimeRange1Year => '1 Jahr';

  @override
  String get nearbyEventsRetry => 'Wiederholen';

  @override
  String get nearbyEventsLoadError => 'Fehler beim Laden.';

  @override
  String get songRecNoDatesAvailable => 'Keine Termine verfügbar.';

  @override
  String get songRecListenAgain => 'Nochmal hören';

  @override
  String get songRecViewAllEvents => 'ALLE EVENTS ANSEHEN';

  @override
  String get artistEventsSubtitle => 'Bevorstehende Konzerte weltweit';

  @override
  String get artistEventsEmpty => 'Keine geplanten Konzerte';

  @override
  String get commonMonthShort1 => 'JAN';

  @override
  String get commonMonthShort2 => 'FEB';

  @override
  String get commonMonthShort3 => 'MÄR';

  @override
  String get commonMonthShort4 => 'APR';

  @override
  String get commonMonthShort5 => 'MAI';

  @override
  String get commonMonthShort6 => 'JUN';

  @override
  String get commonMonthShort7 => 'JUL';

  @override
  String get commonMonthShort8 => 'AUG';

  @override
  String get commonMonthShort9 => 'SEP';

  @override
  String get commonMonthShort10 => 'OKT';

  @override
  String get commonMonthShort11 => 'NOV';

  @override
  String get commonMonthShort12 => 'DEZ';

  @override
  String get downloadDataTitle => 'Meine Daten exportieren';

  @override
  String get downloadDataShare => 'Teilen';

  @override
  String get downloadDataSave => 'Auf Gerät speichern';

  @override
  String get downloadDataSaved => 'Daten erfolgreich gespeichert';
}
