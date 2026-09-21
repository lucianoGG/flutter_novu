// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class SNovuPt extends SNovu {
  SNovuPt([String locale = 'pt']) : super(locale);

  @override
  String get inbox => 'Caixa de entrada';

  @override
  String get unreadOnly => 'Apenas não lidas';

  @override
  String get archived => 'Arquivadas';

  @override
  String get unreadAndRead => 'Não lidas e lidas';

  @override
  String get markAllAsRead => 'Marcar todas como lidas';

  @override
  String get archiveAll => 'Arquivar todas';

  @override
  String get archiveRead => 'Arquivar lidas';

  @override
  String get noUnreadNotifications => 'Nenhuma notificação não lida';

  @override
  String get noArchivedNotifications => 'Nenhuma notificação arquivada';

  @override
  String get noNotifications => 'Nenhuma notificação';

  @override
  String get markAsRead => 'Marcar como lida';

  @override
  String get justNow => 'Agora mesmo';

  @override
  String get unarchive => 'Desarquivar';

  @override
  String get archive => 'Arquivar';

  @override
  String dateAgo(String date) {
    return 'há $date';
  }

  @override
  String get noNotificationSettings => 'Sem configurações de notificação';

  @override
  String get noNotificationSettingsMessage =>
      'Suas preferências de notificação aparecerão aqui\nquando forem carregadas';

  @override
  String get refresh => 'Atualizar';

  @override
  String get notifications => 'Notificações';

  @override
  String get notificationsMessage =>
      'Ao configurar suas notificações, você usará este app de forma mais eficiente';

  @override
  String novuChannel(String value) {
    String _temp0 = intl.Intl.selectLogic(
      value,
      {
        'email': 'E-mail',
        'sms': 'SMS',
        'push': 'Push',
        'in_app': 'No app',
        'inApp': 'No app',
        'chat': 'Chat',
        'other': 'Outro',
      },
    );
    return '$_temp0';
  }

  @override
  String get globalPreferences => 'Preferências globais';

  @override
  String get notificationsPreferences => 'Preferências de notificações';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class SNovuPtBr extends SNovuPt {
  SNovuPtBr() : super('pt_BR');

  @override
  String get inbox => 'Caixa de entrada';

  @override
  String get unreadOnly => 'Apenas não lidas';

  @override
  String get archived => 'Arquivadas';

  @override
  String get unreadAndRead => 'Não lidas e lidas';

  @override
  String get markAllAsRead => 'Marcar todas como lidas';

  @override
  String get archiveAll => 'Arquivar todas';

  @override
  String get archiveRead => 'Arquivar lidas';

  @override
  String get noUnreadNotifications => 'Nenhuma notificação não lida';

  @override
  String get noArchivedNotifications => 'Nenhuma notificação arquivada';

  @override
  String get noNotifications => 'Nenhuma notificação';

  @override
  String get markAsRead => 'Marcar como lida';

  @override
  String get justNow => 'Agora mesmo';

  @override
  String get unarchive => 'Desarquivar';

  @override
  String get archive => 'Arquivar';

  @override
  String dateAgo(String date) {
    return 'há $date';
  }

  @override
  String get noNotificationSettings => 'Sem configurações de notificação';

  @override
  String get noNotificationSettingsMessage =>
      'Suas preferências de notificação aparecerão aqui\nquando forem carregadas';

  @override
  String get refresh => 'Atualizar';

  @override
  String get notifications => 'Notificações';

  @override
  String get notificationsMessage =>
      'Ao configurar suas notificações, você usará este app de forma mais eficiente';

  @override
  String novuChannel(String value) {
    String _temp0 = intl.Intl.selectLogic(
      value,
      {
        'email': 'E-mail',
        'sms': 'SMS',
        'push': 'Push',
        'in_app': 'No app',
        'inApp': 'No app',
        'chat': 'Chat',
        'other': 'Outro',
      },
    );
    return '$_temp0';
  }

  @override
  String get globalPreferences => 'Preferências globais';

  @override
  String get notificationsPreferences => 'Preferências de notificações';
}
