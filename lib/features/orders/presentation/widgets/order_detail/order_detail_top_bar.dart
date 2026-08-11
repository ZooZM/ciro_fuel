import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/widgets/app_logo.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/icon_card.dart';
import '../../../../../core/theme/theme_context.dart';

/// Notification bell, brand logo and back button across the top of the
/// order-detail screen.
class OrderDetailTopBar extends StatelessWidget {
  const OrderDetailTopBar({
    required this.notificationCount,
    required this.onBack,
    super.key,
  });

  final int notificationCount;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconCard(
          onTap: onBack,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 2.0),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: AppSizes.orderBackIconSize,
              color: context.colors.textPrimary,
            ),
          ),
        ),
        const AppLogo(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconCard(
              // The bell opens the notifications screen here too; it carried
              // no handler at all and so did nothing on this screen.
              onTap: () => context.push(AppRoutes.notifications),
              child: Icon(Icons.notifications_none, color: context.colors.textPrimary),
            ),
            Positioned(
              right: AppSizes.orderTopBarBadgeOffsetX,
              top: AppSizes.orderTopBarBadgeOffsetY,
              child: Container(
                width: AppSizes.orderTopBarBadgeSize,
                height: AppSizes.orderTopBarBadgeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.colors.brandRed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$notificationCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.orderTopBarBadgeFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
