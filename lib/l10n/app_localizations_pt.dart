// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get permManagerTitle => 'Gerenciador de Permissões';

  @override
  String get permLocation => 'Localização';

  @override
  String get permCamera => 'Câmera';

  @override
  String get permMicrophone => 'Microfone';

  @override
  String get permNotifications => 'Notificações';

  @override
  String get permStorage => 'Fotos e Armazenamento';

  @override
  String get permStatusAllowed => 'Permitido';

  @override
  String get permStatusDenied => 'Negado';

  @override
  String get permStatusRestricted => 'Restrito';

  @override
  String get permStatusPermanentlyDenied => 'Negado Permanentemente';

  @override
  String get permTip =>
      'Para alterar uma permissão negada permanentemente, você deve ir para as configurações do sistema.';

  @override
  String get permBtnSettings => 'Abrir Configurações';

  @override
  String get permBtnRequest => 'Solicitar';

  @override
  String get appTitle => 'Vibra';

  @override
  String get loginSpotify => 'Entrar com Spotify';

  @override
  String get loginGoogle => 'Entrar com Google';

  @override
  String get loginLoading => 'A carregar...';

  @override
  String get loginTerms =>
      'Ao continuar, aceitas os nossos Termos e Política de Privacidade.';

  @override
  String loginError(String error) {
    return 'Erro ao iniciar sessão: $error';
  }

  @override
  String homeSearchHint(String country) {
    return 'Pesquisar em $country...';
  }

  @override
  String homeGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String homeVibeTitle(String vibe) {
    return 'Explora $vibe';
  }

  @override
  String get vibeBest => 'o melhor';

  @override
  String get homeSectionArtists => 'OS TEUS ARTISTAS';

  @override
  String get homeSectionArtistsSub => 'Com base no que mais ouves';

  @override
  String get homeSectionForYou => 'SÓ PARA TI';

  @override
  String homeSectionForYouSub(String artist) {
    return 'Porque ouves $artist...';
  }

  @override
  String homeSectionTrends(String country) {
    return 'TENDÊNCIAS EM $country';
  }

  @override
  String get homeSectionTrendsSub => 'O mais popular da semana';

  @override
  String get homeSectionWeekend => 'CHEGOU O FIM DE SEMANA!';

  @override
  String get homeSectionWeekendSub => 'Planos para este fim de semana';

  @override
  String get homeSectionDiscover => 'DESCOBRE MAIS';

  @override
  String get homeSectionDiscoverSub => 'Explora novos géneros';

  @override
  String get homeSectionCollections => 'EXPLORA VIBES';

  @override
  String get homeSectionCollectionsSub => 'Encontra o teu plano ideal';

  @override
  String get homeBtnShowMore => 'Mostrar mais eventos';

  @override
  String get homeBtnViewAll => 'Ver todos os eventos';

  @override
  String homeTextNoMore(String keyword) {
    return 'Não há mais eventos de $keyword';
  }

  @override
  String get homeTextEnd => 'Chegaste ao fim!';

  @override
  String homeErrorNoEvents(String country) {
    return 'Não há eventos em $country';
  }

  @override
  String get homeBtnRetryCountry => 'Ver eventos em Espanha';

  @override
  String get homeSearchNoResults => 'Não encontrámos nada';

  @override
  String get homeSearchClear => 'Limpar pesquisa';

  @override
  String get menuAccount => 'A minha Conta';

  @override
  String get menuSaved => 'Eventos guardados';

  @override
  String get menuSettings => 'Definições';

  @override
  String get menuHelp => 'Ajuda';

  @override
  String get menuLogout => 'Terminar sessão';

  @override
  String get menuEditProfile => 'Editar perfil';

  @override
  String prefsTitle(String name) {
    return 'Olá, $name! 🎧';
  }

  @override
  String get prefsSubtitle => 'Personaliza o teu feed. O que te move?';

  @override
  String get prefsSearchHint => 'Pesquisar artista (ex: Bad Bunny)...';

  @override
  String get prefsYourArtists => 'Os teus Artistas:';

  @override
  String get prefsGenres => 'Géneros e Estilos:';

  @override
  String get prefsBtnStart => 'Começar';

  @override
  String get accountTitle => 'A minha Conta';

  @override
  String get accountConnection => 'LIGAÇÃO ATIVA';

  @override
  String get accountLinked => 'Conta associada com sucesso';

  @override
  String accountOpenProfile(String service) {
    return 'Abrir perfil no $service';
  }

  @override
  String get calendarTitle => 'Quando queres sair?';

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
  String get detailBtnLike => 'Gosto';

  @override
  String get detailBtnSave => 'Guardar';

  @override
  String get detailBtnSaved => 'Guardado';

  @override
  String get detailBtnShare => 'Partilhar';

  @override
  String get detailInfoTitle => 'Informação';

  @override
  String get detailAgeRestricted => 'Maiores de 18 anos (ID necessário).';

  @override
  String detailOrganizedBy(String venue) {
    return 'Organizado por $venue';
  }

  @override
  String get detailLocationTitle => 'Localização';

  @override
  String get detailDoorsOpen => 'Abertura de portas';

  @override
  String get detailViewMap => 'Ver mapa';

  @override
  String get detailRelatedEvents => 'Outras datas / Tour';

  @override
  String get detailCheckPrices => 'Ver preços';

  @override
  String get detailFree => 'GRÁTIS';

  @override
  String get detailCheckWeb => 'Consultar na web';

  @override
  String get detailBtnBuy => 'COMPRAR BILHETES';

  @override
  String get editProfileChangePhoto => 'Alterar foto';

  @override
  String get editProfileName => 'Nome';

  @override
  String get editProfileNickname => 'Alcunha';

  @override
  String get editProfileSave => 'Guardar';

  @override
  String get editProfileCancel => 'Cancelar';

  @override
  String get editProfileSuccess => 'Perfil atualizado com sucesso';

  @override
  String get editProfileImageNotImplemented =>
      'Funcionalidade de carregar imagem não implementada';

  @override
  String get helpSearchHint => 'Pesquisar ajuda...';

  @override
  String get helpMainSubtitle => 'Em que podemos ajudar hoje?';

  @override
  String get helpSectionFaq => 'PERGUNTAS FREQUENTES';

  @override
  String get helpSectionTutorials => 'TUTORIAIS RÁPIDOS';

  @override
  String get helpSectionSupport => 'SUPORTE E LEGAL';

  @override
  String get helpFaq1Q => 'Como compro um bilhete?';

  @override
  String get helpFaq1A =>
      'Vai ao concerto que te interessa e toca em \'Comprar bilhete\'. Poderás escolher o método de pagamento e confirmar.';

  @override
  String get helpFaq2Q => 'Como giro as minhas notificações?';

  @override
  String get helpFaq2A =>
      'Na secção Notificações podes ativar avisos de concertos, artistas e recomendações.';

  @override
  String get helpFaq3Q => 'Convidar amigos';

  @override
  String get helpFaq3A =>
      'Na página do evento, toca em \'Convidar amigos\' para enviar-lhes uma notificação direta.';

  @override
  String get helpTut1 => 'Guia de compra';

  @override
  String get helpTut2 => 'Usar os teus bilhetes';

  @override
  String get helpTut3 => 'Sincronizar calendário';

  @override
  String get helpSupportContact => 'Contactar Suporte';

  @override
  String get helpSupportReport => 'Reportar Problema';

  @override
  String get helpSupportTerms => 'Termos e condições';

  @override
  String get savedEmptyTitle => 'Não tens concertos guardados';

  @override
  String get savedEmptySub => 'Toca no ícone de guardar na Home!';

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
  String get settingsTicketReleases => 'Lançamento de bilhetes';

  @override
  String get settingsHeaderPrivacy => 'Privacidade';

  @override
  String get settingsLocationPermissions => 'Permissões de localização';

  @override
  String get settingsSharedData => 'Dados partilhados';

  @override
  String get settingsDownloadData => 'Descarregar os meus dados';

  @override
  String get settingsDeleteAccount => 'Eliminar conta';

  @override
  String get settingsHeaderPrefs => 'Preferências';

  @override
  String get settingsThemeMode => 'Modo escuro';

  @override
  String get settingsLargeText => 'Texto grande';

  @override
  String get settingsDialogAjustes => 'Definições';

  @override
  String get commonError => 'Ocorreu um erro';

  @override
  String get commonSuccess => 'Guardado com sucesso';

  @override
  String get privacyTransparencyTitle => 'Transparência de Dados';

  @override
  String get privacyTransparencyDesc =>
      'Na Vibra, valorizamos a tua privacidade. Aqui mostramos que informações são partilhadas e com que fim.';

  @override
  String get privacyProfile => 'Perfil Público';

  @override
  String get privacyProfileDesc =>
      'O teu nome e foto são visíveis se partilhares eventos.';

  @override
  String get privacyLocation => 'Localização';

  @override
  String get privacyLocationDesc =>
      'Usado apenas para mostrar concertos próximos.';

  @override
  String get privacyAnalytics => 'Analítica';

  @override
  String get privacyAnalyticsDesc =>
      'Dados anónimos de uso para melhorar a app.';

  @override
  String get dialogDeleteTitle => 'Eliminar conta?';

  @override
  String get dialogDeleteBody =>
      'Esta ação é irreversível. Todos os teus dados e bilhetes serão apagados.';

  @override
  String get dialogDeleteBtn => 'Eliminar';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogGenerating => 'A gerar ficheiro...';

  @override
  String get dialogError => 'Ocorreu um erro inesperado.';

  @override
  String get snackDeleteSuccess => 'A tua conta foi eliminada.';

  @override
  String get snackDeleteReauth =>
      'Por segurança, termina sessão e volta a entrar para eliminar a conta.';

  @override
  String get shareDataText => 'Aqui tens os teus dados exportados da Vibra.';

  @override
  String get dialogPermissionTitle => 'Permissões necessárias';

  @override
  String get dialogPermissionContent =>
      'Para ativar estas notificações, precisas de dar permissão nas definições do sistema.';

  @override
  String get dialogSettingsBtn => 'Definições';

  @override
  String get notifPreviewTitle => 'Pré-visualização de notificação';

  @override
  String get notifPreviewBody =>
      'É assim que verás os alertas no teu ecrã de bloqueio:';

  @override
  String get btnActivate => 'Ativar';

  @override
  String get notifGeneralTitle => 'Novidades Vibra';

  @override
  String get notifGeneralBody =>
      'A app foi atualizada! Descobre o novo modo escuro e melhorias.';

  @override
  String get notifReminderTitle => '📅 É amanhã!';

  @override
  String get notifReminderBody =>
      'O teu evento guardado \'Bad Bunny - World Tour\' é amanhã. Tens os teus bilhetes?';

  @override
  String get notifTicketsTitle => '🎟️ Bilhetes Disponíveis';

  @override
  String get notifTicketsBody =>
      'Corre! Saíram novos bilhetes para \'Taylor Swift\'. Não fiques sem eles!';

  @override
  String get timeNow => 'Agora';

  @override
  String get time5min => 'Há 5 min';

  @override
  String get time1min => 'Há 1 min';

  @override
  String get settingsPermissionManager => 'Gestor de permissões';

  @override
  String get snackNotificationsEnabled => 'Notificações ativadas';

  @override
  String get inDevelopment => 'Em breve';

  @override
  String get ticketScreenTitle => 'Os meus Bilhetes';

  @override
  String get navSocial => 'Social';

  @override
  String get socialTitle => 'Meus Amigos';

  @override
  String get socialSearchHint => 'Pesquisar amigo...';

  @override
  String get socialStatusOnline => 'Online';

  @override
  String get regionTitle => 'Selecione a sua Região';

  @override
  String get regionSearchHint => 'Pesquisar país...';

  @override
  String regionExplore(String name) {
    return 'Explora $name';
  }

  @override
  String get regionDialogCityBody =>
      'Procura concertos numa cidade específica?';

  @override
  String get regionDialogCityHint => 'Ex: Lisboa, Porto...';

  @override
  String get regionBtnWholeCountry => 'Ver todo o país';

  @override
  String get regionBtnApply => 'Aplicar';

  @override
  String get regionOptionWholeCountry => 'Todo o país';

  @override
  String regionOptionWholeCountrySub(String name) {
    return 'Ver concertos em todo $name';
  }

  @override
  String get regionHeaderPopular => 'CIDADES POPULARES';

  @override
  String get regionHeaderOther => 'OUTRA LOCALIZAÇÃO';

  @override
  String get regionOptionManual => 'Escrever outra cidade...';

  @override
  String get regionManualTitle => 'Escrever cidade';

  @override
  String get regionManualHint => 'Ex: Braga';

  @override
  String get regionManualSearch => 'Pesquisar';

  @override
  String get songRecListening => 'A ouvir...';

  @override
  String get songRecCancel => 'Cancelar';

  @override
  String get songRecRetry => 'Tentar novamente';

  @override
  String get songRecOpenSpotify => 'ABRIR NO SPOTIFY';

  @override
  String get songRecTryAgain => 'Tentar de novo';

  @override
  String get songRecClose => 'Fechar';

  @override
  String get nearbyEventsTitle => 'Eventos Próximos';

  @override
  String get nearbyEventsPermissionDenied =>
      'Permissão de localização necessária.';

  @override
  String get nearbyEventsPermissionPermanentlyDenied =>
      'Permissão de localização negada permanentemente. Por favor, ative nas definições.';

  @override
  String get nearbyEventsLocationError =>
      'Não foi possível obter a localização atual.';

  @override
  String nearbyEventsRadius(int km) {
    return 'Raio de pesquisa: $km km';
  }

  @override
  String get nearbyEventsNoEvents => 'Nenhum evento próximo encontrado.';

  @override
  String get nearbyEventsViewDetails => 'Ver Detalhes';

  @override
  String get songRecUpcomingEvents => 'PRÓXIMOS EVENTOS';

  @override
  String get songRecNoEvents => 'Não há concertos próximos.';

  @override
  String get songRecErrorLoadingEvents =>
      'Não foi possível carregar informações do concerto.';

  @override
  String get songRecNoMatch => 'Nenhuma correspondência encontrada.';

  @override
  String get songRecErrorInit => 'Não foi possível iniciar o reconhecimento.';

  @override
  String get songRecNoResponse => 'Nenhuma resposta recebida.';

  @override
  String get songRecErrorGeneric => 'Erro desconhecido';

  @override
  String get songRecOpenSpotifyError => 'Não foi possível abrir o Spotify';

  @override
  String get songRecOpenTicket => 'Abrir';

  @override
  String songRecSearchArtistEvents(Object artist) {
    return 'A pesquisar eventos de $artist...';
  }

  @override
  String get nearbyEventsMusicOnly => 'Só Música';

  @override
  String get nearbyEventsLocationDisabled => 'Localização desativada.';

  @override
  String nearbyEventsCount(int count) {
    return '$count eventos';
  }

  @override
  String get nearbyEventsDaysAhead => 'Próximos dias:';

  @override
  String get nearbyEventsTimeRange30Days => '30 dias';

  @override
  String get nearbyEventsTimeRange60Days => '60 dias';

  @override
  String get nearbyEventsTimeRange3Months => '3 meses';

  @override
  String get nearbyEventsTimeRange6Months => '6 meses';

  @override
  String get nearbyEventsTimeRange1Year => '1 ano';

  @override
  String get nearbyEventsRetry => 'Tentar novamente';

  @override
  String get nearbyEventsLoadError => 'Erro ao carregar eventos.';

  @override
  String get songRecNoDatesAvailable => 'Sem datas disponíveis.';

  @override
  String get songRecListenAgain => 'Ouvir novamente';

  @override
  String get songRecViewAllEvents => 'VER TODOS OS EVENTOS';

  @override
  String get artistEventsSubtitle => 'Próximos concertos no mundo';

  @override
  String get artistEventsEmpty => 'Sem concertos agendados';

  @override
  String get commonMonthShort1 => 'JAN';

  @override
  String get commonMonthShort2 => 'FEV';

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
  String get commonMonthShort10 => 'OUT';

  @override
  String get commonMonthShort11 => 'NOV';

  @override
  String get commonMonthShort12 => 'DEZ';

  @override
  String get downloadDataTitle => 'Exportar os meus dados';

  @override
  String get downloadDataShare => 'Partilhar';

  @override
  String get downloadDataSave => 'Guardar no dispositivo';

  @override
  String get downloadDataSaved => 'Dados guardados com sucesso';
}
