/// Typed handles for every key in `assets/translations/*.json`.
///
/// Widgets call `LoginKeys.submit.tr()` instead of `'login.submit'.tr()`, so
/// a renamed or deleted key fails at compile time rather than silently
/// rendering the raw key string at runtime.
///
/// One class per top-level JSON namespace, in the same order as the JSON so
/// the two stay easy to diff by eye.
abstract final class CommonKeys {
  static const String languageName = 'common.language_name';
  static const String arabic = 'common.arabic';
  static const String english = 'common.english';
  static const String cancel = 'common.cancel';
  static const String confirm = 'common.confirm';
  static const String total = 'common.total';
  static const String support = 'common.support';
  static const String or = 'common.or';
  static const String all = 'common.all';
  static const String riyal = 'common.riyal';
  static const String currencySymbol = 'common.currency_symbol';
  static const String litre = 'common.litre';
  static const String unit = 'common.unit';
  static const String km = 'common.km';
  static const String minutes = 'common.minutes';
  static const String today = 'common.today';
  static const String yesterday = 'common.yesterday';
  static const String day = 'common.day';
  static const String hour = 'common.hour';
  static const String driver = 'common.driver';
  static const String truck = 'common.truck';
  static const String arrivalIn = 'common.arrival_in';
  static const String trackOnMap = 'common.track_on_map';
  static const String contactDriver = 'common.contact_driver';
  static const String contactSupport = 'common.contact_support';
  static const String searchByInvoiceCode = 'common.search_by_invoice_code';
  static const String searchByOrderCode = 'common.search_by_order_code';
  static const String save = 'common.save';
  static const String retry = 'common.retry';
  static const String editName = 'common.edit_name';
}

abstract final class NavKeys {
  static const String payments = 'nav.payments';
  static const String orders = 'nav.orders';
  static const String home = 'nav.home';
  static const String invoices = 'nav.invoices';
  static const String more = 'nav.more';
  static const String profile = 'nav.profile';
  static const String notifications = 'nav.notifications';
}

abstract final class FuelKeys {
  static const String gasoline91 = 'fuel.gasoline_91';
  static const String gasoline95 = 'fuel.gasoline_95';
  static const String gasoline98 = 'fuel.gasoline_98';
  static const String diesel = 'fuel.diesel';
  static const String kerosene = 'fuel.kerosene';
}

abstract final class OrderFlowKeys {
  static const String accepted = 'order_flow.accepted';
  static const String loading = 'order_flow.loading';
  static const String dispatched = 'order_flow.dispatched';
  static const String onTheWay = 'order_flow.on_the_way';
  static const String delivered = 'order_flow.delivered';
}

abstract final class DeliveryTimeKeys {
  static const String title = 'delivery_time.title';

  /// Carries its own trailing space — the station name is appended to it in
  /// a single `Text.rich`, so the two spans must not be joined bare.
  static const String stationPrefix = 'delivery_time.station_prefix';
}

abstract final class CountryKeys {
  static const String saudiArabia = 'countries.saudi_arabia';
  static const String unitedArabEmirates = 'countries.united_arab_emirates';
  static const String kuwait = 'countries.kuwait';
  static const String bahrain = 'countries.bahrain';
  static const String qatar = 'countries.qatar';
  static const String oman = 'countries.oman';
  static const String egypt = 'countries.egypt';
}

abstract final class LoginKeys {
  static const String welcomeTitle = 'login.welcome_title';
  static const String welcomeSubtitle = 'login.welcome_subtitle';

  static const String chooseCountry = 'login.choose_country';
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

abstract final class HomeKeys {
  static const String currentStation = 'home.current_station';
  static const String changeStation = 'home.change_station';

  /// Shown while the profile is still loading, or for the rare client whose
  /// station has no name/address on file yet — never invented.
  static const String stationNameUnavailable = 'home.station_name_unavailable';

  /// Divider above the stations the client cannot currently order from.
  static const String inactiveStations = 'home.inactive';

  static const String pendingInvoice = 'home.pending_invoice';
  static const String availableBalance = 'home.available_balance';

  static const String newFuelRequest = 'home.new_fuel_request';

  static const String currentOrderSection = 'home.current_order_section';

  /// Stands in for the current-order card when nothing is in flight.
  static const String noActiveOrder = 'home.no_active_order';
  static const String quickRequestSection = 'home.quick_request_section';
  static const String quickGlanceSection = 'home.quick_glance_section';

  static const String orderTimeLabel = 'home.order_time_label';

  static const String statCancelled = 'home.stat_cancelled';
  static const String statInPreparation = 'home.stat_in_preparation';
  static const String statInDelivery = 'home.stat_in_delivery';
  static const String statDelivered = 'home.stat_delivered';
}

abstract final class OrdersListKeys {
  static const String title = 'orders_list.title';

