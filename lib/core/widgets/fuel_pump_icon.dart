import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The pump artwork with a fuel grade written on its face.
///
/// 'gas .svg' has "95" baked into the artwork, so it can only ever be correct
/// for one grade; this uses 'gas station.svg' — the same pump without a number —
/// and lays the grade on top.
///
/// The grade is centred inside the pump's *face*, not the icon box: the nozzle
/// occupies the right third, so centring on the box pushes the text off the
/// body. Centring inside a fixed rect also keeps one-character grades ('K')
/// and two-digit ones ('98') in the same place.
class FuelPumpIcon extends StatelessWidget {
  const FuelPumpIcon({super.key, required this.grade, required this.color, this.size = 26});

  /// Short label drawn on the pump face — '91', '98', 'D', 'K'.
  final String grade;

  /// Tile colour. The pump is tinted white and the grade drawn in this colour,
  /// since the white tint makes the pump body solid.
  final Color color;

  final double size;

  static const _asset = 'assets/HomePage/gas station.svg';

  // Pump geometry within the icon, as fractions of the box, measured off the
  // SVG's paths.
  static const _bodyLeft = 0.05;
  static const _bodyWidth = 0.63;
  static const _faceTop = 0.42;
  static const _faceHeight = 0.50;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          SvgPicture.asset(
            _asset,
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          Positioned(
            left: size * _bodyLeft,
            width: size * _bodyWidth,
            top: size * _faceTop,
            height: size * _faceHeight,
            child: Center(
              child: Text(
                grade,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
