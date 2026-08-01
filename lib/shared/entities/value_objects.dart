import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_objects.freezed.dart';
part 'value_objects.g.dart';

@freezed
abstract class Money with _$Money {
  const factory Money({required int amountMinor, required String currency}) =
      _Money;

  factory Money.fromJson(Map<String, Object?> json) => _$MoneyFromJson(json);
}

@freezed
abstract class GeoPoint with _$GeoPoint {
  const factory GeoPoint({required double lat, required double lng}) =
      _GeoPoint;

  factory GeoPoint.fromJson(Map<String, Object?> json) =>
      _$GeoPointFromJson(json);
}
