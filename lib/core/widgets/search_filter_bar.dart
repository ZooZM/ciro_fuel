import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../shared/models/filter_selection.dart';
import '../../shared/models/station_option.dart';
import '../localization/translation_keys.dart';
import '../../core/theme/theme_context.dart';
import 'active_filter_chips.dart';
import 'app_action_icon.dart';
import 'filter_sheet.dart';

/// The filter button + search field row used above the payments, orders and
/// invoices lists. Extracted from the payments screen so the three list
/// pages share one look (Principle I — no duplicated layout literals).
///
/// The filter button sits at the start of the row and the field expands into
/// the rest, both following the ambient direction rather than assuming RTL.
class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    this.hintText,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.sortOptions = const [],
    this.filterStations = const [],
    this.showFuelTypeFilter = false,
    this.showDateFilter = false,
    this.filters = const FilterSelection(),
    this.onFiltersChanged,
    super.key,
  });

  /// Defaults to the invoice-code hint, which is what the payments and
  /// invoices lists search by. Pass a translated string to override it.
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  /// Overrides the built-in sheet entirely. Leave null to open [FilterSheet]
  /// with the sections below.
  final VoidCallback? onFilterTap;

  // Which sections the sheet shows. The three list screens do not filter by
  // the same things, so each passes its own set rather than the bar guessing.
  final List<SortOption> sortOptions;
  final List<StationOption> filterStations;
  final bool showFuelTypeFilter;
  final bool showDateFilter;

  /// What the sheet opens with, and where the result goes.
  final FilterSelection filters;
  final ValueChanged<FilterSelection>? onFiltersChanged;

  Future<void> _openSheet(BuildContext context) async {
    final result = await FilterSheet.show(
      context,
      sortOptions: sortOptions,
      initial: filters,
      stations: filterStations,
      showFuelType: showFuelTypeFilter,
      showDate: showDateFilter,
    );
    if (result != null) onFiltersChanged?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final showChips = !filters.isEmpty && onFiltersChanged != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _searchRow(context),
        // The applied filters sit under the bar that opened them. Nothing is
        // drawn while none are set, so an unfiltered list keeps its spacing.
        if (showChips) ...[
          const SizedBox(height: 12),
          ActiveFilterChips(
            filters: filters,
            stations: filterStations,
            onChanged: onFiltersChanged!,
          ),
        ],
      ],
    );
  }

  Widget _searchRow(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          // Opaque, not the default `deferToChild`: the funnel is an SVG whose
          // render box reports a hit only where it actually paints, so taps on
          // the chip's rounded corners fell through and the button felt dead.
          behavior: HitTestBehavior.opaque,
          onTap: onFilterTap ?? () => _openSheet(context),
          child: const AppActionIcon.filter(),
        ),
        const SizedBox(width: 12),
        Expanded(
          // No decoration of its own: the theme's `inputDecorationTheme`
          // already gives the field a fill and a rounded outline, so wrapping
          // it in a bordered container drew the outline twice — one rounded
          // rect just inside the other.
          child: SizedBox(
            height: 48,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              // Follows the locale: right-aligned in Arabic, left in English.
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: hintText ?? CommonKeys.searchByInvoiceCode.tr(),
                hintStyle: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.search, color: context.colors.brandBlue),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
