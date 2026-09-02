/// Named route paths per contracts/ui-state-contract.md — the only place
/// route path literals appear (Principle I).
abstract final class AppRoutes {
  static const String login = '/login';
  static const String support = '/support';
  static const String forgotPassword = '/forgot-password';
  // spec 006 US3 — reachable while unauthenticated, like login/support.
  // `extra` carries the opaque resetToken a code was just verified for.
  static const String resetPassword = '/reset-password';
  static const String clientPayments = '/client/payments';
  static const String clientOrders = '/client/orders';
  static const String clientHome = '/client';
  static const String clientInvoices = '/client/invoices';
  static const String clientMore = '/client/more';
  static const String clientStations = '/client/stations';
  static const String clientCreditLimit = '/client/credit-limit';
  static const String clientTerms = '/client/terms';
  static const String clientProfile = '/client/profile';
  static const String clientChangePhone = '/client/profile/change-phone';
  static const String clientVerifyPhone = '/client/profile/verify-phone';

  static const String clientCreateOrder = '/client/orders/new';
  static const String clientOrderDetailPattern = '/client/orders/:id';
  static String clientOrderDetail(String orderId) => '/client/orders/$orderId';

  static const String clientInvoiceDetailPattern = '/client/invoices/:id';
  static String clientInvoiceDetail(String invoiceId) =>
      '/client/invoices/$invoiceId';

  static const String driverHome = '/driver';
  static const String driverOrders = '/driver/orders';
  static const String driverNotifications = '/driver/notifications';
  static const String driverProfile = '/driver/profile';
  static const String driverProfileDetails = '/driver/profile/details';
  static const String driverChangePhone = '/driver/profile/change-phone';
  static const String driverVerifyPhone = '/driver/profile/verify-phone';
  static const String driverMore = '/driver/more';
  static const String driverOrderDetailPattern = '/driver/orders/:id';
  static String driverOrderDetail(String orderId) => '/driver/orders/$orderId';

  static const String notifications = '/notifications';
}
