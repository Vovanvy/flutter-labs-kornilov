import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:laba3/city_dto.dart';
import 'package:laba3/photon_repository.dart';

Map<String, dynamic> feature({String type = 'R'}) => {
  'properties': {
    'osm_id': 2555133,
    'osm_type': type,
    'name': 'Москва',
    'country': 'Россия',
    'countrycode': 'ru',
    'state': 'Москва',
  },
  'geometry': {
    'type': 'Point',
    'coordinates': [37.61, 55.75],
  },
};

void main() {
  test('GeoJSON: порядок координат, кириллица и отсутствующие поля', () {
    final city = CityDto.fromPhotonJson(feature());
    expect(city.name, 'Москва');
    expect(city.latitude, 55.75);
    expect(city.longitude, 37.61);
    expect(city.countryCode, 'RU');
    expect(city.population, isNull);
    expect(city.timezone, isEmpty);
  });

  test('Одинаковые номера разных типов OSM имеют разные ID', () {
    final ids = [
      'N',
      'W',
      'R',
    ].map((type) => CityDto.fromPhotonJson(feature(type: type)).id).toSet();
    expect(ids.length, 3);
  });

  test('Запрос Photon передаёт поиск, язык и фильтр городов', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'photon.komoot.io');
      expect(
        request.headers['User-Agent'],
        'CityAtlas-Lab/1.0 (Flutter; educational project)',
      );
      expect(request.url.path, '/api/');
      expect(request.url.queryParameters, {
        'q': 'Москва',
        'limit': '10',
        'lang': 'default',
        'layer': 'city',
      });
      return http.Response.bytes(
        utf8.encode(
          jsonEncode({
            'features': [feature()],
          }),
        ),
        200,
      );
    });
    addTearDown(client.close);
    final cities = await PhotonRepository(client: client)
        .searchCities(' Москва ');
    expect(cities.single.name, 'Москва');
  });

  test('Английский интерфейс передаёт поддерживаемый язык en', () async {
    final client = MockClient((request) async {
      expect(request.url.queryParameters['lang'], 'en');
      return http.Response('{"features":[]}', 200);
    });
    addTearDown(client.close);
    await PhotonRepository(client: client)
        .searchCities('Moscow', language: 'en');
  });

  test('Пустая выдача Photon', () async {
    final client = MockClient(
      (_) async => http.Response('{"features":[]}', 200),
    );
    addTearDown(client.close);
    expect(await PhotonRepository(client: client).searchCities('abc'), isEmpty);
  });

  test('HTTP-ошибка не превращается в пустую выдачу', () async {
    final client = MockClient((_) async => http.Response('Unavailable', 503));
    addTearDown(client.close);
    await expectLater(
      PhotonRepository(client: client).searchCities('Paris'),
      throwsException,
    );
  });

  test('Неверный JSON не превращается в пустую выдачу', () async {
    final client = MockClient((_) async => http.Response('invalid', 200));
    addTearDown(client.close);
    await expectLater(
      PhotonRepository(client: client).searchCities('Paris'),
      throwsFormatException,
    );
  });
}
