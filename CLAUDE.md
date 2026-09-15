# ACTIVE: cross-device live-tracking test (Mac = DRIVER, Windows = CLIENT)

**Read this first if you are the session running on the Mac.** It is an
operational handoff, not background. Delete this section when the test is over.

## Who does what

| | Machine | Persona | Responsibility |
|---|---|---|---|
| **You** | Mac | **DRIVER** | Run the app on an iPhone/simulator, sign in as the driver, drive a real route, keep the location stream alive |
| Other session | Windows | **CLIENT** + backend | Prepares the order, watches `order:location` / `order:status` live, drives order state over REST |

The backend runs on the Windows machine and is exposed to you over **ngrok**
(HTTPS). Do not point at `localhost`.

The live tunnel is **`https://firstly-perforative-jaylah.ngrok-free.dev`**,
verified reaching the backend (`/api/v1/health/ready` → mongodb, redis,
rateLimiting, realtimeFanout all `up`; a real login returns 201). That host is
already the **default** in `Env` (`lib/core/config/env.dart`), so a plain
`flutter run` targets it with no flags. Pass them only if the operator sends a
different URL — a free ngrok host changes whenever the tunnel restarts:

```bash
flutter run -d <device> \
  --dart-define=API_BASE_URL=https://<ngrok-host>/api/v1 \
  --dart-define=WS_BASE_URL=https://<ngrok-host>
```

Confirm the tunnel before blaming the app — `curl https://<host>/api/v1/health/ready`.
A dead tunnel and a broken client look identical from the device.

Because ngrok is HTTPS you need **no** cleartext exemption — neither Android's
`usesCleartextTraffic` nor iOS's `NSAllowsLocalNetworking`.

## The rule that will bite you

**DRIVER *and* CLIENT hold exactly ONE session each.** Only the three admin
roles are multi-session (`SESSION_CAPPED_ROLES` — `SUPER_ADMIN`,
`FUEL_COMPANY_ADMIN`, `TRANSPORT_COMPANY_ADMIN`, capped by
`auth.maxAdminSessions`, spec 015). DRIVER and CLIENT were deliberately left on
spec 006's single `sessionGeneration` counter, "bit-for-bit unchanged".

A second sign-in as the same driver *or* the same client displaces the first:
the backend pushes `session:revoked { cause: SIGNED_IN_ELSEWHERE }` to the live
socket, the server drops it, the device signs itself out with
*"تم تسجيل الدخول من جهاز آخر"*, and `LocationStreamService` stops streaming.

While this test runs:

- **Only the Mac signs in as the driver** — never from a script, a second
  simulator, curl, or the Windows side. This already happened once and silently
  killed a tracking run.
- **Only ONE client session exists at a time, and the Windows side is using
  it** to watch the customer's live map. If you sign in as the CLIENT on the
  Mac as well, you will revoke that watcher and the Windows side goes blind.
  Coordinate before doing it.
- Both failures look identical from the outside — positions simply stop — so
  when tracking "breaks", check for `session:revoked` before suspecting the
  platform.
- If a second driver is needed, use the second seeded one — never share one.

## Credentials (seed suffix `45453736`)

| Role | Login | Password |
|---|---|---|
| DRIVER 1 | `+966550037360` | `Password123!` |
| DRIVER 2 | `+966550037361` | `Password123!` |
| CLIENT | `+966540053736` | `Password123!` |
| FUEL_COMPANY_ADMIN | `fuel@dash45453736.test` | `Password123!` |
| TRANSPORT_COMPANY_ADMIN | `transport@dash45453736.test` | `Password123!` |
| SUPER_ADMIN | `owner@example.com` | `change-me-please-16chars` |

Driver 1 operates truck `DSH-3736-0` (NFC card `SEED-CARD-45453736-0`); driver 2
operates `DSH-3736-1` (`SEED-CARD-45453736-1`).

## You do not need NFC or the camera

