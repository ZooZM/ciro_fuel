import 'package:easy_localization/easy_localization.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/utils/number_formatting.dart';

/// Numbers rendered the way each locale writes them — the digits grouped by
/// [NumberFormatting], the unit and currency pulled from the translation
/// files rather than concatenated inline.
abstract final class OrderFormatting {
  /// `20000` → `'20,000 لتر'`.
  static String litres(int value) => OrdersKeys.quantityInLitres.tr(
    namedArgs: {'quantity': NumberFormatting.thousands(value)},
  );

  /// `450000.0` → `'450,000.00 ر.س'`.
  static String money(double value) => OrdersKeys.amountWithCurrency.tr(
    namedArgs: {'amount': NumberFormatting.currency(value)},
  );

  /// As [money], but with the currency spelled out — the order-summary card
  /// uses the long form.
  static String moneyLong(double value) =>
      OrdersKeys.amountWithCurrencyLong.tr(
        namedArgs: {'amount': NumberFormatting.currency(value)},
      );

  /// The receipt's consignment line: `'بنزين 95 • 20,000 لتر'`.
  static String lineItem(String fuelGrade, int litreCount) =>
      '$fuelGrade • ${litres(litreCount)}';
}
