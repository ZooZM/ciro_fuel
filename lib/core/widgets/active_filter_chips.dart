import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../shared/models/filter_selection.dart';
import '../../shared/models/station_option.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

/// The applied filters, drawn under the search bar as removable chips.
///
/// The sheet is where filters are chosen; this is the only place they stay
/// visible afterwards, so the client can see what a short list is short
/// because of. Tapping a chip drops that one filter and leaves the rest —
/// re-opening the sheet to clear a single station was the alternative.
///
/// Chips are listed in the sheet's own section order (sort, station, fuel
/// type, date) so the two read the same way.
class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({
    required this.filters,
    required this.onChanged,
    this.stations = const [],
    super.key,
  });

  final FilterSelection filters;

  /// The same list the sheet was given — chips resolve a station id to the
  /// name in the current locale through it.
  final List<StationOption> stations;

  final ValueChanged<FilterSelection> onChanged;

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    final isArabic = context.locale.languageCode == 'ar';
    final entries = <(String, FilterSelection)>[];

    if (filters.sort != null) {
      entries.add((
        filters.sort!.labelKey.tr(),
        filters.copyWith(clearSort: true),
      ));
    }

    // Driven by [stations] rather than by the id set, so the chips keep the
    // order the sheet listed them in instead of the set's insertion order.
    for (final station in stations) {
      if (!filters.stationIds.contains(station.id)) continue;
      entries.add((
        station.localisedName(isArabic),
        filters.copyWith(
          stationIds: {...filters.stationIds}..remove(station.id),
        ),
      ));
    }

    if (filters.grade != null) {
      entries.add((
        filters.grade!.titleKey.tr(),
        filters.copyWith(clearGrade: true),
      ));
    }

    if (filters.date != null) {
      entries.add((
        // Same formatter as the sheet's date field, so the chip repeats what
        // was picked rather than restating it in another format.
        DateFormat.yMMMd(context.locale.toLanguageTag()).format(filters.date!),
        filters.copyWith(clearDate: true),
      ));
    }

    if (entries.isEmpty) return const SizedBox.shrink();

    // A station name is long enough to outrun the line on its own, and a Wrap
    // child wider than the line overflows rather than wrapping — so each chip
    // is capped at the width available to the row and ellipsises inside it.
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final (label, remaining) in entries)
            _Chip(
              label: label,
              maxWidth: constraints.maxWidth,
              onRemove: () => onChanged(remaining),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.maxWidth,
    required this.onRemove,
  });

  final String label;
  final double maxWidth;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Material(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        child: InkWell(
          // The whole chip removes the filter, not just the glyph: a 14pt
          // icon is well under a comfortable touch target on its own.
          onTap: onRemove,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.tile),
              border: Border.all(color: colors.borderHairline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.close,
                  size: AppSizes.iconSm,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
