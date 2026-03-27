# rental_system

Mobile rental booking mock-up built with Flutter, Riverpod, and GoRouter.

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
