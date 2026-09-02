// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/widgets/station_picker.dart';
import '../../../../../shared/models/station_option.dart';
import '../../../../../core/theme/theme_context.dart';

/// "1. نوع الوقود" — the current-station summary plus favourite-station
/// shortcuts. (The section keeps the design's original heading, which
/// names the fuel-type step rather than the station step it actually
/// shows.)
class StationSection extends StatefulWidget {
  const StationSection({
    this.stationName,
    this.stationAddress,
    this.favouriteStations = const [],
    this.onChangeStation,
    this.onSelectStation,
    this.onToggleFavourite,
    this.stations = const [],
    this.selectedStationId,
    super.key,
  });

  final String? stationName;
  final String? stationAddress;

  /// The client's own real stations marked favourite (spec 005 D2) — a
  /// subset of [stations], never fixed sample data.
  final List<StationOption> favouriteStations;

  /// Still fired on tap, so callers can react; the section unfolds the picker
  /// itself.
  final VoidCallback? onChangeStation;

  /// Fired when the client picks a different station in the expanded
  /// picker — the parent screen owns which station a quote/order is
  /// actually requested against (spec 005 US2), this section is display +
  /// selection UI only.
  final ValueChanged<StationOption>? onSelectStation;

  /// Persists the flip through the backend (spec 005 T111/FR-037) — the
  /// parent owns the real `Station` list and the usecase call; this section
  /// only reports which one was tapped, same division of labour as
  /// [onSelectStation].
  final ValueChanged<StationOption>? onToggleFavourite;

  /// The client's own registered stations (`GET /stations`) — never a list
  /// fixed in the app (FR-036a).
  final List<StationOption> stations;

  /// `null` until the client's stations have loaded.
  final String? selectedStationId;

  @override
  State<StationSection> createState() => _StationSectionState();
}

class _StationSectionState extends State<StationSection> {
  String? _selectedId;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedStationId;
  }

  @override
  void didUpdateWidget(StationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The parent screen fetches the client's stations asynchronously, so
    // this section is first built before they arrive — sync once they do,
    // but never override a selection the client has since made themselves.
    if (_selectedId == null && widget.selectedStationId != null) {
      _selectedId = widget.selectedStationId;
    }
  }

  void _toggle() {
    // spec 005 T113/FR-036d: a single-station client is never asked to
    // choose — nothing to expand.
    if (widget.stations.length <= 1) return;
    setState(() => _expanded = !_expanded);
    widget.onChangeStation?.call();
  }

  void _selectStation(StationOption station) {
    setState(() => _selectedId = station.id);
    widget.onSelectStation?.call(station);
  }

  @override
  Widget build(BuildContext context) {
    // Neither field is ever fabricated (spec 005 FR-001) — while the
    // client's real stations are still loading, the label plainly says so
    // rather than showing a placeholder that reads as a real address.
    final resolvedName = widget.stationName ?? CreateOrderKeys.loadingStation.tr();
    final resolvedAddress = widget.stationAddress ?? '';

    return OrderCard(
      title: CreateOrderKeys.sectionStation.tr(),
      child: Column(
        children: [
          Row(
            children: [
              // Leads the row, next to the artwork. `arrow_back_ios` is
              // declared `matchTextDirection`, so Flutter mirrors it for us:
              // '<' under English, '>' under Arabic — matching the dashboard's
              // copy of this card. Nothing here may swap the icon by hand;
              // that would mirror it twice.
              Icon(
                Icons.arrow_back_ios,
                color: context.colors.textPrimary,
                size: AppSizes.icon16,
              ),
              const SizedBox(width: AppSpacing.sm),
              // `station.png` is a 1024x1024 bitmap embedded as base64 and
              // painted through an SVG <pattern>; flutter_svg does not
              // rasterise <image> elements, so it draws nothing — this is
              // that same bitmap, extracted so it can be shown directly.
              Image.asset(
                AppAssets.orderStationArt,
                width: AppSizes.orderStationArtSize,
                height: AppSizes.orderStationArtSize,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  // Hug the artwork, not the card's outer edge — `end` pushed
                  // the block against the same edge the chevron sits on, so
                  // the two crowded each other in both directions.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Flexible: this row is `mainAxisSize.min`, so
                        // without it the label takes its natural width and
                        // overruns the column on a narrow phone.
                        Flexible(
                          child: Text(
                            CreateOrderKeys.currentStation.tr(),
                            style: TextStyle(
                              color: context.colors.brandGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SvgPicture.asset(
                          AppAssets.orderPinIcon,
                          width: AppSizes.iconMd,
                          height: AppSizes.iconMd,
                          colorFilter: ColorFilter.mode(
                            context.colors.brandGreen,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      resolvedName,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      resolvedAddress,
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
          const SizedBox(height: AppSpacing.md),
          Divider(
            height: AppSizes.dividerThickness,
            color: context.colors.borderHairline,
          ),
          const SizedBox(height: AppSpacing.md),
          if (_expanded)
            StationPicker(
              // Only the active stations: this card is the order form, and an
              // inactive station is not something an order can be placed
              // against. The dashboard's copy of the picker still lists them,
              // under their own divider, because switching your default is a
              // different question from ordering.
              stations: [
                for (final s in widget.stations)
                  if (s.isActive) s,
              ],
              selectedId: _selectedId,
              onSelect: _selectStation,
              onToggleFavourite: widget.onToggleFavourite,
            )
          else ...[
            Row(
              children: [
                Icon(
                  Icons.star_border_rounded,
                  size: AppSizes.iconMd,
                  color: context.colors.textSecondary,
                ),
                const SizedBox(width: 6),
                // "Your favourite stations" is wider than "محطاتك المفضلة", so
                // the label has to be able to give ground on a narrow phone.
                Flexible(
                  child: Text(
                    CreateOrderKeys.favouriteStations.tr(),
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Scrolls rather than sharing the width: split three ways the
            // station names ran out of room and ellipsized ("محطة الصـ…").
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final (index, station)
                      in widget.favouriteStations.indexed) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.sm),
                    SizedBox(
                      width: AppSizes.orderFavouriteChipWidth,
                      child: _FavouriteStationChip(station: station),
                    ),
                  ],
                ],
              ),
            ),
          ],
          // spec 005 T113/FR-036d: with only one registered station there is
          // no choice to offer, so the affordance for making one is absent
          // entirely — not merely disabled.
          if (widget.stations.length > 1) ...[
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _toggle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    CreateOrderKeys.changeStation.tr(),
                    style: TextStyle(
                      color: context.colors.brandGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: AppSizes.iconSm,
                    color: context.colors.brandGreen,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FavouriteStationChip extends StatelessWidget {
  const _FavouriteStationChip({required this.station});

  final StationOption station;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.orderFavouriteChipRadius),
        border: Border.all(color: context.colors.borderHairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  station.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  station.area,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          SvgPicture.asset(
            AppAssets.orderBarePinIcon,
            width: AppSizes.iconSm,
            height: AppSizes.iconSm,
          ),
        ],
      ),
    );
  }
}