  /// Takes a `count` named argument.
  static const String count = 'orders_list.count';

  static const String filterInDelivery = 'orders_list.filter_in_delivery';
  static const String filterDelivered = 'orders_list.filter_delivered';
  static const String filterFailed = 'orders_list.filter_failed';
  static const String filterPendingReview = 'orders_list.filter_pending_review';
  static const String filterConfirmed = 'orders_list.filter_confirmed';
  static const String filterPaid = 'orders_list.filter_paid';

  static const String statusConfirmed = 'orders_list.status_confirmed';
  static const String statusInvoicePending =
      'orders_list.status_invoice_pending';
  static const String statusFailed = 'orders_list.status_failed';
  static const String statusSettled = 'orders_list.status_settled';
  static const String statusInDelivery = 'orders_list.status_in_delivery';
  static const String statusPaymentDeferred =
      'orders_list.status_payment_deferred';
}

abstract final class InvoicesKeys {
  static const String title = 'invoices.title';

  /// Takes a `count` named argument.
  static const String count = 'invoices.count';

  static const String empty = 'invoices.empty';

  static const String tabAll = 'invoices.tab_all';
  static const String tabDeferred = 'invoices.tab_deferred';
  static const String tabPaid = 'invoices.tab_paid';
  static const String tabFailed = 'invoices.tab_failed';

  /// The real `InvoiceState` values (spec 005 T078) — `tabDeferred`/
  /// `tabFailed` above predate this feature and don't name an actual
  /// backend state (ISSUED/SETTLED/VOID); kept only because
  /// `driver_orders_screen.dart` still reuses them for its own, unrelated
  /// mock tabs.
  static const String tabOutstanding = 'invoices.tab_outstanding';
  static const String tabVoided = 'invoices.tab_voided';

  static const String detailTitle = 'invoices.detail_title';
  static const String reference = 'invoices.reference';
  static const String settledOn = 'invoices.settled_on';

  /// The breakdown's consignment line, standing in for a specific fuel
  /// grade/quantity — an invoice carries only the priced totals, not which
  /// grade or how many litres they were for (that lives on its order,
  /// which this screen doesn't also fetch).
  static const String fuelCharge = 'invoices.fuel_charge';
}

abstract final class PaymentsKeys {
  static const String title = 'payments.title';

  /// Takes a `count` named argument.
  static const String count = 'payments.count';

  static const String empty = 'payments.empty';
}

/// spec 005 T110 — the client's real stations list. `title`/`defaultStation`
/// are new; the pre-005 keys this class used to carry (`current_order`,
/// `last_order`, `quick_glance`, `delivered_deferred_invoice`) belonged to
/// this screen's old dashboard-style mock content, dropped along with it.
abstract final class StationsKeys {
  static const String title = 'stations.title';
  static const String defaultStation = 'stations.default_station';
}

abstract final class InvoicePaymentKeys {
  static const String sadadNote = 'invoice_payment.sadad_note';
  static const String downloadReceipt = 'invoice_payment.download_receipt';
  static const String confirmAndComplete =
      'invoice_payment.confirm_and_complete';
  static const String invoiceData = 'invoice_payment.invoice_data';
  static const String invoiceNumber = 'invoice_payment.invoice_number';
  static const String orgNumber = 'invoice_payment.org_number';
  static const String validUntil = 'invoice_payment.valid_until';
  static const String deferredInvoice = 'invoice_payment.deferred_invoice';
  static const String deferredNote = 'invoice_payment.deferred_note';
  static const String deliveryFee = 'invoice_payment.delivery_fee';
  static const String serviceFee = 'invoice_payment.service_fee';
  static const String hideDetails = 'invoice_payment.hide_details';

  /// FR-024: shown while the platform's own webhook confirmation is still
  /// pending — the invoice is never treated as paid on the gateway's
  /// return value alone (spec 005 T079).
  static const String awaitingConfirmation =
      'invoice_payment.awaiting_confirmation';

  /// The payment window (`paymentDeadline`) lapsed before a confirmation
  /// arrived — the order has already reverted server-side by the time this
  /// shows.
  static const String windowExpired = 'invoice_payment.window_expired';
}

abstract final class NotificationKeys {
  static const String filterAll = 'notifications.filter_all';
  static const String filterOrders = 'notifications.filter_orders';
  static const String filterInvoices = 'notifications.filter_invoices';
  static const String filterSystem = 'notifications.filter_system';

  /// spec 005 T088 — the one real, server-applied filter (`?unread=true`);
  /// the three above predate the real `AppNotification` shape and no
  /// longer drive anything.
  static const String filterUnread = 'notifications.filter_unread';

  static const String markAllRead = 'notifications.mark_all_read';

