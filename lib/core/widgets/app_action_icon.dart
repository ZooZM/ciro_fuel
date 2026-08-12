import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';

/// One of the reload / download / filter chips, in the cut that suits the
/// active theme.
///
/// Unlike [AppSvgIcon] these marks are not a single glyph to be tinted: each
/// bakes in a chip fill, a hairline border and a coloured symbol, so a
/// `colorFilter` would collapse all three into one colour. Each therefore
/// ships a second file with every role remapped to the dark palette, and this
/// picks between them — the same arrangement [AppLogo] uses for the wordmark.
class AppActionIcon extends StatelessWidget {
  const AppActionIcon._(
    this._light,
    this._dark, {
    required this.size,
    super.key,
  });

  /// Reload — orange mark.
  const AppActionIcon.reload({double size = 32, Key? key})
    : this._(
        AppAssets.reloadIcon,
        AppAssets.reloadIconDark,
        size: size,
        key: key,
      );

  /// Download — blue mark.
  const AppActionIcon.download({double size = 32, Key? key})
    : this._(
        AppAssets.downloadIcon,
        AppAssets.downloadIconDark,
        size: size,
        key: key,
      );

  /// Filter — green mark.
  const AppActionIcon.filter({double size = 48, Key? key})
    : this._(
        AppAssets.filterIcon,
        AppAssets.filterIconDark,
        size: size,
        key: key,
      );

  /// The payments screen's reload, drawn from its own copy of the artwork.
  const AppActionIcon.paymentsReload({double size = 32, Key? key})
    : this._(
        AppAssets.paymentsReloadIcon,
        AppAssets.paymentsReloadIconDark,
        size: size,
        key: key,
      );

  final String _light;
  final String _dark;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      isDark ? _dark : _light,
      width: size,
      height: size,
    );
  }
}
