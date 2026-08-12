import 'package:json_annotation/json_annotation.dart';

import 'fuel_type.dart';
import 'invoice_state.dart';
import 'notification_type.dart';
import 'order_status.dart';
import 'otp_purpose.dart';
import 'payment_method.dart';
import 'user_role.dart';

/// `JsonConverter`s bridging our enums' backend wire strings and
/// `json_serializable`, so entities stay free of ad hoc string parsing.
class UserRoleConverter implements JsonConverter<UserRole, String> {
  const UserRoleConverter();
  @override
  UserRole fromJson(String json) => UserRole.fromWire(json);
  @override
  String toJson(UserRole object) => object.toWire();
}

class OrderStatusConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();
  @override
  OrderStatus fromJson(String json) => OrderStatus.fromWire(json);
  @override
  String toJson(OrderStatus object) => object.toWire();
}

class OtpPurposeConverter implements JsonConverter<OtpPurpose, String> {
  const OtpPurposeConverter();
  @override
  OtpPurpose fromJson(String json) => OtpPurpose.fromWire(json);
  @override
  String toJson(OtpPurpose object) => object.toWire();
}

class NotificationTypeConverter
    implements JsonConverter<NotificationType, String> {
  const NotificationTypeConverter();
  @override
  NotificationType fromJson(String json) => NotificationType.fromWire(json);
  @override
  String toJson(NotificationType object) => object.toWire();
}

class FuelTypeConverter implements JsonConverter<FuelType, String> {
  const FuelTypeConverter();
  @override
  FuelType fromJson(String json) => FuelType.fromWire(json);
  @override
  String toJson(FuelType object) => object.toWire();
}

class PaymentMethodConverter implements JsonConverter<PaymentMethod, String> {
  const PaymentMethodConverter();
  @override
  PaymentMethod fromJson(String json) => PaymentMethod.fromWire(json);
  @override
  String toJson(PaymentMethod object) => object.toWire();
}

class InvoiceStateConverter implements JsonConverter<InvoiceState, String> {
  const InvoiceStateConverter();
  @override
  InvoiceState fromJson(String json) => InvoiceState.fromWire(json);
  @override
  String toJson(InvoiceState object) => object.toWire();
}
