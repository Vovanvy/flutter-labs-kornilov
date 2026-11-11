// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Атлас городов';

  @override
  String get searchTitle => 'Атлас городов';

  @override
  String get refreshList => 'Обновить список';

  @override
  String get switchLanguage => 'Switch to English';

  @override
  String get searchLabel => 'Название города';

  @override
  String get searchHint => 'Например, Астрахань';

  @override
  String get searchButton => 'Найти';

  @override
  String get typeCity => 'Введите название города.';

  @override
  String get shortQuery => 'Введите хотя бы 2 символа.';

  @override
  String get waitingSearch => 'Поиск начнётся через мгновение.';

  @override
  String get noCities => 'Ничего не найдено. Попробуйте другое название.';

  @override
  String get searchError =>
      'Не удалось загрузить города. Проверьте интернет и повторите поиск.';

  @override
  String likedCity(String cityName) {
    return 'Вам понравилось: $cityName';
  }

  @override
  String unlikedCity(String cityName) {
    return 'Лайк убран: $cityName';
  }

  @override
  String get removeLike => 'Убрать лайк';

  @override
  String get addLike => 'Поставить лайк';

  @override
  String get dataSource => 'Данные: Photon / OpenStreetMap';

  @override
  String get countryLabel => 'Страна';

  @override
  String get regionLabel => 'Регион';

  @override
  String get populationLabel => 'Население';

  @override
  String get notAvailable => 'Нет данных';

  @override
  String get latitudeLabel => 'Широта';

  @override
  String get longitudeLabel => 'Долгота';

  @override
  String get timezoneLabel => 'Часовой пояс';

  @override
  String flagLabel(String countryName) {
    return 'Флаг страны $countryName';
  }
}
