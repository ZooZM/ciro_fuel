import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';

/// The white container one block of settings rows sits in.
///
/// It only supplies the surface: the rows and the [MoreDivider]s between them
/// are passed in, so a block can mix plain rows with the language section's
/// expanding one.
class MoreCard extends StatelessWidget {
  const MoreCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(children: children),
    );
  }
}
