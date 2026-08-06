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

  static const _height = 300.0;
  static const _buttonGap = 10.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
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
                SizedBox(height: _buttonGap),
                _MapButton(AppAssets.orderMapZoomInIcon),
                SizedBox(height: _buttonGap),
                _MapButton(AppAssets.orderMapZoomOutIcon),
                SizedBox(height: _buttonGap),
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

  static const _size = 48.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SvgPicture.asset(asset, width: _size, height: _size),
    );
  }
}
