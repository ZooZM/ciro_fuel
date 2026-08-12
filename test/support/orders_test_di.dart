import 'package:dartz/dartz.dart' hide Order;
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/invoices/domain/repositories/invoices_repository.dart';
import 'package:mobile_app/features/invoices/domain/usecases/get_invoices.dart';
import 'package:mobile_app/features/invoices/presentation/cubit/finance_cubit.dart';
import 'package:mobile_app/features/orders/domain/entities/otp_challenge.dart';
import 'package:mobile_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:mobile_app/features/orders/domain/usecases/create_order.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_orders.dart';
import 'package:mobile_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/entities/invoice.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/payment_method.dart';
import 'package:mobile_app/shared/enums/user_role.dart';

/// Serves a fixed list so screens under test render deterministically.
/// Only [getOrders] is exercised by the home/orders screens; the rest of the
/// contract throws so an unnoticed new call site fails loudly instead of
/// silently returning empty data.
class FakeOrdersRepository implements OrdersRepository {
  FakeOrdersRepository(this._orders);

  final List<Order> _orders;

  @override
  Future<Either<Failure, List<Order>>> getOrders({OrderStatus? status}) async =>
      Right(
        status == null
            ? _orders
            : _orders.where((o) => o.status == status).toList(),
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
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Order>> getOrder(String orderId) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, OtpChallenge>> getCurrentOtp(String orderId) =>
      throw UnimplementedError();

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

/// Registers the orders graph the home and orders screens resolve from
/// [getIt]. Call from `setUp`; [resetOrdersTestDi] from `tearDown`.
void registerOrdersTestDi({List<Order>? orders}) {
  resetOrdersTestDi();
  final repository = FakeOrdersRepository(orders ?? sampleOrders());
  getIt.registerLazySingleton<OrdersRepository>(() => repository);
  getIt.registerLazySingleton(() => GetOrders(getIt<OrdersRepository>()));
  getIt.registerLazySingleton(() => CreateOrder(getIt<OrdersRepository>()));
  getIt.registerFactory(() => OrdersCubit(getOrders: getIt<GetOrders>()));
}

void resetOrdersTestDi() {
  if (getIt.isRegistered<OrdersCubit>()) getIt.unregister<OrdersCubit>();
  if (getIt.isRegistered<GetOrders>()) getIt.unregister<GetOrders>();
  if (getIt.isRegistered<CreateOrder>()) getIt.unregister<CreateOrder>();
  if (getIt.isRegistered<OrdersRepository>()) {
    getIt.unregister<OrdersRepository>();
  }
}

/// As [FakeOrdersRepository]: a fixed list, only [getInvoices] faked.
class FakeInvoicesRepository implements InvoicesRepository {
  FakeInvoicesRepository(this._invoices);

  final List<Invoice> _invoices;

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices() async =>
      Right(_invoices);
}

/// Registers the finance graph [ClientHomeScreen]'s `FinanceCubit` resolves
/// from [getIt]. Call from `setUp`; [resetFinanceTestDi] from `tearDown`.
void registerFinanceTestDi({List<Invoice>? invoices}) {
  resetFinanceTestDi();
  final repository = FakeInvoicesRepository(invoices ?? const []);
  getIt.registerLazySingleton<InvoicesRepository>(() => repository);
  getIt.registerLazySingleton(() => GetInvoices(getIt<InvoicesRepository>()));
  getIt.registerFactory(() => FinanceCubit(getInvoices: getIt<GetInvoices>()));
}

void resetFinanceTestDi() {
  if (getIt.isRegistered<FinanceCubit>()) getIt.unregister<FinanceCubit>();
  if (getIt.isRegistered<GetInvoices>()) getIt.unregister<GetInvoices>();
  if (getIt.isRegistered<InvoicesRepository>()) {
    getIt.unregister<InvoicesRepository>();
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
