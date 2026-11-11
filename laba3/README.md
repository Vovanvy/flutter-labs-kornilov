# Лабораторные работы 3–7 — поиск городов

Корнилов Вова, Пдо-36.

## Что умеет приложение

- Ищет города через Photon API (OpenStreetMap) и показывает карточки с флагом,
  страной и регионом.
- Ставит лайки, показывает SnackBar и открывает подробности города.
- Использует BLoC для состояний загрузки, результата и ошибки.
- Запускает поиск через 500 мс после остановки ввода; список обновляется
  кнопкой в AppBar или свайпом вниз.
- Поддерживает русский и английский. Язык и избранные города сохраняются
  между запусками через SharedPreferences.
- Использует собственную Android-иконку города с меткой на карте.

## Структура

- `lib/city_dto.dart` — модель результата API.
- `lib/city_repository.dart` — интерфейс репозитория.
- `lib/photon_repository.dart` — запросы к Photon.
- `lib/city_search_bloc.dart` — логика поиска и debounce.
- `lib/app_preferences.dart` — сохранение лайков и языка.
- `lib/main.dart` — интерфейс и переход на экран подробностей.
- `lib/l10n` — русские и английские переводы.
- `assets/icon` — исходник SVG и PNG для Android launcher icons.

## Запуск

Откройте `laba3` в Android Studio или VS Code:

```powershell
flutter pub get
flutter run -d emulator-5554
```

При необходимости запустите эмулятор из папки `labs`:

```powershell
.\start-emulator.ps1
```

Локализации генерируются Flutter из ARB-файлов. Иконки можно пересобрать:

```powershell
dart run flutter_launcher_icons
```

## Проверка

```powershell
flutter analyze
flutter test
```

Photon не возвращает население и часовой пояс: показывается «Нет данных».
Лайки Photon сохраняются отдельно от старых ID Open-Meteo.

Для русского интерфейса Photon запрашивается с lang=default (местные названия),
для английского — с lang=en. Публичный сервер не поддерживает lang=ru.

Запросы содержат User-Agent с названием приложения: стандартный
Dart User-Agent публичный сервер Photon отклоняет с HTTP 403.