  static const String orderAcceptedTitle = 'notifications.order_accepted_title';
  static const String invoiceDueTitle = 'notifications.invoice_due_title';
  static const String systemUpdateTitle = 'notifications.system_update_title';

  /// Takes an `id` named argument.
  static const String orderBody = 'notifications.order_body';

  /// Takes an `amount` named argument.
  static const String invoiceBody = 'notifications.invoice_body';

  static const String systemBody = 'notifications.system_body';

  static const String minutesAgo = 'notifications.minutes_ago';
  static const String yesterdayTime = 'notifications.yesterday_time';

  /// Copy for the in-app banner a push raises over whatever screen is open,
  /// one per [NotificationType]. Corrected to the backend's real wire
  /// values in spec 007 (research R10, `mobile_app/CLAUDE.md` debt #5).
  static const String bannerOrderApprovedFinalPrice =
      'notifications.banner_order_approved_final_price';
  static const String bannerNoDriverAvailable =
      'notifications.banner_no_driver_available';
  static const String bannerPaymentTimeout =
      'notifications.banner_payment_timeout';
  static const String bannerOrderAssigned =
      'notifications.banner_order_assigned';
  static const String bannerOrderStatusChanged =
      'notifications.banner_order_status_changed';
  static const String bannerOtpIssued = 'notifications.banner_otp_issued';
  static const String bannerPaymentReconciliationRequired =
      'notifications.banner_payment_reconciliation_required';
  static const String bannerOrderRoutedToTransport =
      'notifications.banner_order_routed_to_transport';
  static const String bannerSupportRequestRaised =
      'notifications.banner_support_request_raised';
  // spec 011: the in-app rendering of the stop prompt. The same
  // notification ALSO raises a device-level alert (FR-004a) — this key is
  // what the notifications list and banner show for it.
  static const String bannerDriverStopDetected =
      'notifications.banner_driver_stop_detected';
  // feature 013 US5a: a driver reported they cannot reach the destination.
  // Addressed to a transport admin (not a mobile persona) — this key exists
  // only so the shared presentation map stays exhaustive.
  static const String bannerDriverBlocked =
      'notifications.banner_driver_blocked';
  static const String bannerUnknown = 'notifications.banner_unknown';
  static const String bannerView = 'notifications.banner_view';
}

/// The mandatory driver app lock (spec 006 US2/FR-010–018a). No "off"
/// state and no settings screen — see `AppLockCubit`.
abstract final class LockKeys {
  /// The reason string shown inside the OS's own biometric/passcode
  /// prompt (`local_auth`'s `localizedReason`), not this app's UI chrome.
  static const String challengeReason = 'lock.challenge_reason';
  static const String title = 'lock.title';
  static const String retry = 'lock.retry';
  static const String unavailableTitle = 'lock.unavailable_title';
  static const String unavailableBody = 'lock.unavailable_body';
}

abstract final class MoreKeys {
  static const String sectionAccount = 'more.section_account';
  static const String sectionApp = 'more.section_app';
  static const String sectionAbout = 'more.section_about';

  static const String yourStations = 'more.your_stations';
  static const String invoicesAndPayment = 'more.invoices_and_payment';
  static const String creditLimit = 'more.credit_limit';

  static const String appLock = 'more.app_lock';
  static const String appLockTitle = 'more.app_lock_title';
  static const String appLockBody = 'more.app_lock_body';
  static const String appLockPassword = 'more.app_lock_password';
  static const String appLockOff = 'more.app_lock_off';
  static const String appLockUnavailable = 'more.app_lock_unavailable';
  static const String fingerprint = 'more.fingerprint';
  static const String notifications = 'more.notifications';
  static const String supportHelp = 'more.support_help';

  static const String terms = 'more.terms';
  static const String aboutUs = 'more.about_us';

  static const String language = 'more.language';
  static const String colorTheme = 'more.color_theme';

  /// A literal until the build number is read from package_info at runtime.
  static const String appVersion = 'more.app_version';

  /// Takes a `count` named argument.
  static const String stationsCount = 'more.stations_count';

  static const String signOut = 'more.sign_out';
  static const String signOutConfirmation = 'more.sign_out_confirmation';
}

abstract final class TermsKeys {
  static const String contents = 'terms.contents';

  static const String introTitle = 'terms.intro_title';
  static const String introBody = 'terms.intro_body';
  static const String updatesTitle = 'terms.updates_title';
  static const String updatesBody = 'terms.updates_body';
  static const String dataAccuracyTitle = 'terms.data_accuracy_title';
  static const String dataAccuracyBody = 'terms.data_accuracy_body';
  static const String credentialsTitle = 'terms.credentials_title';
  static const String credentialsBody = 'terms.credentials_body';
  static const String lawfulUseTitle = 'terms.lawful_use_title';
  static const String lawfulUseBody = 'terms.lawful_use_body';
  static const String systemProtectionTitle = 'terms.system_protection_title';
  static const String systemProtectionBody = 'terms.system_protection_body';
}

abstract final class CreditLimitKeys {
  static const String requestOrRenew = 'credit_limit.request_or_renew';
  static const String title = 'credit_limit.title';
  static const String unavailable = 'credit_limit.unavailable';
  static const String noActiveLimit = 'credit_limit.no_active_limit';

