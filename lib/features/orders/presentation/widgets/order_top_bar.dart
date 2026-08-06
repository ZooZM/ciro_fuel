import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/icon_card.dart';

/// Notification bell, brand logo and back button across the top of the
/// create-order and track-order screens.
class OrderTopBar extends StatelessWidget {
  const OrderTopBar({
    required this.notificationCount,
    required this.onNotificationTap,
    required this.onBack,
    super.key,
  });

  final int notificationCount;
  final VoidCallback onNotificationTap;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // First child is right-most in RTL, so the bell leads and the back
        // button lands on the left, as designed.
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconCard(
              onTap: onNotificationTap,
              child: SvgPicture.asset(
                AppAssets.notificationIcon,
                width: AppSizes.orderTopBarIconSize,
                height: AppSizes.orderTopBarIconSize,
                colorFilter: const ColorFilter.mode(
                  AppColors.navy,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              right: AppSizes.orderTopBarBadgeOffsetX,
              top: AppSizes.orderTopBarBadgeOffsetY,
              child: Container(
                width: AppSizes.orderTopBarBadgeSize,
                height: AppSizes.orderTopBarBadgeSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.red,
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
        SvgPicture.asset(AppAssets.appBarLogo, height: AppSizes.appBarLogoHeight),
        IconCard(
          onTap: onBack,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Icon(
              Icons.arrow_back_ios,
              size: AppSizes.orderBackIconSize,
              color: AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}
