import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../constants/support_topics.dart';
import 'support_topic_item.dart';

/// The bordered list of most-searched topics.
class SupportTopicsCard extends StatelessWidget {
  const SupportTopicsCard({required this.onTopicTap, super.key});

  /// Given the topic that was tapped.
  final ValueChanged<SupportTopic> onTopicTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: context.colors.borderHairline),
      ),
      child: Column(
        children: [
          for (final (index, topic) in supportTopics.indexed) ...[
            if (index > 0)
              Divider(
                height: AppSizes.dividerThickness,
                color: context.colors.borderHairline,
              ),
            SupportTopicItem(topic: topic, onTap: () => onTopicTap(topic)),
          ],
        ],
      ),
    );
  }
}
