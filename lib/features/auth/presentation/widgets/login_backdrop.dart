import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

class LoginBackdrop extends StatelessWidget {
  const LoginBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final canvas = context.colors.canvas;
    final bandHeight =
        MediaQuery.sizeOf(context).height * AppSizes.heroBandFraction;

    return ExcludeSemantics(
      child: Stack(
        children: [
          Positioned(
            top: bandHeight * 0.15346,
            left: 0,
            right: 0,
            height: bandHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AppAssets.loginBackground,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, AppSizes.heroFocalY),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        canvas,
                        canvas.withValues(alpha: 0.5),
                        canvas.withValues(alpha: 0.3),
                        canvas,
                      ],
                      stops: const [
                        0,
                        AppSizes.heroScrimTopStop,
                        AppSizes.heroScrimBottomStop,
                        1,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: SvgPicture.asset(
                AppAssets.loginWave,
                width: AppSizes.waveWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
