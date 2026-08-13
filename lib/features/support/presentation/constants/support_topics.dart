import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';

/// One row of the "أكثر المواضيع بحثاً" list.
class SupportTopic {
  const SupportTopic({required this.titleKey, required this.icon});

  /// A key from [SupportKeys], translated where the row is built.
  final String titleKey;
  final String icon;
}

/// The four topics the list offers, in the order they are shown.
///
/// Each still expands to nothing — the articles behind them are not written
/// yet — but the list itself is fixed copy, so it lives here rather than in
/// the screen.
const List<SupportTopic> supportTopics = [
  SupportTopic(
    titleKey: SupportKeys.topicFuelOrders,
    icon: AppAssets.supportFuelOrdersIcon,
  ),
  SupportTopic(
    titleKey: SupportKeys.topicDeliveryDelay,
    icon: AppAssets.supportDeliveryDelayIcon,
  ),
  SupportTopic(
    titleKey: SupportKeys.topicPaymentMethods,
    icon: AppAssets.supportAccountIcon,
  ),
  SupportTopic(
    titleKey: SupportKeys.topicAccountLogin,
    icon: AppAssets.supportPaymentIcon,
  ),
];
