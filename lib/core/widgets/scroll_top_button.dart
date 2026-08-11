import 'package:flutter/material.dart';

import '../theme/theme_context.dart';

/// The back-to-top button the long scrolling screens float over their content.
///
/// Shared so the terms and notifications screens draw the same button: the
/// notifications screen used to float a bare SVG of its own, which read as a
/// different control and, being a plain image, only took taps where its
/// artwork actually painted.
class ScrollTopButton extends StatelessWidget {
  const ScrollTopButton({required this.controller, super.key});

  final ScrollController controller;

  /// Inset from the bottom and trailing edges, for callers positioning it.
  static const double inset = 16;

  static const double _side = 44;
  static const double _radius = 12;

  void _scrollToTop() {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(_radius),
      elevation: 2,
      shadowColor: const Color(0x1F000000),
      child: InkWell(
        borderRadius: BorderRadius.circular(_radius),
        onTap: _scrollToTop,
        child: SizedBox(
          width: _side,
          height: _side,
          child: Icon(
            Icons.arrow_upward,
            size: 22,
            color: context.colors.brandBlue,
          ),
        ),
      ),
    );
  }
}
