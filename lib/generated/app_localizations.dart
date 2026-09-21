import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SNovu
/// returned by `SNovu.of(context)`.
///
/// Applications need to include `SNovu.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SNovu.localizationsDelegates,
///   supportedLocales: SNovu.supportedLocales,
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
/// be consistent with the languages listed in the SNovu.supportedLocales
/// property.
abstract class SNovu {
  SNovu(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SNovu? of(BuildContext context) {
    return Localizations.of<SNovu>(context, SNovu);
  }

  static const LocalizationsDelegate<SNovu> delegate = _SNovuDelegate();

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
    Locale('fr'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @unreadOnly.
  ///
  /// In en, this message translates to:
  /// **'Unread Only'**
  String get unreadOnly;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @unreadAndRead.
  ///
  /// In en, this message translates to:
  /// **'Unread & Read'**
  String get unreadAndRead;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get markAllAsRead;

  /// No description provided for @archiveAll.
  ///
  /// In en, this message translates to:
  /// **'Archive All'**
  String get archiveAll;

  /// No description provided for @archiveRead.
  ///
  /// In en, this message translates to:
  /// **'Archive Read'**
  String get archiveRead;

  /// No description provided for @noUnreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get noUnreadNotifications;

  /// No description provided for @noArchivedNotifications.
  ///
  /// In en, this message translates to:
  /// **'No archived notifications'**
  String get noArchivedNotifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just Now'**
  String get justNow;

  /// No description provided for @unarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get unarchive;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @dateAgo.
  ///
  /// In en, this message translates to:
  /// **'{date} ago'**
  String dateAgo(String date);

  /// No description provided for @noNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'No Notification Settings'**
  String get noNotificationSettings;

  /// No description provided for @noNotificationSettingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Your notification preferences will appear here\nonce they are loaded'**
  String get noNotificationSettingsMessage;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'By setting up your notifications you will efficiently use this app'**
  String get notificationsMessage;

  /// No description provided for @novuChannel.
  ///
  /// In en, this message translates to:
  /// **'{value, select, email{Email} sms{SMS} push{Push} in_app{In App} inApp{In App} chat{Chat} other{Other}}'**
  String novuChannel(String value);

  /// No description provided for @globalPreferences.
  ///
  /// In en, this message translates to:
  /// **'Global Preferences'**
  String get globalPreferences;

  /// No description provided for @notificationsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notifications Preferences'**
  String get notificationsPreferences;
}

class _SNovuDelegate extends LocalizationsDelegate<SNovu> {
  const _SNovuDelegate();

  @override
  Future<SNovu> load(Locale locale) {
    return SynchronousFuture<SNovu>(lookupSNovu(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_SNovuDelegate old) => false;
}

SNovu lookupSNovu(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return SNovuPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SNovuEn();
    case 'fr':
      return SNovuFr();
    case 'pt':
      return SNovuPt();
  }

  throw FlutterError(
      'SNovu.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
