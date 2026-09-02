import '../../domain/entities/profile_user.dart';

/// No generated `fromJson`: the backend keys the id `_id`, not this entity's
/// `id` (same reasoning as `StationMapper` for the GeoJSON `location`
/// shape), so this is mapped by hand rather than via `json_serializable`.
abstract final class ProfileMapper {
  static ProfileUser fromJson(Map<String, dynamic> json) => ProfileUser(
    id: json['_id'] as String,
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    isActive: json['isActive'] as bool? ?? true,
    createdAt: DateTime.parse(json['createdAt'] as String),
    profilePictureFileId: json['profilePictureFileId'] as String?,
    // DRIVER-only (spec 006 FR-002); null for a CLIENT's own profile,
    // exactly as the backend leaves the key absent there.
    companyName: json['companyName'] as String?,
  );
}
