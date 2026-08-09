/// Typed handles for every key in `assets/translations/*.json`.
///
/// Widgets call `LoginKeys.submit.tr()` instead of `'login.submit'.tr()`, so
/// a renamed or deleted key fails at compile time rather than silently
/// rendering the raw key string at runtime.
abstract final class CommonKeys {
  static const String languageName = 'common.language_name';
  static const String cancel = 'common.cancel';
}

abstract final class LoginKeys {
  static const String welcomeTitle = 'login.welcome_title';
  static const String welcomeSubtitle = 'login.welcome_subtitle';

  static const String phoneLabel = 'login.phone_label';
  static const String phoneHint = 'login.phone_hint';
  static const String phoneRequired = 'login.phone_required';
  static const String phoneInvalid = 'login.phone_invalid';

  static const String passwordHint = 'login.password_hint';
  static const String passwordRequired = 'login.password_required';
  static const String showPassword = 'login.show_password';
  static const String hidePassword = 'login.hide_password';

  static const String rememberMe = 'login.remember_me';
  static const String forgotPassword = 'login.forgot_password';
  static const String submit = 'login.submit';

  static const String alternativesDivider = 'login.alternatives_divider';
  static const String faceId = 'login.face_id';
  static const String fingerprint = 'login.fingerprint';
  static const String biometricReason = 'login.biometric_reason';

  static const String continueWithApple = 'login.continue_with_apple';
  static const String continueWithGoogle = 'login.continue_with_google';
  static const String comingSoon = 'login.coming_soon';

  static const String support = 'login.support';
  static const String securityNote = 'login.security_note';
}

abstract final class ForgotPasswordKeys {
  static const String title = 'forgot_password.title';
  static const String body = 'forgot_password.body';
}

/// Copy shared by every order screen — units, currency and the orders list.
abstract final class OrdersKeys {
  static const String listTitle = 'orders.list_title';
  static const String loadFailed = 'orders.load_failed';
  static const String empty = 'orders.empty';

  static const String litreUnit = 'orders.litre_unit';
  static const String currency = 'orders.currency';
  static const String currencyLong = 'orders.currency_long';

  /// `{quantity}` — a pre-formatted number.
  static const String quantityInLitres = 'orders.quantity_in_litres';

  /// `{amount}` — a pre-formatted number.
  static const String amountWithCurrency = 'orders.amount_with_currency';
  static const String amountWithCurrencyLong =
      'orders.amount_with_currency_long';
}

/// The create-order form.
abstract final class CreateOrderKeys {
  static const String title = 'order_create.title';
  static const String subtitle = 'order_create.subtitle';

  static const String sectionStation = 'order_create.section_station';
  static const String sectionGrade = 'order_create.section_grade';
  static const String sectionQuantity = 'order_create.section_quantity';
  static const String sectionDelivery = 'order_create.section_delivery';
  static const String sectionPayment = 'order_create.section_payment';

  static const String currentStation = 'order_create.current_station';
  static const String favouriteStations = 'order_create.favourite_stations';
  static const String changeStation = 'order_create.change_station';

  static const String chooseFuelTypeFirst =
      'order_create.choose_fuel_type_first';
  static const String customQuantity = 'order_create.custom_quantity';

  static const String scheduleTitle = 'order_create.schedule_title';
  static const String scheduleSubtitle = 'order_create.schedule_subtitle';
  static const String todayTitle = 'order_create.today_title';
  static const String todaySubtitle = 'order_create.today_subtitle';
  static const String fastestTitle = 'order_create.fastest_title';
  static const String fastestSubtitle = 'order_create.fastest_subtitle';

  static const String notesLabel = 'order_create.notes_label';
  static const String notesHint = 'order_create.notes_hint';

  static const String confirmOrder = 'order_create.confirm_order';
  static const String selectAtLeastOneFuelType =
      'order_create.select_at_least_one_fuel_type';

  /// `{grade}` — the fuel grade's display title.
  static const String enterValidQuantityFor =
      'order_create.enter_valid_quantity_for';
}

/// The order-detail screen and every status card on it.
abstract final class OrderDetailKeys {
  static const String orderStatus = 'order_detail.order_status';
  static const String orderSummary = 'order_detail.order_summary';

  static const String stepConfirmOrder = 'order_detail.step_confirm_order';
  static const String stepPayment = 'order_detail.step_payment';
  static const String stepDelivery = 'order_detail.step_delivery';
  static const String stepHandover = 'order_detail.step_handover';

  static const String fuelType = 'order_detail.fuel_type';
  static const String quantity = 'order_detail.quantity';
  static const String pricePerLiter = 'order_detail.price_per_liter';
  static const String totalWithTax = 'order_detail.total_with_tax';
  static const String transportFees = 'order_detail.transport_fees';
  static const String vat = 'order_detail.vat';
  static const String finalTotal = 'order_detail.final_total';

  static const String headlineDeferred = 'order_detail.headline_deferred';
  static const String headlinePaid = 'order_detail.headline_paid';
  static const String headlineDelivered = 'order_detail.headline_delivered';
  static const String orderAnother = 'order_detail.order_another';

