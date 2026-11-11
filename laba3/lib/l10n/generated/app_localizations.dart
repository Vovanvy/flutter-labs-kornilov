import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Атлас городов'**
  String get appTitle;

  /// No description provided for @searchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Атлас городов'**
  String get searchTitle;

  /// No description provided for @refreshList.
  ///
  /// In ru, this message translates to:
  /// **'Обновить список'**
  String get refreshList;

  /// No description provided for @switchLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Switch to English'**
  String get switchLanguage;

  /// No description provided for @searchLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название города'**
  String get searchLabel;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Астрахань'**
  String get searchHint;

  /// No description provided for @searchButton.
  ///
  /// In ru, this message translates to:
  /// **'Найти'**
  String get searchButton;

  /// No description provided for @typeCity.
  ///
  /// In ru, this message translates to:
  /// **'Введите название города.'**
  String get typeCity;

  /// No description provided for @shortQuery.
  ///
  /// In ru, this message translates to:
  /// **'Введите хотя бы 2 символа.'**
  String get shortQuery;

  /// No description provided for @waitingSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск начнётся через мгновение.'**
  String get waitingSearch;

  /// No description provided for @noCities.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено. Попробуйте другое название.'**
  String get noCities;

  /// No description provided for @searchError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить города. Проверьте интернет и повторите поиск.'**
  String get searchError;

  /// No description provided for @likedCity.
  ///
  /// In ru, this message translates to:
  /// **'Вам понравилось: {cityName}'**
  String likedCity(String cityName);

  /// No description provided for @unlikedCity.
  ///
  /// In ru, this message translates to:
  /// **'Лайк убран: {cityName}'**
  String unlikedCity(String cityName);

  /// No description provided for @removeLike.
  ///
  /// In ru, this message translates to:
  /// **'Убрать лайк'**
  String get removeLike;

  /// No description provided for @addLike.
  ///
  /// In ru, this message translates to:
  /// **'Поставить лайк'**
  String get addLike;

  /// No description provided for @dataSource.
  ///
  /// In ru, this message translates to:
  /// **'Данные: Photon / OpenStreetMap'**
  String get dataSource;

  /// No description provided for @countryLabel.
  ///
  /// In ru, this message translates to:
  /// **'Страна'**
  String get countryLabel;

  /// No description provided for @regionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Регион'**
  String get regionLabel;

  /// No description provided for @populationLabel.
  ///
  /// In ru, this message translates to:
  /// **'Население'**
  String get populationLabel;

  /// No description provided for @notAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Нет данных'**
  String get notAvailable;

  /// No description provided for @latitudeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Широта'**
  String get latitudeLabel;

  /// No description provided for @longitudeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Долгота'**
  String get longitudeLabel;

  /// No description provided for @timezoneLabel.
  ///
  /// In ru, this message translates to:
  /// **'Часовой пояс'**
  String get timezoneLabel;

  /// No description provided for @flagLabel.
  ///
  /// In ru, this message translates to:
  /// **'Флаг страны {countryName}'**
  String flagLabel(String countryName);
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
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
