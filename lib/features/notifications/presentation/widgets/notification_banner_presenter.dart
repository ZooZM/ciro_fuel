import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/enums/notification_type.dart';
import '../../../../shared/enums/user_role.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

/// Surfaces newly-pushed notifications as a transient in-app banner
/// regardless of which screen is currently open (FR-022). Mounted once at
/// the app root over a singleton [NotificationsCubit], so it observes
/// every push for the lifetime of the session.
class NotificationBannerPresenter extends StatefulWidget {
  const NotificationBannerPresenter({super.key, required this.child});

  final Widget child;

  @override
  State<NotificationBannerPresenter> createState() =>
      _NotificationBannerPresenterState();
}

class _NotificationBannerPresenterState
    extends State<NotificationBannerPresenter> {
  String? _lastSeenId;

  String _messageFor(NotificationType type) => switch (type) {
    NotificationType.finalPriceReady => NotificationKeys.bannerFinalPriceReady,
    NotificationType.paymentTimeout => NotificationKeys.bannerPaymentTimeout,
    NotificationType.noEligibleDriver =>
      NotificationKeys.bannerNoEligibleDriver,
    NotificationType.deliveryCompleted =>
      NotificationKeys.bannerDeliveryCompleted,
    NotificationType.unknown => NotificationKeys.bannerUnknown,
  }.tr();

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is! NotificationsLoaded || state.notifications.isEmpty) {
          return;
        }

        final head = state.notifications.first;
        final isFirstObservedList = _lastSeenId == null;
        final isNew = head.id != _lastSeenId;
        _lastSeenId = head.id;

        // The first list this presenter ever sees is the REST backfill —
        // never banner the entire history, only genuinely new arrivals.
        if (isFirstObservedList || !isNew) return;

        final orderId = head.orderId;
        final role = switch (context.read<SessionCubit>().state) {
          SessionAuthenticated(:final user) => user.role,
          _ => null,
        };

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_messageFor(head.type)),
            action: (orderId != null && role != null)
                ? SnackBarAction(
                    label: NotificationKeys.bannerView.tr(),
                    onPressed: () => context.push(
                      role == UserRole.driver
                          ? AppRoutes.driverOrderDetail(orderId)
                          : AppRoutes.clientOrderDetail(orderId),
                    ),
                  )
                : null,
          ),
        );
      },
      child: widget.child,
    );
  }
}
