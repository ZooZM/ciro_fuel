import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../shared/models/station_option.dart';
import '../localization/translation_keys.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

/// The list revealed by "change station": every station the client can switch
/// to, with the active ones first and the rest under their own divider.
///
/// Laid out directionally throughout — the favourite star leads the row, the
/// radio takes its trailing edge and the pin sits beside the name — so the
/// whole row mirrors with the locale rather than assuming Arabic.
class StationPicker extends StatelessWidget {
  const StationPicker({
    required this.stations,
    required this.selectedId,
    required this.onSelect,
    this.onToggleFavourite,
    super.key,
  });

  final List<StationOption> stations;
  final String? selectedId;
  final ValueChanged<StationOption> onSelect;

  /// Omit to hide the favourite control entirely.
  final ValueChanged<StationOption>? onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    final active = stations.where((s) => s.isActive).toList();
    final inactive = stations.where((s) => !s.isActive).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final station in active) ...[
          _StationRow(
            station: station,
            selected: station.id == selectedId,
            onSelect: () => onSelect(station),
            onToggleFavourite: onToggleFavourite == null
                ? null
                : () => onToggleFavourite!(station),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (inactive.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          _InactiveDivider(),
          const SizedBox(height: AppSpacing.md),
          for (final station in inactive) ...[
            _StationRow(
              station: station,
              selected: station.id == selectedId,
              onSelect: () => onSelect(station),
              // Inactive stations carry no favourite control in the design.
              onToggleFavourite: null,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ],
    );
  }
}

/// A rule with the "inactive" caption set into it.
class _InactiveDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(
        height: AppSizes.dividerThickness,
        color: context.colors.borderHairline,
      ),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            HomeKeys.inactiveStations.tr(),
            style: TextStyle(
              color: context.colors.brandRed,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        line,
      ],
    );
  }
}

class _StationRow extends StatelessWidget {
  const _StationRow({
    required this.station,
    required this.selected,
    required this.onSelect,
    required this.onToggleFavourite,
  });

  final StationOption station;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback? onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isArabic = context.locale.languageCode == 'ar';

    return Row(
      children: [
        // Leads the row, so it takes the right under Arabic and the left
        // under English.
        if (onToggleFavourite != null) ...[
          FavouriteStar(
            isFavourite: station.isFavourite,
            onTap: onToggleFavourite!,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: InkWell(
            onTap: onSelect,
            borderRadius: BorderRadius.circular(AppRadii.tile),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadii.tile),
                border: Border.all(color: colors.borderHairline),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: AppSizes.iconLg,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          station.localisedName(isArabic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          station.localisedArea(isArabic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _SelectionDot(selected: selected),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The favourite toggle: an outlined star that fills in once set.
///
/// Both states are grey — the filled star is the darker of the two, so the
/// change reads without the control colouring itself in.
/// A station's favourite star, on its own disc.
///
/// Public because the dashboard's current-station card heads with the same
/// mark: the picker unfolds directly under it, so a bare glyph up there and
/// these discs below read as two different things.
class FavouriteStar extends StatelessWidget {
  const FavouriteStar({required this.isFavourite, this.onTap, super.key});

  final bool isFavourite;

  /// Null where the star only reports the state rather than setting it.
  final VoidCallback? onTap;

  static const _tile = 44.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: _tile,
        height: _tile,
        decoration: BoxDecoration(
          color: colors.surface2,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavourite ? Icons.star_rounded : Icons.star_border_rounded,
          size: AppSizes.iconLg,
          color: isFavourite ? colors.textSecondary : colors.textTertiary,
        ),
      ),
    );
  }
}

/// The radio, drawn to the supplied artwork: a solid 16pt disc with an 8pt
/// core, grey until its station is the chosen one and green after.
///
/// Drawn rather than shipped as the two SVGs so the three fills come from the
/// palette and follow the theme — the artwork's `#9CA3AF` / `#12A150` /
/// `#E4F7EC` are exactly the light palette's tertiary text, brand green and
/// green tint.
class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected});

  final bool selected;

  static const _size = 16.0;
  static const _core = 8.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.brandGreen : colors.textTertiary,
      ),
      child: Center(
        child: Container(
          width: _core,
          height: _core,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.greenTint,
          ),
        ),
      ),
    );
  }
}
