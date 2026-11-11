# Лабораторная работа 1

Минимальный Flutter-проект с целевой платформой Android.
В AppBar отображаются ФИО и группа: Корнилов Вова, Пдо-36.

Основной код: `lib/main.dart`. `main` запускает `MyApp`, `MaterialApp`
задаёт приложение, `Scaffold` содержит верхнюю панель `AppBar` и тело экрана.
Состояния и дополнительные библиотеки для этой работы не нужны.

```powershell
flutter pub get
flutter analyze
flutter build apk --debug
flutter run -d emulator-5554
```

Сначала запустите эмулятор в Device Manager Android Studio или командой
`flutter emulators --launch Medium_Phone`. Идентификатор смотрите в `flutter devices`.

APK после сборки: `build/app/outputs/flutter-apk/app-debug.apk`.
Git-репозиторий находится в родительской папке `labs`.
