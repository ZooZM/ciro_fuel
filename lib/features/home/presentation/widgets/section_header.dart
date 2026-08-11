import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';

/// The bold section label above each dashboard block (طلبك الحالي, طلب
/// سريع, نظرة سريعة).
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
      ),
    );
  }
}