  static const String requestTitle = 'credit_limit.request_title';
  static const String underReview = 'credit_limit.under_review';
  static const String requestedLimit = 'credit_limit.requested_limit';

  static const String stepSent = 'credit_limit.step_sent';
  static const String stepReview = 'credit_limit.step_review';
  static const String stepDecision = 'credit_limit.step_decision';
  static const String expectedReply = 'credit_limit.expected_reply';

  static const String acknowledgementTitle =
      'credit_limit.acknowledgement_title';
  static const String acknowledgementBody = 'credit_limit.acknowledgement_body';
  static const String applyTerms = 'credit_limit.apply_terms';
  static const String requestYourLimit = 'credit_limit.request_your_limit';
}

/// spec 006 FR-002/003 — the driver-only company/truck section on
/// `DriverProfileDetailsScreen`. Distinct from [ProfileKeys], which covers
/// the sections shared with the client's own profile screen.
abstract final class DriverProfileKeys {
  static const String company = 'driver_profile.company';
  static const String truckPlate = 'driver_profile.truck_plate';
  static const String truckFuelTypes = 'driver_profile.truck_fuel_types';

  /// FR-003: shown instead of a blank or invented row when the driver has
  /// no truck assigned yet.
  static const String noTruckAssigned = 'driver_profile.no_truck_assigned';
}

abstract final class ProfileKeys {
  static const String contactInfo = 'profile.contact_info';
  static const String linkedStations = 'profile.linked_stations';

  /// Takes a `count` named argument.
  static const String stationsCount = 'profile.stations_count';

  static const String accountInfo = 'profile.account_info';
  static const String joinDate = 'profile.join_date';
  static const String active = 'profile.active';
  static const String changePhone = 'profile.change_phone';
  static const String verifiedAccount = 'profile.verified_account';
  static const String noStations = 'profile.no_stations';
}

abstract final class ChangePhoneKeys {
  static const String stepChangeNumber = 'change_phone.step_change_number';
  static const String stepVerifyCode = 'change_phone.step_verify_code';
  static const String stepReverify = 'change_phone.step_reverify';

  static const String title = 'change_phone.title';
  static const String warning = 'change_phone.warning';
  static const String sendCode = 'change_phone.send_code';
  static const String contactUs = 'change_phone.contact_us';
}

abstract final class VerifyPhoneKeys {
  static const String title = 'verify_phone.title';
  static const String sentTo = 'verify_phone.sent_to';
  static const String changeNumber = 'verify_phone.change_number';

  /// Takes a `timer` named argument (`mm:ss`), shown only while a resend
  /// throttle's real `retryAfterSeconds` is counting down (spec 005 T102) —
  /// never a client-fabricated cooldown.
  static const String resendIn = 'verify_phone.resend_in';

  /// The tappable resend link, shown whenever no throttle countdown is
  /// active.
  static const String resendCode = 'verify_phone.resend_code';
  static const String codeResent = 'verify_phone.code_resent';
  static const String phoneVerified = 'verify_phone.phone_verified';
}

abstract final class SupportKeys {
  /// The word set beside the logo in the signed-out header. Untranslated by
  /// design — it is part of the wordmark.
  static const String brandSuffix = 'support.brand_suffix';

  // Accessibility labels for the three channel marks, which are artwork
  // carrying no text of their own.
  static const String whatsapp = 'support.whatsapp';
  static const String telegram = 'support.telegram';
  static const String facebook = 'support.facebook';

  static const String contactNow = 'support.contact_now';
  static const String directCall = 'support.direct_call';
  // feature 013 T084: the number the "Direct call" button dials. A Saudi
  // 920 unified-number placeholder — ops fills the real one; it is a config
  // value, not identity.
  static const String hotline = 'support.hotline';
  static const String callUnavailable = 'support.call_unavailable';
  static const String orVia = 'support.or_via';

  static const String orderIssueTitle = 'support.order_issue_title';
  static const String orderIssueBody = 'support.order_issue_body';
  static const String orderIssueNotListed = 'support.order_issue_not_listed';
  static const String orderIssueSendCode = 'support.order_issue_send_code';
  static const String orderIssueHint = 'support.order_issue_hint';

