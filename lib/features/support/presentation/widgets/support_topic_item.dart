import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/support_topics.dart';

/// One row of the most-searched list. The '+' says the row expands, which it
/// will once the articles behind these topics exist.
class SupportTopicItem extends StatefulWidget {
  const SupportTopicItem({required this.topic, required this.onTap, super.key});

  final SupportTopic topic;
  final VoidCallback onTap;

  @override
  State<SupportTopicItem> createState() => _SupportTopicItemState();
}

class _SupportTopicItemState extends State<SupportTopicItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
            widget.onTap();
          },
          child: Container(
            color: context.colors.surface,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  widget.topic.icon,
                  width: AppSizes.supportTopicIconSize,
                  height: AppSizes.supportTopicIconSize,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    widget.topic.titleKey.tr(),
                    style: TextStyle(
                      fontSize: AppFontSizes.bodyLarge,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.remove : Icons.add,
                  color: _isExpanded ? context.colors.brandBlue : context.colors.textSecondary,
                  size: AppSizes.iconLg,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            color: context.colors.blueTint,
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.languageCode == 'ar'
                      ? 'هل ممكن أطلب و أدفع مرة أخري ؟'
                      : 'Can I order and pay later?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: context.colors.brandBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.locale.languageCode == 'ar'
                      ? 'نعم، تقدر تطلب شحنتك و فاتورة سداد تتأجل للشحنة القادمة.'
                      : 'Yes, you can order your shipment and a sadad invoice will be delayed for the next shipment.',
                  style: TextStyle(
                    fontSize: 10,
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final dashWidth = 4.0;
                    final dashHeight = 1.0;
                    final dashCount = (constraints.constrainWidth() / (2 * dashWidth)).floor();
                    return Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: List.generate(dashCount, (_) {
                        return SizedBox(
                          width: dashWidth,
                          height: dashHeight,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: context.colors.brandGreen.withOpacity(0.4)),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Mock second question
                Text(
                  context.locale.languageCode == 'ar'
                      ? 'هل ممكن أطلب و أدفع مرة أخري ؟'
                      : 'Can I order and pay later?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: context.colors.brandBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.locale.languageCode == 'ar'
                      ? 'نعم، تقدر تطلب شحنتك و فاتورة سداد تتأجل للشحنة القادمة.'
                      : 'Yes, you can order your shipment and a sadad invoice will be delayed for the next shipment.',
                  style: TextStyle(
                    fontSize: 10,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
