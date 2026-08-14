import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/theme_context.dart';

const _kAvatar = 'assets/driverHomePage/driver.jpg';


/// The photo, name, station and verified badge that head both the profile
/// screen and the phone-change flow.
class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity({
    super.key,
    this.name = 'محمد أحمد',
    this.station = 'محطة قو ستيشن',
    this.showEditBadge = false,
    this.onEdit,
  });

  final String name;
  final String station;

  /// The pencil badge only belongs on the screen where the photo can be
  /// changed, not on the read-only steps of the phone-change flow.
  final bool showEditBadge;
  final VoidCallback? onEdit;

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
                child: Image.asset(_kAvatar, fit: BoxFit.cover),
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
        Text(
          name,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: context.colors.textPrimary,
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
