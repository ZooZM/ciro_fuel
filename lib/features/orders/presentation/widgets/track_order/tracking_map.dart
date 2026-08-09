import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';

/// The full-bleed map image with its floating reload/zoom/share controls.
///
/// A flat image until a maps SDK is wired in; the zoom and locate controls
/// are part of the artwork, so [_MapButton] taps are no-ops for now.
class TrackingMap extends StatelessWidget {
  const TrackingMap({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.orderMapHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.orderMapImage, fit: BoxFit.cover),
          ),
          const Positioned(
            left: AppSpacing.lg,
            top: AppSpacing.xl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MapButton(AppAssets.orderMapReloadIcon),
                SizedBox(height: AppSizes.orderMapButtonGap),
                _MapButton(AppAssets.orderMapZoomInIcon),
                SizedBox(height: AppSizes.orderMapButtonGap),
                _MapButton(AppAssets.orderMapZoomOutIcon),
                SizedBox(height: AppSizes.orderMapButtonGap),
                _MapButton(AppAssets.orderMapShareIcon),
              ],
            ),
          ),
        ],
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
        width: AppSizes.orderMapButtonSize,
        height: AppSizes.orderMapButtonSize,
      ),
    );
  }
}
