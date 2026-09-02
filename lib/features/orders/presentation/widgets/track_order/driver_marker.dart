import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Builds the tanker-truck marker that stands in for the driver on the
/// tracking map, matching the design's white circular badge.
///
/// Painted from the truck SVG at the device's own pixel ratio rather than
/// scaled up from `assets/Order/tank_truck.png` (48×19), which would be
/// visibly soft on a 3x screen.
abstract final class DriverMarker {
  static const _asset = 'assets/HomePage/truck.svg';

  /// Diameter of the badge in logical pixels.
  static const _diameter = 44.0;

  /// How much of the badge the truck glyph fills.
  static const _glyphFraction = 0.52;

  static final Map<int, BitmapDescriptor> _cache = {};

  /// Cached per pixel ratio — the bitmap is identical for every order, and
  /// re-rasterising it on each rebuild would churn the GPU for nothing.
  static Future<BitmapDescriptor> build({required double devicePixelRatio}) async {
    final key = (devicePixelRatio * 100).round();
    final cached = _cache[key];
    if (cached != null) return cached;

    final side = (_diameter * devicePixelRatio).round();
    final s = side.toDouble();
    final centre = Offset(s / 2, s / 2);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Soft drop shadow, then the white disc, then a hairline edge — without
    // the edge the badge disappears against pale map tiles.
    canvas.drawCircle(
      centre.translate(0, devicePixelRatio),
      s / 2 - devicePixelRatio,
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, devicePixelRatio * 1.5),
    );
    canvas.drawCircle(
      centre,
      s / 2 - devicePixelRatio * 1.5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      centre,
      s / 2 - devicePixelRatio * 1.5,
      Paint()
        ..color = const Color(0x1F000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = devicePixelRatio,
    );

    final picture = await vg.loadPicture(const SvgAssetLoader(_asset), null);
    final glyph = s * _glyphFraction;
    canvas.save();
    canvas.translate((s - glyph) / 2, (s - glyph) / 2);
    canvas.scale(
      glyph / picture.size.width,
      glyph / picture.size.height,
    );
    canvas.drawPicture(picture.picture);
    canvas.restore();
    picture.picture.dispose();

    final image = await recorder.endRecording().toImage(side, side);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    final descriptor = BitmapDescriptor.bytes(
      bytes!.buffer.asUint8List(),
      imagePixelRatio: devicePixelRatio,
      width: _diameter,
      height: _diameter,
    );
    _cache[key] = descriptor;
    return descriptor;
  }
}
