// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vibra';

  @override
  String get loginSpotify => 'Login with Spotify';

  @override
  String get loginGoogle => 'Login with Google';

  @override
  String get loginLoading => 'Loading...';

  @override
  String get loginTerms =>
      'By continuing, you accept our Terms and Privacy Policy.';

  @override
  String loginError(String error) {
    return 'Login error: $error';
  }

  @override
  String homeSearchHint(String country) {
    return 'Search in $country...';
  }

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String homeVibeTitle(String vibe) {
    return 'Explore $vibe';
  }

  @override
  String get vibeBest => 'the best';

  @override
  String get homeSectionArtists => 'YOUR ARTISTS';

  @override
  String get homeSectionArtistsSub => 'Based on your listening history';

  @override
  String get homeSectionForYou => 'JUST FOR YOU';

  @override
  String homeSectionForYouSub(String artist) {
    return 'Because you listen to $artist...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TRENDING IN $country';
  }

  @override
  String get homeSectionTrendsSub => 'This week\'s most popular';

  @override
  String get homeSectionWeekend => 'IT\'S THE WEEKEND!';

  @override
  String get homeSectionWeekendSub => 'Plans for this weekend';

  @override
  String get homeSectionDiscover => 'DISCOVER MORE';

  @override
  String get homeSectionDiscoverSub => 'Explore new genres';

  @override
  String get homeSectionCollections => 'EXPLORE VIBES';

  @override
  String get homeSectionCollectionsSub => 'Find your perfect plan';

  @override
  String get homeBtnShowMore => 'Show more events';

  @override
  String get homeBtnViewAll => 'View all events';

  @override
  String homeTextNoMore(String keyword) {
    return 'No more events for $keyword';
  }

  @override
  String get homeTextEnd => 'You\'ve reached the end!';

  @override
  String homeErrorNoEvents(String country) {
    return 'No events found in $country';
  }

  @override
  String get homeBtnRetryCountry => 'See events in Spain';

  @override
  String get homeSearchNoResults => 'We couldn\'t find anything';

  @override
  String get homeSearchClear => 'Clear search';

  @override
  String get menuAccount => 'My Account';

  @override
  String get menuSaved => 'Saved events';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuHelp => 'Help';

  @override
  String get menuLogout => 'Log out';

  @override
  String get menuEditProfile => 'Edit profile';

  @override
  String prefsTitle(String name) {
    return 'Hi, $name! 🎧';
  }

  @override
  String get prefsSubtitle => 'Customize your feed. What moves you?';

  @override
  String get prefsSearchHint => 'Search artist (e.g. Bad Bunny)...';

  @override
  String get prefsYourArtists => 'Your Artists:';

  @override
  String get prefsGenres => 'Genres and Styles:';

  @override
  String get prefsBtnStart => 'Get Started';

  @override
  String get accountTitle => 'My Account';

  @override
  String get accountConnection => 'ACTIVE CONNECTION';

  @override
  String get accountLinked => 'Account linked successfully';

  @override
  String accountOpenProfile(String service) {
    return 'Open profile in $service';
  }

  @override
  String get calendarTitle => 'When do you want to go out?';

  @override
  String get calendarToday => 'Today';

  @override
  String get calendarTomorrow => 'Tomorrow';

  @override
  String get calendarWeek => 'This week';

  @override
  String get calendarMonth => 'Next 30 days';

  @override
  String get calendarBtnSelect => 'SELECT DATE';

  @override
  String get rangeTitle => 'AVAILABLE EVENTS';

  @override
  String get detailEventTitle => 'Event';

  @override
  String get detailBtnLike => 'Like';

  @override
  String get detailBtnSave => 'Save';

  @override
  String get detailBtnSaved => 'Saved';

  @override
  String get detailBtnShare => 'Share';

  @override
  String get detailInfoTitle => 'Information';

  @override
  String get detailAgeRestricted => '18+ only (ID required).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organized by $venue';
  }

  @override
  String get detailLocationTitle => 'Location';

  @override
  String get detailDoorsOpen => 'Doors open';

  @override
  String get detailViewMap => 'View map';

  @override
  String get detailRelatedEvents => 'Other dates / Tour';

  @override
  String get detailCheckPrices => 'Check prices';

  @override
  String get detailFree => 'FREE';

  @override
  String get detailCheckWeb => 'Check website';

  @override
  String get detailBtnBuy => 'BUY TICKETS';

  @override
  String get editProfileChangePhoto => 'Change photo';

  @override
  String get editProfileName => 'Name';

  @override
  String get editProfileNickname => 'Nickname';

  @override
  String get editProfileSave => 'Save';

  @override
  String get editProfileCancel => 'Cancel';

  @override
  String get editProfileSuccess => 'Profile updated successfully';

  @override
  String get editProfileImageNotImplemented =>
      'Image upload functionality not implemented';

  @override
  String get helpSearchHint => 'Search help...';

  @override
  String get helpMainSubtitle => 'How can we help you today?';

  @override
  String get helpSectionFaq => 'FAQ';

  @override
  String get helpSectionTutorials => 'QUICK TUTORIALS';

  @override
  String get helpSectionSupport => 'SUPPORT & LEGAL';

  @override
  String get helpFaq1Q => 'How do I buy a ticket?';

  @override
  String get helpFaq1A =>
      'Go to the concert you\'re interested in and tap \'Buy Ticket\'. You can choose the payment method and confirm.';

  @override
  String get helpFaq2Q => 'How do I manage my notifications?';

  @override
  String get helpFaq2A =>
      'In the Notifications section, you can enable alerts for concerts, artists, and recommendations.';

  @override
  String get helpFaq3Q => 'Invite friends';

  @override
  String get helpFaq3A =>
      'On the event page, tap \'Invite friends\' to send them a direct notification.';

  @override
  String get helpTut1 => 'Buying guide';

  @override
  String get helpTut2 => 'Using your tickets';

  @override
  String get helpTut3 => 'Sync calendar';

  @override
  String get helpSupportContact => 'Contact Support';

  @override
  String get helpSupportReport => 'Report Issue';

  @override
  String get helpSupportTerms => 'Terms and conditions';

  @override
  String get savedEmptyTitle => 'You have no saved concerts';

  @override
  String get savedEmptySub => 'Hit the save icon on the Home screen!';

  @override
  String get savedPriceInfo => 'See more';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsHeaderNotifications => 'Notifications';

  @override
  String get settingsGeneralNotifications => 'General notifications';

  @override
  String get settingsEventReminders => 'Event reminders';

  @override
  String get settingsTicketReleases => 'Ticket releases';

  @override
  String get settingsHeaderPrivacy => 'Privacy';

  @override
  String get settingsLocationPermissions => 'Location permissions';

  @override
  String get settingsSharedData => 'Shared data';

  @override
  String get settingsDownloadData => 'Download my data';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsHeaderPrefs => 'Preferences';

  @override
  String get settingsThemeMode => 'Dark mode';

  @override
  String get settingsLargeText => 'Large text';

  @override
  String get settingsDialogAjustes => 'Settings';

  @override
  String get commonError => 'An error occurred';

  @override
  String get commonSuccess => 'Saved successfully';

  @override
  String get privacyTransparencyTitle => 'Data Transparency';

  @override
  String get privacyTransparencyDesc =>
      'At Vibra, we value your privacy. Here is what information is shared and why.';

  @override
  String get privacyProfile => 'Public Profile';

  @override
  String get privacyProfileDesc =>
      'Your name and photo are visible if you share events.';

  @override
  String get privacyLocation => 'Location';

  @override
  String get privacyLocationDesc => 'Only used to show you nearby concerts.';

  @override
  String get privacyAnalytics => 'Analytics';

  @override
  String get privacyAnalyticsDesc => 'Anonymous usage data to improve the app.';

  @override
  String get dialogDeleteTitle => 'Delete account?';

  @override
  String get dialogDeleteBody =>
      'This action is irreversible. All your data and tickets will be deleted.';

  @override
  String get dialogDeleteBtn => 'Delete';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogGenerating => 'Generating file...';

  @override
  String get dialogError => 'An unexpected error occurred.';

  @override
  String get snackDeleteSuccess => 'Your account has been deleted.';

  @override
  String get snackDeleteReauth =>
      'For security, log out and log back in to delete the account.';

  @override
  String get shareDataText => 'Here is your exported data from Vibra.';

  @override
  String get dialogPermissionTitle => 'Permissions needed';

  @override
  String get dialogPermissionContent =>
      'To enable these notifications, you need to grant permission in system settings.';

  @override
  String get dialogSettingsBtn => 'Settings';

  @override
  String get notifPreviewTitle => 'Notification preview';

  @override
  String get notifPreviewBody =>
      'This is how alerts will look on your lock screen:';

  @override
  String get btnActivate => 'Activate';

  @override
  String get notifGeneralTitle => 'What\'s new in Vibra';

  @override
  String get notifGeneralBody =>
      'The app has been updated! Discover the new dark mode and improvements.';

  @override
  String get notifReminderTitle => '📅 It\'s tomorrow!';

  @override
  String get notifReminderBody =>
      'Your saved event \'Bad Bunny - World Tour\' is tomorrow. Do you have your tickets?';

  @override
  String get notifTicketsTitle => '🎟️ Tickets Available';

  @override
  String get notifTicketsBody =>
      'Hurry! New tickets for \'Taylor Swift\' have been released. Don\'t miss out!';

  @override
  String get timeNow => 'Now';

  @override
  String get time5min => '5 min ago';

  @override
  String get time1min => '1 min ago';

  @override
  String get regionTitle => 'Select your Region';

  @override
  String get regionSearchHint => 'Search country...';

  @override
  String regionExplore(String name) {
    return 'Explore $name';
  }

  @override
  String get regionDialogCityBody => 'Looking for concerts in a specific city?';

  @override
  String get regionDialogCityHint => 'Ex: Madrid, Barcelona...';

  @override
  String get regionBtnWholeCountry => 'See whole country';

  @override
  String get regionBtnApply => 'Apply';

  @override
  String get regionOptionWholeCountry => 'Whole country';

  @override
  String regionOptionWholeCountrySub(String name) {
    return 'See concerts in all of $name';
  }

  @override
  String get regionHeaderPopular => 'POPULAR CITIES';

  @override
  String get regionHeaderOther => 'OTHER LOCATION';

  @override
  String get regionOptionManual => 'Type another city...';

  @override
  String get regionManualTitle => 'Type city';

  @override
  String get regionManualHint => 'Ex: Benidorm';

  @override
  String get regionManualSearch => 'Search';

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