  static const String topTopics = 'support.top_topics';
  static const String topicFuelOrders = 'support.topic_fuel_orders';
  static const String topicDeliveryDelay = 'support.topic_delivery_delay';
  static const String topicPaymentMethods = 'support.topic_payment_methods';
  static const String topicAccountLogin = 'support.topic_account_login';

  /// Placeholder question and answer, repeated under every topic until the
  /// real FAQ copy arrives.
  static const String faqQuestion = 'support.faq_question';
  static const String faqAnswer = 'support.faq_answer';

  static const String availability = 'support.availability';

  // spec 005 T120/T121 — the order-problem card's real submission flow and
  // the screen's own submitted/acknowledged history.
  static const String selectOrder = 'support.select_order';
  static const String noOrdersToAttach = 'support.no_orders_to_attach';
  static const String requestSubmitted = 'support.request_submitted';
  static const String myRequests = 'support.my_requests';
  static const String noRequestsYet = 'support.no_requests_yet';
  static const String stateSubmitted = 'support.state_submitted';
  static const String stateAcknowledged = 'support.state_acknowledged';
}

/// The driver-side delivery screens.
abstract final class DriverKeys {
  static const String myDelivery = 'driver.my_delivery';
  static const String delivery = 'driver.delivery';

  static const String noActiveDelivery = 'driver.no_active_delivery';
  static const String noActiveDeliveryRetry = 'driver.no_active_delivery_retry';
  static const String loadFailed = 'driver.load_failed';
  static const String loadFailedRetry = 'driver.load_failed_retry';

  /// Takes a `status` named argument.
  static const String status = 'driver.status';

  static const String locationSharingOff = 'driver.location_sharing_off';

  /// Shown by the OS while the foreground location service is running.
  /// Resolved once, when the service starts — an OS notification already up
  /// does not follow a later language switch.
  static const String deliveryInProgress = 'driver.delivery_in_progress';
  static const String sharingLocation = 'driver.sharing_location';

  // spec 011 FR-004a: the device-level alert shown when the platform
  // notices this truck has stopped moving mid-delivery.
  static const String stopDetectedTitle = 'driver.stop_detected_title';
  static const String stopDetectedBody = 'driver.stop_detected_body';

  // spec 011 US2. Reason labels are addressed by `StopReason.labelKey`
  // rather than named individually here: the enum is the list, and a second
  // hand-maintained list of the same seven values is a place for them to
  // disagree.
  static const String stopPromptTitle = 'driver.stop_prompt_title';
  static const String stopPromptSubtitle = 'driver.stop_prompt_subtitle';
  static const String stopReasonOtherHint = 'driver.stop_reason_other_hint';
  static const String stopReasonOtherRequired = 'driver.stop_reason_other_required';
  static const String stopReasonSubmit = 'driver.stop_reason_submit';
  static const String stopReasonSent = 'driver.stop_reason_sent';
  static const String stopReasonFailed = 'driver.stop_reason_failed';
  static const String declareStop = 'driver.declare_stop';
  static const String declareStopTitle = 'driver.declare_stop_title';
  static const String declareStopSubtitle = 'driver.declare_stop_subtitle';
  static const String declareStopDuration = 'driver.declare_stop_duration';
  static const String declareStopMinutes = 'driver.declare_stop_minutes';
  static const String declareStopSubmit = 'driver.declare_stop_submit';
  static const String declareStopSent = 'driver.declare_stop_sent';
  static const String declareStopFailed = 'driver.declare_stop_failed';

  // feature 013 US1: an unanswered stop question shown ON the delivery, so
  // it is reachable on a device that never received the alert (FR-005/FR-006).
  static const String outstandingStopTitle = 'driver.outstanding_stop_title';
  static const String outstandingStopBody = 'driver.outstanding_stop_body';
  static const String outstandingStopAnswer = 'driver.outstanding_stop_answer';

  // feature 013 US1 (FR-011): the delivery is active but the platform is
  // receiving no position — location permission is off. On `main` the screen
  // looked completely normal in this state.
  static const String untrackedTitle = 'driver.untracked_title';
  static const String untrackedBody = 'driver.untracked_body';

  // feature 013 US5a: the driver reports they cannot reach the destination.
  static const String blockedReportTitle = 'driver.blocked_report_title';
  static const String blockedReportSubmit = 'driver.blocked_report_submit';
  static const String blockedReportSent = 'driver.blocked_report_sent';
  static const String blockedReportFailed = 'driver.blocked_report_failed';
  static const String blockedReportAlreadyOpen =
      'driver.blocked_report_already_open';

  static const String openDelivery = 'driver.open_delivery';
  static const String deliveryComplete = 'driver.delivery_complete';

  static const String arrived = 'driver.arrived';
  static const String requestDeliveryCode = 'driver.request_delivery_code';
  static const String arrivalCode = 'driver.arrival_code';
  static const String deliveryCode = 'driver.delivery_code';
  static const String verify = 'driver.verify';

