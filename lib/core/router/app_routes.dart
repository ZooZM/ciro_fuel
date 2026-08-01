/// Named route paths per contracts/ui-state-contract.md — the only place
/// route path literals appear (Principle I).
abstract final class AppRoutes {
  static const String login = '/login';

  static const String clientHome = '/client';
  static const String clientCreateOrder = '/client/orders/new';
  static const String clientOrderDetailPattern = '/client/orders/:id';
  static String clientOrderDetail(String orderId) =>
      '/client/orders/$orderId';

  static const String driverHome = '/driver';
  static const String driverOrderDetailPattern = '/driver/orders/:id';
  static String driverOrderDetail(String orderId) =>
      '/driver/orders/$orderId';

  static const String notifications = '/notifications';
}
