/// Placeholder order data the order screens are previewed against until the
/// cubits are wired to the API.
///
/// These are *sample values*, not user-facing copy: they stand in for what
/// the backend will supply, so they are deliberately not translated. Every
/// widget takes them as a default constructor argument, which keeps the
/// fake data out of the widget tree and in one file to delete once the real
/// data lands.
abstract final class OrderMockData {
  // --- Identity ---------------------------------------------------------
  static const String orderReference = 'ORD-2024-256 · 9 صفر 1448';
  static const String orderCode = 'ORD-2024-256';
  static const String receiptReference = '#889241035';
  static const String invoiceNumber = '40521';
  static const String billerNumber = '889241035';

  // --- Consignment ------------------------------------------------------
  static const String fuelGrade = 'بنزين 95';
  static const String summaryFuelGrade = 'بنزين 98';
  static const int quantityLitres = 20000;
  static const double pricePerLitre = 2.33;

  // --- Schedule ---------------------------------------------------------
  static const String deliveryDate = '9 أغسطس 2024';
  static const String deliveryHour = '06.30 صباحاً';
  static const String invoiceValidUntil = 'اليوم 06:30 صباحاً';
  static const String creditValidUntil = '9 أغسطس 2024';

  // --- Stations ---------------------------------------------------------
  static const String stationName = 'محطة الرحاب';
  static const String stationAddress = 'جدة - طريق مكة القديم - حي البوادي';
  static const String deliveryStationAddress = 'طريق أنس بن مالك، حي الملقا';

  // --- Driver / vehicle -------------------------------------------------
  static const String driverName = 'أحمد السبيعي';
  static const String truckPlate = 'ABC-1234';
  static const int etaMinutes = 35;
  static const double journeyProgress = 0.75;
  static const String remainingDistance = '12.7 كم';
  static const String etaTime = '04:35 م';
  static const String etaDate = '02/05/2024 اليوم';

  // --- Handover ---------------------------------------------------------
  /// Space-separated so each digit can be laid out in its own box.
  static const String pickupCode = '8 6 3 5 6 4';
  static const String pickupCodeTimeRemaining = 'د 05:00';

  // --- Money ------------------------------------------------------------
  static const double fuelLineTotal = 450000.00;
  static const double deliveryFee = 30.00;
  static const double serviceFee = 30.00;
  static const double receiptTotal = 600120.00;

  static const double transportFees = 1200.00;
  static const double vat = 6000.00;
  static const double summaryTotal = 46600.00;

  static const double creditAvailable = 120000.00;
  static const double creditLimit = 200000.00;
  static const String creditUsedPercent = '37.5%';

  /// Share of the credit limit already drawn down, as the usage bar's two
  /// flex weights.
  static const int creditUsedFlex = 63;
  static const int creditFreeFlex = 37;

  static const int notificationCount = 3;
}
