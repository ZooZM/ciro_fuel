import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A square SVG asset rendered like an [Icon] — sized and tinted by the
/// caller. Wraps the `colorFilter` boilerplate that would otherwise repeat
/// at every icon site.
///
/// Pass `color: null` for multi-colour marks (the Google "G", the Apple
/// logo) that must keep their own palette.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(this.asset, {required this.size, this.color, super.key});

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
