/// Named route paths per contracts/ui-state-contract.md — the only place
/// route path literals appear (Principle I).
abstract final class AppRoutes {
  static const String login = '/login';
  static const String support = '/support';
  static const String forgotPassword = '/forgot-password';
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

  static const String driverHome = '/driver';
  static const String driverOrderDetailPattern = '/driver/orders/:id';
  static String driverOrderDetail(String orderId) => '/driver/orders/$orderId';

  static const String notifications = '/notifications';
}
