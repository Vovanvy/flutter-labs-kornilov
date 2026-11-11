import 'city_dto.dart';

// Интерфейс: описывает, что должен уметь репозиторий.
abstract class CityRepository {
  Future<List<CityDto>> searchCities(String query);
}

abstract class LocalizedCityRepository implements CityRepository {
  @override
  Future<List<CityDto>> searchCities(String query, {String language = 'ru'});
}
