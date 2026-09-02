import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/features/more/presentation/view/client_credit_limit_screen.dart';
import 'package:mobile_app/features/more/presentation/view/client_terms_screen.dart';
import 'package:mobile_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_orders.dart';
import 'package:mobile_app/features/stations/domain/repositories/stations_repository.dart';
import 'package:mobile_app/features/stations/domain/usecases/get_stations.dart';
import 'package:mobile_app/features/stations/domain/usecases/set_favourite_station.dart';
import 'package:mobile_app/features/stations/presentation/cubit/stations_cubit.dart';
import 'package:mobile_app/features/stations/presentation/view/client_stations_screen.dart';
import 'package:mobile_app/features/support/domain/repositories/support_repository.dart';
import 'package:mobile_app/features/support/domain/usecases/create_support_request.dart';
import 'package:mobile_app/features/support/domain/usecases/get_support_requests.dart';
import 'package:mobile_app/features/support/presentation/cubit/support_cubit.dart';
import 'package:mobile_app/features/support/presentation/view/support_screen.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadTajawal();
  });

  // ClientCreditLimitScreen now resolves CreditCubit from getIt (spec 005 T083).
  // ClientStationsScreen now resolves StationsCubit from getIt (spec 005 T110).
  // SupportScreen(showTopBar: true) now resolves SupportCubit + GetOrders
  // (spec 005 T119/T120). All registered narrowly here rather than via
  // registerOrdersTestDi(), which would double-register the
  // InvoicesRepository/GetCreditStanding pair registerFinanceTestDi() above
  // already owns.
  setUp(() {
    registerFinanceTestDi();
    final stationsRepository = FakeStationsRepository(const []);
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

    final ordersRepository = FakeOrdersRepository(const []);
    getIt.registerLazySingleton<OrdersRepository>(() => ordersRepository);
    getIt.registerLazySingleton(() => GetOrders(getIt<OrdersRepository>()));

    final supportRepository = FakeSupportRepository(const []);
    getIt.registerLazySingleton<SupportRepository>(() => supportRepository);
    getIt.registerLazySingleton(
      () => GetSupportRequests(getIt<SupportRepository>()),
    );
    getIt.registerLazySingleton(
      () => CreateSupportRequest(getIt<SupportRepository>()),
    );
    getIt.registerFactory(
      () => SupportCubit(
        getSupportRequests: getIt<GetSupportRequests>(),
        createSupportRequest: getIt<CreateSupportRequest>(),
      ),
    );
  });
  tearDown(() {
    resetFinanceTestDi();
    if (getIt.isRegistered<StationsCubit>()) getIt.unregister<StationsCubit>();
    if (getIt.isRegistered<SetFavouriteStation>()) {
      getIt.unregister<SetFavouriteStation>();
    }
    if (getIt.isRegistered<GetStations>()) getIt.unregister<GetStations>();
    if (getIt.isRegistered<StationsRepository>()) {
      getIt.unregister<StationsRepository>();
    }
    if (getIt.isRegistered<GetOrders>()) getIt.unregister<GetOrders>();
    if (getIt.isRegistered<OrdersRepository>()) {
      getIt.unregister<OrdersRepository>();
    }
    if (getIt.isRegistered<SupportCubit>()) getIt.unregister<SupportCubit>();
    if (getIt.isRegistered<CreateSupportRequest>()) {
      getIt.unregister<CreateSupportRequest>();
    }
    if (getIt.isRegistered<GetSupportRequests>()) {
      getIt.unregister<GetSupportRequests>();
    }
    if (getIt.isRegistered<SupportRepository>()) {
      getIt.unregister<SupportRepository>();
    }
  });

  /// A tall viewport: these are long scrolling pages, and an overflow only
  /// reports for the part of the tree that is actually laid out.
  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1206, 4200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // Through the harness, not a bare MaterialApp: these screens read
    // `context.locale`, which needs a real EasyLocalization ancestor.
    await pumpLocalized(
      tester,
      screen,
      theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
    );

    // Catches the RenderFlex overflows and missing-asset errors a layout
    // refactor is most likely to introduce.
    expect(tester.takeException(), isNull);
  }

  testWidgets('the credit-limit screen lays out on a phone screen', (
    tester,
  ) async {
    await pumpScreen(tester, const ClientCreditLimitScreen());
  });

  testWidgets('the terms screen lays out on a phone screen', (tester) async {
    await pumpScreen(tester, const ClientTermsScreen());
  });

  testWidgets('the stations screen lays out on a phone screen', (tester) async {
    await pumpScreen(tester, const ClientStationsScreen());
  });

  testWidgets('the support screen lays out signed out', (tester) async {
    await pumpScreen(tester, const SupportScreen());
  });

  testWidgets('the support screen lays out with the in-app header', (
    tester,
  ) async {
    await pumpScreen(tester, const SupportScreen(showTopBar: true));
  });
}
