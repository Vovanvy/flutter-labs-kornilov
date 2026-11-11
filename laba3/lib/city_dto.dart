// DTO — данные города, полученные из JSON.
class CityDto {
  final int id;
  final String name;
  final String country;
  final String countryCode;
  final String region;
  final double latitude;
  final double longitude;
  final String timezone;
  final int? population;

  const CityDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country = 'Страна не указана',
    this.countryCode = '',
    this.region = 'Регион не указан',
    this.timezone = 'Не указан',
    this.population,
  });

  factory CityDto.fromPhotonJson(Map<String, dynamic> feature) {
    final properties = feature['properties'] as Map<String, dynamic>;
    final geometry = feature['geometry'] as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>;
    // OSM использует отдельные пространства ID для узлов, линий и отношений.
    final type = properties['osm_type'] as String;
    final typeId = switch (type) {
      'N' => 0,
      'W' => 1,
      'R' => 2,
      _ => throw FormatException('Неизвестный тип OSM: $type'),
    };
    return CityDto(
      id: (properties['osm_id'] as num).toInt() * 3 + typeId,
      name: properties['name'] as String,
      country: properties['country'] as String? ?? 'Страна не указана',
      countryCode: (properties['countrycode'] as String? ?? '').toUpperCase(),
      region:
          properties['state'] as String? ??
          properties['county'] as String? ??
          'Регион не указан',
      latitude: (coordinates[1] as num).toDouble(),
      longitude: (coordinates[0] as num).toDouble(),
      timezone: '',
    );
  }

  factory CityDto.fromJson(Map<String, dynamic> json) {
    return CityDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      country: json['country'] as String? ?? 'Страна не указана',
      countryCode: json['country_code'] as String? ?? '',
      region: json['admin1'] as String? ?? 'Регион не указан',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String? ?? 'Не указан',
      population: (json['population'] as num?)?.toInt(),
    );
  }
}
