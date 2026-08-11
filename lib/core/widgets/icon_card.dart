import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

/// A small shadowed, rounded icon tile — the notification bell and
/// back button on the order screens' top bars.
///
/// [onTap] is optional: the order-detail screen's notification icon is
/// decorative only, with no gesture detector wrapping it.
class IconCard extends StatelessWidget {
  const IconCard({required this.child, this.onTap, super.key});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.field),
        boxShadow: AppColors.shadowCard,
      ),
      child: child,
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}
