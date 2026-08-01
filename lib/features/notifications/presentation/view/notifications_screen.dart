import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/enums/notification_type.dart';
import '../../../../shared/enums/user_role.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../../domain/entities/app_notification.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

/// Reads the app-wide singleton [NotificationsCubit] provided at the root
/// (see [NotificationBannerPresenter]) — this screen does not own its own
/// instance, so read state persists across navigation.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) => switch (state) {
          NotificationsLoading() => const Center(child: CircularProgressIndicator()),
          NotificationsFailureState() => Center(
            child: TextButton(
              onPressed: () => context.read<NotificationsCubit>().load(),
              child: const Text('Could not load notifications. Tap to retry.'),
            ),
          ),
          NotificationsLoaded(:final notifications) when notifications.isEmpty =>
            const Center(child: Text('No notifications yet')),
          NotificationsLoaded(:final notifications) => RefreshIndicator(
            onRefresh: () => context.read<NotificationsCubit>().load(),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) =>
                  _NotificationTile(notification: notifications[index]),
            ),
          ),
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  String get _label => switch (notification.type) {
    NotificationType.finalPriceReady => 'Final price ready',
    NotificationType.paymentTimeout => 'Payment window expired',
    NotificationType.noEligibleDriver => 'No driver available',
    NotificationType.deliveryCompleted => 'Delivery completed',
    NotificationType.unknown => 'Notification',
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        notification.isRead ? Icons.notifications_none : Icons.notifications_active,
      ),
      title: Text(_label),
      subtitle: Text(notification.createdAt.toLocal().toString()),
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationsCubit>().markRead(notification.id);
        }
        final orderId = notification.orderId;
        if (orderId == null) return;
        final role = switch (context.read<SessionCubit>().state) {
          SessionAuthenticated(:final user) => user.role,
          _ => null,
        };
        if (role == null) return;
        context.push(
          role == UserRole.driver
              ? AppRoutes.driverOrderDetail(orderId)
              : AppRoutes.clientOrderDetail(orderId),
        );
      },
    );
  }
}
