import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/station_picker.dart';
import '../../../../shared/models/station_option.dart';

/// The client's current fuel station. "Change station" unfolds the picker
/// below it rather than navigating away, so the client can see what they are
/// switching from while they choose.
class CurrentStationCard extends StatefulWidget {
  const CurrentStationCard({
    required this.name,
    required this.address,
    required this.onChangeStation,
    this.onOpenStations,
    this.headsWithStar = false,
    this.stations = const [],
    this.selectedStationId,
    super.key,
  });

  final String name;
  final String address;

  /// Still fired on tap, so callers can react; the card handles the unfolding
  /// itself.
  final VoidCallback onChangeStation;

  /// Tapping the station itself — the block the chevron points at — opens the
  /// full stations screen. Left null by the stations screen, which is already
  /// showing it; the block is then inert rather than pushing itself again.
  final VoidCallback? onOpenStations;

  /// Heads the row with the favourite star instead of the chevron.
  ///
  /// The stations screen sets it: there is nowhere left to go from there, so
  /// the star marking the station on file says more than an arrow pointing at
  /// the screen you are already on. The dashboard keeps the chevron, which is
  /// what takes you there.
  final bool headsWithStar;

  final List<StationOption> stations;
  final String? selectedStationId;

  @override
  State<CurrentStationCard> createState() => _CurrentStationCardState();
}

class _CurrentStationCardState extends State<CurrentStationCard> {
  late List<StationOption> _stations = widget.stations;
  late String? _selectedId = widget.selectedStationId;
  bool _expanded = false;

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onChangeStation();
  }

  void _select(StationOption station) {
    setState(() => _selectedId = station.id);
  }

  void _toggleFavourite(StationOption station) {
    setState(() {
      _stations = [
        for (final s in _stations)
          s.id == station.id ? s.copyWith(isFavourite: !s.isFavourite) : s,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
      ),
      child: Column(
        // The copy sits against the card's left edge in both
        // languages: that is `end` once the row has mirrored under
        // Arabic, and `start` under English.
        crossAxisAlignment: isArabic
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onOpenStations,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.dashboardCard),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // RTL row: the first child renders right-most, so the order
                  // here is the leading glyph, the station icon, then the text
                  // block filling the rest.
                  //
                  // The star is the picker's own — disc and all — so it does
                  // not read as a different mark from the ones that unfold
                  // right below it. `arrow_back_ios` is mirrored under RTL
                  // (matchTextDirection), so it is what actually draws the
                  // '>' the design shows.
                  if (widget.headsWithStar)
                    const FavouriteStar(isFavourite: true)
                  else
                    Icon(
                      Icons.arrow_back_ios,
                      color: context.colors.textPrimary,
                      size: AppSizes.icon16,
                    ),
                  const SizedBox(width: AppSpacing.md),
                  SvgPicture.asset(
                    AppAssets.dashboardStationIcon,
                    width: AppSizes.dashboardStationIconSize,
                    height: AppSizes.dashboardStationIconSize,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      // The copy sits against the card's left edge in both
                      // languages: that is `end` once the row has mirrored under
                      // Arabic, and `start` under English.
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Row(
                          // Hug the content, otherwise the row spans the
                          // full width and the label snaps back to the
                          // right.
                          mainAxisSize: MainAxisSize.min,
                          // Label first so the pin lands to its left, as
                          // designed.
                          children: [
                            // Flexible: this row is `mainAxisSize.min`, so
                            // without it the label takes its natural width and
                            // overruns the column on a narrow phone.
                            Flexible(
                              child: Text(
                                HomeKeys.currentStation.tr(),
                                style: TextStyle(
                                  color: context.colors.brandGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Icons.location_on_outlined,
                              color: context.colors.brandGreen,
                              size: AppSizes.icon16,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.name,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.address,
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: AppSizes.dividerThickness,
            color: context.colors.borderHairline,
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: StationPicker(
                stations: _stations,
                selectedId: _selectedId,
                onSelect: _select,
                onToggleFavourite: _toggleFavourite,
              ),
            ),
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
              child: Row(
                // `end` packs the pair against the left edge; label first
                // so the chevron sits to its left. `arrow_forward_ios` is
                // mirrored under RTL, which is what draws the '<' shown.
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    HomeKeys.changeStation.tr(),
                    style: TextStyle(
                      color: context.colors.brandGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.brandGreen,
                    size: AppSizes.dashboardChangeStationIconSize,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
