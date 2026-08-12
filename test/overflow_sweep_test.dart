import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/delivery_time_card.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/order_detail_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/orders_list_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/track_order_screen.dart';
import 'package:mobile_app/features/orders/presentation/widgets/create_order/create_order_data.dart';
import 'package:mobile_app/features/orders/presentation/widgets/create_order/delivery_section.dart';

import 'helpers/localized_harness.dart';

/// Flutter reports a layout overflow by throwing, so pumping each screen and
/// asking for the pending exception is the check.
///
/// Both locales, because the English copy is materially longer than the Arabic
/// it was laid out against — every overflow found so far showed up only there.
void main() {
  Widget wrap(Widget child) => Scaffold(
    body: SafeArea(
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );

  final cases = <String, Widget>{
    'create order': const CreateOrderScreen(),
    'orders list': const OrdersListScreen(),
    'track order': const TrackOrderScreen(),
    'delivery time card': wrap(const DeliveryTimeCard()),
    'delivery section': wrap(
      DeliverySection(
        selected: DeliveryOption.today,
        onChanged: (_) {},
        onScheduleTap: () {},
      ),
    ),
  };

  for (final entry in cases.entries) {
    for (final (localeName, locale) in [
      ('Arabic', AppLocales.arabic),
      ('English', AppLocales.english),
    ]) {
      testWidgets('${entry.key} lays out under $localeName', (tester) async {
        await loadTajawal();
        // A common small-ish phone; overflows hide on a roomy canvas.
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpLocalized(
          tester,
          entry.value,
          locale: locale,
          theme: AppTheme.lightTheme,
        );

        expect(
          tester.takeException(),
          isNull,
          reason: '${entry.key} overflows under $localeName',
        );
      });
    }
  }

  for (final state in MockOrderState.values) {
    testWidgets('order detail (${state.name}) lays out under English', (
      tester,
    ) async {
      await loadTajawal();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await pumpLocalized(
        tester,
        OrderDetailScreen(orderId: 'x', mockState: state),
        locale: AppLocales.english,
        theme: AppTheme.lightTheme,
      );

      expect(tester.takeException(), isNull, reason: '${state.name} overflows');
    });
  }
}
