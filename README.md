# rental_system

Mobile rental booking mock-up built with Flutter, Riverpod, and GoRouter.

## Download APK

[⬇ Download Android APK](https://drive.google.com/file/d/1Wz4T4qktbMbikiKnmHwyonC-J9IZeGZW/view?usp=sharing)

> Android 5.0+ required. Enable "Install from unknown sources" in device settings before installing.

## What this is

- A portfolio/assessment style mock project.
- Demonstrates auth flow, shell navigation, rental browsing, bookings, and a payment flow UI.
- Not production-ready backend architecture.

## Tech stack

- Flutter + Dart
- flutter_riverpod
- go_router
- flutter_screenutil
- shared_preferences

## Run locally

1. Install Flutter SDK.
2. Run `flutter pub get`.

## Project structure

- `lib/core`: shared constants, router, theme, common widgets.
- `lib/features`: feature-first modules (`auth`, `rentals`, `bookings`, `payments`, `profile`).
- `android/`, `ios/`: Flutter platform targets.