  /// Takes a `minutes` named argument.
  static const String throttledIn = 'driver.throttled_in';
  static const String throttled = 'driver.throttled';
  static const String codeRejected = 'driver.code_rejected';
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

  /// `{count}` — a pre-formatted number.
  static const String totalCount = 'orders.total_count';
  static const String retry = 'orders.retry';
  static const String locationUnavailable = 'orders.location_unavailable';

  static const String filterAll = 'orders.filters.all';
  static const String filterUnderReview = 'orders.filters.under_review';
  static const String filterConfirmed = 'orders.filters.confirmed';
  static const String filterAwaitingPayment = 'orders.filters.awaiting_payment';
  static const String filterInDelivery = 'orders.filters.in_delivery';
  static const String filterDelivered = 'orders.filters.delivered';
  static const String filterFailed = 'orders.filters.failed';
}

/// One label per backend `OrderStatus` — the client renders the server's
/// status verbatim and never derives it (research R7).
abstract final class OrderStatusKeys {
  static const String pendingApproval = 'order_status.pending_approval';
  static const String approved = 'order_status.approved';
  static const String awaitingRouting = 'order_status.awaiting_routing';
  static const String routedToTransport = 'order_status.routed_to_transport';
  static const String assignedToDriver = 'order_status.assigned_to_driver';
  static const String pendingPayment = 'order_status.pending_payment';
  static const String loading = 'order_status.loading';
  static const String inTransit = 'order_status.in_transit';
  static const String unloading = 'order_status.unloading';
  static const String delivered = 'order_status.delivered';
  static const String rejected = 'order_status.rejected';
  static const String cancelled = 'order_status.cancelled';
}

/// One label per backend `FuelType`.
abstract final class FuelTypeKeys {
  static const String diesel = 'fuel_type.diesel';
  static const String gasoline91 = 'fuel_type.gasoline_91';
  static const String gasoline95 = 'fuel_type.gasoline_95';
  static const String kerosene = 'fuel_type.kerosene';
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
  static const String paymentDirectTitle = 'order_create.payment_direct_title';
  static const String paymentDirectSubtitle =
      'order_create.payment_direct_subtitle';
  static const String paymentDeferredTitle =
      'order_create.payment_deferred_title';
  static const String paymentDeferredSubtitle =
      'order_create.payment_deferred_subtitle';
  static const String paymentCreditTitle = 'order_create.payment_credit_title';
  static const String paymentCreditSubtitle =
      'order_create.payment_credit_subtitle';

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
  static const String orderFailed = 'order_create.order_failed';

  /// Shown in place of the station name while `GET /stations` is still
  /// loading (spec 005 T058) — never a fabricated placeholder address.
  static const String loadingStation = 'order_create.loading_station';
  static const String selectStation = 'order_create.select_station';

  /// QUOTE_STALE (spec 005 T062): the platform's price changed between the
  /// quote and the order attempt — `{total}` is the new, current total.
  static const String priceChangedTitle = 'order_create.price_changed_title';
  static const String priceChangedMessage =
      'order_create.price_changed_message';
  static const String confirmNewPrice = 'order_create.confirm_new_price';

  /// FR-028: a pre-submission courtesy warning only — `{shortfall}` is how
  /// much the quote exceeds the client's available credit by. The server's
  /// own check inside the order transaction remains authoritative.
  static const String creditOverLimitWarning =
      'order_create.credit_over_limit_warning';
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
  static const String headlineCredit = 'order_detail.headline_credit';
  static const String headlineDelivered = 'order_detail.headline_delivered';
  static const String orderAnother = 'order_detail.order_another';
  static const String retryPayment = 'order_detail.retry_payment';

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
  static const String validUntil = 'order_detail.valid_until';

  /// Takes an `amount` named argument.
  static const String creditOf = 'order_detail.credit_of';

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
  static const String payFromCreditLimit = 'order_detail.pay_from_credit_limit';

  static const String support = 'order_detail.support';
  static const String changeMockState = 'order_detail.change_mock_state';
}

abstract final class TrackOrderKeys {
  static const String title = 'track_order.title';

  /// Takes an `id` named argument.
  static const String orderReference = 'track_order.order_reference';

  static const String onTheWay = 'track_order.on_the_way';
  static const String mapUnavailable = 'track_order.map_unavailable';
  static const String callUnavailable = 'track_order.call_unavailable';
  static const String remainingDistance = 'track_order.remaining_distance';
  static const String expectedArrival = 'track_order.expected_arrival';

  static const String vehicle = 'track_order.vehicle';
  static const String fuelTankerTruck = 'track_order.fuel_tanker_truck';

