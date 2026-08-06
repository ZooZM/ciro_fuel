import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/icon_card.dart';

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
        Stack(
          clipBehavior: Clip.none,
          children: [
            const IconCard(
              child: Icon(Icons.notifications_none, color: AppColors.navy),
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
                    fontSize: 10,
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
