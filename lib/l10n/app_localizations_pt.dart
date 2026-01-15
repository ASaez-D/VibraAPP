// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Vibra';

  @override
  String get loginSpotify => 'Entrar com Spotify';

  @override
  String get loginGoogle => 'Entrar com Google';

  @override
  String get loginLoading => 'Carregando...';

  @override
  String get loginTerms =>
      'Ao continuar, você aceita nossos Termos e Política de Privacidade.';

  @override
  String loginError(String error) {
    return 'Erro ao iniciar sessão: $error';
  }

  @override
  String homeSearchHint(String country) {
    return 'Buscar em $country...';
  }

  @override
  String homeGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String homeVibeTitle(String vibe) {
    return 'Explore $vibe';
  }

  @override
  String get vibeBest => 'o melhor';

  @override
  String get homeSectionArtists => 'SEUS ARTISTAS';

  @override
  String get homeSectionArtistsSub => 'Baseado no que você mais ouve';

  @override
  String get homeSectionForYou => 'SÓ PARA VOCÊ';

  @override
  String homeSectionForYouSub(String artist) {
    return 'Porque você ouve $artist...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TENDÊNCIAS EM $country';
  }

  @override
  String get homeSectionTrendsSub => 'O mais popular da semana';

  @override
  String get homeSectionWeekend => 'FINAL DE SEMANA!';

  @override
  String get homeSectionWeekendSub => 'Planos para este fim de semana';

  @override
  String get homeSectionDiscover => 'DESCUBRA MAIS';

  @override
  String get homeSectionDiscoverSub => 'Explore novos gêneros';

  @override
  String get homeSectionCollections => 'EXPLORE VIBES';

  @override
  String get homeSectionCollectionsSub => 'Encontre seu plano ideal';

  @override
  String get homeBtnShowMore => 'Mostrar mais eventos';

  @override
  String get homeBtnViewAll => 'Ver todos os eventos';

  @override
  String homeTextNoMore(String keyword) {
    return 'Não há mais eventos de $keyword';
  }

  @override
  String get homeTextEnd => 'Você chegou ao fim!';

  @override
  String homeErrorNoEvents(String country) {
    return 'Não há eventos em $country';
  }

  @override
  String get homeBtnRetryCountry => 'Ver eventos na Espanha';

  @override
  String get homeSearchNoResults => 'Não encontramos nada';

  @override
  String get homeSearchClear => 'Limpar busca';

  @override
  String get menuAccount => 'Minha Conta';

  @override
  String get menuSaved => 'Eventos salvos';

  @override
  String get menuSettings => 'Configurações';

  @override
  String get menuHelp => 'Ajuda';

  @override
  String get menuLogout => 'Sair';

  @override
  String get menuEditProfile => 'Editar perfil';

  @override
  String prefsTitle(String name) {
    return 'Olá, $name! 🎧';
  }

  @override
  String get prefsSubtitle => 'Personalize seu feed. O que te move?';

  @override
  String get prefsSearchHint => 'Buscar artista (ex: Bad Bunny)...';

  @override
  String get prefsYourArtists => 'Seus Artistas:';

  @override
  String get prefsGenres => 'Gêneros e Estilos:';

  @override
  String get prefsBtnStart => 'Começar';

  @override
  String get accountTitle => 'Minha Conta';

  @override
  String get accountConnection => 'CONEXÃO ATIVA';

  @override
  String get accountLinked => 'Conta vinculada com sucesso';

  @override
  String accountOpenProfile(String service) {
    return 'Abrir perfil no $service';
  }

  @override
  String get calendarTitle => 'Quando você quer sair?';

  @override
  String get calendarToday => 'Hoje';

  @override
  String get calendarTomorrow => 'Amanhã';

  @override
  String get calendarWeek => 'Esta semana';

  @override
  String get calendarMonth => 'Próximos 30 dias';

  @override
  String get calendarBtnSelect => 'ESCOLHER DATA';

  @override
  String get rangeTitle => 'EVENTOS DISPONÍVEIS';

  @override
  String get detailEventTitle => 'Evento';

  @override
  String get detailBtnLike => 'Curtir';

  @override
  String get detailBtnSave => 'Salvar';

  @override
  String get detailBtnSaved => 'Salvo';

  @override
  String get detailBtnShare => 'Compartilhar';

  @override
  String get detailInfoTitle => 'Informação';

  @override
  String get detailAgeRestricted => 'Maiores de 18 anos (RG necessário).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organizado por $venue';
  }

  @override
  String get detailLocationTitle => 'Localização';

  @override
  String get detailDoorsOpen => 'Abertura dos portões';

  @override
  String get detailViewMap => 'Ver mapa';

  @override
  String get detailRelatedEvents => 'Outras datas / Turnê';

  @override
  String get detailCheckPrices => 'Ver preços';

  @override
  String get detailFree => 'GRÁTIS';

  @override
  String get detailCheckWeb => 'Consultar no site';

  @override
  String get detailBtnBuy => 'COMPRAR INGRESSOS';

  @override
  String get editProfileChangePhoto => 'Alterar foto';

  @override
  String get editProfileName => 'Nome';

  @override
  String get editProfileNickname => 'Apelido';

  @override
  String get editProfileSave => 'Salvar';

  @override
  String get editProfileCancel => 'Cancelar';

  @override
  String get editProfileSuccess => 'Perfil atualizado com sucesso';

  @override
  String get editProfileImageNotImplemented =>
      'Funcionalidade de upload de imagem não implementada';

  @override
  String get helpSearchHint => 'Buscar ajuda...';

  @override
  String get helpMainSubtitle => 'Como podemos ajudar hoje?';

  @override
  String get helpSectionFaq => 'PERGUNTAS FREQUENTES';

  @override
  String get helpSectionTutorials => 'TUTORIAIS RÁPIDOS';

  @override
  String get helpSectionSupport => 'SUPORTE E LEGAL';

  @override
  String get helpFaq1Q => 'Como compro um ingresso?';

  @override
  String get helpFaq1A =>
      'Vá ao show que te interessa e clique em \'Comprar ingresso\'. Você poderá escolher o método de pagamento e confirmar.';

  @override
  String get helpFaq2Q => 'Como gerencio minhas notificações?';

  @override
  String get helpFaq2A =>
      'Na seção Notificações, você pode ativar avisos de shows, artistas e recomendações.';

  @override
  String get helpFaq3Q => 'Convidar amigos';

  @override
  String get helpFaq3A =>
      'Na página do evento, clique em \'Convidar amigos\' para enviar uma notificação direta.';

  @override
  String get helpTut1 => 'Guia de compra';

  @override
  String get helpTut2 => 'Usar seus ingressos';

  @override
  String get helpTut3 => 'Sincronizar calendário';

  @override
  String get helpSupportContact => 'Contatar Suporte';

  @override
  String get helpSupportReport => 'Reportar Problema';

  @override
  String get helpSupportTerms => 'Termos e condições';

  @override
  String get savedEmptyTitle => 'Você não tem shows salvos';

  @override
  String get savedEmptySub => 'Clique no ícone de salvar na Home!';

  @override
  String get savedPriceInfo => 'Ver mais';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsHeaderNotifications => 'Notificações';

  @override
  String get settingsGeneralNotifications => 'Notificações gerais';

  @override
  String get settingsEventReminders => 'Lembretes de eventos';

  @override
  String get settingsTicketReleases => 'Lançamento de ingressos';

  @override
  String get settingsHeaderPrivacy => 'Privacidade';

  @override
  String get settingsLocationPermissions => 'Permissões de localização';

  @override
  String get settingsSharedData => 'Dados compartilhados';

  @override
  String get settingsDownloadData => 'Baixar meus dados';

  @override
  String get settingsDeleteAccount => 'Excluir conta';

  @override
  String get settingsHeaderPrefs => 'Preferências';

  @override
  String get settingsThemeMode => 'Modo escuro';

  @override
  String get settingsLargeText => 'Texto grande';

  @override
  String get settingsDialogAjustes => 'Configurações';

  @override
  String get commonError => 'Ocorreu um erro';

  @override
  String get commonSuccess => 'Salvo com sucesso';

  @override
  String get privacyTransparencyTitle => 'Transparência de Dados';

  @override
  String get privacyTransparencyDesc =>
      'Na Vibra, valorizamos sua privacidade. Aqui mostramos quais informações são compartilhadas e por quê.';

  @override
  String get privacyProfile => 'Perfil Público';

  @override
  String get privacyProfileDesc =>
      'Seu nome e foto ficam visíveis se você compartilhar eventos.';

  @override
  String get privacyLocation => 'Localização';

  @override
  String get privacyLocationDesc =>
      'Usado apenas para mostrar shows próximos a você.';

  @override
  String get privacyAnalytics => 'Análise';

  @override
  String get privacyAnalyticsDesc =>
      'Dados anônimos de uso para melhorar o aplicativo.';

  @override
  String get dialogDeleteTitle => 'Excluir conta?';

  @override
  String get dialogDeleteBody =>
      'Esta ação é irreversível. Todos os seus dados e ingressos serão excluídos.';

  @override
  String get dialogDeleteBtn => 'Excluir';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogGenerating => 'Gerando arquivo...';

  @override
  String get dialogError => 'Ocorreu um erro inesperado.';

  @override
  String get snackDeleteSuccess => 'Sua conta foi excluída.';

  @override
  String get snackDeleteReauth =>
      'Por segurança, faça logout e login novamente para excluir sua conta.';

  @override
  String get shareDataText => 'Aqui estão seus dados exportados do Vibra.';

  @override
  String get dialogPermissionTitle => 'Permissões necessárias';

  @override
  String get dialogPermissionContent =>
      'Para ativar essas notificações, você precisa dar permissão nas configurações do sistema.';

  @override
  String get dialogSettingsBtn => 'Configurações';

  @override
  String get notifPreviewTitle => 'Pré-visualização da notificação';

  @override
  String get notifPreviewBody =>
      'É assim que você verá os alertas na tela de bloqueio:';

  @override
  String get btnActivate => 'Ativar';

  @override
  String get notifGeneralTitle => 'Novidades Vibra';

  @override
  String get notifGeneralBody =>
      'O aplicativo foi atualizado! Descubra o novo modo escuro e melhorias.';

  @override
  String get notifReminderTitle => '📅 É amanhã!';

  @override
  String get notifReminderBody =>
      'Seu evento salvo \'Bad Bunny - World Tour\' é amanhã. Você tem seus ingressos?';

  @override
  String get notifTicketsTitle => '🎟️ Ingressos Disponíveis';

  @override
  String get notifTicketsBody =>
      'Corre! Novos ingressos para \'Taylor Swift\' foram lançados. Não perca!';

  @override
  String get timeNow => 'Agora';

  @override
  String get time5min => 'Há 5 min';

  @override
  String get time1min => 'Há 1 min';
}