Departure and loading verify a truck by **NFC card or QR**, and a simulator has
neither. Do not work around it: **the Windows side drives the order to
`IN_TRANSIT` over REST before you start**, so your job begins with a delivery
already in flight.

Sign in → pass the app lock → confirm the home screen shows the active delivery
→ move. `DeliveryCubit.load()` starts `LocationStreamService` automatically
whenever `getActiveOrder()` returns an order; there is no "start tracking"
button.

**Order waiting for you right now:** `6aa74a614a0300d40cb24020` — `IN_TRANSIT`,
12,000 L DIESEL, held by Dashboard Driver 1, destination "Dashboard test
station, Riyadh" (24.7136, 46.6753). The driver home shows it as **`#B24020`**.
If it has been completed by the time you start, ask the Windows side for a fresh
one rather than trying to create it yourself — only that side can get an order
past the NFC-gated steps.

Signing in on the Mac will **displace** the Android emulator session on the
Windows machine that is currently holding this driver. That is expected and is
the correct handover; it is not a bug to report.

## The app lock

Mandatory and unconfigurable (spec 006), and it accepts the device passcode as
well as biometrics (`biometricOnly: false`) so a failed sensor cannot strand a
driver mid-delivery. On the Windows emulator it is PIN `1234` with one enrolled
fingerprint at id `0` (`adb emu finger touch 0`). Set whatever equivalent you
need on the Mac; the prompt exposes a **"Use PIN"** button when biometrics fail.

## What the gate does, so you can read the result

`LocationEmitGate` sends a fix only when it is **> 50 m** from the last accepted
one **or** 3 minutes have passed, and never more than once per 5 s. So:

- Normal driving produces a steady stream.
- Standing still produces one fix every 3 minutes, not silence.
- A deliberate small move (< 50 m) inside 3 minutes **must produce nothing** —
  that suppression is a correct result, not a failure.

The server re-enforces the same policy, so a fix accepted locally can still be
dropped server-side; the Windows side sees the truth.

## Android fixes already applied — do not re-diagnose

Three defects were found by running on a real Android device and are already
fixed in this repo:

1. **`android/app/build.gradle.kts`** — `isCoreLibraryDesugaringEnabled` plus
   `desugar_jdk_libs:2.1.4`. `flutter_local_notifications` ^18 requires it;
   without it **no APK builds at all** (`:app:checkDebugAarMetadata`).
2. **`android/app/src/main/AndroidManifest.xml`** — `android.permission.WAKE_LOCK`.
   `LocationStreamService` sets `enableWakeLock: true`, and without the
   permission `getPositionStream` throws `SecurityException` the moment the
   foreground service starts. **Live tracking was silently dead**: `start()`
   still returned true and the UI still claimed to be sharing location.
3. **`android/app/src/debug/AndroidManifest.xml`** — `usesCleartextTraffic`,
   debug-only, for a local backend over plain HTTP. Irrelevant over ngrok.

None are visible to `flutter test`, which never invokes Gradle and never touches
a real geolocator. Do not expect the suite to catch their return.

## iOS notes

`Info.plist` already declares `NSLocationWhenInUseUsageDescription`,
`NSLocationAlwaysAndWhenInUseUsageDescription` and `UIBackgroundModes: [location]`,
and `AppleSettings` sets `allowBackgroundLocationUpdates: true` with
`pauseLocationUpdatesAutomatically: false`. That configuration has been reviewed
but **never executed** — no Mac was available until now. You are the first real
iOS run, so treat anything location-related as unverified rather than
known-good.

Simulate movement with **Debug → Location → Custom Location** or a GPX route; on
a physical iPhone, just drive.

## Report back

State explicitly which of these you observed, and do not infer the last two —
the Windows side is the only place they are visible:

1. Did the app reach the home screen with the active delivery?
2. Did the location stream start without an exception (`FlutterGeolocator` logs)?
3. Did the app stay signed in for the whole route, or get displaced?
4. Anything the UI got wrong — wrong copy, broken RTL, a control that does
   nothing, a value that disagrees with the backend.

