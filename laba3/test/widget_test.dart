import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laba3/city_dto.dart';
import 'package:laba3/city_repository.dart';
import 'package:laba3/main.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const city = CityDto(
  id: 1,
  name: 'Париж',
  country: 'Франция',
  region: 'Иль-де-Франс',
  latitude: 48.85,
  longitude: 2.35,
  population: 2138551,
  timezone: 'Europe/Paris',
);

class FakeCityRepository implements CityRepository {
  List<CityDto> result = [city];
  bool fail = false;
  final queries = <String>[];

  @override
  Future<List<CityDto>> searchCities(String query) async {
    queries.add(query);
    if (fail) throw Exception('Нет соединения');
    return result;
  }
}

Future<void> search(WidgetTester tester, String query) async {
  await tester.enterText(find.byType(TextField), query);
  await tester.tap(find.byTooltip('Найти'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('Поиск, лайк, подробности и повторный поиск', (tester) async {
    final repository = FakeCityRepository();
    await tester.pumpWidget(MyApp(repository: repository));
    expect(find.byType(CityCard), findsNothing);

    await search(tester, '  Paris  ');
    expect(repository.queries, ['Paris']);
    expect(find.text('Париж'), findsOneWidget);

    await tester.tap(find.byTooltip('Поставить лайк'));
    await tester.pumpAndSettle();
    expect(find.text('Вам понравилось: Париж'), findsOneWidget);
    expect(find.byType(CityDetails), findsNothing);

    await tester.tap(find.text('Париж'));
    await tester.pumpAndSettle();
    expect(find.byType(CityDetails), findsOneWidget);
    expect(find.textContaining('Население: 2138551'), findsOneWidget);
    expect(find.textContaining('Europe/Paris'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Убрать лайк'), findsOneWidget);

    // Лайк привязан к ID города и переживает повторную загрузку списка.
    await search(tester, 'Paris');
    expect(find.byTooltip('Убрать лайк'), findsOneWidget);
    await tester.tap(find.byTooltip('Убрать лайк'));
    await tester.pumpAndSettle();
    expect(find.text('Лайк убран: Париж'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Короткий запрос не отправляется, пустой ответ объясняется', (
    tester,
  ) async {
    final repository = FakeCityRepository()..result = [];
    await tester.pumpWidget(MyApp(repository: repository));
    await search(tester, 'a');
    expect(repository.queries, isEmpty);
    expect(find.text('Введите хотя бы 2 символа.'), findsOneWidget);
    await search(tester, 'НесуществующийГород');
    expect(find.textContaining('Ничего не найдено'), findsOneWidget);
  });

  testWidgets('После сетевой ошибки поиск можно повторить', (tester) async {
    final repository = FakeCityRepository()..fail = true;
    await tester.pumpWidget(MyApp(repository: repository));
    await search(tester, 'Paris');
    expect(find.textContaining('Не удалось загрузить города'), findsOneWidget);
    repository.fail = false;
    await search(tester, 'Paris');
    expect(find.byType(CityCard), findsOneWidget);
    expect(find.textContaining('Не удалось загрузить города'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
