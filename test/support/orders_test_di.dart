import 'package:dartz/dartz.dart' hide Order;
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/network/paginated_response.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/invoices/domain/entities/credit_standing.dart';
import 'package:mobile_app/features/invoices/domain/repositories/invoices_repository.dart';
import 'package:mobile_app/features/invoices/domain/usecases/get_credit_standing.dart';
import 'package:mobile_app/features/invoices/domain/usecases/get_invoice.dart';
import 'package:mobile_app/features/invoices/domain/usecases/get_invoices.dart';
import 'package:mobile_app/features/invoices/presentation/cubit/credit_cubit.dart';
import 'package:mobile_app/features/invoices/presentation/cubit/finance_cubit.dart';
import 'package:mobile_app/features/invoices/presentation/cubit/invoice_detail_cubit.dart';
import 'package:mobile_app/features/invoices/presentation/cubit/invoices_cubit.dart';
import 'package:mobile_app/features/notifications/domain/entities/app_notification.dart';
import 'package:mobile_app/features/notifications/domain/entities/notifications_page.dart';
import 'package:mobile_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:mobile_app/features/notifications/domain/usecases/get_notifications.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:mobile_app/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mobile_app/features/payments/domain/entities/payment.dart';
import 'package:mobile_app/features/payments/domain/repositories/payments_repository.dart';
import 'package:mobile_app/features/payments/domain/usecases/get_payments.dart';
import 'package:mobile_app/features/payments/presentation/cubit/payments_cubit.dart';
import 'package:mobile_app/features/orders/domain/entities/otp_challenge.dart';
import 'package:mobile_app/features/orders/domain/entities/price_breakdown.dart';
import 'package:mobile_app/features/orders/domain/entities/pricing_config.dart';
import 'package:mobile_app/features/orders/domain/gateways/payment_gateway.dart';
import 'package:mobile_app/features/orders/domain/repositories/company_pricing_repository.dart';
import 'package:mobile_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:mobile_app/features/orders/domain/usecases/create_order.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_company_pricing_config.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_current_otp.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_fuel_prices.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_order.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_orders.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_quote.dart';
import 'package:mobile_app/features/orders/domain/usecases/submit_rating.dart';
import 'package:mobile_app/features/orders/presentation/cubit/order_detail_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/payment_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/rating_cubit.dart';
import 'package:mobile_app/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:mobile_app/features/stations/domain/entities/station.dart';
import 'package:mobile_app/features/stations/domain/repositories/stations_repository.dart';
import 'package:mobile_app/features/stations/domain/usecases/get_stations.dart';
import 'package:mobile_app/features/stations/domain/usecases/set_favourite_station.dart';
import 'package:mobile_app/features/stations/presentation/cubit/stations_cubit.dart';
import 'package:mobile_app/features/support/domain/entities/support_request.dart';
import 'package:mobile_app/features/support/domain/repositories/support_repository.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/entities/invoice.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/invoice_state.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/payment_method.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';

class _UnusedTokenStore extends Mock implements TokenStore {}

/// Never connected, so every `_socket?.…` call inside a cubit that merely
/// registers a push handler on it is a safe no-op.
class OfflineTrackingSocket extends TrackingSocket {
  OfflineTrackingSocket() : super(tokenStore: _UnusedTokenStore());
}

/// Serves a fixed list so screens under test render deterministically.
/// Only [getOrders] is exercised by the home/orders screens; the rest of the
/// contract throws so an unnoticed new call site fails loudly instead of
/// silently returning empty data.
class FakeOrdersRepository implements OrdersRepository {
  FakeOrdersRepository(this._orders);

  final List<Order> _orders;

  @override
  Future<Either<Failure, PaginatedResult<Order>>> getOrders({
    OrderStatus? status,
    String? cursor,
  }) async => Right(
    PaginatedResult(
      items: status == null
          ? _orders
          : _orders.where((o) => o.status == status).toList(),
      // A fixed sample list is always a single page — nothing in the
      // render tests this fake serves exercises scrolling.
      nextCursor: null,
    ),
  );

  @override
  Never noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not faked');

