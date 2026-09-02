import 'package:dartz/dartz.dart' hide Order, State;
import 'package:easy_localization/easy_localization.dart';
// `Localization` and `Translations` are what `.tr()` reads from, but
// easy_localization only re-exports the widget that populates them. Seeding
// them directly is the only way to translate a tree the EasyLocalization
// widget is not wrapped around.
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/orders/domain/entities/price_breakdown.dart';
import 'package:mobile_app/features/orders/domain/entities/pricing_config.dart';
import 'package:mobile_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';
import 'package:mobile_app/features/stations/domain/entities/station.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/payment_method.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

/// A [FakeOrdersRepository] that also prices and creates a real order — the
/// base fake throws on both (spec 005 T057/T063 weren't exercised when it
/// was written), so this test needs its own.
class _QuotingOrdersRepository extends FakeOrdersRepository {
  _QuotingOrdersRepository({required this.fakeQuote, required this.fakeOrder})
    : super(const []);

  final Quote fakeQuote;
  final Order fakeOrder;

  @override
  Future<Either<Failure, Quote>> quote({
    required FuelType fuelType,
    required int quantityLiters,
    required String stationId,
  }) async => Right(fakeQuote);

  @override
  Future<Either<Failure, Order>> createOrder({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
    PaymentMethod? paymentMethod,
    String? stationId,
    String? quoteToken,
  }) async => Right(fakeOrder);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final arabic = await const RootBundleAssetLoader().load(
      AppAssets.translationsPath,
      AppLocales.arabic,
    );
    Localization.load(AppLocales.arabic, translations: Translations(arabic));
  });

  setUp(registerOrdersTestDi);
  tearDown(resetOrdersTestDi);

  testWidgets(
    'prices the client\'s own station/grade and submitting navigates to the new order',
    (tester) async {
      tester.view.physicalSize = const Size(1206, 3400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      const station = Station(
        id: '6a678f6a7bcf5a3ef09ae400',
        regionCode: 'RIYADH',
        governorateCode: 'RIYADH_CITY',
        location: GeoPoint(lat: 24.7, lng: 46.6),
        addressText: 'Al Malqa',
        isDefault: true,
        isFavourite: false,
      );
      registerOrdersTestDi(
        stations: const [station],
        fuelPrices: const [
          FuelPrice(fuelType: FuelType.gasoline95, basePricePerLiter: 2.33),
        ],
        pricingConfig: const PricingConfig(
          deliveryFee: 30,
          serviceFeePercent: 2,
          taxRatePercent: 15,
          tankerCapacitiesLiters: [20000, 25000],
        ),
      );

      const breakdown = PriceBreakdown(
        fuelLineTotal: 46600,
        deliveryFee: 30,
        serviceFee: 932,
        tax: 7128.3,
        total: 54690.3,
        unitPrice: 2.33,
        serviceFeePercent: 2,
        taxRatePercent: 15,
        currency: 'SAR',
      );
      final quote = Quote(
        breakdown: breakdown,
        quoteToken: 'quote-token-1',
        expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      );
      final createdOrder = Order(
        id: '6a678f6a7bcf5a3ef09ae999',
        status: OrderStatus.pendingApproval,
        fuelType: FuelType.gasoline95,
        quantityLiters: 20000,
        statusChangedAt: DateTime.now(),
      );

      getIt.unregister<OrdersRepository>();
      final repository = _QuotingOrdersRepository(
        fakeQuote: quote,
        fakeOrder: createdOrder,
      );
      getIt.registerLazySingleton<OrdersRepository>(() => repository);

      final router = GoRouter(
        initialLocation: '/client/orders/new',
        routes: [
          GoRoute(
            path: '/client/orders/new',
            builder: (_, _) => BlocProvider<SessionCubit>.value(
              value: sampleAuthenticatedSessionCubit(),
              child: const CreateOrderScreen(),
            ),
          ),
          GoRoute(
            path: '/client/orders/:id',
            builder: (_, state) =>
                Scaffold(body: Text('order-detail-${state.pathParameters['id']}')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await pumpLocalizedRouter(tester, router);
      await tester.pumpAndSettle();

      expect(find.byType(CreateOrderScreen), findsOneWidget);
      // The live quote replaced the loading spinner in the summary card.
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.text('تأكيد الطلب'));
      await tester.pumpAndSettle();

      expect(find.byType(CreateOrderScreen), findsNothing);
      expect(find.text('order-detail-${createdOrder.id}'), findsOneWidget);
    },
  );
}
