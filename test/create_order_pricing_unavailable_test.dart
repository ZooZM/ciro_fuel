import 'package:dartz/dartz.dart' hide State;
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/network/error_codes.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/orders/domain/entities/pricing_config.dart';
import 'package:mobile_app/features/orders/domain/repositories/company_pricing_repository.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_company_pricing_config.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_fuel_prices.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';
import 'package:mobile_app/features/orders/presentation/widgets/create_order/grade_section.dart';
import 'package:mobile_app/features/stations/domain/entities/station.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_grade.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

/// The fuel company sells grades but has never had its pricing configured,
/// so `GET /companies/:id/pricing-config` answers 409
/// PRICING_NOT_CONFIGURED — the state a real client hit on the create-order
/// screen. The tanker ladder comes from that response, and the form used to
/// key its selected grade by a litre value drawn from it, which made every
/// grade tile a silent no-op with no message anywhere on screen.
class _UnpricedCompanyRepository implements CompanyPricingRepository {
  @override
  Future<Either<Failure, List<FuelPrice>>> getFuelPrices(String companyId) async =>
      const Right([
        FuelPrice(fuelType: FuelType.gasoline91, basePricePerLiter: 2.18),
        FuelPrice(fuelType: FuelType.diesel, basePricePerLiter: 1.15),
      ]);

  @override
  Future<Either<Failure, PricingConfig?>> getPricingConfig(
    String companyId,
  ) async => const Left(
    Failure.validation(
      'Pricing is not yet configured for this fuel company',
      code: ErrorCodes.pricingNotConfigured,
    ),
  );
}

const _station = Station(
  id: '6a678f6a7bcf5a3ef09ae400',
  regionCode: 'RIYADH',
  governorateCode: 'RIYADH_CITY',
  location: GeoPoint(lat: 24.7, lng: 46.6),
  addressText: 'Al Malqa',
  isDefault: true,
  isFavourite: false,
);

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

  Future<void> pumpUnpricedScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 3400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    registerOrdersTestDi(stations: const [_station]);
    getIt.unregister<GetCompanyPricingConfig>();
    getIt.unregister<GetFuelPrices>();
    getIt.unregister<CompanyPricingRepository>();
    getIt.registerLazySingleton<CompanyPricingRepository>(
      _UnpricedCompanyRepository.new,
    );
    getIt.registerLazySingleton(
      () => GetFuelPrices(getIt<CompanyPricingRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetCompanyPricingConfig(getIt<CompanyPricingRepository>()),
    );

    await pumpLocalized(
      tester,
      BlocProvider<SessionCubit>.value(
        value: sampleAuthenticatedSessionCubit(),
        child: const CreateOrderScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  int selectedGradeIndex(WidgetTester tester) =>
      tester.widget<GradeSection>(find.byType(GradeSection)).selectedIndex!;

  testWidgets(
    'a grade tile still selects when the company has no tanker ladder',
    (tester) async {
      await pumpUnpricedScreen(tester);

      expect(selectedGradeIndex(tester), FuelGrade.gasoline91.index);

      await tester.tap(find.text('fuel.diesel'.tr()));
      await tester.pumpAndSettle();

      expect(
        selectedGradeIndex(tester),
        FuelGrade.diesel.index,
        reason: 'the tap must move the selection, ladder or no ladder',
      );
    },
  );

  testWidgets(
    'the quantity card names the real reason instead of asking for a fuel '
    'type already chosen',
    (tester) async {
      await pumpUnpricedScreen(tester);

      expect(find.text('order_create.choose_fuel_type_first'.tr()), findsNothing);
      expect(
        find.text('order_create.quantities_unavailable'.tr()),
        findsOneWidget,
      );
      // And a way out of it, rather than a dead form.
      expect(find.text('common.retry'.tr()), findsOneWidget);
    },
  );

  testWidgets('an empty fuel-price list says so rather than drawing nothing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1206, 3400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    registerOrdersTestDi(stations: const [_station]);

    await pumpLocalized(
      tester,
      BlocProvider<SessionCubit>.value(
        value: sampleAuthenticatedSessionCubit(),
        child: const CreateOrderScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('order_create.no_fuel_types'.tr()), findsOneWidget);
  });
}
