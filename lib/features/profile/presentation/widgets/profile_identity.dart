import 'package:flutter/material.dart';

const _kAvatar = 'assets/more/Image.png';

const _kNavy = Color(0xFF162155);
const _kGrey = Color(0xFF6B7280);
const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF12A150);
const _kGreenTint = Color(0xFFE4F7EC);
const _kBorder = Color(0xFFE7E9EF);

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
                  border: Border.all(color: _kBorder),
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
                  left: 2,
                  bottom: 8,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 15,
                        color: _kBlue,
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
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: _kNavy,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          station,
          style: const TextStyle(fontSize: 16, color: _kGrey),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _kGreenTint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            // Shield first so it sits to the right of the label in RTL.
            children: [
              Icon(Icons.verified_user_outlined, size: 16, color: _kGreen),
              SizedBox(width: 6),
              Text(
                'حساب موثوق',
                style: TextStyle(
                  color: _kGreen,
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
