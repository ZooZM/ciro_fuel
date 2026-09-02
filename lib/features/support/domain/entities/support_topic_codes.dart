/// Mirrors the backend's `SupportTopic` enum
/// (`src/common/enums/support-topic.enum.ts`) value-for-value (Constitution
/// Principle I — referenced by name, never a literal string at the call
/// site). `orderIssue` is the only one this app currently submits —
/// `support_order_problem_card.dart` is the sole ticket-creation surface.
abstract final class SupportTopicCodes {
  static const String orderIssue = 'ORDER_ISSUE';
  static const String payment = 'PAYMENT';
  static const String account = 'ACCOUNT';
  static const String other = 'OTHER';
}
