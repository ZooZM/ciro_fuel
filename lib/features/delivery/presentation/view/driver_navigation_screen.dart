import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/app_logo.dart';
import '../widgets/driver_navigation_stats_card.dart';
import '../widgets/driver_navigation_bottom_sheet.dart';

class DriverNavigationScreen extends StatelessWidget {
  const DriverNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        appBar: AppBar(
          backgroundColor: context.colors.canvas,
          elevation: 0,
          centerTitle: true,
          title: const AppLogo(),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconCard(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 2.0),
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: context.colors.textPrimary),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            // Title + Stats area at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: context.colors.canvas,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      DriverNavigationKeys.title.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      DriverNavigationKeys.subtitle.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const DriverNavigationStatsCard(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // Full bleed map background (below the top area)
            Positioned.fill(
              top: 140,
              child: Image.asset(AppAssets.orderMapImage, fit: BoxFit.cover),
            ),

            // Map floating controls
            Positioned(
              left: AppSpacing.lg,
              top: 160,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MapButton(AppAssets.orderMapReloadIcon),
                  SizedBox(height: 12),
                  _MapButton(AppAssets.orderMapZoomInIcon),
                  SizedBox(height: 12),
                  _MapButton(AppAssets.orderMapZoomOutIcon),
                  SizedBox(height: 12),
                  _MapButton(AppAssets.orderMapShareIcon),
                ],
              ),
            ),

            // Bottom Sheet Overlay
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DriverNavigationBottomSheet(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton(this.asset);
  final String asset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SvgPicture.asset(
        asset,
        width: 44,
        height: 44,
      ),
    );
  }
}
