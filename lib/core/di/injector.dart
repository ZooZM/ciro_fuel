import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../core/theme/theme_cubit.dart';
import '../../shared/enums/user_role.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/login_preferences_store.dart';
import '../../features/auth/data/datasources/password_reset_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/password_reset_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/password_reset_repository.dart';
import '../../features/auth/domain/usecases/complete_password_reset.dart';
import '../../features/auth/domain/usecases/request_password_reset.dart';
import '../../features/auth/domain/usecases/restore_session.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/verify_reset_code.dart';
import '../../features/auth/presentation/cubit/app_lock_cubit.dart';
import '../../features/auth/presentation/cubit/password_reset_cubit.dart';
import '../../features/auth/presentation/cubit/session_cubit.dart';
import '../../features/auth/presentation/cubit/session_revocation_message.dart';
import '../../features/auth/presentation/cubit/session_state.dart';
import '../../features/delivery/data/datasources/delivery_remote_data_source.dart';
import '../../features/delivery/data/repositories/delivery_repository_impl.dart';
import '../../features/delivery/data/services/location_stream_service.dart';
import '../../features/delivery/domain/repositories/delivery_repository.dart';
import '../../features/delivery/domain/usecases/get_active_order.dart';
import '../../features/delivery/domain/usecases/get_driver_summary.dart';
import '../../features/delivery/presentation/cubit/delivery_cubit.dart';
import '../../features/delivery/presentation/cubit/driver_summary_cubit.dart';
import '../../features/delivery/presentation/cubit/otp_verify_cubit.dart';
import '../../features/delivery/domain/usecases/mark_arrived.dart';
import '../../features/delivery/domain/usecases/acknowledge_assignment.dart';
import '../../features/delivery/domain/usecases/declare_stop.dart';
import '../../features/delivery/domain/usecases/report_blocked.dart';
import '../../features/delivery/domain/usecases/submit_stop_reason.dart';
import '../notifications/notification_presenter.dart';
import '../notifications/stop_alert_router.dart';
import '../notifications/local_notification_presenter.dart';
import '../../features/delivery/domain/usecases/request_delivery_otp.dart';
import '../../features/delivery/domain/usecases/verify_arrival_otp.dart';
import '../../features/delivery/domain/usecases/verify_delivery_otp.dart';
import '../../features/delivery/domain/usecases/verify_vehicle.dart';
import '../../features/delivery/domain/usecases/confirm_loading.dart';
import '../../features/delivery/presentation/cubit/vehicle_verification_cubit.dart';
import '../nfc/nfc_reader.dart';
import '../location/geolocator_position_reader.dart';
import '../location/position_reader.dart';
import '../nfc/nfc_manager_reader.dart';
import '../../features/orders/data/datasources/orders_remote_data_source.dart';
import '../../features/orders/data/datasources/company_pricing_remote_data_source.dart';
import '../../features/orders/data/gateways/payment_gateway_impl.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/data/repositories/company_pricing_repository_impl.dart';
import '../../features/orders/domain/gateways/payment_gateway.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/repositories/company_pricing_repository.dart';
import '../../features/orders/domain/usecases/accept_final_price.dart';
import '../../features/orders/domain/usecases/cancel_order.dart';
import '../../features/orders/domain/usecases/create_order.dart';
import '../../features/orders/domain/usecases/get_current_otp.dart';
import '../../features/orders/domain/usecases/get_driving_route.dart';
import '../../features/orders/domain/usecases/get_order.dart';
import '../../features/orders/domain/usecases/get_orders.dart';
import '../../features/orders/domain/usecases/get_quote.dart';
import '../../features/orders/domain/usecases/submit_rating.dart';
import '../../features/orders/domain/usecases/get_fuel_prices.dart';
import '../../features/orders/domain/usecases/get_company_pricing_config.dart';
import '../../features/orders/domain/usecases/redispatch.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/orders/presentation/cubit/order_detail_cubit.dart';
import '../../features/orders/presentation/cubit/payment_cubit.dart';
import '../../features/orders/presentation/cubit/rating_cubit.dart';
import '../../features/tracking/presentation/cubit/tracking_cubit.dart';
import '../../features/stations/data/datasources/stations_remote_data_source.dart';
import '../../features/stations/data/repositories/stations_repository_impl.dart';
import '../../features/stations/domain/repositories/stations_repository.dart';
import '../../features/stations/domain/usecases/get_stations.dart';
import '../../features/stations/domain/usecases/set_favourite_station.dart';
import '../../features/stations/presentation/cubit/stations_cubit.dart';
import '../../features/invoices/data/datasources/invoices_remote_data_source.dart';
import '../../features/invoices/data/repositories/invoices_repository_impl.dart';
import '../../features/invoices/domain/repositories/invoices_repository.dart';
import '../../features/invoices/domain/usecases/get_credit_standing.dart';
import '../../features/invoices/domain/usecases/get_invoice.dart';
import '../../features/invoices/domain/usecases/get_invoices.dart';
import '../../features/invoices/presentation/cubit/credit_cubit.dart';
import '../../features/invoices/presentation/cubit/finance_cubit.dart';
import '../../features/invoices/presentation/cubit/invoice_detail_cubit.dart';
import '../../features/invoices/presentation/cubit/invoices_cubit.dart';
import '../../features/payments/data/datasources/payments_remote_data_source.dart';
import '../../features/payments/data/repositories/payments_repository_impl.dart';
import '../../features/payments/domain/repositories/payments_repository.dart';
import '../../features/payments/domain/usecases/get_payments.dart';
import '../../features/payments/presentation/cubit/payments_cubit.dart';
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications.dart';
import '../../features/notifications/domain/usecases/mark_all_notifications_read.dart';
import '../../features/notifications/domain/usecases/mark_notification_read.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/profile/data/datasources/phone_verification_remote_data_source.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/phone_verification_repository_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/phone_verification_repository.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/confirm_phone_verification.dart';
import '../../features/profile/domain/usecases/download_avatar.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/request_phone_verification.dart';
import '../../features/profile/domain/usecases/update_full_name.dart';
import '../../features/profile/domain/usecases/upload_profile_picture.dart';
import '../../features/profile/presentation/cubit/phone_verification_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/support/data/datasources/support_remote_data_source.dart';
import '../../features/support/data/repositories/support_repository_impl.dart';
import '../../features/support/domain/repositories/support_repository.dart';
import '../../features/support/domain/usecases/create_support_request.dart';
import '../../features/support/domain/usecases/get_support_requests.dart';
import '../../features/support/presentation/cubit/support_cubit.dart';
import '../session/current_avatar.dart';
import '../network/dio_client.dart';
import '../network/token_store.dart';
import '../realtime/delivery_listener.dart';
import '../realtime/session_revocation_listener.dart';
import '../realtime/tracking_socket.dart';
import '../security/biometric_authenticator.dart';
import '../router/app_router.dart';

