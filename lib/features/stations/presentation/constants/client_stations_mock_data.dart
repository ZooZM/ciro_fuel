import '../../../home/presentation/widgets/current_order_card.dart';

/// Placeholder data the stations screen is previewed against until it is
/// wired to the API.
///
/// Sample values, not user-facing copy — the same reasoning as
/// `OrderMockData`, which is why none of it is translated.
abstract final class ClientStationsMockData {
  // --- The client's station --------------------------------------------
  static const String stationName = 'محطة الرحاب';
  static const String stationAddress = 'جدة - طريق مكة القديم - حي البوادي';

  // --- The order in flight ---------------------------------------------
  static const CurrentOrderSummary currentOrder = CurrentOrderSummary(
    fuelType: 'بنزين 95',
    quantity: '20,000 لتر',
    statusLabel: 'قيد التوصيل',
    driverName: 'أحمد السبيعي',
    truckPlate: 'ABC-1234',
    progress: 0.65,
    etaMinutes: '35',
    orderId: 'ORD-2024-256',
    orderDate: '02/05/2024',
    orderTime: '04:35 م',
  );

  // --- The most recent completed order ----------------------------------
  static const String lastOrderSummary = 'بنزين 95 • 20,000 لتر';
  static const String lastOrderReference = 'ORD-2024-256';
  static const String lastOrderAddress = 'طريق أنس بن مالك، حي الملقا';
  static const String lastOrderDate = '9 صفر 1446';
  static const String lastOrderTime = '06.30 صباحاً';

  /// The order is delivered, so its bar is full — it is the deferred invoice
  /// that keeps it in the warning colour rather than the delivered green.
  static const double lastOrderProgress = 1;
}
