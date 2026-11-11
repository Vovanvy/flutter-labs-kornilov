# Лабораторные по разработке мобильных приложений

Автор: Корнилов Вова. Группа: Пдо-36 (сохранена из исходного проекта).

- `laba1` — Flutter-приложение с именем автора в AppBar.
- `laba2` — консольный учёт расходов на Dart.
- `laba3` — «Атлас городов»: лабораторные 3–7, Photon API, карточки,
  подробности, лайки, BLoC, debounce, обновление, локализация и настройки.

## Запуск

Установите Flutter SDK и Android SDK. Открывайте папку соответствующей
лабораторной, а не вложенную папку `android`.

Для `laba1` и `laba3`:

```powershell
flutter pub get
flutter run
```

Для `laba2`:

```powershell
dart pub get
dart run
```

## Проверка

В Flutter-проектах: `flutter analyze`; в `laba3` также `flutter test`.
В `laba2`: `dart analyze` и `dart run`.

## Изменения

API заменён на Photon: https://photon.komoot.io/api/
Документация: https://github.com/komoot/photon/blob/master/docs/api-v1.md
Источник: OpenStreetMap, https://www.openstreetmap.org/copyright
Поиск ограничен городами (`layer=city`), результат GeoJSON преобразуется в DTO.
В Photon нет населения и часового пояса: в карточке подробностей для них
отображается отсутствие данных. Сервер может возвращать местное название,
если перевод на выбранный язык отсутствует.
Обновлены бирюзовая палитра, название приложения и пример поискового запроса.
Автор заменён на «Корнилов Вова». Старые настройки SDK и результаты сборок
другого компьютера в комплект не включены.

## Проверено на этом компьютере

Flutter 3.47.9, Dart 3.13.7, Android SDK 35/36, NDK 28.2, CMake 3.22.1,
Android Studio 2026.2.2 и плагины Flutter/Dart установлены в C:/DevTools.
Проекты: C:/DevTools/projects/labs.

- laba1: flutter analyze — без замечаний.
- laba2: dart analyze — без замечаний; dart run — успешно.
- laba3: flutter analyze — без замечаний; flutter test — 10 тестов прошли.

На рабочем столе есть ярлыки Android Studio и лабораторных.
После установки откройте новый терминал, чтобы обновился PATH.

Для Java настроен параметр jdk.net.unixdomain.tmpdir, обходящий ошибку
Unable to establish loopback connection на этом компьютере.
Для эмулятора используется графика host с отключённым Vulkan.

APK laba3 собран в debug-режиме, установлен и запущен на эмуляторе API 36.
Все лицензии Android SDK приняты.

Проверен настоящий поиск Moscow на эмуляторе: города и флаги загружаются.

## Git и публичный репозиторий

Репозиторий: https://github.com/Vovanvy/flutter-labs-kornilov

```powershell
git clone https://github.com/Vovanvy/flutter-labs-kornilov.git
cd flutter-labs-kornilov/laba3
flutter pub get
flutter run
```

Сборочные кэши и локальные пути SDK исключены через `.gitignore`.
Gradle Wrapper включён, поэтому отдельная установка Gradle не требуется.
