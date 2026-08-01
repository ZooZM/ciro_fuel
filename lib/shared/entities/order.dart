import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/converters.dart';
import '../enums/fuel_type.dart';
import '../enums/order_status.dart';
import 'value_objects.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// Mirrors a backend order (feature 001 `/orders` resource) read-only.
/// `status` is authoritative only from the backend — the client never
/// derives or asserts a transition locally (research R7).
@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    @OrderStatusConverter() required OrderStatus status,
    @FuelTypeConverter() required FuelType fuelType,
    required int quantityLiters,
    Money? estimatedPrice,
    Money? finalPrice,
    String? paymentReference,
    DateTime? paymentWindowEndsAt,
    String? assignedDriverId,
    GeoPoint? destination,
    required DateTime statusChangedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);
}