  @override
  Future<Either<Failure, Order>> createOrder({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
    PaymentMethod? paymentMethod,
    String? stationId,
    String? quoteToken,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Quote>> quote({
    required FuelType fuelType,
    required int quantityLiters,
    required String stationId,
  }) => throw UnimplementedError();

  /// Finds by id among the fixed list, falling back to the first entry —
  /// render tests care that *an* order renders, not exact id round-tripping.
  @override
  Future<Either<Failure, Order>> getOrder(String orderId) async => Right(
    _orders.firstWhere((o) => o.id == orderId, orElse: () => _orders.first),
  );

  /// No active OTP by default — a `Left` here is the real repository's own
  /// "nothing to show" case (`OrderDetailCubit.loadCurrentOtp` treats any
  /// `Left` as non-error), not a fetch failure worth throwing on.
  @override
  Future<Either<Failure, OtpChallenge>> getCurrentOtp(String orderId) async =>
      const Left(Failure.notFound());

  @override
  Future<Either<Failure, Order>> cancelOrder(String orderId) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Order>> redispatch(String orderId) =>
      throw UnimplementedError();
}

/// Mirrors the shape `GET /orders` returns, including the GeoJSON-derived
/// destination and (spec 004) the driver summary/ETA/address, so screens
/// are exercised against realistic values.
List<Order> sampleOrders() => [
  Order(
    id: '6a678f6a7bcf5a3ef09ae45a',
    status: OrderStatus.inTransit,
    fuelType: FuelType.gasoline95,
    quantityLiters: 20000,
    estimatedPrice: const Money(amountMinor: 4660000, currency: 'SAR'),
    paymentMethod: PaymentMethod.direct,
    driverId: '6a678f6a7bcf5a3ef09ae400',
    driverSummary: const DriverSummary(
      fullName: 'محمد العتيبي',
      phone: '+966501234567',
      plateNumber: 'ABC-1234',
    ),
    etaMinutes: 18,
    destination: const GeoPoint(lat: 24.7136, lng: 46.6753),
    deliveryAddressText: 'طريق أنس بن مالك، حي الملقا',
    statusChangedAt: DateTime.utc(2026, 5, 2, 13, 35),
  ),
  Order(
    id: '6a678f6a7bcf5a3ef09ae45b',
    status: OrderStatus.delivered,
    fuelType: FuelType.diesel,
    quantityLiters: 5000,
    estimatedPrice: const Money(amountMinor: 1250000, currency: 'SAR'),
    destination: const GeoPoint(lat: 24.7136, lng: 46.6753),
    statusChangedAt: DateTime.utc(2026, 5, 1, 9, 15),
  ),
  Order(
    id: '6a678f6a7bcf5a3ef09ae45c',
    status: OrderStatus.pendingApproval,
    fuelType: FuelType.gasoline91,
    quantityLiters: 750,
    statusChangedAt: DateTime.utc(2026, 4, 30, 8),
  ),
];

/// Serves a fixed list, filtering by `unread` the same way the real backend
/// does. `unreadCount` is always derived from the fixed list, matching the
/// real endpoint's "whole set, not the current page" contract (T086).
class FakeNotificationsRepository implements NotificationsRepository {
  FakeNotificationsRepository(this._notifications);

  final List<AppNotification> _notifications;

  @override
  Future<Either<Failure, NotificationsPage>> getNotifications({
    bool? unread,
    String? cursor,
  }) async {
    final items = unread == true
        ? _notifications.where((n) => !n.isRead).toList()
        : _notifications;
    return Right(
      NotificationsPage(
        items: items,
        nextCursor: null,
        unreadCount: _notifications.where((n) => !n.isRead).length,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markRead(String id) async => const Right(null);

  @override
  Future<Either<Failure, int>> markAllRead() async => Right(
        _notifications.where((n) => !n.isRead).length,
      );
}

/// Serves a fixed (empty by default) list, same fail-loud philosophy as
/// [FakeOrdersRepository] — screens under test that don't exercise a real
/// station list still need `GetStations` registered so `CreateOrderScreen`'s
/// `initState` doesn't throw on an unregistered type.
class FakeStationsRepository implements StationsRepository {
  FakeStationsRepository(this._stations);

  final List<Station> _stations;

  @override
  Future<Either<Failure, List<Station>>> getStations() async =>
      Right(_stations);

  @override
  Future<Either<Failure, Station>> setFavourite(
    String stationId,
    bool isFavourite,
  ) async {
    final station = _stations.firstWhere((s) => s.id == stationId);
    return Right(station.copyWith(isFavourite: isFavourite));
  }
}

/// Serves a fixed (empty by default) list, same fail-loud philosophy as
/// [FakeStationsRepository] — screens under test that don't exercise a real
/// support history still need this registered so `SupportCubit`'s DI
/// resolves.
class FakeSupportRepository implements SupportRepository {
  FakeSupportRepository(this._requests);

  final List<SupportRequest> _requests;

  @override
  Future<Either<Failure, List<SupportRequest>>> getRequests() async =>
      Right(_requests);

  @override
  Future<Either<Failure, SupportRequest>> createRequest({
    required String topic,
    required String message,
    String? orderId,
  }) async => Right(
    SupportRequest(
      id: 'new-request',
      topic: topic,
      message: message,
      state: 'SUBMITTED',
      createdAt: DateTime.now(),
      orderId: orderId,
    ),
  );
}

/// As [FakeStationsRepository], for the company's fuel prices/pricing
/// config — empty/absent by default so `CreateOrderScreen`'s grade and
/// quantity sections just render their own "nothing yet" states.
class FakeCompanyPricingRepository implements CompanyPricingRepository {
  FakeCompanyPricingRepository(this._fuelPrices, this._pricingConfig);

  final List<FuelPrice> _fuelPrices;
  final PricingConfig? _pricingConfig;

  @override
  Future<Either<Failure, List<FuelPrice>>> getFuelPrices(
    String companyId,
  ) async => Right(_fuelPrices);

  @override
  Future<Either<Failure, PricingConfig?>> getPricingConfig(
    String companyId,
  ) async => Right(_pricingConfig);
}

/// Registers the orders graph the home, orders-list, order-detail and
/// create-order screens resolve from [getIt]. Call from `setUp`;
/// [resetOrdersTestDi] from `tearDown`.
void registerOrdersTestDi({
  List<Order>? orders,
  List<Station>? stations,
  List<FuelPrice>? fuelPrices,
  PricingConfig? pricingConfig,
  CreditStanding? creditStanding,
  List<AppNotification>? notifications,
}) {
  resetOrdersTestDi();
  final repository = FakeOrdersRepository(orders ?? sampleOrders());
  getIt.registerLazySingleton<OrdersRepository>(() => repository);
  getIt.registerLazySingleton(() => GetOrders(getIt<OrdersRepository>()));
  getIt.registerLazySingleton(() => CreateOrder(getIt<OrdersRepository>()));
  getIt.registerLazySingleton(() => GetOrder(getIt<OrdersRepository>()));
  getIt.registerLazySingleton(() => GetCurrentOtp(getIt<OrdersRepository>()));
  getIt.registerLazySingleton(() => GetQuote(getIt<OrdersRepository>()));
  getIt.registerLazySingleton(() => SubmitRating(getIt<OrdersRepository>()));
  getIt.registerFactoryParam<RatingCubit, String, void>(
    (orderId, _) => RatingCubit(orderId: orderId, submitRating: getIt<SubmitRating>()),
  );
  getIt.registerLazySingleton<TrackingSocket>(OfflineTrackingSocket.new);
  getIt.registerFactory(() => OrdersCubit(getOrders: getIt<GetOrders>()));
  getIt.registerFactoryParam<OrderDetailCubit, String, void>(
    (orderId, _) => OrderDetailCubit(
      orderId: orderId,
      getOrder: getIt<GetOrder>(),
      getCurrentOtp: getIt<GetCurrentOtp>(),
      socket: getIt<TrackingSocket>(),
    ),
  );
  getIt.registerFactory<TrackingCubit>(
    () => TrackingCubit(socket: getIt<TrackingSocket>()),
  );
  getIt.registerLazySingleton<PaymentGateway>(_FakePaymentGateway.new);
  getIt.registerFactoryParam<PaymentCubit, String, void>(
    (orderId, _) => PaymentCubit(
      orderId: orderId,
      gateway: getIt<PaymentGateway>(),
      socket: getIt<TrackingSocket>(),
      getOrder: getIt<GetOrder>(),
    ),
  );

  final stationsRepository = FakeStationsRepository(stations ?? const []);
  getIt.registerLazySingleton<StationsRepository>(() => stationsRepository);
  getIt.registerLazySingleton(() => GetStations(getIt<StationsRepository>()));
  getIt.registerLazySingleton(
    () => SetFavouriteStation(getIt<StationsRepository>()),
  );
  getIt.registerFactory(
    () => StationsCubit(
      getStations: getIt<GetStations>(),
      setFavouriteStation: getIt<SetFavouriteStation>(),
    ),
  );

  // The client "more" screen resolves the session from getIt to render the
  // signed-in client's real name, so any screen tree containing it needs
  // this registered — not only the trees that exercise sign-out.
  getIt.registerLazySingleton<SessionCubit>(sampleAuthenticatedSessionCubit);

  final pricingRepository = FakeCompanyPricingRepository(
    fuelPrices ?? const [],
    pricingConfig,
  );
  getIt.registerLazySingleton<CompanyPricingRepository>(
    () => pricingRepository,
  );

  // spec 005 T085 — CreateOrderScreen fetches this alongside stations/fuel
  // prices/pricing config; registered here (not only via
  // registerFinanceTestDi) so it works whether or not a test also mounts
  // the finance/invoices screens. registerFinanceTestDi, when also called,
  // resets and replaces this with its own.
  final invoicesRepository = FakeInvoicesRepository(
    const [],
    creditStanding ?? const CreditStanding(),
  );
  getIt.registerLazySingleton<InvoicesRepository>(() => invoicesRepository);
  getIt.registerLazySingleton(
    () => GetCreditStanding(getIt<InvoicesRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetFuelPrices(getIt<CompanyPricingRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCompanyPricingConfig(getIt<CompanyPricingRepository>()),
  );

  // spec 005 T088/T089 — every client screen's AppTopBar now reads the
  // unread badge from this singleton, matching app.dart's app-root
  // provider; registered here so it works for any test that pumps a
  // client screen, not only ones that exercise the notifications screen
  // itself.
  final notificationsRepository = FakeNotificationsRepository(
    notifications ?? const [],
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => notificationsRepository,
  );
  getIt.registerLazySingleton(
    () => GetNotifications(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkNotificationRead(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkAllNotificationsRead(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton<NotificationsCubit>(
    () => NotificationsCubit(
      getNotifications: getIt<GetNotifications>(),
      markNotificationRead: getIt<MarkNotificationRead>(),
      markAllNotificationsRead: getIt<MarkAllNotificationsRead>(),
      socket: getIt<TrackingSocket>(),
    ),
  );
}

void resetOrdersTestDi() {
  if (getIt.isRegistered<SessionCubit>()) {
    getIt.unregister<SessionCubit>();
  }
  if (getIt.isRegistered<NotificationsCubit>()) {
    getIt.unregister<NotificationsCubit>();
  }
  if (getIt.isRegistered<MarkNotificationRead>()) {
    getIt.unregister<MarkNotificationRead>();
  }
  if (getIt.isRegistered<MarkAllNotificationsRead>()) {
    getIt.unregister<MarkAllNotificationsRead>();
  }
  if (getIt.isRegistered<GetNotifications>()) {
    getIt.unregister<GetNotifications>();
  }
  if (getIt.isRegistered<NotificationsRepository>()) {
    getIt.unregister<NotificationsRepository>();
  }
  if (getIt.isRegistered<OrderDetailCubit>()) {
    getIt.unregister<OrderDetailCubit>();
  }
  if (getIt.isRegistered<TrackingCubit>()) getIt.unregister<TrackingCubit>();
  if (getIt.isRegistered<PaymentCubit>()) getIt.unregister<PaymentCubit>();
  if (getIt.isRegistered<PaymentGateway>()) getIt.unregister<PaymentGateway>();
  if (getIt.isRegistered<OrdersCubit>()) getIt.unregister<OrdersCubit>();
  if (getIt.isRegistered<TrackingSocket>()) {
    getIt.unregister<TrackingSocket>();
  }
  if (getIt.isRegistered<GetCurrentOtp>()) getIt.unregister<GetCurrentOtp>();
  if (getIt.isRegistered<GetQuote>()) getIt.unregister<GetQuote>();
  if (getIt.isRegistered<SubmitRating>()) getIt.unregister<SubmitRating>();
  if (getIt.isRegistered<RatingCubit>()) getIt.unregister<RatingCubit>();
  if (getIt.isRegistered<GetOrder>()) getIt.unregister<GetOrder>();
  if (getIt.isRegistered<GetOrders>()) getIt.unregister<GetOrders>();
  if (getIt.isRegistered<CreateOrder>()) getIt.unregister<CreateOrder>();
  if (getIt.isRegistered<OrdersRepository>()) {
    getIt.unregister<OrdersRepository>();
  }
  if (getIt.isRegistered<GetCreditStanding>()) {
    getIt.unregister<GetCreditStanding>();
  }
  if (getIt.isRegistered<InvoicesRepository>()) {
    getIt.unregister<InvoicesRepository>();
  }
  if (getIt.isRegistered<StationsCubit>()) getIt.unregister<StationsCubit>();
  if (getIt.isRegistered<SetFavouriteStation>()) {
    getIt.unregister<SetFavouriteStation>();
  }
  if (getIt.isRegistered<GetStations>()) getIt.unregister<GetStations>();
  if (getIt.isRegistered<StationsRepository>()) {
    getIt.unregister<StationsRepository>();
  }
  if (getIt.isRegistered<GetFuelPrices>()) {
    getIt.unregister<GetFuelPrices>();
  }
  if (getIt.isRegistered<GetCompanyPricingConfig>()) {
    getIt.unregister<GetCompanyPricingConfig>();
  }
  if (getIt.isRegistered<CompanyPricingRepository>()) {
    getIt.unregister<CompanyPricingRepository>();
  }
}

/// As [FakeOrdersRepository]: a fixed list, always a single page — nothing
/// this fake serves exercises scrolling.
class FakeInvoicesRepository implements InvoicesRepository {
  FakeInvoicesRepository(this._invoices, [this._creditStanding = const CreditStanding()]);

  final List<Invoice> _invoices;
  final CreditStanding _creditStanding;

  @override
  Future<Either<Failure, PaginatedResult<Invoice>>> getInvoices({
    PaymentMethod? method,
    InvoiceState? state,
    String? cursor,
  }) async => Right(PaginatedResult(items: _invoices, nextCursor: null));

  @override
  Future<Either<Failure, Invoice>> getInvoice(String invoiceId) async => Right(
    _invoices.firstWhere(
      (i) => i.id == invoiceId,
      orElse: () => _invoices.first,
    ),
  );

  @override
  Future<Either<Failure, CreditStanding>> getCreditStanding() async =>
      Right(_creditStanding);
}

/// Never actually invoked by any current test — a `PaymentCubit` fixture
/// only needs to exist for `InvoicePaymentScreen` to mount without a DI
/// error, not to be tapped.
class _FakePaymentGateway implements PaymentGateway {
  @override
  Future<Either<Failure, void>> pay({
    required String orderId,
    required Money amount,
  }) => throw UnimplementedError();
}

/// Registers the finance/invoices graph [ClientHomeScreen]'s `FinanceCubit`
/// and the invoices list/detail screens' cubits resolve from [getIt]. Call
/// from `setUp`; [resetFinanceTestDi] from `tearDown`.
void registerFinanceTestDi({
  List<Invoice>? invoices,
  CreditStanding? creditStanding,
}) {
  resetFinanceTestDi();
  final repository = FakeInvoicesRepository(
    invoices ?? const [],
    creditStanding ?? const CreditStanding(),
  );
  getIt.registerLazySingleton<InvoicesRepository>(() => repository);
  getIt.registerLazySingleton(() => GetInvoices(getIt<InvoicesRepository>()));
  getIt.registerLazySingleton(() => GetInvoice(getIt<InvoicesRepository>()));
  getIt.registerLazySingleton(
    () => GetCreditStanding(getIt<InvoicesRepository>()),
  );
  getIt.registerFactory(
    () => FinanceCubit(
      getInvoices: getIt<GetInvoices>(),
      getCreditStanding: getIt<GetCreditStanding>(),
    ),
  );
  getIt.registerFactory(() => InvoicesCubit(getInvoices: getIt<GetInvoices>()));
  getIt.registerFactoryParam<InvoiceDetailCubit, String, void>(
    (invoiceId, _) => InvoiceDetailCubit(
      invoiceId: invoiceId,
      getInvoice: getIt<GetInvoice>(),
    ),
  );
  getIt.registerFactory(
    () => CreditCubit(getCreditStanding: getIt<GetCreditStanding>()),
  );
}

void resetFinanceTestDi() {
  if (getIt.isRegistered<InvoiceDetailCubit>()) {
    getIt.unregister<InvoiceDetailCubit>();
  }
  if (getIt.isRegistered<CreditCubit>()) getIt.unregister<CreditCubit>();
  if (getIt.isRegistered<InvoicesCubit>()) getIt.unregister<InvoicesCubit>();
  if (getIt.isRegistered<FinanceCubit>()) getIt.unregister<FinanceCubit>();
  if (getIt.isRegistered<GetCreditStanding>()) {
    getIt.unregister<GetCreditStanding>();
  }
  if (getIt.isRegistered<GetInvoice>()) getIt.unregister<GetInvoice>();
  if (getIt.isRegistered<GetInvoices>()) getIt.unregister<GetInvoices>();
  if (getIt.isRegistered<InvoicesRepository>()) {
    getIt.unregister<InvoicesRepository>();
  }
}

/// As [FakeOrdersRepository]: a fixed list, always a single page.
class FakePaymentsRepository implements PaymentsRepository {
  FakePaymentsRepository(this._payments);

  final List<Payment> _payments;

  @override
  Future<Either<Failure, PaginatedResult<Payment>>> getPayments({
    String? cursor,
  }) async => Right(PaginatedResult(items: _payments, nextCursor: null));
}

/// Registers the payments graph [ClientPaymentsScreen]'s `PaymentsCubit`
/// resolves from [getIt]. Call from `setUp`; [resetPaymentsTestDi] from
/// `tearDown`.
void registerPaymentsTestDi({List<Payment>? payments}) {
  resetPaymentsTestDi();
  final repository = FakePaymentsRepository(payments ?? const []);
  getIt.registerLazySingleton<PaymentsRepository>(() => repository);
  getIt.registerLazySingleton(() => GetPayments(getIt<PaymentsRepository>()));
  getIt.registerFactory(() => PaymentsCubit(getPayments: getIt<GetPayments>()));
}

void resetPaymentsTestDi() {
  if (getIt.isRegistered<PaymentsCubit>()) getIt.unregister<PaymentsCubit>();
  if (getIt.isRegistered<GetPayments>()) getIt.unregister<GetPayments>();
  if (getIt.isRegistered<PaymentsRepository>()) {
    getIt.unregister<PaymentsRepository>();
  }
}

/// An authenticated CLIENT session with a station matching [sampleOrders]'
/// delivery address and a credit limit — [ClientHomeScreen] reads this via
/// an ancestor `BlocProvider<SessionCubit>` the test sets up (mirroring
/// `app.dart`'s app-root provider, which the screen relies on in production).
SessionCubit sampleAuthenticatedSessionCubit() {
  final cubit = SessionCubit();
  cubit.authenticate(
    const AuthUser(
      id: 'u1',
      role: UserRole.client,
      companyId: 'c1',
      fullName: 'Jane Client',
      station: UserStation(
        name: 'محطة الرحاب',
        addressText: 'جدة - طريق مكة القديم - حي البوادي',
      ),
      creditLimit: 500,
    ),
  );
  return cubit;
}
