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
│   └── models/                   filter_selection.dart · station_option.dart
│
└── features/
    ├── auth/            [S]  data · domain · presentation
    │                         SessionCubit here is the app-wide identity the
    │                         router redirects from. AuthCubit drives the form.
    ├── orders/          [C]  data · domain · presentation
    │                         data/ + domain/ are the SHARED order stack even
    │                         though every screen under presentation/ is client.
    ├── delivery/        [D]  data · domain · presentation
    │                         driver_home_screen · delivery_detail_screen
    │                         OTP cubits · location_stream_service + emit gate
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
| Routes (`app_routes.dart`) | 14 (`/client/*`) | 3 (`/driver/*`) |
| Screens | 8 `client_*` | 2 `driver_*` |
| Shell | `ClientMainScaffold` + `MainNavBar` (5 tabs) | none — single screen |
| Profile / settings | yes | **none** |

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

1. **🔴 The driver's order fetch is broken against the real backend.**
   `GET /orders` returns a **bare JSON array** (`OrdersController.findMine`).
   `orders/data/datasources/orders_remote_data_source.dart` parses that
   correctly. `delivery/data/datasources/delivery_remote_data_source.dart`
   reads `response.data!['data']` — an envelope the backend never sends.
   It is masked because `test/integration/driver_delivery_test.dart` mocks
   `{"data":[…]}`, so the test passes against a fiction; and
   `DeliveryRepositoryImpl._guard` catches only `DioException`, so the cast
   failure escapes the repository instead of becoming a `Failure`.

2. **Two datasources call one endpoint.** Direct consequence of the driver
   having its own stack. `delivery/`'s data + domain layers belong inside
   `orders/`. This is the concrete reason for the rule in §1.

3. **`core/widgets/main_nav_bar.dart` is client-only** (Payments / Orders /
   Invoices / More) but sits in `core/` as if shared. Belongs with the client
   shell. When the driver gets a nav bar, `core/` must not hold two.

4. **`ClientMainScaffold` lives in `features/home/`.** It is an app shell, not
   a home feature.

5. **`shared/enums/notification_type.dart` does not match the backend.** Wire
   values (`FINAL_PRICE_READY`, …) are not the backend's
   (`ORDER_APPROVED_FINAL_PRICE`, `ORDER_ASSIGNED`, `ORDER_STATUS_CHANGED`,
   `OTP_ISSUED`, `ORDER_ROUTED_TO_TRANSPORT`). Everything degrades to
   `unknown`, so live notifications render as generic entries.

6. **`NotificationsCubit` never receives socket pushes.** It registers its
   handler in its constructor, but it is an eager singleton built before
   `TrackingSocket.connect()`, so `_socket` is still null and
   `onNotification` is a silent `?.` no-op. A fresh socket object is created
   on each connect, so the handler is never attached.

7. **`order_mock_data.dart` / `mock_order_state.dart` are still wired into
   real screens** (`OrderDetailScreen(mockState:)`, `OrderTopBar`
   notification counts). Not all order-detail UI is backed by the API yet.

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

**Three known-failing tests, all pre-existing and unrelated to structure:**
`login_screen_golden_test` (pixel diff), `auth_session_test` (router timing),
`order_flow_render_test` → "order detail renders in canceled" (mock-only
state gap). Do not treat these as regressions from your change — but do
confirm the count is still exactly three.

---

## 8. Related docs

| Doc | Covers |
|---|---|
| [README.md](./README.md) | setup, run commands, keys, manual verification |
| `../ciro_fuel/specs/002-flutter-mobile-app/plan.md` | this app's design plan |
| `../ciro_fuel/specs/001-fuel-delivery-platform/contracts/rest-api.md` | **the API contract — check before touching a datasource** |
| `../ciro_fuel/CLAUDE.md` | backend architecture, roles, tenant isolation |
