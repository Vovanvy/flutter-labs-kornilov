import 'dart:convert';

import 'package:http/http.dart' as http;

import 'city_dto.dart';
import 'city_repository.dart';

// Photon возвращает GeoJSON с данными OpenStreetMap.
class PhotonRepository implements LocalizedCityRepository {
  final http.Client _client;

  PhotonRepository({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<CityDto>> searchCities(
    String query, {
    String language = 'ru',
  }) async {
    if (query.trim().isEmpty) return [];
    final uri = Uri.https('photon.komoot.io', '/api/', {
      'q': query.trim(),
      'limit': '10',
      // Публичный сервер поддерживает default, en, de, fr, но не ru.
      'lang': language == 'en' ? 'en' : 'default',
      'layer': 'city',
    });
    final response = await _client
        .get(
          uri,
          headers: {
            'User-Agent': 'CityAtlas-Lab/1.0 (Flutter; educational project)',
          },
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Ошибка API: ${response.statusCode}');
    }
    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final features = json['features'] as List<dynamic>;
    return features
        .map((item) => CityDto.fromPhotonJson(item as Map<String, dynamic>))
        .toList();
  }
}