final GetIt getIt = GetIt.instance;

/// Wires the app's dependency graph. Core singletons are registered here;
/// each feature adds its own registration block as that user story is
/// built, keeping this function the single composition root without
/// pre-declaring feature types earlier phases don't need yet.
Future<void> configureDependencies() async {
  _registerCore();
  _registerOrdersFeature();
  _registerInvoicesFeature();
  _registerPaymentsFeature();
  _registerDeliveryFeature();
  _registerNotificationsFeature();
  _registerProfileFeature();
  _registerSupportFeature();
  await _registerAuthFeature();
  _registerPasswordResetFeature();
}

void _registerCore() {
  final tokenStore = TokenStore();
  getIt.registerSingleton<TokenStore>(tokenStore);

  getIt.registerLazySingleton(ThemeCubit.new);

  final sessionCubit = SessionCubit();
  getIt.registerSingleton<SessionCubit>(sessionCubit);

  final trackingSocket = TrackingSocket(tokenStore: tokenStore);
  getIt.registerSingleton(trackingSocket);

  final dio = buildDioClient(
    tokenStore: tokenStore,
    // spec 006 T082: `cause` is set only when the 401 that killed the
    // refresh was the structured `SESSION_REVOKED` shape — the HTTP
    // backstop for FR-035b, stating the same reason the socket push
    // (below) would have when the device missed it while disconnected.
    onSessionExpired: ([cause]) async {
      await tokenStore.clear();
      sessionCubit.signOut(reason: sessionRevocationMessage(cause));
    },
    // The socket's handshake auth is fixed at connect time (WS contract),
    // so a silent token refresh must cycle the connection to pick up the
    // new token (FR-020, research R6) — only meaningful once already
    // connected; reauthenticate() is a no-op otherwise.
    onTokenRefreshed: trackingSocket.reauthenticate,
  );
  getIt.registerSingleton(dio);

  // The /tracking handshake needs a valid JWT, so the socket connects only
  // once authenticated and disconnects on sign-out. Registered before
  // hydration runs (below) so the resulting state change is not missed.
  var socketListenersAttached = false;
  sessionCubit.stream.listen((state) async {
    switch (state) {
      case SessionAuthenticated(:final user):
        // Awaited (spec 006 T080): `connect()` only assigns the underlying
        // socket after its own internal await (reading the access token) —
        // though feature 013 Slice 0 made a handler registered before that
        // await safe anyway, by recording it in `TrackingSocket`'s durable
        // registry rather than dropping it (`mobile_app/CLAUDE.md` debt #6).
        await trackingSocket.connect();
        // feature 013 Slice 0: `TrackingSocket` now keeps that registry
        // across `dispose()` and re-flushes it onto the fresh socket every
        // `connect()`, so these two socket listeners attach exactly once —
        // re-attaching them on each sign-in would stack duplicate handlers
        // (a second device-level stop alert, a double active-delivery
        // reload) that would only surface after a sign-out/sign-in without
        // an app restart.
        if (!socketListenersAttached) {
          socketListenersAttached = true;
          SessionRevocationListener(
            trackingSocket: trackingSocket,
            tokenStore: tokenStore,
            sessionCubit: sessionCubit,
          ).attach();
          // spec 007: a driver can never receive order:status any other way
          // (research R1/R2).
          DeliveryListener(
            trackingSocket: trackingSocket,
            deliveryCubit: getIt<DeliveryCubit>(),
            notificationPresenter: getIt<NotificationPresenter>(),
          ).attach();
        }
        // spec 011 T028: the tap side of that same alert — attached here so
        // it shares the listener's lifetime, and only for a signed-in
        // session, since there is nothing to route to before one exists.
        StopAlertRouter(
          notificationPresenter: getIt<NotificationPresenter>(),
          appRouter: getIt<AppRouter>(),
        ).attach();
        unawaited(getIt<NotificationsCubit>().load());
        // spec 007 FR-002: DeliveryCubit's active-delivery concept only
        // exists for the driver persona — a CLIENT session has no
        // assigned delivery to load, and `GET /orders` would just return
        // their own order history for no reason anything renders.
        if (user.role == UserRole.driver) {
          unawaited(getIt<DeliveryCubit>().load());
          unawaited(getIt<DriverSummaryCubit>().load());
        }
      case SessionUnauthenticated():
        trackingSocket.dispose();
        // Every sign-out path lands here — the deliberate one from the "more"
        // screen, a refresh failure via AuthInterceptor's onSessionExpired,
        // and a failed launch hydration — so clearing per-user state once
        // here covers all of them rather than only the button. Extended in
        // spec 005 (FR-047/T028/T029) to every list cubit now registered as
        // a session-lifetime singleton — a stale singleton surviving an
        // account switch would leak the previous client's orders/balances
        // into the next client's first frame. Extended again in spec 006
        // (FR-008/SC-002) to DeliveryCubit, the driver-side equivalent —
        // it too is a session-lifetime singleton (it owns the location
        // stream's lifecycle) and would otherwise leak the previous
        // driver's active order into the next driver's first frame.
        // ProfileCubit needs no entry here: it is `registerFactoryParam`,
        // not a singleton — a fresh instance is created and `load()`ed for
        // the current user on every screen visit, so there is nothing
        // persistent to clear. AppLockCubit also needs no entry: it
        // subscribes to `sessionCubit.stream` itself and already emits
        // `AppLockState.unlocked()` the moment it sees this exact
        // transition, so calling it here would be redundant.
        getIt<NotificationsCubit>().clear();
        getIt<OrdersCubit>().clear();
        getIt<FinanceCubit>().clear();
        getIt<DeliveryCubit>().clear();
        getIt<DriverSummaryCubit>().clear();
        // Found while adding the above (spec 006 FR-008/SC-002): this was
        // previously called only on a failed launch-hydration, never on a
        // deliberate mid-session sign-out — so a driver's photo could
        // persist in `AppTopBar` chrome after sign-out, until whichever
        // moment the next driver happened to open their own profile.
        CurrentAvatar.clear();
      case SessionUnknown():
        break;
    }
  });

  getIt.registerSingleton(AppRouter(sessionCubit: sessionCubit));
}

