/// Arabic copy for the order-tracking screen. Kept here rather than inline
/// in each widget so the screen's text is auditable in one place; the
/// app's wider `.tr()` translation system is not wired up for this screen
/// yet. Labels shared verbatim with the order-detail screen (حالة الطلب,
/// نوع الوقود, الكمية, السائق, and the pickup-code card's copy) live in
/// [OrderDetailStrings] instead of being redeclared here.
abstract final class TrackOrderStrings {
  static const String title = 'تتبع الطلب';

  static const String onTheWay = 'علي الطريق إليك';
  static const String remainingDistance = 'المسافة المتبقية';
  static const String expectedArrival = 'وقت الوصول المتوقع';

  static const String vehicle = 'المركبة';
  static const String fuelTankerTruck = 'شاحنة نقل وقود';

  // The pickup-code card's handover note is spelled slightly differently
  // here (لإستكمال) than on the order-detail screen (لاستكمال) in the
  // original design; preserved as-is rather than unified.
  static const String handoverNote =
      'لضمان إستلام أمن و سريع، أعرض علي السائق التالي لإستكمال عملية الاستلام.';

  static const String orderStages = 'مراحل الطلب';

  static const String received = 'تم الاستلام';
  static const String contactSupport = 'تواصل مع الدعم';
}
