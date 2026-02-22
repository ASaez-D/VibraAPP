// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get permManagerTitle => 'Gestionnaire de permissions';

  @override
  String get permLocation => 'Localisation';

  @override
  String get permCamera => 'Caméra';

  @override
  String get permMicrophone => 'Microphone';

  @override
  String get permNotifications => 'Notifications';

  @override
  String get permStorage => 'Photos et Stockage';

  @override
  String get permStatusAllowed => 'Autorisé';

  @override
  String get permStatusDenied => 'Refusé';

  @override
  String get permStatusRestricted => 'Restreint';

  @override
  String get permStatusPermanentlyDenied => 'Refusé définitivement';

  @override
  String get permTip =>
      'Pour modifier une permission refusée définitivement, vous devez aller dans les paramètres système.';

  @override
  String get permBtnSettings => 'Ouvrir les paramètres';

  @override
  String get permBtnRequest => 'Demander';

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
  String get homeSectionForYou => 'RIEN QUE POUR VOUS';

  @override
  String homeSectionForYouSub(String artist) {
    return 'Parce que vous écoutez $artist...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TENDANCES EN $country';
  }

  @override
  String get homeSectionTrendsSub => 'Le plus populaire de la semaine';

  @override
  String get homeSectionWeekend => 'C\'EST ENFIN LE WEEK-END !';

  @override
  String get homeSectionWeekendSub => 'Plans pour ce week-end';

  @override
  String get homeSectionDiscover => 'DÉCOUVRIR PLUS';

  @override
  String get homeSectionDiscoverSub => 'Explorez de nouveaux genres';

  @override
  String get homeSectionCollections => 'EXPLOREZ DES VIBES';

  @override
  String get homeSectionCollectionsSub => 'Trouvez votre plan idéal';

  @override
  String get homeBtnShowMore => 'Voir plus d\'événements';

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
    return 'Aucun événement trouvé en $country';
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
  String get calendarMonth => 'Les 30 prochains jours';

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
  String get detailAgeRestricted =>
      'Plus de 18 ans (Pièce d\'identité requise).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organisé par $venue';
  }

  @override
  String get detailLocationTitle => 'Lieu';

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
  String get detailCheckWeb => 'Voir sur le web';

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
  String get helpSectionFaq => 'QUESTIONS FRÉQUENTES';

  @override
  String get helpSectionTutorials => 'TUTORIELS RAPIDES';

  @override
  String get helpSectionSupport => 'SUPPORT ET LÉGAL';

  @override
  String get helpFaq1Q => 'Comment acheter un billet ?';

  @override
  String get helpFaq1A =>
      'Allez sur le concert qui vous intéresse et appuyez sur « Acheter un billet ». Vous pourrez choisir le mode de paiement et confirmer.';

  @override
  String get helpFaq2Q => 'Comment gérer mes notifications ?';

  @override
  String get helpFaq2A =>
      'Dans la section Notifications, vous pouvez activer les alertes pour les concerts, les artistes et les recommandations.';

  @override
  String get helpFaq3Q => 'Inviter des amis';

  @override
  String get helpFaq3A =>
      'Sur la page de l\'événement, appuyez sur « Inviter des amis » pour leur envoyer une notification directe.';

  @override
  String get helpTut1 => 'Guide d\'achat';

  @override
  String get helpTut2 => 'Utiliser vos billets';

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
      'Appuyez sur l\'icône d\'enregistrement sur l\'écran d\'accueil !';

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
  String get settingsLocationPermissions => 'Permissions de localisation';

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
  String get settingsLargeText => 'Grand texte';

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
      'Chez Vibra, nous tenons à votre vie privée. Voici quelles informations sont partagées et pourquoi.';

  @override
  String get privacyProfile => 'Profil Public';

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
  String get dialogError => 'Une erreur inattendue est survenue.';

  @override
  String get snackDeleteSuccess => 'Votre compte a été supprimé.';

  @override
  String get snackDeleteReauth =>
      'Par sécurité, déconnectez-vous et reconnectez-vous pour supprimer le compte.';

  @override
  String get shareDataText => 'Voici vos données exportées de Vibra.';

  @override
  String get dialogPermissionTitle => 'Permissions nécessaires';

  @override
  String get dialogPermissionContent =>
      'Pour activer ces notifications, vous devez donner l\'autorisation dans les paramètres système.';

  @override
  String get dialogSettingsBtn => 'Paramètres';

  @override
  String get notifPreviewTitle => 'Aperçu de la notification';

  @override
  String get notifPreviewBody =>
      'Voici à quoi ressembleront les alertes sur votre écran de verrouillage :';

  @override
  String get btnActivate => 'Activer';

  @override
  String get notifGeneralTitle => 'Quoi de neuf sur Vibra';

  @override
  String get notifGeneralBody =>
      'L\'application a été mise à jour ! Découvrez le nouveau mode sombre et les améliorations.';

  @override
  String get notifReminderTitle => '📅 C\'est demain !';

  @override
  String get notifReminderBody =>
      'Votre événement enregistré \'Bad Bunny - World Tour\' est demain. Avez-vous vos billets ?';

  @override
  String get notifTicketsTitle => '🎟️ Billets disponibles';

  @override
  String get notifTicketsBody =>
      'Vite ! De nouveaux billets pour \'Taylor Swift\' sont sortis. Ne manquez pas ça !';

  @override
  String get timeNow => 'Maintenant';

  @override
  String get time5min => 'Il y a 5 min';

  @override
  String get time1min => 'Il y a 1 min';

  @override
  String get settingsPermissionManager => 'Gestionnaire de permissions';

  @override
  String get snackNotificationsEnabled => 'Notifications activées';

  @override
  String get inDevelopment => 'Bientôt disponible';

  @override
  String get ticketScreenTitle => 'Mes Billets';

  @override
  String get navSocial => 'Social';

  @override
  String get socialTitle => 'Mes Amis';

  @override
  String get socialSearchHint => 'Rechercher un ami...';

  @override
  String get socialStatusOnline => 'En ligne';

  @override
  String get regionTitle => 'Sélectionnez votre Région';

  @override
  String get regionSearchHint => 'Rechercher un pays...';

  @override
  String regionExplore(String name) {
    return 'Découvrez $name';
  }

  @override
  String get regionDialogCityBody =>
      'Cherchez-vous des concerts dans une ville spécifique ?';

  @override
  String get regionDialogCityHint => 'Ex : Paris, Lyon...';

  @override
  String get regionBtnWholeCountry => 'Voir tout le pays';

  @override
  String get regionBtnApply => 'Appliquer';

  @override
  String get regionOptionWholeCountry => 'Tout le pays';

  @override
  String regionOptionWholeCountrySub(String name) {
    return 'Voir les concerts dans tout $name';
  }

  @override
  String get regionHeaderPopular => 'VILLES POPULAIRES';

  @override
  String get regionHeaderOther => 'AUTRE LIEU';

  @override
  String get regionOptionManual => 'Saisir une autre ville...';

  @override
  String get regionManualTitle => 'Saisir la ville';

  @override
  String get regionManualHint => 'Ex : Nice';

  @override
  String get regionManualSearch => 'Rechercher';

  @override
  String get songRecListening => 'Écoute...';

  @override
  String get songRecCancel => 'Annuler';

  @override
  String get songRecRetry => 'Réessayer';

  @override
  String get songRecOpenSpotify => 'OUVRIR DANS SPOTIFY';

  @override
  String get songRecTryAgain => 'Réessayer';

  @override
  String get songRecClose => 'Fermer';

  @override
  String get nearbyEventsTitle => 'Événements à proximité';

  @override
  String get nearbyEventsPermissionDenied =>
      'Permission de localisation requise.';

  @override
  String get nearbyEventsPermissionPermanentlyDenied =>
      'Permission de localisation refusée de façon permanente. Veuillez l\'activer dans les paramètres.';

  @override
  String get nearbyEventsLocationError =>
      'Impossible d\'obtenir la localisation actuelle.';

  @override
  String nearbyEventsRadius(int km) {
    return 'Rayon de recherche : $km km';
  }

  @override
  String get nearbyEventsNoEvents => 'Aucun événement trouvé à proximité.';

  @override
  String get nearbyEventsViewDetails => 'Voir Détails';

  @override
  String get songRecUpcomingEvents => 'PROCHAINS ÉVÉNEMENTS';

  @override
  String get songRecNoEvents => 'Pas de prochains concerts.';

  @override
  String get songRecErrorLoadingEvents =>
      'Impossible de charger les infos de concert.';

  @override
  String get songRecNoMatch => 'Aucune correspondance trouvée.';

  @override
  String get songRecErrorInit => 'Impossible d\'initialiser la reconnaissance.';

  @override
  String get songRecNoResponse => 'Aucune réponse reçue.';

  @override
  String get songRecErrorGeneric => 'Erreur inconnue';

  @override
  String get songRecOpenSpotifyError => 'Impossible d\'ouvrir Spotify';

  @override
  String get songRecOpenTicket => 'Ouvrir';

  @override
  String songRecSearchArtistEvents(Object artist) {
    return 'Recherche d\'événements pour $artist...';
  }

  @override
  String get nearbyEventsMusicOnly => 'Musique Seulement';

  @override
  String get nearbyEventsLocationDisabled => 'Localisation désactivée.';

  @override
  String nearbyEventsCount(int count) {
    return '$count événements';
  }

  @override
  String get nearbyEventsDaysAhead => 'Prochains jours :';

  @override
  String get nearbyEventsTimeRange30Days => '30 jours';

  @override
  String get nearbyEventsTimeRange60Days => '60 jours';

  @override
  String get nearbyEventsTimeRange3Months => '3 mois';

  @override
  String get nearbyEventsTimeRange6Months => '6 mois';

  @override
  String get nearbyEventsTimeRange1Year => '1 an';

  @override
  String get nearbyEventsRetry => 'Réessayer';

  @override
  String get nearbyEventsLoadError => 'Erreur de chargement.';

  @override
  String get songRecNoDatesAvailable => 'Pas de dates disponibles.';

  @override
  String get songRecListenAgain => 'Écouter à nouveau';

  @override
  String get songRecViewAllEvents => 'VOIR TOUS LES ÉVÉNEMENTS';

  @override
  String get artistEventsSubtitle => 'Prochains concerts dans le monde';

  @override
  String get artistEventsEmpty => 'Aucun concert programmé';

  @override
  String get commonMonthShort1 => 'JAN';

  @override
  String get commonMonthShort2 => 'FÉV';

  @override
  String get commonMonthShort3 => 'MAR';

  @override
  String get commonMonthShort4 => 'AVR';

  @override
  String get commonMonthShort5 => 'MAI';

  @override
  String get commonMonthShort6 => 'JUIN';

  @override
  String get commonMonthShort7 => 'JUIL';

  @override
  String get commonMonthShort8 => 'AOÛ';

  @override
  String get commonMonthShort9 => 'SEP';

  @override
  String get commonMonthShort10 => 'OCT';

  @override
  String get commonMonthShort11 => 'NOV';

  @override
  String get commonMonthShort12 => 'DÉC';

  @override
  String get downloadDataTitle => 'Exporter mes données';

  @override
  String get downloadDataShare => 'Partager';

  @override
  String get downloadDataSave => 'Enregistrer sur l\'appareil';

  @override
  String get downloadDataSaved => 'Données enregistrées avec succès';
}
