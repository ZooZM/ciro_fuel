import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// The stations screen's header: the client's photo on the right, the CIRO
/// FUEL logo centred, and the way back on the left.
///
/// Not the shared `AppTopBar` — this screen leads with the profile rather
/// than a notification bell, as the dashboard it mirrors does.
class StationsTopBar extends StatelessWidget {
  const StationsTopBar({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _ProfileAvatar(),
        SvgPicture.asset(
          AppAssets.appBarLogo,
          height: AppSizes.appBarLogoHeight,
        ),
        _BackButton(onTap: onBack),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        AppAssets.moreProfileImage,
        width: AppSizes.tapTarget,
        height: AppSizes.tapTarget,
        fit: BoxFit.cover,
        // The photo is a bundled placeholder today, but will come off the
        // network once profiles are real — so a missing image falls back to
        // a neutral avatar rather than a broken box.
        errorBuilder: (context, error, stackTrace) => Container(
          width: AppSizes.tapTarget,
          height: AppSizes.tapTarget,
          color: AppColors.chipBackground,
          child: const Icon(Icons.person, color: AppColors.grey),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.tapTarget,
        height: AppSizes.tapTarget,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          boxShadow: AppColors.shadowCard,
        ),
        // The chevron is a matchTextDirection icon, so on this RTL page it
        // would mirror and point right without this.
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              size: AppSizes.iconLg,
              color: AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}
