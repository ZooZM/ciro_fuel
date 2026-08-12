/// Arabic copy for the client home dashboard. Kept here rather than inline
/// in each widget so the screen's text is auditable in one place; the app's
/// wider `.tr()` translation system is not wired up for this screen yet.
abstract final class ClientHomeStrings {
  static const String currentStation = 'المحطة الحالية';
  static const String changeStation = 'تغيير المحطة';
  // Shown while the profile is still loading, or for the rare client whose
  // station has no name/address on file yet — never invented.
  static const String stationNameUnavailable = 'غير متوفر';

  static const String pendingInvoice = 'فاتورة مستحقة';
  static const String availableBalance = 'الرصيد المتاح';
  static const String currency = 'ريال';

  static const String newFuelRequest = 'طلب وقود جديد';

  static const String currentOrderSection = 'طلبك الحالي';
  static const String quickRequestSection = 'طلب سريع';
  static const String quickGlanceSection = 'نظرة سريعة';

  static const String driverLabel = 'السائق';
  static const String truckLabel = 'الشاحنة';
  static const String arrivalIn = 'الوصول خلال';
  static const String minutes = 'دقيقة';
  static const String orderTimeLabel = 'وقت الطلب';
  static const String trackOnMap = 'تتبع الطلب على الخريطة';
  static const String contactDriver = 'تواصل مع السائق';

  static const String statCancelled = 'ملغاة';
  static const String statInPreparation = 'قيد التجهيز';
  static const String statInDelivery = 'قيد التوصيل';
  static const String statDelivered = 'تم التوصيل';
}
