import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Vibra'**
  String get appTitle;

  /// No description provided for @loginSpotify.
  ///
  /// In es, this message translates to:
  /// **'Iniciar con Spotify'**
  String get loginSpotify;

  /// No description provided for @loginGoogle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar con Google'**
  String get loginGoogle;

  /// No description provided for @loginLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loginLoading;

  /// No description provided for @loginTerms.
  ///
  /// In es, this message translates to:
  /// **'Al continuar, aceptas nuestros Términos y Política de privacidad.'**
  String get loginTerms;

  /// No description provided for @loginError.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión: {error}'**
  String loginError(String error);

  /// No description provided for @homeSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar en {country}...'**
  String homeSearchHint(String country);

  /// No description provided for @homeGreeting.
  ///
  /// In es, this message translates to:
  /// **'Hola, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeVibeTitle.
  ///
  /// In es, this message translates to:
  /// **'Explora {vibe}'**
  String homeVibeTitle(String vibe);

  /// No description provided for @vibeBest.
  ///
  /// In es, this message translates to:
  /// **'lo mejor'**
  String get vibeBest;

  /// No description provided for @homeSectionArtists.
  ///
  /// In es, this message translates to:
  /// **'TUS ARTISTAS'**
  String get homeSectionArtists;

  /// No description provided for @homeSectionArtistsSub.
  ///
  /// In es, this message translates to:
  /// **'Basado en lo que más escuchas'**
  String get homeSectionArtistsSub;

  /// No description provided for @homeSectionForYou.
  ///
  /// In es, this message translates to:
  /// **'SOLO PARA TI'**
  String get homeSectionForYou;

  /// No description provided for @homeSectionForYouSub.
  ///
  /// In es, this message translates to:
  /// **'Porque escuchas a {artist}...'**
  String homeSectionForYouSub(String artist);

  /// No description provided for @homeSectionTrends.
  ///
  /// In es, this message translates to:
  /// **'TENDENCIAS EN {country}'**
  String homeSectionTrends(String country);

  /// No description provided for @homeSectionTrendsSub.
  ///
  /// In es, this message translates to:
  /// **'Lo más popular de la semana'**
  String get homeSectionTrendsSub;

  /// No description provided for @homeSectionWeekend.
  ///
  /// In es, this message translates to:
  /// **'¡YA ES FINDE!'**
  String get homeSectionWeekend;

  /// No description provided for @homeSectionWeekendSub.
  ///
  /// In es, this message translates to:
  /// **'Planes para este fin de semana'**
  String get homeSectionWeekendSub;

  /// No description provided for @homeSectionDiscover.
  ///
  /// In es, this message translates to:
  /// **'DESCUBRE MÁS'**
  String get homeSectionDiscover;

  /// No description provided for @homeSectionDiscoverSub.
  ///
  /// In es, this message translates to:
  /// **'Explora nuevos géneros'**
  String get homeSectionDiscoverSub;

  /// No description provided for @homeSectionCollections.
  ///
  /// In es, this message translates to:
  /// **'EXPLORA VIBRAS'**
  String get homeSectionCollections;

  /// No description provided for @homeSectionCollectionsSub.
  ///
  /// In es, this message translates to:
  /// **'Encuentra tu plan ideal'**
  String get homeSectionCollectionsSub;

  /// No description provided for @homeBtnShowMore.
  ///
  /// In es, this message translates to:
  /// **'Mostrar más eventos'**
  String get homeBtnShowMore;

  /// No description provided for @homeBtnViewAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todos los eventos'**
  String get homeBtnViewAll;

  /// No description provided for @homeTextNoMore.
  ///
  /// In es, this message translates to:
  /// **'No hay más eventos de {keyword}'**
  String homeTextNoMore(String keyword);

  /// No description provided for @homeTextEnd.
  ///
  /// In es, this message translates to:
  /// **'¡Has llegado al final!'**
  String get homeTextEnd;

  /// No description provided for @homeErrorNoEvents.
  ///
  /// In es, this message translates to:
  /// **'No hay eventos en {country}'**
  String homeErrorNoEvents(String country);

  /// No description provided for @homeBtnRetryCountry.
  ///
  /// In es, this message translates to:
  /// **'Ver eventos en España'**
  String get homeBtnRetryCountry;

  /// No description provided for @homeSearchNoResults.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado nada'**
  String get homeSearchNoResults;

  /// No description provided for @homeSearchClear.
  ///
  /// In es, this message translates to:
  /// **'Borrar búsqueda'**
  String get homeSearchClear;

  /// No description provided for @menuAccount.
  ///
  /// In es, this message translates to:
  /// **'Mi Cuenta'**
  String get menuAccount;

  /// No description provided for @menuSaved.
  ///
  /// In es, this message translates to:
  /// **'Eventos guardados'**
  String get menuSaved;

  /// No description provided for @menuSettings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get menuSettings;

  /// No description provided for @menuHelp.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get menuHelp;

  /// No description provided for @menuLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get menuLogout;

  /// No description provided for @menuEditProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get menuEditProfile;

  /// No description provided for @prefsTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Hola, {name}! 🎧'**
  String prefsTitle(String name);

  /// No description provided for @prefsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Personaliza tu feed. ¿Qué te mueve?'**
  String get prefsSubtitle;

  /// No description provided for @prefsSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar artista (ej: Bad Bunny)...'**
  String get prefsSearchHint;

  /// No description provided for @prefsYourArtists.
  ///
  /// In es, this message translates to:
  /// **'Tus Artistas:'**
  String get prefsYourArtists;

  /// No description provided for @prefsGenres.
  ///
  /// In es, this message translates to:
  /// **'Géneros y Estilos:'**
  String get prefsGenres;

  /// No description provided for @prefsBtnStart.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get prefsBtnStart;

  /// No description provided for @accountTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Cuenta'**
  String get accountTitle;

  /// No description provided for @accountConnection.
  ///
  /// In es, this message translates to:
  /// **'CONEXIÓN ACTIVA'**
  String get accountConnection;

  /// No description provided for @accountLinked.
  ///
  /// In es, this message translates to:
  /// **'Cuenta vinculada correctamente'**
  String get accountLinked;

  /// No description provided for @accountOpenProfile.
  ///
  /// In es, this message translates to:
  /// **'Abrir perfil en {service}'**
  String accountOpenProfile(String service);

  /// No description provided for @calendarTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo quieres salir?'**
  String get calendarTitle;

  /// No description provided for @calendarToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get calendarToday;

  /// No description provided for @calendarTomorrow.
  ///
  /// In es, this message translates to:
  /// **'Mañana'**
  String get calendarTomorrow;

  /// No description provided for @calendarWeek.
  ///
  /// In es, this message translates to:
  /// **'Esta semana'**
  String get calendarWeek;

  /// No description provided for @calendarMonth.
  ///
  /// In es, this message translates to:
  /// **'Próximos 30 días'**
  String get calendarMonth;

  /// No description provided for @calendarBtnSelect.
  ///
  /// In es, this message translates to:
  /// **'ESCOGER FECHA'**
  String get calendarBtnSelect;

  /// No description provided for @rangeTitle.
  ///
  /// In es, this message translates to:
  /// **'EVENTOS DISPONIBLES'**
  String get rangeTitle;

  /// No description provided for @detailEventTitle.
  ///
  /// In es, this message translates to:
  /// **'Evento'**
  String get detailEventTitle;

  /// No description provided for @detailBtnLike.
  ///
  /// In es, this message translates to:
  /// **'Me gusta'**
  String get detailBtnLike;

  /// No description provided for @detailBtnSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get detailBtnSave;

  /// No description provided for @detailBtnSaved.
  ///
  /// In es, this message translates to:
  /// **'Guardado'**
  String get detailBtnSaved;

  /// No description provided for @detailBtnShare.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get detailBtnShare;

  /// No description provided for @detailInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get detailInfoTitle;

  /// No description provided for @detailAgeRestricted.
  ///
  /// In es, this message translates to:
  /// **'Mayores de 18 años (DNI requerido).'**
  String get detailAgeRestricted;

  /// No description provided for @detailOrganizedBy.
  ///
  /// In es, this message translates to:
  /// **'Organizado por {venue}'**
  String detailOrganizedBy(String venue);

  /// No description provided for @detailLocationTitle.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get detailLocationTitle;

  /// No description provided for @detailDoorsOpen.
  ///
  /// In es, this message translates to:
  /// **'Apertura puertas'**
  String get detailDoorsOpen;

  /// No description provided for @detailViewMap.
  ///
  /// In es, this message translates to:
  /// **'Ver mapa'**
  String get detailViewMap;

  /// No description provided for @detailRelatedEvents.
  ///
  /// In es, this message translates to:
  /// **'Otras fechas / Gira'**
  String get detailRelatedEvents;

  /// No description provided for @detailCheckPrices.
  ///
  /// In es, this message translates to:
  /// **'Ver precios'**
  String get detailCheckPrices;

  /// No description provided for @detailFree.
  ///
  /// In es, this message translates to:
  /// **'GRATIS'**
  String get detailFree;

  /// No description provided for @detailCheckWeb.
  ///
  /// In es, this message translates to:
  /// **'Consulta en web'**
  String get detailCheckWeb;

  /// No description provided for @detailBtnBuy.
  ///
  /// In es, this message translates to:
  /// **'COMPRAR ENTRADAS'**
  String get detailBtnBuy;

  /// No description provided for @editProfileChangePhoto.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto'**
  String get editProfileChangePhoto;

  /// No description provided for @editProfileName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get editProfileName;

  /// No description provided for @editProfileNickname.
  ///
  /// In es, this message translates to:
  /// **'Apodo'**
  String get editProfileNickname;

  /// No description provided for @editProfileSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get editProfileSave;

  /// No description provided for @editProfileCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get editProfileCancel;

  /// No description provided for @editProfileSuccess.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado correctamente'**
  String get editProfileSuccess;

  /// No description provided for @editProfileImageNotImplemented.
  ///
  /// In es, this message translates to:
  /// **'Funcionalidad de subir imagen no implementada'**
  String get editProfileImageNotImplemented;

  /// No description provided for @helpSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar ayuda...'**
  String get helpSearchHint;

  /// No description provided for @helpMainSubtitle.
  ///
  /// In es, this message translates to:
  /// **'¿En qué podemos ayudarte hoy?'**
  String get helpMainSubtitle;

  /// No description provided for @helpSectionFaq.
  ///
  /// In es, this message translates to:
  /// **'PREGUNTAS FRECUENTES'**
  String get helpSectionFaq;

  /// No description provided for @helpSectionTutorials.
  ///
  /// In es, this message translates to:
  /// **'TUTORIALES RÁPIDOS'**
  String get helpSectionTutorials;

  /// No description provided for @helpSectionSupport.
  ///
  /// In es, this message translates to:
  /// **'SOPORTE Y LEGAL'**
  String get helpSectionSupport;

  /// No description provided for @helpFaq1Q.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo compro una entrada?'**
  String get helpFaq1Q;

  /// No description provided for @helpFaq1A.
  ///
  /// In es, this message translates to:
  /// **'Ve al concierto que te interese y pulsa en “Comprar entrada”. Podrás elegir el método de pago y confirmar.'**
  String get helpFaq1A;

  /// No description provided for @helpFaq2Q.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo gestiono mis notificaciones?'**
  String get helpFaq2Q;

  /// No description provided for @helpFaq2A.
  ///
  /// In es, this message translates to:
  /// **'En el apartado Notificaciones podrás habilitar avisos de conciertos, artistas y recomendaciones.'**
  String get helpFaq2A;

  /// No description provided for @helpFaq3Q.
  ///
  /// In es, this message translates to:
  /// **'Invitar amigos'**
  String get helpFaq3Q;

  /// No description provided for @helpFaq3A.
  ///
  /// In es, this message translates to:
  /// **'En la página del evento, pulsa “Invitar amigos” para enviarles una notificación directa.'**
  String get helpFaq3A;

  /// No description provided for @helpTut1.
  ///
  /// In es, this message translates to:
  /// **'Guía de compra'**
  String get helpTut1;

  /// No description provided for @helpTut2.
  ///
  /// In es, this message translates to:
  /// **'Usar tus tickets'**
  String get helpTut2;

  /// No description provided for @helpTut3.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar calendario'**
  String get helpTut3;

  /// No description provided for @helpSupportContact.
  ///
  /// In es, this message translates to:
  /// **'Contactar Soporte'**
  String get helpSupportContact;

  /// No description provided for @helpSupportReport.
  ///
  /// In es, this message translates to:
  /// **'Reportar Problema'**
  String get helpSupportReport;

  /// No description provided for @helpSupportTerms.
  ///
  /// In es, this message translates to:
  /// **'Términos y condiciones'**
  String get helpSupportTerms;

  /// No description provided for @savedEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'No tienes conciertos guardados'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptySub.
  ///
  /// In es, this message translates to:
  /// **'¡Dale al icono de guardar en la Home!'**
  String get savedEmptySub;

  /// No description provided for @savedPriceInfo.
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get savedPriceInfo;

  /// No description provided for @settingsLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @settingsHeaderNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get settingsHeaderNotifications;

  /// No description provided for @settingsGeneralNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones generales'**
  String get settingsGeneralNotifications;

  /// No description provided for @settingsEventReminders.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios de eventos'**
  String get settingsEventReminders;

  /// No description provided for @settingsTicketReleases.
  ///
  /// In es, this message translates to:
  /// **'Lanzamiento de entradas'**
  String get settingsTicketReleases;

  /// No description provided for @settingsHeaderPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Privacidad'**
  String get settingsHeaderPrivacy;

  /// No description provided for @settingsLocationPermissions.
  ///
  /// In es, this message translates to:
  /// **'Permisos de ubicación'**
  String get settingsLocationPermissions;

  /// No description provided for @settingsSharedData.
  ///
  /// In es, this message translates to:
  /// **'Datos compartidos'**
  String get settingsSharedData;

  /// No description provided for @settingsDownloadData.
  ///
  /// In es, this message translates to:
  /// **'Descargar mis datos'**
  String get settingsDownloadData;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsHeaderPrefs.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get settingsHeaderPrefs;

  /// No description provided for @settingsThemeMode.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get settingsThemeMode;

  /// No description provided for @settingsLargeText.
  ///
  /// In es, this message translates to:
  /// **'Texto grande'**
  String get settingsLargeText;

  /// No description provided for @settingsDialogAjustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsDialogAjustes;

  /// No description provided for @commonError.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error'**
  String get commonError;

  /// No description provided for @commonSuccess.
  ///
  /// In es, this message translates to:
  /// **'Guardado con éxito'**
  String get commonSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
