# DishDash

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.4+-0175C2?logo=dart&logoColor=white)](https://dart.dev/)

Cross-platform **Flutter** app that surfaces **meal and drink recipe ideas** to support healthier eating day to day. State is handled with **Riverpod** (with **Provider**-compatible patterns where applicable), preferences via **shared_preferences**, and HTTP calls through **`http`**. The UI targets **Material Design** with **light and dark** themes.

Application sources live in [`dish_dash/`](dish_dash/).

## Prerequisites

- **Flutter SDK** compatible with Dart `>=3.4.1 <4.0.0` (see [`dish_dash/pubspec.yaml`](dish_dash/pubspec.yaml))
- **Xcode** (iOS), **Android SDK** (Android), or a desktop/web target as supported by your Flutter install

## Setup

```bash
git clone https://github.com/Linch-mini/DishDash.git
cd DishDash/dish_dash
flutter pub get
```

## Run

From `dish_dash/` (after setup):

```bash
flutter run
```

Select a device or emulator when prompted.

## Quality checks

From `dish_dash/`:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Project layout

| Path | Purpose |
| ---- | ------- |
| `dish_dash/lib/` | Dart application code |
| `dish_dash/assets/` | Images and launcher artwork |
| `dish_dash/ios/`, `dish_dash/android/` | Platform projects |

Course-oriented assignment notes for team workflows remain in [`dish_dash/README.md`](dish_dash/README.md).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
