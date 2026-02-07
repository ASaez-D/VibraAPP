import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

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
    Locale('ca'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
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
  /// **'Mi cuenta'**
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

  /// Título de bienvenida en la pantalla de preferencias
  ///
  /// In es, this message translates to:
  /// **'¡Hola, {name}!'**
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

  /// No description provided for @privacyTransparencyTitle.
  ///
  /// In es, this message translates to:
  /// **'Transparencia de Datos'**
  String get privacyTransparencyTitle;

  /// No description provided for @privacyTransparencyDesc.
  ///
  /// In es, this message translates to:
  /// **'En Vibra, valoramos tu privacidad. Aquí te mostramos qué información se comparte y con qué fin.'**
  String get privacyTransparencyDesc;

  /// No description provided for @privacyProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil Público'**
  String get privacyProfile;

  /// No description provided for @privacyProfileDesc.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre y foto son visibles si compartes eventos.'**
  String get privacyProfileDesc;

  /// No description provided for @privacyLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get privacyLocation;

  /// No description provided for @privacyLocationDesc.
  ///
  /// In es, this message translates to:
  /// **'Solo se usa para mostrarte conciertos cercanos.'**
  String get privacyLocationDesc;

  /// No description provided for @privacyAnalytics.
  ///
  /// In es, this message translates to:
  /// **'Analíticas'**
  String get privacyAnalytics;

  /// No description provided for @privacyAnalyticsDesc.
  ///
  /// In es, this message translates to:
  /// **'Datos anónimos de uso para mejorar la app.'**
  String get privacyAnalyticsDesc;

  /// No description provided for @dialogDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar cuenta?'**
  String get dialogDeleteTitle;

  /// No description provided for @dialogDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible. Se borrarán todos tus datos y entradas.'**
  String get dialogDeleteBody;

  /// No description provided for @dialogDeleteBtn.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get dialogDeleteBtn;

  /// No description provided for @dialogCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get dialogCancel;

  /// No description provided for @dialogGenerating.
  ///
  /// In es, this message translates to:
  /// **'Generando archivo...'**
  String get dialogGenerating;

  /// No description provided for @dialogError.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado.'**
  String get dialogError;

  /// No description provided for @snackDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta ha sido eliminada.'**
  String get snackDeleteSuccess;

  /// No description provided for @snackDeleteReauth.
  ///
  /// In es, this message translates to:
  /// **'Por seguridad, cierra sesión y vuelve a entrar para eliminar la cuenta.'**
  String get snackDeleteReauth;

  /// No description provided for @shareDataText.
  ///
  /// In es, this message translates to:
  /// **'Aquí tienes tus datos exportados de Vibra.'**
  String get shareDataText;

  /// No description provided for @dialogPermissionTitle.
  ///
  /// In es, this message translates to:
  /// **'Permisos necesarios'**
  String get dialogPermissionTitle;

  /// No description provided for @dialogPermissionContent.
  ///
  /// In es, this message translates to:
  /// **'Para activar estas notificaciones, necesitas dar permiso en los ajustes del sistema.'**
  String get dialogPermissionContent;

  /// No description provided for @dialogSettingsBtn.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get dialogSettingsBtn;

  /// No description provided for @notifPreviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Vista previa de notificación'**
  String get notifPreviewTitle;

  /// No description provided for @notifPreviewBody.
  ///
  /// In es, this message translates to:
  /// **'Así es como verás las alertas en tu pantalla de bloqueo:'**
  String get notifPreviewBody;

  /// No description provided for @btnActivate.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get btnActivate;

  /// No description provided for @notifGeneralTitle.
  ///
  /// In es, this message translates to:
  /// **'Novedades Vibra'**
  String get notifGeneralTitle;

  /// No description provided for @notifGeneralBody.
  ///
  /// In es, this message translates to:
  /// **'¡La app se ha actualizado! Descubre el nuevo modo oscuro y mejoras.'**
  String get notifGeneralBody;

  /// No description provided for @notifReminderTitle.
  ///
  /// In es, this message translates to:
  /// **'📅 ¡Es mañana!'**
  String get notifReminderTitle;

  /// No description provided for @notifReminderBody.
  ///
  /// In es, this message translates to:
  /// **'Tu evento guardado \'Bad Bunny - World Tour\' es mañana. ¿Tienes tus entradas?'**
  String get notifReminderBody;

  /// No description provided for @notifTicketsTitle.
  ///
  /// In es, this message translates to:
  /// **'🎟️ Entradas Disponibles'**
  String get notifTicketsTitle;

  /// No description provided for @notifTicketsBody.
  ///
  /// In es, this message translates to:
  /// **'¡Corre! Han salido nuevas entradas para \'Taylor Swift\'. ¡No te quedes sin ellas!'**
  String get notifTicketsBody;

  /// No description provided for @timeNow.
  ///
  /// In es, this message translates to:
  /// **'Ahora'**
  String get timeNow;

  /// No description provided for @time5min.
  ///
  /// In es, this message translates to:
  /// **'Hace 5 min'**
  String get time5min;

  /// No description provided for @time1min.
  ///
  /// In es, this message translates to:
  /// **'Hace 1 min'**
  String get time1min;

  /// No description provided for @regionTitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu Región'**
  String get regionTitle;

  /// No description provided for @regionSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar país...'**
  String get regionSearchHint;

  /// No description provided for @regionExplore.
  ///
  /// In es, this message translates to:
  /// **'Explora {name}'**
  String regionExplore(String name);

  /// No description provided for @regionDialogCityBody.
  ///
  /// In es, this message translates to:
  /// **'¿Buscas conciertos en una ciudad específica?'**
  String get regionDialogCityBody;

  /// No description provided for @regionDialogCityHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Madrid, Barcelona...'**
  String get regionDialogCityHint;

  /// No description provided for @regionBtnWholeCountry.
  ///
  /// In es, this message translates to:
  /// **'Ver todo el país'**
  String get regionBtnWholeCountry;

  /// No description provided for @regionBtnApply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get regionBtnApply;

  /// No description provided for @regionOptionWholeCountry.
  ///
  /// In es, this message translates to:
  /// **'Todo el país'**
  String get regionOptionWholeCountry;

  /// No description provided for @regionOptionWholeCountrySub.
  ///
  /// In es, this message translates to:
  /// **'Ver conciertos en todo {name}'**
  String regionOptionWholeCountrySub(String name);

  /// No description provided for @regionHeaderPopular.
  ///
  /// In es, this message translates to:
  /// **'CIUDADES POPULARES'**
  String get regionHeaderPopular;

  /// No description provided for @regionHeaderOther.
  ///
  /// In es, this message translates to:
  /// **'OTRA UBICACIÓN'**
  String get regionHeaderOther;

  /// No description provided for @regionOptionManual.
  ///
  /// In es, this message translates to:
  /// **'Escribir otra ciudad...'**
  String get regionOptionManual;

  /// No description provided for @regionManualTitle.
  ///
  /// In es, this message translates to:
  /// **'Escriure ciutat'**
  String get regionManualTitle;

  /// No description provided for @regionManualHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Benidorm'**
  String get regionManualHint;

  /// No description provided for @regionManualSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get regionManualSearch;

  /// No description provided for @songRecListening.
  ///
  /// In es, this message translates to:
  /// **'Escuchando...'**
  String get songRecListening;

  /// No description provided for @songRecCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get songRecCancel;

  /// No description provided for @songRecRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get songRecRetry;

  /// No description provided for @songRecOpenSpotify.
  ///
  /// In es, this message translates to:
  /// **'ESCUCHAR EN SPOTIFY'**
  String get songRecOpenSpotify;

  /// No description provided for @songRecTryAgain.
  ///
  /// In es, this message translates to:
  /// **'Intentar de nuevo'**
  String get songRecTryAgain;

  /// No description provided for @songRecClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get songRecClose;

  /// No description provided for @songRecUpcomingEvents.
  ///
  /// In es, this message translates to:
  /// **'PRÓXIMOS EVENTOS'**
  String get songRecUpcomingEvents;

  /// No description provided for @songRecNoEvents.
  ///
  /// In es, this message translates to:
  /// **'No hay conciertos próximos.'**
  String get songRecNoEvents;

  /// No description provided for @songRecErrorLoadingEvents.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la info de conciertos.'**
  String get songRecErrorLoadingEvents;

  /// No description provided for @songRecNoMatch.
  ///
  /// In es, this message translates to:
  /// **'No se encontró ninguna coincidencia.'**
  String get songRecNoMatch;

  /// No description provided for @songRecErrorInit.
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar el reconocimiento.'**
  String get songRecErrorInit;

  /// No description provided for @songRecNoResponse.
  ///
  /// In es, this message translates to:
  /// **'No se recibió respuesta.'**
  String get songRecNoResponse;

  /// No description provided for @songRecErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Error desconocido'**
  String get songRecErrorGeneric;

  /// No description provided for @songRecOpenSpotifyError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir Spotify'**
  String get songRecOpenSpotifyError;

  /// No description provided for @songRecOpenTicket.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get songRecOpenTicket;

  /// No description provided for @songRecSearchArtistEvents.
  ///
  /// In es, this message translates to:
  /// **'Buscando eventos de {artist}...'**
  String songRecSearchArtistEvents(Object artist);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ca',
    'de',
    'en',
    'es',
    'fr',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
