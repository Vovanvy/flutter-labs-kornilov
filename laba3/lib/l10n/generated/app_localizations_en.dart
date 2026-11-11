// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'City Atlas';

  @override
  String get searchTitle => 'City Atlas';

  @override
  String get refreshList => 'Refresh list';

  @override
  String get switchLanguage => 'Переключить на русский';

  @override
  String get searchLabel => 'City name';

  @override
  String get searchHint => 'For example, Paris';

  @override
  String get searchButton => 'Search';

  @override
  String get typeCity => 'Enter a city name.';

  @override
  String get shortQuery => 'Enter at least 2 characters.';

  @override
  String get waitingSearch => 'Searching in a moment…';

  @override
  String get noCities => 'No cities found. Try another name.';

  @override
  String get searchError =>
      'Could not load cities. Check your internet connection and try again.';

  @override
  String likedCity(String cityName) {
    return 'Liked: $cityName';
  }

  @override
  String unlikedCity(String cityName) {
    return 'Like removed: $cityName';
  }

  @override
  String get removeLike => 'Remove like';

  @override
  String get addLike => 'Like';

  @override
  String get dataSource => 'Data: Photon / OpenStreetMap';

  @override
  String get countryLabel => 'Country';

  @override
  String get regionLabel => 'Region';

  @override
  String get populationLabel => 'Population';

  @override
  String get notAvailable => 'Not available';

  @override
  String get latitudeLabel => 'Latitude';

  @override
  String get longitudeLabel => 'Longitude';

  @override
  String get timezoneLabel => 'Time zone';

  @override
  String flagLabel(String countryName) {
    return 'Flag of $countryName';
  }
}