  /// Spelled slightly differently in Arabic (لإستكمال) from the order-detail
  /// screen's [OrderDetailKeys.handoverMethodNote] (لاستكمال), as in the
  /// original design — kept as two keys rather than unified.
  static const String handoverNote = 'track_order.handover_note';

  static const String orderStages = 'track_order.order_stages';

  static const String received = 'track_order.received';

  /// FR-020: shown alongside the last known position once it has aged past
  /// the staleness window — the position itself is still shown, never
  /// hidden, this only qualifies it as possibly out of date.
  static const String staleWarning = 'track_order.stale_warning';

  /// FR-021: no driver assigned yet, or none has reported a position —
  /// explanatory, not an error and not an empty map.
  static const String notTrackableTitle = 'track_order.not_trackable_title';
  static const String notTrackableBody = 'track_order.not_trackable_body';
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

  /// spec 005 — PHONE_IN_USE (contracts/mobile-integration.md: needs its own
  /// Arabic/English message, not the generic validation fallback).
  static const String phoneInUse = 'errors.phone_in_use';

  /// spec 005 — SMS_SEND_FAILED.
  static const String smsSendFailed = 'errors.sms_send_failed';

  /// spec 005 — the confirm endpoint's one, non-enumerating 401 (FR-035):
  /// wrong or expired code, never says which.
  static const String wrongVerificationCode = 'errors.wrong_verification_code';

  /// spec 006 FR-024 — one message for wrong/expired/superseded/attempt-
  /// locked-out alike; distinguishing them would tell an attacker which
  /// wall they hit.
  static const String resetCodeInvalid = 'errors.reset_code_invalid';

  /// spec 006 FR-025. Takes a `minutes` named argument.
  static const String resetRateLimited = 'errors.reset_rate_limited';
}

/// Password recovery (spec 006 US3) — `ForgotPasswordScreen` (phone entry
/// + code entry + resend) and `ResetPasswordScreen` (new password).
abstract final class PasswordResetKeys {
  static const String forgotTitle = 'password_reset.forgot_title';
  static const String phoneIntro = 'password_reset.phone_intro';
  static const String sendCode = 'password_reset.send_code';

  /// Takes a `phone` named argument.
  static const String codeSentTo = 'password_reset.code_sent_to';
  static const String codeLabel = 'password_reset.code_label';
  static const String verify = 'password_reset.verify';
  static const String resend = 'password_reset.resend';
  static const String changeNumber = 'password_reset.change_number';

  static const String newPasswordTitle = 'password_reset.new_password_title';
  static const String newPasswordLabel = 'password_reset.new_password_label';

  /// Stated before submission, not only on rejection (FR-026).
  static const String newPasswordRules = 'password_reset.new_password_rules';
  static const String submit = 'password_reset.submit';
  static const String completedMessage = 'password_reset.completed_message';
}

/// Session-ended messaging (spec 006 US5, FR-036) — one message per
/// `SessionRevocationCause`, plus a generic fallback for an absent/
/// unrecognised cause. The app maps the enum to these and MUST NOT match
/// on the server's `message` text (Principle I/III).
abstract final class SessionKeys {
  static const String signedInElsewhere = 'session.signed_in_elsewhere';
  static const String passwordReset = 'session.password_reset';
  static const String accountDeactivated = 'session.account_deactivated';
  static const String ended = 'session.ended';
}

/// The filter sheet the list screens share. Which sections it shows differs
/// per screen, so the sort options are named individually rather than as one
/// fixed set.
abstract final class FilterKeys {
  static const String title = 'filter.title';
  static const String sortBy = 'filter.sort_by';

  static const String newestFirst = 'filter.newest_first';
  static const String oldestFirst = 'filter.oldest_first';
  static const String highestQuantity = 'filter.highest_quantity';
  static const String lowestQuantity = 'filter.lowest_quantity';
  static const String highestAmount = 'filter.highest_amount';
  static const String lowestAmount = 'filter.lowest_amount';

  static const String station = 'filter.station';
  static const String fuelType = 'filter.fuel_type';
  static const String date = 'filter.date';

  static const String reset = 'filter.reset';

