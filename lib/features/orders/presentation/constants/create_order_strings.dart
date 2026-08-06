/// Arabic copy for the create-order form. Kept here rather than inline in
/// each widget so the screen's text is auditable in one place; the app's
/// wider `.tr()` translation system is not wired up for this screen yet.
abstract final class CreateOrderStrings {
  static const String title = 'طلب وقود جديد';
  static const String subtitle = 'اطلب الوقود خلال أقل من دقيقة';

  // Section headings — numbered as in the design. Sections 1 and 2 share
  // the same "نوع الوقود" heading in the source design despite section 1
  // being the station picker; preserved as-is rather than corrected here.
  static const String sectionStation = '1. نوع الوقود';
  static const String sectionGrade = '2. نوع الوقود';
  static const String sectionQuantity = '3. الكمية';
  static const String sectionDelivery = '4. موعد التوصيل';
  static const String sectionPayment = '5. طريقة الدفع';

  static const String currentStation = 'المحطة الحالية';
  static const String favouriteStations = 'محطاتك المفضلة';
  static const String changeStation = 'تغيير المحطة';

  static const String chooseFuelTypeFirst = 'الرجاء اختيار نوع الوقود أولاً';
  static const String litre = 'لتر';

  static const String scheduleTitle = 'جدول موعد';
  static const String scheduleSubtitle = 'اختر التاريخ و الوقت';
  static const String todayTitle = 'اليوم';
  static const String todaySubtitle = 'توصيل خلال نفس اليوم';
  static const String fastestTitle = 'بأسرع وقت';
  static const String fastestSubtitle = 'أقرب وقت متاح';

  static const String notesLabel = 'ملاحظات للسائق (اختياري)';
  static const String notesHint = 'اكتب أي ملاحظات خاصة بالتوصيل ...';

  static const String confirmOrder = 'تأكيد الطلب';

  static const String selectAtLeastOneFuelType =
      'الرجاء اختيار نوع وقود واحد على الأقل';

  /// `%s` placeholder for the grade label — see [enterValidQuantityFor].
  static const String enterValidQuantityPrefix = 'أدخل كمية صحيحة لـ ';

  static String enterValidQuantityFor(String gradeLabel) =>
      '$enterValidQuantityPrefix$gradeLabel';
}
