// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vibra';

  @override
  String get loginSpotify => 'Se connecter avec Spotify';

  @override
  String get loginGoogle => 'Se connecter avec Google';

  @override
  String get loginLoading => 'Chargement...';

  @override
  String get loginTerms =>
      'En continuant, vous acceptez nos Conditions et notre Politique de confidentialité.';

  @override
  String loginError(String error) {
    return 'Erreur de connexion : $error';
  }

  @override
  String homeSearchHint(String country) {
    return 'Rechercher en $country...';
  }

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name';
  }

  @override
  String homeVibeTitle(String vibe) {
    return 'Explorez $vibe';
  }

  @override
  String get vibeBest => 'le meilleur';

  @override
  String get homeSectionArtists => 'VOS ARTISTES';

  @override
  String get homeSectionArtistsSub => 'Basé sur vos écoutes';

  @override
  String get homeSectionForYou => 'JUSTE POUR VOUS';

  @override
  String homeSectionForYouSub(String artist) {
    return 'Parce que vous écoutez $artist...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TENDANCES EN $country';
  }

  @override
  String get homeSectionTrendsSub => 'Le plus populaire cette semaine';

  @override
  String get homeSectionWeekend => 'C\'EST LE WEEK-END !';

  @override
  String get homeSectionWeekendSub => 'Plans pour ce week-end';

  @override
  String get homeSectionDiscover => 'DÉCOUVRIR PLUS';

  @override
  String get homeSectionDiscoverSub => 'Explorez de nouveaux genres';

  @override
  String get homeSectionCollections => 'EXPLOREZ LES VIBRATIONS';

  @override
  String get homeSectionCollectionsSub => 'Trouvez votre plan idéal';

  @override
  String get homeBtnShowMore => 'Afficher plus d\'événements';

  @override
  String get homeBtnViewAll => 'Voir tous les événements';

  @override
  String homeTextNoMore(String keyword) {
    return 'Plus d\'événements pour $keyword';
  }

  @override
  String get homeTextEnd => 'Vous avez atteint la fin !';

  @override
  String homeErrorNoEvents(String country) {
    return 'Aucun événement en $country';
  }

  @override
  String get homeBtnRetryCountry => 'Voir les événements en Espagne';

  @override
  String get homeSearchNoResults => 'Nous n\'avons rien trouvé';

  @override
  String get homeSearchClear => 'Effacer la recherche';

  @override
  String get menuAccount => 'Mon Compte';

  @override
  String get menuSaved => 'Événements enregistrés';

  @override
  String get menuSettings => 'Paramètres';

  @override
  String get menuHelp => 'Aide';

  @override
  String get menuLogout => 'Se déconnecter';

  @override
  String get menuEditProfile => 'Modifier le profil';

  @override
  String prefsTitle(String name) {
    return 'Salut, $name ! 🎧';
  }

  @override
  String get prefsSubtitle =>
      'Personnalisez votre flux. Qu\'est-ce qui vous fait vibrer ?';

  @override
  String get prefsSearchHint => 'Rechercher un artiste (ex: Bad Bunny)...';

  @override
  String get prefsYourArtists => 'Vos Artistes :';

  @override
  String get prefsGenres => 'Genres et Styles :';

  @override
  String get prefsBtnStart => 'Commencer';

  @override
  String get accountTitle => 'Mon Compte';

  @override
  String get accountConnection => 'CONNEXION ACTIVE';

  @override
  String get accountLinked => 'Compte lié avec succès';

  @override
  String accountOpenProfile(String service) {
    return 'Ouvrir le profil sur $service';
  }

  @override
  String get calendarTitle => 'Quand voulez-vous sortir ?';

  @override
  String get calendarToday => 'Aujourd\'hui';

  @override
  String get calendarTomorrow => 'Demain';

  @override
  String get calendarWeek => 'Cette semaine';

  @override
  String get calendarMonth => '30 prochains jours';

  @override
  String get calendarBtnSelect => 'CHOISIR UNE DATE';

  @override
  String get rangeTitle => 'ÉVÉNEMENTS DISPONIBLES';

  @override
  String get detailEventTitle => 'Événement';

  @override
  String get detailBtnLike => 'J\'aime';

  @override
  String get detailBtnSave => 'Enregistrer';

  @override
  String get detailBtnSaved => 'Enregistré';

  @override
  String get detailBtnShare => 'Partager';

  @override
  String get detailInfoTitle => 'Information';

  @override
  String get detailAgeRestricted => '18 ans et plus (ID requis).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organisé par $venue';
  }

  @override
  String get detailLocationTitle => 'Emplacement';

  @override
  String get detailDoorsOpen => 'Ouverture des portes';

  @override
  String get detailViewMap => 'Voir la carte';

  @override
  String get detailRelatedEvents => 'Autres dates / Tournée';

  @override
  String get detailCheckPrices => 'Voir les prix';

  @override
  String get detailFree => 'GRATUIT';

  @override
  String get detailCheckWeb => 'Consulter sur le web';

  @override
  String get detailBtnBuy => 'ACHETER DES BILLETS';

  @override
  String get editProfileChangePhoto => 'Changer la photo';

  @override
  String get editProfileName => 'Nom';

  @override
  String get editProfileNickname => 'Surnom';

  @override
  String get editProfileSave => 'Enregistrer';

  @override
  String get editProfileCancel => 'Annuler';

  @override
  String get editProfileSuccess => 'Profil mis à jour avec succès';

  @override
  String get editProfileImageNotImplemented =>
      'Fonctionnalité de téléchargement d\'image non implémentée';

  @override
  String get helpSearchHint => 'Rechercher de l\'aide...';

  @override
  String get helpMainSubtitle =>
      'Comment pouvons-nous vous aider aujourd\'hui ?';

  @override
  String get helpSectionFaq => 'FOIRE AUX QUESTIONS';

  @override
  String get helpSectionTutorials => 'TUTORIELS RAPIDES';

  @override
  String get helpSectionSupport => 'SUPPORT ET LÉGAL';

  @override
  String get helpFaq1Q => 'Comment acheter un billet ?';

  @override
  String get helpFaq1A =>
      'Allez au concert qui vous intéresse et cliquez sur « Acheter un billet ». Vous pourrez choisir le mode de paiement et confirmer.';

  @override
  String get helpFaq2Q => 'Comment gérer mes notifications ?';

  @override
  String get helpFaq2A =>
      'Dans la section Notifications, vous pouvez activer les alertes pour les concerts, les artistes et les recommandations.';

  @override
  String get helpFaq3Q => 'Inviter des amis';

  @override
  String get helpFaq3A =>
      'Sur la page de l\'événement, cliquez sur « Inviter des amis » pour leur envoyer une notification directe.';

  @override
  String get helpTut1 => 'Guide d\'achat';

  @override
  String get helpTut2 => 'Utiliser vos tickets';

  @override
  String get helpTut3 => 'Synchroniser le calendrier';

  @override
  String get helpSupportContact => 'Contacter le support';

  @override
  String get helpSupportReport => 'Signaler un problème';

  @override
  String get helpSupportTerms => 'Conditions générales';

  @override
  String get savedEmptyTitle => 'Vous n\'avez aucun concert enregistré';

  @override
  String get savedEmptySub =>
      'Appuyez sur l\'icône d\'enregistrement sur l\'accueil !';

  @override
  String get savedPriceInfo => 'Voir plus';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsHeaderNotifications => 'Notifications';

  @override
  String get settingsGeneralNotifications => 'Notifications générales';

  @override
  String get settingsEventReminders => 'Rappels d\'événements';

  @override
  String get settingsTicketReleases => 'Sorties de billets';

  @override
  String get settingsHeaderPrivacy => 'Confidentialité';

  @override
  String get settingsLocationPermissions => 'Autorisations de localisation';

  @override
  String get settingsSharedData => 'Données partagées';

  @override
  String get settingsDownloadData => 'Télécharger mes données';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsHeaderPrefs => 'Préférences';

  @override
  String get settingsThemeMode => 'Mode sombre';

  @override
  String get settingsLargeText => 'Texte agrandi';

  @override
  String get settingsDialogAjustes => 'Paramètres';

  @override
  String get commonError => 'Une erreur est survenue';

  @override
  String get commonSuccess => 'Enregistré avec succès';

  @override
  String get privacyTransparencyTitle => 'Transparence des données';

  @override
  String get privacyTransparencyDesc =>
      'Chez Vibra, nous tenons à votre confidentialité. Voici ce que nous partageons et pourquoi.';

  @override
  String get privacyProfile => 'Profil public';

  @override
  String get privacyProfileDesc =>
      'Votre nom et photo sont visibles si vous partagez des événements.';

  @override
  String get privacyLocation => 'Localisation';

  @override
  String get privacyLocationDesc =>
      'Utilisé uniquement pour vous montrer des concerts à proximité.';

  @override
  String get privacyAnalytics => 'Analytique';

  @override
  String get privacyAnalyticsDesc =>
      'Données d\'utilisation anonymes pour améliorer l\'application.';

  @override
  String get dialogDeleteTitle => 'Supprimer le compte ?';

  @override
  String get dialogDeleteBody =>
      'Cette action est irréversible. Toutes vos données et billets seront supprimés.';

  @override
  String get dialogDeleteBtn => 'Supprimer';

  @override
  String get dialogCancel => 'Annuler';

  @override
  String get dialogGenerating => 'Génération du fichier...';

  @override
  String get dialogError => 'Une erreur inattendue s\'est produite.';

  @override
  String get snackDeleteSuccess => 'Votre compte a été supprimé.';

  @override
  String get snackDeleteReauth =>
      'Par sécurité, veuillez vous déconnecter et vous reconnecter pour supprimer votre compte.';

  @override
  String get shareDataText => 'Voici vos données exportées de Vibra.';
}