void _registerOrdersFeature() {
  final dio = getIt<Dio>();

  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<PaymentGateway>(PaymentGatewayImpl.new);

  getIt.registerLazySingleton(() => CreateOrder(getIt()));
  getIt.registerLazySingleton(() => GetOrders(getIt()));
  getIt.registerLazySingleton(() => GetOrder(getIt()));
  getIt.registerLazySingleton(() => GetDrivingRoute(getIt()));
  getIt.registerLazySingleton(() => GetCurrentOtp(getIt()));
  getIt.registerLazySingleton(() => CancelOrder(getIt()));
  getIt.registerLazySingleton(() => AcceptFinalPrice(getIt()));
  getIt.registerLazySingleton(() => Redispatch(getIt()));
  getIt.registerLazySingleton(() => GetQuote(getIt()));
  getIt.registerLazySingleton(() => SubmitRating(getIt()));

  // spec 005 US2 — the create-order flow's company-pricing reads.
  getIt.registerLazySingleton<CompanyPricingRemoteDataSource>(
    () => CompanyPricingRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<CompanyPricingRepository>(
    () => CompanyPricingRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetFuelPrices(getIt()));
  getIt.registerLazySingleton(() => GetCompanyPricingConfig(getIt()));

  // spec 005 T058 — read-only station list for the create-order picker.
  // US8 (T109) extends this with the favourite/write side, not replaces it.
  getIt.registerLazySingleton<StationsRemoteDataSource>(
    () => StationsRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<StationsRepository>(
    () => StationsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetStations(getIt()));
  getIt.registerLazySingleton(() => SetFavouriteStation(getIt()));

  // spec 005 T109 — one instance per screen visit, same reasoning as
  // InvoicesCubit: the client's own stations list isn't cached across the
  // session.
  getIt.registerFactory(
    () => StationsCubit(getStations: getIt(), setFavouriteStation: getIt()),
  );

  // Lazy singleton, not factory (spec 005 FR-047/T028): data already
  // fetched is reused across screens within a session rather than
  // refetched on every navigation. Reset on sign-out below in
  // `_registerCore`'s session listener, not here — that listener already
  // owns every cross-feature "clear per-user state" concern
  // (NotificationsCubit) and is the single place all of them belong.
  getIt.registerLazySingleton(() => OrdersCubit(getOrders: getIt()));

  // One instance per order, not a session-lifetime singleton — unlike
  // OrdersCubit above, an order's own detail is scoped to the screen
  // showing it, not the whole session. `param1` is the orderId.
  getIt.registerFactoryParam<OrderDetailCubit, String, void>(
    (orderId, _) => OrderDetailCubit(
      orderId: orderId,
      getOrder: getIt(),
      getCurrentOtp: getIt(),
      socket: getIt(),
    ),
  );

  // spec 005 US3 — one instance per screen visit, same lifecycle as
  // OrderDetailCubit above; `watch`/`unwatch` carry the orderId rather than
  // the constructor, so no param is needed here.
  getIt.registerFactory<TrackingCubit>(() => TrackingCubit(socket: getIt()));

  // spec 005 T079 — one instance per screen visit, keyed by orderId.
  getIt.registerFactoryParam<PaymentCubit, String, void>(
    (orderId, _) => PaymentCubit(
      orderId: orderId,
      gateway: getIt(),
      socket: getIt(),
      getOrder: getIt(),
    ),
  );

  // spec 007 T089 — one instance per screen visit, keyed by orderId, same
  // lifecycle as PaymentCubit above.
  getIt.registerFactoryParam<RatingCubit, String, void>(
    (orderId, _) => RatingCubit(orderId: orderId, submitRating: getIt()),
  );
}

void _registerInvoicesFeature() {
  final dio = getIt<Dio>();

  getIt.registerLazySingleton<InvoicesRemoteDataSource>(
    () => InvoicesRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<InvoicesRepository>(
    () => InvoicesRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetInvoices(getIt()));
  getIt.registerLazySingleton(() => GetInvoice(getIt()));
  getIt.registerLazySingleton(() => GetCreditStanding(getIt()));

  // Lazy singleton, not factory — see the matching note on OrdersCubit above.
  getIt.registerLazySingleton(
    () => FinanceCubit(getInvoices: getIt(), getCreditStanding: getIt()),
  );

  // spec 005 T083 — one instance per screen visit.
  getIt.registerFactory(
    () => CreditCubit(getCreditStanding: getIt<GetCreditStanding>()),
  );

  // spec 005 T078 — one instance per screen visit, same reasoning as
  // OrdersCubit not applying here: unlike the home dashboard's totals, the
  // invoices list has no cross-screen state worth keeping warm.
  getIt.registerFactory(() => InvoicesCubit(getInvoices: getIt()));

  // spec 005 T078a — one instance per screen visit, keyed by invoiceId.
  getIt.registerFactoryParam<InvoiceDetailCubit, String, void>(
    (invoiceId, _) =>
        InvoiceDetailCubit(invoiceId: invoiceId, getInvoice: getIt()),
  );
}

void _registerPaymentsFeature() {
  final dio = getIt<Dio>();

  getIt.registerLazySingleton<PaymentsRemoteDataSource>(
    () => PaymentsRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<PaymentsRepository>(
    () => PaymentsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetPayments(getIt()));

  // spec 005 T076 — one instance per screen visit, same reasoning as
  // InvoicesCubit above.
  getIt.registerFactory(() => PaymentsCubit(getPayments: getIt()));
}

void _registerDeliveryFeature() {
  final dio = getIt<Dio>();

  getIt.registerLazySingleton<DeliveryRemoteDataSource>(
    () => DeliveryRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<DeliveryRepository>(
    () => DeliveryRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(
    () => LocationStreamService(socket: getIt<TrackingSocket>()),
  );

  getIt.registerLazySingleton(() => GetActiveOrder(getIt()));
  getIt.registerLazySingleton(() => MarkArrived(getIt()));
  getIt.registerLazySingleton(() => AcknowledgeAssignment(getIt()));
  // spec 011 US2: the driver's two stop actions.
  getIt.registerLazySingleton(() => DeclareStop(getIt()));
  getIt.registerLazySingleton(() => ReportBlocked(getIt()));
  getIt.registerLazySingleton(() => SubmitStopReason(getIt()));
  getIt.registerLazySingleton(() => VerifyArrivalOtp(getIt()));
  getIt.registerLazySingleton(() => RequestDeliveryOtp(getIt()));
  getIt.registerLazySingleton(() => VerifyDeliveryOtp(getIt()));
  getIt.registerLazySingleton(() => GetDriverSummary(getIt()));
  getIt.registerLazySingleton(() => VerifyVehicle(getIt()));
  getIt.registerLazySingleton(() => ConfirmLoading(getIt()));

  // spec 008 research R5: isolates `nfc_manager` the same way `PhoneDialer`
  // isolates `url_launcher` — a lazy singleton so a device's one NFC
  // session is never contended by two live instances.
  getIt.registerLazySingleton<NfcReader>(NfcManagerReader.new);
  // spec 008 FR-030c — the one-shot fix that accompanies a verification
  // attempt. Separate from LocationStreamService's throttled stream on
  // purpose; see position_reader.dart.
  getIt.registerLazySingleton<PositionReader>(GeolocatorPositionReader.new);
  // spec 011 FR-004a — the seam that lets the platform reach a driver whose
  // app is backgrounded. Initialized at registration so the Android channel
  // exists before any alert is ever posted (a notification to a channel that
  // was never created is silently dropped).
  getIt.registerLazySingleton<NotificationPresenter>(() {
    final presenter = LocalNotificationPresenter();
    unawaited(presenter.initialize());
    return presenter;
  });

  // Lazy singleton, not a factory: it owns the location stream's lifecycle,
  // and a second instance would race the first over starting and stopping it.
  // Takes no TrackingSocket (spec 007 research R2) — DeliveryListener owns
  // that subscription and drives this cubit through handleOrderStatus.
  getIt.registerLazySingleton(
    () => DeliveryCubit(
      getActiveOrder: getIt(),
      verifyArrivalOtp: getIt(),
      verifyDeliveryOtp: getIt(),
      locationStream: getIt<LocationStreamService>(),
      acknowledgeAssignment: getIt(),
    ),
  );

  // Lazy singleton, not a factory — session-lifetime like DeliveryCubit
  // above, loaded once at sign-in (SessionAuthenticated) and cleared at
  // sign-out, rather than refetched every time the home screen rebuilds.
  getIt.registerLazySingleton(
    () => DriverSummaryCubit(getDriverSummary: getIt()),
  );

  // spec 007 T026 — one instance per delivery-detail screen visit, keyed by
  // orderId (same reasoning as ProfileCubit/OrderDetailCubit): the arrival
  // and delivery handover steps belong to whichever order is currently
  // open, not to the app-wide active-delivery singleton above.
  getIt.registerFactoryParam<OtpVerifyCubit, String, void>(
    (orderId, _) => OtpVerifyCubit(
      orderId: orderId,
      markArrived: getIt(),
      verifyArrivalOtp: getIt(),
      requestDeliveryOtp: getIt(),
      verifyDeliveryOtp: getIt(),
    ),
  );

  // spec 008 US3 — one instance per verification screen visit, keyed by
  // orderId, same reasoning as OtpVerifyCubit above.
  getIt.registerFactoryParam<VehicleVerificationCubit, String, void>(
    (orderId, _) => VehicleVerificationCubit(
      orderId: orderId,
      nfcReader: getIt(),
      verifyVehicle: getIt(),
      positionReader: getIt(),
    ),
  );
}

void _registerNotificationsFeature() {
  final dio = getIt<Dio>();
  final socket = getIt<TrackingSocket>();

  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetNotifications(getIt()));
  getIt.registerLazySingleton(() => MarkNotificationRead(getIt()));
  getIt.registerLazySingleton(() => MarkAllNotificationsRead(getIt()));

  // Eager singleton, not lazy: it must be alive and listening to
  // `notification:new` from app start (app.dart provides it at the root),
  // not only once some screen first reads it.
  getIt.registerSingleton(
    NotificationsCubit(
      getNotifications: getIt(),
      markNotificationRead: getIt(),
      markAllNotificationsRead: getIt(),
      socket: socket,
    ),
  );
}

void _registerProfileFeature() {
  final dio = getIt<Dio>();

  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetProfile(getIt()));
  getIt.registerLazySingleton(() => UpdateFullName(getIt()));
  getIt.registerLazySingleton(() => UploadProfilePicture(getIt()));
  getIt.registerLazySingleton(() => DownloadAvatar(getIt()));

  // `AppTopBar` shows the signed-in user's picture on every screen but lives
  // in core/, so it cannot reach the profile feature. The composition root is
  // the one place that knows both, so it supplies the fetch.
  CurrentAvatar.loader = () async {
    final session = getIt<SessionCubit>().state;
    if (session is! SessionAuthenticated) return;
    final profile = await getIt<GetProfile>()(session.user.id);
    await profile.fold((_) async {}, (user) async {
      final fileId = user.profilePictureFileId;
      if (fileId == null) return;
      final bytes = await getIt<DownloadAvatar>()(fileId);
      bytes.fold((_) {}, (data) => CurrentAvatar.publish(Uint8List.fromList(data)));
    });
  };

  // spec 005 T099 — one instance per screen visit, keyed by userId (the
  // CLIENT's own id from SessionCubit), same reasoning as InvoicesCubit.
  getIt.registerFactoryParam<ProfileCubit, String, void>(
    (userId, _) => ProfileCubit(
      userId: userId,
      getProfile: getIt(),
      getStations: getIt(),
      updateFullName: getIt(),
      uploadProfilePicture: getIt(),
      downloadAvatar: getIt(),
    ),
  );

  getIt.registerLazySingleton<PhoneVerificationRemoteDataSource>(
    () => PhoneVerificationRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<PhoneVerificationRepository>(
    () => PhoneVerificationRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => RequestPhoneVerification(getIt()));
  getIt.registerLazySingleton(() => ConfirmPhoneVerification(getIt()));

  // spec 005 T101 — one instance per screen visit; change_phone_screen.dart
  // and verify_phone_screen.dart each get their own (see PhoneVerificationCubit's
  // own doc comment for why one shared instance isn't needed).
  getIt.registerFactory(
    () => PhoneVerificationCubit(
      requestVerification: getIt(),
      confirmVerification: getIt(),
    ),
  );
}

void _registerSupportFeature() {
  final dio = getIt<Dio>();

  getIt.registerLazySingleton<SupportRemoteDataSource>(
    () => SupportRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetSupportRequests(getIt()));
  getIt.registerLazySingleton(() => CreateSupportRequest(getIt()));

  // spec 005 T119 — one instance per screen visit, shared by the problem
  // card and the screen's own submitted/acknowledged list.
  getIt.registerFactory(
    () => SupportCubit(
      getSupportRequests: getIt(),
      createSupportRequest: getIt(),
    ),
  );
}

Future<void> _registerAuthFeature() async {
  final dio = getIt<Dio>();
  final tokenStore = getIt<TokenStore>();
  final sessionCubit = getIt<SessionCubit>();

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton(LoginPreferencesStore.new);
  getIt.registerLazySingleton(BiometricAuthenticator.new);
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt(), tokenStore: tokenStore),
  );
  getIt.registerLazySingleton(() => SignIn(getIt()));
  getIt.registerLazySingleton(() => RestoreSession(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));

  // Launch hydration (FR-002): resolve session before the first frame so
  // the router never flashes the login screen for an already-authenticated
  // user. No "expired" reason is shown here — that copy is reserved for a
  // genuine mid-session expiry surfaced via AuthInterceptor's callback.
  final result = await getIt<RestoreSession>()();
  result.fold(
    // No stored session, or the stored one no longer validates: land on the
    // login screen rather than blocking the first frame on a retry.
    (_) {
      CurrentAvatar.clear();
      sessionCubit.signOut();
    },
    sessionCubit.authenticate,
  );

  // Registered only now, after hydration above has resolved `sessionCubit`'s
  // real state — AppLockCubit reads that state at construction to detect a
  // cold launch into an existing driver session (spec 006 FR-012). An
  // eager singleton, like SessionCubit itself: it must be observing app
  // lifecycle and the session stream from launch, not only once
  // AppLockGate first builds.
  getIt.registerSingleton(
    AppLockCubit(
      biometrics: getIt<BiometricAuthenticator>(),
      sessionCubit: sessionCubit,
    ),
  );
}

void _registerPasswordResetFeature() {
  final dio = getIt<Dio>();

  getIt.registerLazySingleton<PasswordResetRemoteDataSource>(
    () => PasswordResetRemoteDataSourceImpl(dio),
  );
  getIt.registerLazySingleton<PasswordResetRepository>(
    () => PasswordResetRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => RequestPasswordReset(getIt()));
  getIt.registerLazySingleton(() => VerifyResetCode(getIt()));
  getIt.registerLazySingleton(() => CompletePasswordReset(getIt()));

  // One instance per screen visit (mirrors PhoneVerificationCubit) — a
  // fresh cubit for ForgotPasswordScreen and another for
  // ResetPasswordScreen, neither carrying state across the other.
  getIt.registerFactory(
    () => PasswordResetCubit(
      requestReset: getIt(),
      verifyCode: getIt(),
      completeReset: getIt(),
    ),
  );
}
