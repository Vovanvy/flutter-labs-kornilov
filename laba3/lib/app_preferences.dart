import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferencesAsync _preferences;

  AppPreferences({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  Future<Set<int>> loadLikedCityIds() async {
    final values = await _preferences.getStringList('photonLikedCityIds') ?? [];
    return values.map(int.tryParse).whereType<int>().toSet();
  }

  Future<void> saveLikedCityIds(Set<int> ids) {
    final values = ids.map((id) => id.toString()).toList()..sort();
    return _preferences.setStringList('photonLikedCityIds', values);
  }

  Future<String?> loadLanguage() => _preferences.getString('appLanguage');

  Future<void> saveLanguage(String languageCode) {
    return _preferences.setString('appLanguage', languageCode);
  }
}