  /// Takes a `count` named argument — how many filters are set.
  static const String apply = 'filter.apply';
}

/// The driver-side navigation screen.
abstract final class DriverNavigationKeys {
  static const String title = 'driver_navigation.title';
  static const String subtitle = 'driver_navigation.subtitle';
  static const String orderId = 'driver_navigation.order_id';
  static const String remainingDistance = 'driver_navigation.remaining_distance';
  static const String expectedTime = 'driver_navigation.expected_time';
  static const String fuelType = 'driver_navigation.fuel_type';
  static const String viewOnMap = 'driver_navigation.view_on_map';
  static const String contactCustomer = 'driver_navigation.contact_customer';
  static const String requestedTime = 'driver_navigation.requested_time';
  static const String quantity = 'driver_navigation.quantity';
  static const String scanDeliveryCode = 'driver_navigation.scan_delivery_code';
  static const String deliveryHint = 'driver_navigation.delivery_hint';
  static const String startNavigation = 'driver_navigation.start_navigation';
  static const String cannotReach = 'driver_navigation.cannot_reach';
  static const String enterCode = 'driver_navigation.enter_code';
  static const String scanQr = 'driver_navigation.scan_qr';
  static const String pointCamera = 'driver_navigation.point_camera';
  static const String confirmDelivery = 'driver_navigation.confirm_delivery';
  static const String codeNotRecognised = 'driver_navigation.code_not_recognised';
  static const String codeTooManyAttempts = 'driver_navigation.code_too_many_attempts';
  static const String codeConfirmFailed = 'driver_navigation.code_confirm_failed';
  static const String enterDeliveryCode = 'driver_navigation.enter_delivery_code';
  // spec 007 T030: was "enter4DigitCode" — the backend's handover code is
  // 6 digits (`OtpPrimitivesService.generateCode`); the 4-digit copy and
  // input cap meant a typed code could never actually be submitted.
  static const String enter6DigitCode = 'driver_navigation.enter_6_digit_code';
  // spec 007 US2 — the two steps that issue the customer's code, shown at
  // the delivery detail's real IN_TRANSIT/UNLOADING stages respectively.
  static const String markArrived = 'driver_navigation.mark_arrived';
  static const String requestDeliveryCode = 'driver_navigation.request_delivery_code';
  static const String codeSentToCustomer = 'driver_navigation.code_sent_to_customer';
}

/// spec 008 US3 — the vehicle-verification screen (departure and loading
/// stages both reuse this one screen and its copy).
abstract final class DriverVerificationKeys {
  static const String departureTitle = 'driver_verification.departure_title';
  static const String loadingTitle = 'driver_verification.loading_title';
  static const String tapCard = 'driver_verification.tap_card';
  static const String tapCardHint = 'driver_verification.tap_card_hint';
  static const String scanCodeInstead = 'driver_verification.scan_code_instead';
  static const String useCardInstead = 'driver_verification.use_card_instead';
  static const String pointCamera = 'driver_verification.point_camera';
  static const String verifying = 'driver_verification.verifying';
  static const String mismatch = 'driver_verification.mismatch';
  static const String tryAgain = 'driver_verification.try_again';
  static const String unreachable = 'driver_verification.unreachable';
  static const String failed = 'driver_verification.failed';
  static const String tooManyAttempts = 'driver_verification.too_many_attempts';
  // FR-030a: the right truck, the wrong place — interpolates `distance`.
  static const String notAtWarehouse = 'driver_verification.not_at_warehouse';
  static const String notAtWarehouseUnknownDistance =
      'driver_verification.not_at_warehouse_unknown_distance';
  // FR-030c: the phone, not the depot, is what needs fixing here.
  static const String locationUnavailable = 'driver_verification.location_unavailable';
  // research R5: NFC unsupported is a normal state on iOS, never an error.
  static const String nfcUnavailable = 'driver_verification.nfc_unavailable';
  static const String verifyVehicle = 'driver_verification.verify_vehicle';
}

/// spec 008 US4 — the driver's warehouse-loading leg: tank identity, the
/// depot destination, and the quantity-free confirmation action.
abstract final class DriverLoadingKeys {
  static const String destination = 'driver_loading.destination';
  static const String tankDetails = 'driver_loading.tank_details';
  static const String tankCode = 'driver_loading.tank_code';
  static const String tankMaterial = 'driver_loading.tank_material';
  static const String confirmLoading = 'driver_loading.confirm_loading';
  static const String confirmLoadingFailed = 'driver_loading.confirm_loading_failed';
  static const String materialIron = 'driver_loading.material_iron';
  static const String materialAluminium = 'driver_loading.material_aluminium';
  // FR-027: the depot as a destination, not just an address to read.
  static const String navigateToWarehouse = 'driver_loading.navigate_to_warehouse';
  static const String navigateFailed = 'driver_loading.navigate_failed';
}

/// spec 007 US6 (FR-037–FR-040): the client's own rating control on the
/// delivered order card. `driver_summary.not_yet_rated` (T075's header
/// state) is reused as-is for the driver-side "not yet rated" display
/// (T094) rather than a duplicate string here.
abstract final class RatingKeys {
  static const String prompt = 'rating.prompt';
  static const String reviewHint = 'rating.review_hint';
  static const String submit = 'rating.submit';
  static const String submitted = 'rating.submitted';
  static const String alreadyRated = 'rating.already_rated';
  static const String notDelivered = 'rating.not_delivered';
  static const String submitFailed = 'rating.submit_failed';
}
