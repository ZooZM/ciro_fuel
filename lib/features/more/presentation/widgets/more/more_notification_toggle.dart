import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';

/// The notification switch on the الإشعارات row.
///
/// Two pieces of artwork rather than a Material [Switch], cross-faded so the
/// change reads as a movement instead of a swap. Keyed on [value] — without
/// the key the [AnimatedSwitcher] sees one unchanged [SvgPicture] and never
/// runs the transition.
class MoreNotificationToggle extends StatelessWidget {
  const MoreNotificationToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedSwitcher(
        duration: AppSizes.moreToggleDuration,
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: SvgPicture.asset(
          value ? AppAssets.moreToggleOnIcon : AppAssets.moreToggleOffIcon,
          key: ValueKey<bool>(value),
          width: AppSizes.moreToggleWidth,
        ),
      ),
    );
  }
}
