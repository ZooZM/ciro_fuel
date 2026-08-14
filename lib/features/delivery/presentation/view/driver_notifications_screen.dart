import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/order_card.dart';

class DriverNotificationsScreen extends StatelessWidget {
  const DriverNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: 48.0,
            bottom: 120, // space for nav bar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header & Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('driver_notifications.mark_all_read'.tr(), style: TextStyle(color: context.colors.brandBlue, fontWeight: FontWeight.w700)),
                  ),
                  Row(
                    children: [
                      _buildTabItem(context, 'driver_notifications.tab_all'.tr(), true),
                      const SizedBox(width: 8),
                      _buildTabItem(context, 'driver_notifications.tab_orders'.tr(), false),
                      const SizedBox(width: 8),
                      _buildTabItem(context, 'driver_notifications.tab_system'.tr(), false),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Today
              _buildDateHeader(context, 'driver_notifications.today'.tr()),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationItem(
                context: context,
                title: 'driver_notifications.order_assigned_title'.tr(),
                orderId: 'ORD-2024-256',
                time: 'driver_notifications.five_mins_ago'.tr(),
                description: 'driver_notifications.order_assigned_desc'.tr(),
                iconWidget: _buildOrderIcon(context),
                isUnread: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationItem(
                context: context,
                title: 'driver_notifications.order_assigned_title'.tr(),
                orderId: 'ORD-2024-256',
                time: 'driver_notifications.five_mins_ago'.tr(),
                description: 'driver_notifications.order_assigned_desc'.tr(),
                iconWidget: _buildOrderIcon(context),
                isUnread: true,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Yesterday
              _buildDateHeader(context, 'driver_notifications.yesterday'.tr()),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationItem(
                context: context,
                title: 'driver_notifications.system_update_title'.tr(),
                orderId: null,
                time: 'driver_notifications.five_mins_ago'.tr(),
                description: 'driver_notifications.system_update_desc'.tr(),
                iconWidget: _buildSystemIcon(),
                isUnread: false,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationItem(
                context: context,
                title: 'driver_notifications.order_assigned_title'.tr(),
                orderId: 'ORD-2024-256',
                time: 'driver_notifications.five_mins_ago'.tr(),
                description: 'driver_notifications.order_assigned_desc'.tr(),
                iconWidget: _buildOrderIcon(context),
                isUnread: true,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Older
              _buildDateHeader(context, 'driver_notifications.old_date'.tr()),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationItem(
                context: context,
                title: 'driver_notifications.order_assigned_title'.tr(),
                orderId: 'ORD-2024-256',
                time: 'driver_notifications.yesterday_time'.tr(),
                description: 'driver_notifications.order_assigned_desc'.tr(),
                iconWidget: _buildOrderIcon(context),
                isUnread: false,
                isWhiteBox: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationItem(
                context: context,
                title: 'driver_notifications.order_assigned_title'.tr(),
                orderId: 'ORD-2024-256',
                time: 'driver_notifications.yesterday_time'.tr(),
                description: 'driver_notifications.order_assigned_desc'.tr(),
                iconWidget: _buildOrderIcon(context),
                isUnread: false,
                isWhiteBox: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationItem(
                context: context,
                title: 'driver_notifications.system_update_title'.tr(),
                orderId: null,
                time: 'driver_notifications.yesterday_time'.tr(),
                description: 'driver_notifications.system_update_desc'.tr(),
                iconWidget: _buildSystemIcon(),
                isUnread: false,
                isWhiteBox: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderIcon(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: context.colors.brandBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SvgPicture.asset(
          'assets/Icons/truck.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }

  Widget _buildSystemIcon() {
    return SvgPicture.asset(
      'assets/Notification Page/setting.svg',
      width: 28,
      height: 28,
    );
  }

  Widget _buildTabItem(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? context.colors.brandBlue : context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? context.colors.brandBlue : context.colors.borderHairline),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : context.colors.textPrimary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: context.colors.textSecondary,
      ),
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required String title,
    required String? orderId,
    required String time,
    required String description,
    required Widget iconWidget,
    required bool isUnread,
    bool isWhiteBox = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isUnread ? context.colors.blueTint : (isWhiteBox ? context.colors.surface : Colors.transparent),
        borderRadius: BorderRadius.circular(16),
        border: isWhiteBox ? Border.all(color: context.colors.borderHairline) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconWidget,
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                        if (orderId != null) Text(orderId, style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(time, style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: context.colors.brandBlue, shape: BoxShape.circle)),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: context.colors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
