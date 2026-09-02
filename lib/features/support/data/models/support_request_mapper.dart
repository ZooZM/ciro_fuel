import '../../domain/entities/support_request.dart';

/// No generated `fromJson`: the backend keys the id `_id`, same reasoning
/// as `ProfileMapper`/`StationMapper`.
abstract final class SupportRequestMapper {
  static SupportRequest fromJson(Map<String, dynamic> json) => SupportRequest(
    id: json['_id'] as String,
    topic: json['topic'] as String,
    message: json['message'] as String,
    state: json['state'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    orderId: json['orderId'] as String?,
    acknowledgedAt: json['acknowledgedAt'] != null
        ? DateTime.parse(json['acknowledgedAt'] as String)
        : null,
  );
}
