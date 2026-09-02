import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_user.freezed.dart';

/// The full self-profile (`GET /users/:id`, spec 005 T099) — richer than the
/// thin [AuthUser] carried on `/auth/me`/session state (no phone, email or
/// picture there). Fetched independently by `ProfileCubit` rather than
/// folded into `AuthUser`, so editing contact details here never perturbs
/// session state or forces every screen to carry these fields.
///
/// [companyName] is DRIVER-only (spec 006 FR-002) — `undefined`/`null` for
/// a CLIENT's own profile.
///
/// spec 008 (research R12): this used to also carry a driver's own `truck`
/// (spec 006 FR-003) — deleted, not migrated, along with the backend's
/// embedded `User.truck`. A vehicle is now assigned per delivery, never a
/// fixed personal attribute, so there is nothing analogous to show here any
/// more; see `delivery_detail_screen.dart`'s `tankSummary`/`driverSummary`
/// display for where a driver's assigned vehicle actually lives now.
@freezed
abstract class ProfileUser with _$ProfileUser {
  const factory ProfileUser({
    required String id,
    required String fullName,
    required String email,
    required String phone,
    required bool isActive,
    required DateTime createdAt,
    String? profilePictureFileId,
    String? companyName,
  }) = _ProfileUser;
}
