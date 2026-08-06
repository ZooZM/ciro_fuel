import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import 'notification_bell.dart';

/// Profile photo, brand logo and notification bell across the top of the
/// dashboard.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    required this.notificationCount,
    required this.onNotificationTap,
    super.key,
  });

  final int notificationCount;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile Image (RIGHT in RTL). The PNG already draws its own white
        // ring on transparent corners, so it is rendered plain — a circle
        // clip and Border here produced a second ring and shrank the photo.
        Image.asset(
          AppAssets.dashboardProfileImage,
          width: AppSizes.dashboardProfileImageSize,
          height: AppSizes.dashboardProfileImageSize,
        ),

        // Center Logo
        SvgPicture.asset(
          AppAssets.appBarLogo,
          height: AppSizes.appBarLogoHeight,
        ),

        // Notification Icon with Badge (LEFT in RTL)
        NotificationBell(
          count: notificationCount,
          onTap: onNotificationTap,
        ),
      ],
    );
  }
}