  static const String paidSuccessfully = 'order_detail.paid_successfully';
  static const String referenceNumber = 'order_detail.reference_number';
  static const String day = 'order_detail.day';
  static const String hour = 'order_detail.hour';
  static const String downloadReceipt = 'order_detail.download_receipt';
  static const String shareReceipt = 'order_detail.share_receipt';
  static const String deferredInvoiceTitle =
      'order_detail.deferred_invoice_title';
  static const String deferredInvoiceNote =
      'order_detail.deferred_invoice_note';
  static const String deliveryFee = 'order_detail.delivery_fee';
  static const String serviceFee = 'order_detail.service_fee';
  static const String total = 'order_detail.total';
  static const String showDetails = 'order_detail.show_details';
  static const String hideDetails = 'order_detail.hide_details';

  static const String inDelivery = 'order_detail.in_delivery';
  static const String driver = 'order_detail.driver';
  static const String truck = 'order_detail.truck';
  static const String arrivalIn = 'order_detail.arrival_in';
  static const String minutes = 'order_detail.minutes';
  static const String trackOnMap = 'order_detail.track_on_map';
  static const String contactDriver = 'order_detail.contact_driver';

  static const String handoverMethodTitle =
      'order_detail.handover_method_title';
  static const String handoverMethodNote = 'order_detail.handover_method_note';
  static const String qrLabel = 'order_detail.qr_label';
  static const String showThisToDriver = 'order_detail.show_this_to_driver';
  static const String or = 'order_detail.or';
  static const String pickupCode = 'order_detail.pickup_code';
  static const String validFor = 'order_detail.valid_for';
  static const String codeShareWarning = 'order_detail.code_share_warning';

  static const String invoicePending = 'order_detail.invoice_pending';
  static const String confirmed = 'order_detail.confirmed';
  static const String completePayment = 'order_detail.complete_payment';
  static const String pay = 'order_detail.pay';
  static const String cancel = 'order_detail.cancel';
  static const String payNextTime = 'order_detail.pay_next_time';
  static const String requestCreditLimit = 'order_detail.request_credit_limit';
  static const String pendingReview = 'order_detail.pending_review';

  static const String creditLimit = 'order_detail.credit_limit';

  /// `{date}` — the limit's expiry.
  static const String creditValidUntil = 'order_detail.credit_valid_until';

  /// `{amount}` — a pre-formatted number.
  static const String creditTotalLimit = 'order_detail.credit_total_limit';

  /// `{amount}`, `{percent}` — both pre-formatted.
  static const String creditUsed = 'order_detail.credit_used';
  static const String active = 'order_detail.active';
  static const String availableNow = 'order_detail.available_now';
  static const String creditLimitInBudget =
      'order_detail.credit_limit_in_budget';
  static const String payFromCreditLimit =
      'order_detail.pay_from_credit_limit';

  static const String support = 'order_detail.support';
  static const String changeMockState = 'order_detail.change_mock_state';
}

/// The live order-tracking screen.
abstract final class TrackOrderKeys {
  static const String title = 'order_track.title';

  /// `{reference}` — the order's reference code.
  static const String orderNumber = 'order_track.order_number';
  static const String onTheWay = 'order_track.on_the_way';
  static const String remainingDistance = 'order_track.remaining_distance';
  static const String expectedArrival = 'order_track.expected_arrival';
  static const String vehicle = 'order_track.vehicle';
  static const String fuelTankerTruck = 'order_track.fuel_tanker_truck';
  static const String handoverNote = 'order_track.handover_note';
  static const String orderStages = 'order_track.order_stages';
  static const String received = 'order_track.received';
  static const String contactSupport = 'order_track.contact_support';
}

/// The SADAD invoice-payment screen.
abstract final class InvoicePaymentKeys {
  static const String sadadNote = 'order_invoice.sadad_note';
  static const String invoiceDetails = 'order_invoice.invoice_details';
  static const String invoiceNumber = 'order_invoice.invoice_number';
  static const String billerNumber = 'order_invoice.biller_number';
  static const String validUntil = 'order_invoice.valid_until';
  static const String confirmAndComplete = 'order_invoice.confirm_and_complete';
}

/// The موعد التسليم panel shown at every stage of an order.
abstract final class DeliveryTimeKeys {
  static const String title = 'delivery_time.title';
  static const String stationPrefix = 'delivery_time.station_prefix';
}

/// Stop labels on the shared delivery timeline.
abstract final class OrderFlowKeys {
  static const String accepted = 'order_flow.accepted';
  static const String loading = 'order_flow.loading';
  static const String dispatched = 'order_flow.dispatched';
  static const String onTheWay = 'order_flow.on_the_way';
  static const String delivered = 'order_flow.delivered';
}

/// User-facing failure copy. Deliberately non-enumerating: none of these
/// reveal whether an account exists or which credential was wrong (FR-007).
abstract final class ErrorKeys {
  static const String invalidCredentials = 'errors.invalid_credentials';
  static const String throttled = 'errors.throttled';
  static const String network = 'errors.network';
  static const String generic = 'errors.generic';
  static const String biometricUnavailable = 'errors.biometric_unavailable';
  static const String biometricFailed = 'errors.biometric_failed';
}
