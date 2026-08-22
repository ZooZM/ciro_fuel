import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/entities/auth_user.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// Wire shape of `POST /auth/login` (feature 001 REST contract).
///
/// `toJson: false` — nothing ever serializes this DTO back to JSON, and it
/// nests `AuthUser`, which (via `station.location`'s `GeoPoint`) has no
/// shape `json_serializable` can derive a matching `toJson` for. `fromJson`
/// generation stays on; only the direction nothing uses is turned off.
@Freezed(toJson: false)
abstract class LoginResponseModel with _$LoginResponseModel {
  const LoginResponseModel._();

  const factory LoginResponseModel({
    required String accessToken,
    required String refreshToken,
    required AuthUser user,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, Object?> json) =>
      _$LoginResponseModelFromJson(json);

  /// Redacted — freezed's default toString would otherwise print both
  /// tokens in full if this DTO were ever logged (SC-008 covers OTPs; the
  /// same discipline applies to session tokens).
  @override
  String toString() =>
      'LoginResponseModel(accessToken: [REDACTED], refreshToken: [REDACTED], user: $user)';
}
