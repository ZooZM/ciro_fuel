import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/session_cubit.dart';
import '../../features/auth/presentation/cubit/session_state.dart';
import '../../features/auth/presentation/view/forgot_password_screen.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/delivery/presentation/view/delivery_detail_screen.dart';
import '../../features/delivery/presentation/view/driver_home_screen.dart';
import '../../features/home/presentation/view/client_home_screen.dart';
import '../../features/notifications/presentation/view/notifications_screen.dart';
import '../../features/orders/presentation/view/create_order_screen.dart';
import '../../features/orders/presentation/view/order_detail_screen.dart';
import '../../features/orders/presentation/view/orders_list_screen.dart';
import '../../features/support/presentation/support_screen.dart';
import '../../features/home/presentation/view/client_main_scaffold.dart';
import '../../features/invoices/presentation/view/client_invoices_screen.dart';
import '../../features/more/presentation/view/client_more_screen.dart';
import '../../features/payments/presentation/view/client_payments_screen.dart';
import '../../features/more/presentation/view/client_credit_limit_screen.dart';
import '../../features/more/presentation/view/client_terms_screen.dart';
import '../../features/profile/presentation/view/change_phone_screen.dart';
import '../../features/profile/presentation/view/profile_screen.dart';
import '../../features/profile/presentation/view/verify_phone_screen.dart';
import '../../features/stations/presentation/view/client_stations_screen.dart';
import '../../shared/enums/user_role.dart';
import 'app_routes.dart';

/// Bridges a [Stream] (here, [Cubit.stream]) to go_router's
/// `refreshListenable`, since go_router itself only exposes a
/// `Listenable`-based API for redirect re-evaluation.
class _StreamRefreshListenable extends ChangeNotifier {
  _StreamRefreshListenable(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Role-gated routing (contracts/ui-state-contract.md route table). Redirect
/// decisions read only [SessionCubit] — role/company scoping for data is
/// still enforced server-side regardless (Principle II); this is UX only.
class AppRouter {
  AppRouter({required SessionCubit sessionCubit})
    : _sessionCubit = sessionCubit {
    config = GoRouter(
      initialLocation: AppRoutes.login,
      refreshListenable: _StreamRefreshListenable(_sessionCubit.stream),
      redirect: _redirect,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ClientMainScaffold(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.clientPayments,
                  builder: (context, state) => const ClientPaymentsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.clientOrders,
                  builder: (context, state) => const OrdersListScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.clientHome,
                  builder: (context, state) => const ClientHomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.clientInvoices,
                  builder: (context, state) => const ClientInvoicesScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.clientMore,
                  builder: (context, state) => const ClientMoreScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.clientStations,
          builder: (context, state) => const ClientStationsScreen(),
        ),
        GoRoute(
          path: AppRoutes.clientCreditLimit,
          builder: (context, state) => const ClientCreditLimitScreen(),
        ),
        GoRoute(
          path: AppRoutes.clientTerms,
          builder: (context, state) => const ClientTermsScreen(),
        ),
        GoRoute(
          path: AppRoutes.clientProfile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.clientChangePhone,
          builder: (context, state) => const ChangePhoneScreen(),
        ),
        GoRoute(
          path: AppRoutes.clientVerifyPhone,
          builder: (context, state) => const VerifyPhoneScreen(),
        ),
        GoRoute(
          path: AppRoutes.clientCreateOrder,
          // `extra` carries the fuel-grade badge ('95', 'D', …) when the order
          // form is opened from a طلب سريع tile, so it starts on that grade.
          builder: (context, state) =>
              CreateOrderScreen(initialGradeBadge: state.extra as String?),
        ),
        GoRoute(
          path: AppRoutes.clientOrderDetailPattern,
          builder: (context, state) {
            final mockState = state.extra is MockOrderState ? state.extra as MockOrderState : MockOrderState.pendingReview;
            return OrderDetailScreen(orderId: state.pathParameters['id']!, mockState: mockState);
          },
        ),
        GoRoute(
          path: AppRoutes.driverHome,
          builder: (context, state) => const DriverHomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.driverOrderDetailPattern,
          builder: (context, state) =>
              DeliveryDetailScreen(orderId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: AppRoutes.support,
          // `extra` is true when opened from inside the app, which swaps the
          // plain back arrow for the full header with the notification bell.
          builder: (context, state) =>
              SupportScreen(showTopBar: state.extra == true),
        ),
      ],
    );
  }

  final SessionCubit _sessionCubit;
  late final GoRouter config;

  String? _redirect(BuildContext context, GoRouterState state) {
    final session = _sessionCubit.state;
    final atLogin = state.matchedLocation == AppRoutes.login;
    // Help & support is reachable from the login screen, so it must stay
    // accessible before a session exists (contracts/ui-state-contract.md).
    final atSupport = state.matchedLocation == AppRoutes.support;

    return switch (session) {
      // Splash/launch: stay on the current route while session restore runs.
      SessionUnknown() => null,
      SessionUnauthenticated() => null, // Bypass redirect for testing
      SessionAuthenticated(:final user) => _redirectAuthenticated(
        user.role,
        state.matchedLocation,
        atLogin,
      ),
    };
  }

  String? _redirectAuthenticated(UserRole role, String location, bool atLogin) {
    if (atLogin) {
      return role == UserRole.driver
          ? AppRoutes.driverHome
          : AppRoutes.clientHome;
    }

    final onDriverRoute = location.startsWith(AppRoutes.driverHome);
    final onClientRoute = location.startsWith(AppRoutes.clientHome);

    if (role == UserRole.driver && onClientRoute) return AppRoutes.driverHome;
    if (role != UserRole.driver && onDriverRoute) return AppRoutes.clientHome;
    return null;
  }
}
