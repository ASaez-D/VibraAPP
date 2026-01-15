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
  String get loginLoading => 'Laden...';

  @override
  String get loginTerms =>
      'Indem Sie fortfahren, akzeptieren Sie unsere Bedingungen und Datenschutzrichtlinien.';

  @override
  String loginError(String error) {
    return 'Fehler beim Anmelden: $error';
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
  String get homeSectionDiscover => 'MEHR ENTDECKEN';

  @override
  String get homeSectionDiscoverSub => 'Erkunde neue Genres';

  @override
  String get homeSectionCollections => 'VIBES ERKUNDEN';

  @override
  String get homeSectionCollectionsSub => 'Finde deinen idealen Plan';

  @override
  String get homeBtnShowMore => 'Mehr Events anzeigen';

  @override
  String get homeBtnViewAll => 'Alle Events ansehen';

  @override
  String homeTextNoMore(String keyword) {
    return 'Keine weiteren Events für $keyword';
  }

  @override
  String get homeTextEnd => 'Du hast das Ende erreicht!';

  @override
  String homeErrorNoEvents(String country) {
    return 'Keine Events in $country gefunden';
  }

  @override
  String get homeBtnRetryCountry => 'Events in Spanien ansehen';

  @override
  String get homeSearchNoResults => 'Wir haben nichts gefunden';

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
  String get prefsGenres => 'Genres & Stile:';

  @override
  String get prefsBtnStart => 'Los geht\'s';

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
  String get calendarTitle => 'Wann möchtest du ausgehen?';

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
  String get detailInfoTitle => 'Informationen';

  @override
  String get detailAgeRestricted => 'Ab 18 Jahren (Ausweis erforderlich).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organisiert von $venue';
  }

  @override
  String get detailLocationTitle => 'Standort';

  @override
  String get detailDoorsOpen => 'Einlass';

  @override
  String get detailViewMap => 'Karte anzeigen';

  @override
  String get detailRelatedEvents => 'Andere Termine / Tour';

  @override
  String get detailCheckPrices => 'Preise prüfen';

  @override
  String get detailFree => 'GRATIS';

  @override
  String get detailCheckWeb => 'Auf Website prüfen';

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
      'Bild-Upload-Funktion nicht implementiert';

  @override
  String get helpSearchHint => 'Hilfe suchen...';

  @override
  String get helpMainSubtitle => 'Wie können wir dir heute helfen?';

  @override
  String get helpSectionFaq => 'HÄUFIG GESTELLTE FRAGEN';

  @override
  String get helpSectionTutorials => 'KURZANLEITUNGEN';

  @override
  String get helpSectionSupport => 'SUPPORT & RECHTLICHES';

  @override
  String get helpFaq1Q => 'Wie kaufe ich ein Ticket?';

  @override
  String get helpFaq1A =>
      'Gehe zum gewünschten Konzert und klicke auf „Ticket kaufen“. Wähle eine Zahlungsmethode und bestätige.';

  @override
  String get helpFaq2Q => 'Wie verwalte ich meine Benachrichtigungen?';

  @override
  String get helpFaq2A =>
      'Unter „Benachrichtigungen“ kannst du Hinweise für Konzerte, Künstler und Empfehlungen aktivieren.';

  @override
  String get helpFaq3Q => 'Freunde einladen';

  @override
  String get helpFaq3A =>
      'Klicke auf der Event-Seite auf „Freunde einladen“, um ihnen eine direkte Nachricht zu senden.';

  @override
  String get helpTut1 => 'Kaufanleitung';

  @override
  String get helpTut2 => 'Tickets entwerten';

  @override
  String get helpTut3 => 'Kalender synchronisieren';

  @override
  String get helpSupportContact => 'Support kontaktieren';

  @override
  String get helpSupportReport => 'Problem melden';

  @override
  String get helpSupportTerms => 'AGB';

  @override
  String get savedEmptyTitle => 'Du hast keine gespeicherten Konzerte';

  @override
  String get savedEmptySub =>
      'Klicke auf das Speichern-Symbol auf dem Home-Bildschirm!';

  @override
  String get savedPriceInfo => 'Mehr sehen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsHeaderNotifications => 'Benachrichtigungen';

  @override
  String get settingsGeneralNotifications => 'Allgemeine Benachrichtigungen';

  @override
  String get settingsEventReminders => 'Erinnerungen';

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
}
