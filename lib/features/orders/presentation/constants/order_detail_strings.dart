/// Arabic copy for the order-detail screen. Kept here rather than inline in
/// each widget so the screen's text is auditable in one place; the app's
/// wider `.tr()` translation system is not wired up for this screen yet.
abstract final class OrderDetailStrings {
  static const String orderStatus = 'حالة الطلب';
  static const String orderSummary = 'ملخص الطلب';

  static const String stepConfirmOrder = 'تأكيد الطلب';
  static const String stepPayment = 'الدفع';
  static const String stepDelivery = 'التوصيل';
  static const String stepHandover = 'التسليم';

  static const String fuelType = 'نوع الوقود';
  static const String quantity = 'الكمية';
  static const String pricePerLiter = 'سعر اللتر';
  static const String totalWithTax = 'الإجمالي\n(شامل الضريبة)';
  static const String transportFees = 'رسوم النقل';
  static const String vat = 'ضريبة القيمة المضافة\n(%15)';
  static const String finalTotal = 'الإجمالي النهائي';

  static const String headlineDeferred = 'مؤجلة للمرة القادمة';
  static const String headlinePaid = 'تم السداد';
  static const String headlineDelivered = 'تم التسليم';
  static const String orderAnother = 'طلب أخر';

  static const String paidSuccessfully = 'تم الدفع بنجاح';
  static const String referenceNumber = 'الرقم المرجعي';
  static const String day = 'اليوم';
  static const String hour = 'الساعة';
  static const String downloadReceipt = 'تنزيل الإيصال';
  static const String deferredInvoiceTitle = 'فاتورة مؤجلة';
  static const String deferredInvoiceNote =
      'يجب دفع الفاتورة المؤجلة لأستكمال العملية الحالية';
  static const String deliveryFee = 'رسوم التوصيل';
  static const String serviceFee = 'رسوم خدمة';
  static const String total = 'الإجمالي';
  static const String showDetails = 'إظهار التفاصيل';
  static const String hideDetails = 'إخفاء التفاصيل';

  static const String inDelivery = 'قيد التوصيل';
  static const String driverLabel = 'السائق';
  static const String truckLabel = 'الشاحنة';
  static const String arrivalIn = 'الوصول خلال';
  static const String minutes = 'دقيقة';
  static const String trackOnMap = 'تتبع الطلب علي الخريطة';
  static const String contactDriver = 'تواصل مع السائق';

  static const String handoverMethodTitle = 'طريقة الاستلام عند وصول الطلب';
  static const String handoverMethodNote =
      'لضمان إستلام أمن و سريع، أعرض علي السائق التالي لاستكمال عملية الاستلام.';
  static const String qrLabel = 'QR';
  static const String showThisToDriver = 'اعرض هذا للسائق';
  static const String or = 'أو';
  static const String pickupCode = 'كود الإستلام';
  static const String validFor = 'صالح لمدة';
  static const String codeShareWarning =
      'لا تقم بمشاركة الكود مع أي شخص غير السائق الخاص بالطلب';

  static const String invoicePending = 'الفاتورة معلقة';
  static const String confirmed = 'تم التأكيد';
  static const String completePayment = 'إكمال الدفع';
  static const String pay = 'إدفع';
  static const String cancel = 'إلغاء';
  static const String payNextTime = 'إدفع المرة القادمة';
  static const String requestCreditLimit = 'أطلب حد إئتماني';

  static const String pendingReview = 'قيد المراجعة';

  static const String creditLimit = 'الحد الإئتماني';
  static const String validUntil = 'صالح حتى 9 صفر 1446';
  static const String active = 'نشط';
  static const String availableNow = 'المتاح للدفع الآن';
  static const String creditLimitInBudget = 'هذا الطلب ضمن حدك الإئتماني';
  static const String payFromCreditLimit = 'أدفع من الحد الإئتماني';

  static const String support = 'الدعم';

  static const String changeMockState = 'تغيير الحالة (Mock)';
}
