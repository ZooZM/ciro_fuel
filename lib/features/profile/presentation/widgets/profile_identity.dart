import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/theme_context.dart';

/// The neutral stand-in shown until someone uploads a picture of their own.
///
/// This used to be `assets/driverHomePage/driver.jpg` — a photograph of an
/// actual person — so every account without a photo appeared to have that
/// stranger's face.
const _kAvatarPlaceholder = 'assets/HomePage/profile.svg';


/// The photo, name, station and verified badge that head both the profile
/// screen and the phone-change flow.
class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity({
    super.key,
    required this.name,
    this.station = '',
    this.showEditBadge = false,
    this.onEdit,
    this.avatarBytes,
    this.onNameTap,
  });

  /// The signed-in person's own name.
  ///
  /// Required, with no default: this used to fall back to a literal
  /// "محمد أحمد" and "محطة قو ستيشن", so any screen that forgot to pass a
  /// value showed the client someone else's identity entirely.
  final String name;

  /// The station line beneath the name. Empty where the role has no station
  /// — a driver belongs to a transport company, not a station — rather than
  /// inventing one.
  final String station;

  /// The pencil badge only belongs on the screen where the photo can be
  /// changed, not on the read-only steps of the phone-change flow.
  final bool showEditBadge;
  final VoidCallback? onEdit;

  /// When set, the name becomes a tap target for renaming (T100) — kept
  /// separate from [onEdit], which belongs to the photo the badge sits on.
  final VoidCallback? onNameTap;

  /// The real uploaded picture (spec 005 T100/T103), fetched via
  /// `ProfileCubit`/`DownloadAvatar`. `null` — no picture set, or still
  /// loading — falls back to the placeholder asset below.
  final Uint8List? avatarBytes;

  static const double _avatar = 120;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: _avatar,
          height: _avatar,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // No fill of its own — the photo carries its own white ground, so
              // a colour here only produced a second one behind it.
              Container(
                width: _avatar,
                height: _avatar,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // No outline: the photo's own white ground already reads as a
                  // frame, and a hairline on top of it drew a second edge.
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      offset: Offset(0, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: avatarBytes != null
                    ? Image.memory(avatarBytes!, fit: BoxFit.cover)
                    : const _AvatarPlaceholder(),
              ),
              if (showEditBadge)
                // Overlapping the photo's bottom-left corner — most of the
                // badge sits on the picture, with only its left edge hanging
                // off, rather than standing clear of it.
                Positioned(
                  left: -15,
                  bottom: -15,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.6),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/driverHomePage/edit_profile_badge.svg',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onNameTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // spec 006 T087 (RTL sweep): a bare `Text` here overflowed
              // rather than wrapping/truncating for a long registered name
              // — `Row` never wraps a plain child regardless of
              // `mainAxisSize`. `Flexible` lets it shrink to whatever room
              // `mainAxisSize: min` still leaves after the edit icon.
              Flexible(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              if (onNameTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: context.colors.textTertiary,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(station, style: TextStyle(fontSize: 16, color: context.colors.textSecondary)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: context.colors.greenTint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // Shield first so it sits to the right of the label in RTL.
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 16,
                color: context.colors.brandGreen,
              ),
              const SizedBox(width: 6),
              Text(
                ProfileKeys.verifiedAccount.tr(),
                style: TextStyle(
                  color: context.colors.brandGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A person glyph on a tinted ground, filling the avatar square.
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  /// Matches ProfileIdentity's own avatar box.
  static const double _size = 120;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.borderHairline.withValues(alpha: 0.35),
      child: Center(
        child: SvgPicture.asset(
          _kAvatarPlaceholder,
          // Roughly half the square, so the glyph reads as an icon inside a
          // frame rather than a cropped picture.
          width: _size * 0.42,
          height: _size * 0.42,
          colorFilter: ColorFilter.mode(
            context.colors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
