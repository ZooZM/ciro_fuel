import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The label above each block of settings rows (الحساب, التطبيق, عن
/// التطبيق). Sits outside the card, so it is set in the muted warm grey
/// rather than the list titles' ink.
class MoreSectionTitle extends StatelessWidget {
  const MoreSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: AppFontSizes.title,
        fontWeight: FontWeight.bold,
        color: AppColors.warmGray,
      ),
    );
  }
}
