# Ciro Fuel — Client & Driver Mobile App

Flutter app for the CLIENT (fuel-station operator) and DRIVER personas of the
Ciro Fuel delivery platform. Consumes the backend defined in
`../specs/001-fuel-delivery-platform/` — see that feature's plan for the
NestJS API this app talks to. Full design docs for this app live in
`../specs/002-flutter-mobile-app/` (plan, research, data model, contracts).

## Architecture

Clean Architecture (data / domain / presentation) + MVVM, with **Cubit**
(`flutter_bloc`) as the ViewModel. Cross-cutting concerns live under
`lib/core/`; business capabilities are vertical feature modules under
`lib/features/{auth,orders,delivery,tracking,notifications}/`, each split
into `data/domain/presentation`. See `lib/core/di/injector.dart` for the
composition root.

## Prerequisites

- Flutter 3.24+ (stable), Dart 3.5+ — `flutter doctor` clean for iOS and/or
  Android.
- The backend running and reachable (see
  `../specs/001-fuel-delivery-platform/quickstart.md`).
- A Google Maps API key (Android + iOS).

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed / json_serializable
```

### Google Maps keys (never committed)

- **Android**: copy nothing — set `googleMaps.apiKey=...` in
  `android/local.properties` (gitignored).
- **iOS**: copy `ios/Flutter/Secrets.example.xcconfig` to
  `ios/Flutter/Secrets.xcconfig` (gitignored) and fill in
  `GOOGLE_MAPS_API_KEY`.

## Running

Config is passed via `--dart-define`, consumed by `lib/core/config/env.dart`:

```bash
flutter run \
  --dart-define=API_BASE_URL=http://localhost:3000/api/v1 \
  --dart-define=WS_BASE_URL=http://localhost:3000 \
  --dart-define=GOOGLE_MAPS_API_KEY=...
```

- The defaults in `lib/core/config/env.dart` already point at `localhost:3000`,
  so on the iOS simulator, macOS or Chrome a bare `flutter run` talks to a local
  backend with no defines at all.
- An **Android emulator** reaches the host via `10.0.2.2`, and a **physical
  device** needs the host's LAN IP (`ipconfig getifaddr en0`) — override
  `API_BASE_URL`/`WS_BASE_URL` for those. `.vscode/launch.json` has a ready
  configuration for each of the three targets.
- The backend must be running first (`npm run start:dev` in `ciro_fuel/`, with
  Mongo and Redis up via `docker compose up -d mongo mongo-init redis`).
  CLIENT/DRIVER accounts sign in by **phone** in E.164 form.

> `mobile_app/.env` is not read by anything — there is no `flutter_dotenv`
> dependency and it is not declared as an asset. All config flows through
> `--dart-define`.

## Tests

```bash
flutter test                      # unit + widget + bloc_test + integration (in-process)
```

All tests run headlessly against scripted HTTP adapters and mocked sockets —
no real backend or device is required to run the suite.

## Manual verification

See `../specs/002-flutter-mobile-app/quickstart.md` for a full walkthrough
of each user story (sign-in/session persistence, client order → payment →
tracking, driver delivery with the two-step OTP, and tracking
resilience/notifications) against a live backend.
