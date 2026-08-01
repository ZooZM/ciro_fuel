import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/session_cubit.dart';
import '../../features/auth/presentation/cubit/session_state.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/delivery/presentation/view/delivery_detail_screen.dart';
import '../../features/delivery/presentation/view/driver_home_screen.dart';
import '../../features/notifications/presentation/view/notifications_screen.dart';
import '../../features/orders/presentation/view/create_order_screen.dart';
import '../../features/orders/presentation/view/order_detail_screen.dart';
import '../../features/orders/presentation/view/orders_list_screen.dart';
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
        GoRoute(
          path: AppRoutes.clientHome,
          builder: (context, state) => const OrdersListScreen(),
        ),
        GoRoute(
          path: AppRoutes.clientCreateOrder,
          builder: (context, state) => const CreateOrderScreen(),
        ),
        GoRoute(
          path: AppRoutes.clientOrderDetailPattern,
          builder: (context, state) =>
              OrderDetailScreen(orderId: state.pathParameters['id']!),
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
      ],
    );
  }

  final SessionCubit _sessionCubit;
  late final GoRouter config;

  String? _redirect(BuildContext context, GoRouterState state) {
    final session = _sessionCubit.state;
    final atLogin = state.matchedLocation == AppRoutes.login;

    return switch (session) {
      // Splash/launch: stay on the current route while session restore runs.
      SessionUnknown() => null,
      SessionUnauthenticated() => atLogin ? null : AppRoutes.login,
      SessionAuthenticated(:final user) =>
        _redirectAuthenticated(user.role, state.matchedLocation, atLogin),
    };
  }

  String? _redirectAuthenticated(
    UserRole role,
    String location,
    bool atLogin,
  ) {
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