---

# mobile_app — structure guide for AI agents

Flutter app serving **two personas from one binary**: `CLIENT` (fuel-station
operator) and `DRIVER`. Backend is the NestJS API in `../ciro_fuel`
(`/api/v1` REST + `/tracking` Socket.io). Setup, run commands and manual
verification live in [README.md](./README.md) — this file is only about
*where code goes and why*.

> **Read this before creating any file.** The single most common mistake in
> this repo is putting persona-specific code somewhere that implies it is
> shared, or duplicating a shared data path per persona. Both have already
> happened; see [Known structural debt](#known-structural-debt).

---

## 1. The rule

> **A folder's position answers "which domain?".**
> **A subfolder under `presentation/` answers "which persona?".**

| Layer | Persona split? | Why |
|---|---|---|
| `data/`, `domain/` | **Never** | One backend, one API, one `Order` entity. The backend scopes by role — a driver's "trip" *is* an order from `GET /orders`. Two repositories for one endpoint is always a bug waiting to happen. |
| `presentation/` | **Only where the UI actually diverges** | Client = browse/order/pay/track. Driver = execute one job, stream location, OTP handover. These share almost no pixels. |

Where one screen genuinely serves both personas (login, notifications,
support), keep `presentation/` flat. **Do not split preemptively.**

**Rejected alternative — persona-first (`features/client/…` + `features/driver/…`).**
It reads well in a tree and is the wrong shape here: it forces the order
domain to exist twice, which is exactly what produced the duplicate
datasource this repo already carries. Persona-first pays off when two apps
share nothing but a login. These two share a backend contract, an `Order`, a
socket and a session — everything except pixels.

---

## 2. Current structure (what actually exists)

Accurate as of the last update to this file. **Persona ownership is not
visible in these folder names** — the annotations below are the only place it
is written down.

Legend: **[C]** client-only · **[D]** driver-only · **[S]** shared

```
lib/
├── main.dart                     bootstrap: DI, localization, runApp
├── app.dart                      root widget; app-level BlocProviders
│
├── core/                         [S] infrastructure — MUST stay persona-agnostic
│   ├── config/                   constants.dart · env.dart · redaction_policy.dart
│   ├── constants/                app_assets.dart
│   ├── di/                       injector.dart          ← composition root (get_it)
│   ├── error/                    failure.dart · exceptions.dart · error_boundary.dart
│   │                             app_bloc_observer.dart
│   ├── localization/             app_locales.dart · translation_keys.dart
│   ├── network/                  dio_client.dart · auth_interceptor.dart
│   │                             error_interceptor.dart · token_store.dart
│   │                             request_extras.dart
│   ├── nfc/                      spec 008: NfcReader port + NfcManagerReader
│   │                             adapter — the only file importing `nfc_manager`,
│   │                             mirroring how `phone_dialer.dart` isolates
│   │                             `url_launcher`
│   ├── realtime/                 tracking_socket.dart · socket_events.dart
│   ├── router/                   app_router.dart · app_routes.dart
│   ├── security/                 biometric_authenticator.dart
│   ├── theme/                    app_theme.dart · app_colors.dart · app_spacing.dart
│   │                             app_text_styles.dart · theme_context.dart
│   │                             theme_cubit.dart
│   ├── utils/                    number_formatting.dart
│   └── widgets/                  shared primitives — BUT see debt #3
│
├── shared/                       [S] cross-persona truth
│   ├── entities/                 order.dart · auth_user.dart · invoice.dart
│   │                             value_objects.dart            (freezed)
│   ├── enums/                    order_status · fuel_type · payment_method
│   │                             invoice_state · notification_type · otp_purpose
│   │                             user_role · fuel_grade · converters
│   │                             spec 008: order_status gained `loading` (backend
│   │                             `LOADING`, between assignedToDriver and inTransit)
│   │                             — every exhaustive switch over the enum has a
│   │                             case for it; + tank_material, verification_method
│   └── models/                   filter_selection.dart · station_option.dart
│
└── features/
    ├── auth/            [S]  data · domain · presentation
    │                         SessionCubit here is the app-wide identity the
    │                         router redirects from. AuthCubit drives the form.
    │                         spec 006: AppLockCubit + LockScreen + AppLockGate
    │                         (mandatory, DRIVER-only device lock — app.dart's
    │                         `builder:`, not a route, so it also covers screens
    │                         pushed via raw MaterialPageRoute); PasswordResetCubit
    │                         + ForgotPasswordScreen/ResetPasswordScreen (shared,
    │                         reachable pre-login like /login itself).
    ├── orders/          [C]  data · domain · presentation
    │                         data/ + domain/ are the SHARED order stack; as of
    │                         spec 007, `OrdersCubit`/`GetOrders` under
    │                         presentation/ are ALSO consumed directly by a
    │                         driver screen (`driver_orders_screen.dart`, in
    │                         delivery/) — the "presentation/ is client-only"
    │                         reading no longer holds for that one cubit.
    │                         RatingCubit (client's own rating control) is
    │                         genuinely client-only here.
    ├── delivery/        [D]  data · domain · presentation
    │                         driver_home_screen (real header via
    │                         DriverSummaryCubit) · delivery_detail_screen
    │                         (real stage + customer rating display) ·
    │                         driver_orders_screen (reads orders/'s stack)
    │                         OTP cubits · location_stream_service + emit gate
    │                         spec 008: VehicleVerificationCubit +
    │                         vehicle_verification_screen (departure/loading
    │                         NFC-tap-or-QR-scan verification, `getIt`
    │                         `registerFactoryParam` keyed by orderId, same
    │                         lifecycle as OtpVerifyCubit); delivery_detail_screen
    │                         now gates ASSIGNED_TO_DRIVER/LOADING behind it and
    │                         shows `tankSummary`/`warehouseSummary` + a
    │                         quantity-free "Confirm Loading Complete" button
    ├── tracking/        [S]  domain/entities · presentation/cubit
    │                         client watches an order · driver emits position
    ├── notifications/   [S]  data · domain · presentation
    ├── home/            [C]  presentation only
    │                         client_home_screen · client_main_scaffold (shell)
    │                         + 12 dashboard widgets
    ├── invoices/        [C]  data · domain · presentation (FinanceCubit)
    ├── payments/        [C]  presentation only
    ├── more/            [C]  presentation only — settings list, terms, credit limit
    ├── profile/         [C]  presentation only — client routes today
    ├── stations/        [C]  presentation only
    └── support/         [S]  presentation only — reachable pre-login
```

### Where the personas actually diverge today

| | Client | Driver |
|---|---|---|
| Routes (`app_routes.dart`) | 14 (`/client/*`) | 9 (`/driver/*`) |
| Screens | 8 `client_*` | 11 (`driver_*` + `DeliveryDetailScreen`) |
| Shell | `ClientMainScaffold` + `MainNavBar` (5 tabs) | `DriverMainScaffold` (5 tabs: home, orders, notifications, profile, more) |
| Profile / settings | yes | yes (spec 006: live identity, phone-number change — spec 008 removed the driver's own embedded truck field entirely, see below) |

Both personas share the mandatory app lock (`AppLockGate`, DRIVER-only per FR-010 — the
client's own lock stays optional/`more/`-configurable) and password recovery
(`ForgotPasswordScreen`/`ResetPasswordScreen`, reachable pre-login).

**Biometrics depend on two platform settings that no widget test can see, and both were wrong until
2026-09-03** (found from a user report: pressing Face ID on the login screen crashed the app).
`BiometricAuthenticator` catches `PlatformException`/`MissingPluginException` and degrades to
"unavailable", which hides almost every biometric failure — but not these two:
· **iOS** *terminates the process* on the first Face ID `evaluatePolicy` call when
`NSFaceIDUsageDescription` is missing from `ios/Runner/Info.plist`. It is a native abort, so no Dart
`catch` runs and the "password form remains the path in" contract does not hold — the app just
disappears.
· **Android** shows the prompt through the AndroidX fragment manager, so `MainActivity` **must** extend
`FlutterFragmentActivity`. Under a plain `FlutterActivity` every `authenticate()` fails with
`no_fragment_activity` — which *is* caught, so the lock and biometric sign-in were silently inert with
no crash and no error to follow.
Both are now guarded by `test/unit/biometric_platform_config_test.dart`. **Still open, disclosed:**
`LaunchTheme`/`NormalTheme` descend from `@android:style/Theme.*`, not AppCompat, which
`androidx.biometric`'s pre-API-28 fallback dialog wants; `minSdk` is 26, so API 26–27 devices can still
hit that path.

`AppRouter._redirect` gates on `SessionCubit` and bounces a driver off
`/client/*` and a client off `/driver/*`. Server-side role scoping is the real
enforcement; the router is UX only.

---

## 3. Target structure (agreed, NOT yet applied)

**Do not assume these paths exist.** Written down so incremental work moves
toward it instead of away. Migration is staged in §5.

```
lib/
├── app/                          composition root, lifted out of core/
│   ├── app.dart · di/injector.dart
│   └── router/  app_routes · app_router · client_routes · driver_routes
├── core/                         unchanged (infrastructure only)
├── shared/                       unchanged (entities + enums)
└── features/
    ├── auth/          data · domain · presentation            (flat — one login)
    ├── orders/        data · domain                           ← delivery/ folds in here
    │                  presentation/{client, driver, shared}
    ├── home/          presentation/{client, driver}           client shell + driver shell
    ├── profile/       presentation/{client, driver}
    ├── settings/      presentation/{client, driver}           ← renamed from more/
    ├── tracking/      presentation/{client, driver}           watch vs. emit
    ├── notifications/ presentation                            (flat — one UI)
    ├── support/       presentation                            (flat)
    ├── billing/       presentation/client                     ← invoices/ + payments/ merged
    └── stations/      presentation/client
```

Two deliberate calls:

- **Client-only features still get `presentation/client/`.** Costs one
  directory; means adding a driver view later is a new folder, never a
  reshuffle.
- **`invoices/` + `payments/` → `billing/`.** One domain split across two
  folders today, and the driver will eventually need a deferred-invoice view
  of the same data (backend `GET /invoices` already serves
  `TRANSPORT_COMPANY_ADMIN`).

---

## 4. Known structural debt

Live issues an agent will trip over. Fix in place; don't work around.

1. **✅ Fixed (spec 007 T014).** `GET /orders` returns `{ items, nextCursor }`
   (cursor pagination, spec 005) — this file previously described it as
   returning "a bare JSON array", which stopped being true once spec 005
   landed and was itself stale. `delivery/data/datasources/
   delivery_remote_data_source.dart`'s `getActiveOrder()` now parses that
   real envelope via the shared `parsePaginatedResponse` helper, same as
   `orders/`'s own datasource; `test/unit/delivery_active_order_test.dart`
   scripts the real shape rather than the old `{"data":[…]}` fiction.

2. **Two datasources call one endpoint — driver half closed (spec 007
   T041).** The driver's order list (`driver_orders_screen.dart`) now reads
   `features/orders/`'s `OrdersRepository`/`GetOrders` directly rather than
   growing its own; `delivery/` no longer duplicates a second list-fetch
   path. `delivery/`'s remaining data/domain layers (active-order lookup,
   the four handover actions, the driver-summary read) are genuinely
   driver-only work with no client equivalent, so folding all of `delivery/`
   into `orders/` — the rest of this debt entry — is still open; only the
   part that was a real duplicate is resolved.

3. **`core/widgets/main_nav_bar.dart` is client-only** (Payments / Orders /
   Invoices / More) but sits in `core/` as if shared. Belongs with the client
   shell. When the driver gets a nav bar, `core/` must not hold two.

4. **`ClientMainScaffold` lives in `features/home/`.** It is an app shell, not
   a home feature.

5. **✅ Fixed (spec 007 T010).** `shared/enums/notification_type.dart` now
   matches the backend's real wire values (`ORDER_APPROVED_FINAL_PRICE`,
   `NO_DRIVER_AVAILABLE`, `PAYMENT_TIMEOUT`, `ORDER_ASSIGNED`,
   `ORDER_STATUS_CHANGED`, `OTP_ISSUED`, `PAYMENT_RECONCILIATION_REQUIRED`,
   `ORDER_ROUTED_TO_TRANSPORT`, `SUPPORT_REQUEST_RAISED`) — the two enums
   previously shared no values at all, so every live notification degraded
   to `unknown`. `test/unit/notification_type_test.dart` guards them from
   drifting apart again.

6. **✅ Fixed (spec 013 Slice 0).** `TrackingSocket` now keeps a durable
   `(event, handler)` registry: `on*` records into it and attaches
   immediately only if a socket already exists; `connect()` flushes the whole
   registry onto the socket it builds; `dispose()` tears down the socket but
   **keeps the registry** (an app-lifetime singleton like `NotificationsCubit`
   registers once, in its constructor, and must survive a sign-out/sign-in).
   A handler registered before `connect()` — the exact case that silently
   subscribed to nothing — now fires. `test/unit/tracking_socket_registry_test.dart`
   guards it. `SessionRevocationListener`/`DeliveryListener` remain but attach
   **once** (an `injector.dart` guard) since the registry re-flushes them per
   connect; re-attaching would stack duplicate handlers.

7. **`order_mock_data.dart` / `mock_order_state.dart` are still wired into
   real screens** — the **client-side** `OrderDetailScreen(mockState:)`
   instance remains open; not all client order-detail UI is API-backed yet.
   The driver-side instances of this pattern are now all closed:
   `delivery_detail_screen.dart`'s `_OrderMockState` enum (spec 007), and
   spec 013 US3's rewrite of `driver_notifications_screen.dart` against the
   app-wide `NotificationsCubit` — it had been a `StatelessWidget` with
   hardcoded rows (`ORD-2024-256`, "5 mins ago") and three category tabs; the
   tabs are gone (a driver receives only `ORDER_ASSIGNED` and
   `DRIVER_STOP_DETECTED`, both order-related), replaced by the All/Unread
   filter. spec 013 also removed the fabricated identity on the driver "more"
   tab (`driver_mock_profile.*` name/station → real `ProfileCubit`), the
   fixed screenshot posing as a live map in `driver_navigation_screen.dart`,
   and every inert `onPressed: () {}` on a driver screen (guarded by
   `test/no_dead_controls_sweep_test.dart`).

---

## 5. Migration path

Sequential; each step leaves the suite green and is independently
shippable. Do **not** collapse these into one commit.

1. **Fix debt #1 + its test.** One-line shape fix, no file moves — keep it a
   reviewable bug fix rather than burying it in a rename diff.
2. **Fold `delivery/` into `orders/`.** Delete the duplicate datasource; both
   personas resolve one `OrdersRepository`. Driver screens →
   `orders/presentation/driver/`. Largest diff.
3. **Give each persona a shell.** `client_main_scaffold` + `main_nav_bar` →
   `home/presentation/client/`; add the driver shell beside it; split the
   route table into `client_routes` / `driver_routes`.
4. **Split the shared-domain screens.** Add `presentation/{client,driver}/`
   under `profile/`, `settings/` (from `more/`) and `tracking/`. Existing
   client screens move down one level unchanged; driver screens are additive.
5. **Tidy.** Merge `invoices/` + `payments/` → `billing/`; lift `di/` +
   `router/` into `app/`; sweep `core/widgets/` for persona-specific leftovers.

---

## 6. Conventions

- **Clean Architecture + MVVM.** `data → domain ← presentation`. Repositories
  return `Either<Failure, T>` (`dartz`); cubits depend on use cases, not
  repositories. *Existing exception:* three cubits inject a `data/` service
  directly (`LoginPreferencesStore` in `auth_cubit` + `login_form_cubit`,
  `LocationStreamService` in `delivery_cubit`) — device-local services with no
  domain abstraction. Follow the use-case path for anything that touches the
  API; don't cite these three as precedent for it.
- **Cubit only** (`flutter_bloc`) — no `Bloc` with events. State classes are
  `freezed` sealed unions; screens `switch` on them exhaustively.
- **DI is `get_it`**, wired in `core/di/injector.dart`. Register a feature in
  its own `_register<Feature>Feature()` function. Screens may resolve use
  cases directly via `getIt<T>()`; that is the established pattern here.
- **No magic values.** Roles, statuses, OTP purposes, socket events, route
  paths and asset paths are enums or `abstract final class` constant holders.
  Wire strings are parsed in exactly one place — the enum's `fromWire`.
- **The backend is the only source of truth for state transitions.** Never
  derive or assert an order status locally; re-fetch on an `order:status`
  push (see `OrderDetailCubit`).
- **Codegen**: `freezed` + `json_serializable`. After touching an entity or
  state class run `dart run build_runner build`. Never edit `*.freezed.dart`
  or `*.g.dart`.
- **Localization**: `easy_localization`, keys in
  `core/localization/translation_keys.dart`, JSON in `assets/translations/`.
  Arabic is default and the app is RTL-first. Some older screens still hold
  inline Arabic strings — follow the file you are editing.
- **Theming**: read colors via `context.colors` (`core/theme/theme_context.dart`).
  `AppColors.light.*` direct access appears in older files; prefer
  `context.colors` in new code.
- **Secrets** never land in the repo: config flows through `--dart-define`
  into `core/config/env.dart`; Maps keys live in gitignored
  `android/local.properties` and `ios/Flutter/Secrets.xcconfig`.

---

## 7. Tests

`flutter test` — all headless, scripted Dio adapters and mocked sockets. No
backend or device needed.

```
test/
├── unit/            cubits, interceptor, location gate, socket reauth
├── integration/     auth_session · client_order_flow · driver_delivery
├── golden/          login_screen_golden_test.dart
├── helpers/         localized_harness.dart
├── support/         orders_test_di.dart   ← fake repos + getIt registration
└── *.dart           widget/render tests (overflow sweeps, nav, screens)
```

Register feature DI in a test via `test/support/orders_test_di.dart`
(`registerOrdersTestDi` / `registerFinanceTestDi` /
`sampleAuthenticatedSessionCubit`). Reset in `tearDown`.

**Two known non-green tests, both pre-existing and unrelated to structure:**
`login_screen_golden_test` (pixel diff, fails) and `auth_session_test`
(router timing, `skip: true`). Corrected during spec 006 (driver auth &
session), which verified this count by actually running the suite
repeatedly rather than trusting an older count of three here that
included `order_flow_render_test` → "order detail renders in cancelled" —
that case passes on its own and inside the full run; there is no third
pre-existing failure. Do not treat the two above as regressions from your
change — but do confirm the count is still exactly two.

---

## 8. Related docs

| Doc | Covers |
|---|---|
| [README.md](./README.md) | setup, run commands, keys, manual verification |
| `../ciro_fuel/specs/002-flutter-mobile-app/plan.md` | this app's design plan |
| `../ciro_fuel/specs/001-fuel-delivery-platform/contracts/rest-api.md` | **the API contract — check before touching a datasource** |
| `../ciro_fuel/CLAUDE.md` | backend architecture, roles, tenant isolation |
