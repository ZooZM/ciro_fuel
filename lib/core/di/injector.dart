import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../core/theme/theme_cubit.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/login_preferences_store.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/restore_session.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/presentation/cubit/session_cubit.dart';
import '../../features/auth/presentation/cubit/session_state.dart';
import '../../features/delivery/data/datasources/delivery_remote_data_source.dart';
import '../../features/delivery/data/repositories/delivery_repository_impl.dart';
import '../../features/delivery/data/services/location_stream_service.dart';
import '../../features/delivery/domain/repositories/delivery_repository.dart';
import '../../features/delivery/domain/usecases/get_active_order.dart';
import '../../features/delivery/domain/usecases/mark_arrived.dart';
import '../../features/delivery/domain/usecases/request_delivery_otp.dart';
import '../../features/delivery/domain/usecases/verify_arrival_otp.dart';
import '../../features/delivery/domain/usecases/verify_delivery_otp.dart';
import '../../features/orders/data/datasources/orders_remote_data_source.dart';
import '../../features/orders/data/gateways/payment_gateway_impl.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/gateways/payment_gateway.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/cancel_order.dart';
import '../../features/orders/domain/usecases/create_order.dart';
import '../../features/orders/domain/usecases/get_current_otp.dart';
import '../../features/orders/domain/usecases/get_order.dart';
import '../../features/orders/domain/usecases/get_orders.dart';
import '../../features/orders/domain/usecases/redispatch.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications.dart';
import '../../features/notifications/domain/usecases/mark_notification_read.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../network/dio_client.dart';
import '../network/token_store.dart';
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
  _registerDeliveryFeature();
  _registerNotificationsFeature();
  await _registerAuthFeature();
}

void _registerCore() {
  final tokenStore = TokenStore();
  getIt.registerSingleton<TokenStore>(tokenStore);

  getIt.registerLazySingleton(() => ThemeCubit());

  final sessionCubit = SessionCubit();
  getIt.registerSingleton<SessionCubit>(sessionCubit);

  final trackingSocket = TrackingSocket(tokenStore: tokenStore);
  getIt.registerSingleton(trackingSocket);

  final dio = buildDioClient(
    tokenStore: tokenStore,
    onSessionExpired: () async {
      await tokenStore.clear();
      sessionCubit.signOut(
        reason: 'Your session has expired. Please sign in again.',
      );
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
  sessionCubit.stream.listen((state) {
    switch (state) {
      case SessionAuthenticated():
        trackingSocket.connect();
        getIt<NotificationsCubit>().load();
      case SessionUnauthenticated():
        trackingSocket.dispose();
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
  getIt.registerLazySingleton(() => GetCurrentOtp(getIt()));
  getIt.registerLazySingleton(() => CancelOrder(getIt()));
  getIt.registerLazySingleton(() => Redispatch(getIt()));

  getIt.registerFactory(() => OrdersCubit(getOrders: getIt()));
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
  getIt.registerLazySingleton(() => VerifyArrivalOtp(getIt()));
  getIt.registerLazySingleton(() => RequestDeliveryOtp(getIt()));
  getIt.registerLazySingleton(() => VerifyDeliveryOtp(getIt()));
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

  // Eager singleton, not lazy: it must be alive and listening to
  // `notification:new` from app start (app.dart provides it at the root),
  // not only once some screen first reads it.
  getIt.registerSingleton(
    NotificationsCubit(
      getNotifications: getIt(),
      markNotificationRead: getIt(),
      socket: socket,
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
    (_) => sessionCubit.signOut(),
    sessionCubit.authenticate,
  );
}
