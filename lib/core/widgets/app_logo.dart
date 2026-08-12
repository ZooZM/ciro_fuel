import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../theme/app_spacing.dart';

/// The CIRO FUEL wordmark, in the cut that suits the active theme.
///
/// The artwork draws CIRO in black with a green (#12A150) accent on the R, and
/// FUEL in blue (#1E5FFF). A [ColorFilter] is no use here — it would flatten
/// all three into one colour — so the dark cut is a separate file that redraws
/// only the CIRO letterforms in white. Everything that shows the wordmark goes
/// through this widget so no screen has to remember which file to reach for.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = AppSizes.appBarLogoHeight});

  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      isDark ? AppAssets.appBarLogoDark : AppAssets.appBarLogo,
      height: height,
    );
  }
}

/// The stacked logo used on the sign-in and support screens, in the cut that
/// suits the active theme. Same two-file arrangement as [AppLogo].
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      isDark ? AppAssets.logoDark : AppAssets.logo,
      height: height,
      width: width,
    );
  }
}
