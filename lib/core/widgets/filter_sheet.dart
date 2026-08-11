import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../shared/enums/fuel_grade.dart';
import '../../shared/models/filter_selection.dart';
import '../../shared/models/station_option.dart';
import '../localization/translation_keys.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';
import 'app_calendar.dart';
import 'fuel_pump_icon.dart';

/// The filter sheet the orders, invoices and payments lists share.
///
/// Every section is opt-in: the three screens do not filter by the same
/// things, so a screen passes the sort options it supports and omits the
/// sections it has no use for rather than the sheet guessing from a screen id.
class FilterSheet extends StatefulWidget {
  const FilterSheet({
    required this.sortOptions,
    this.initial = const FilterSelection(),
    this.stations = const [],
    this.showFuelType = false,
    this.showDate = false,
    super.key,
  });

  /// In the order they should appear. Pass an empty list to drop the section.
  final List<SortOption> sortOptions;

  final FilterSelection initial;

  /// Empty hides the station section.
  final List<StationOption> stations;

  final bool showFuelType;
  final bool showDate;

  /// Opens the sheet and resolves to the chosen filters, or null if it was
  /// dismissed without applying.
  static Future<FilterSelection?> show(
    BuildContext context, {
    required List<SortOption> sortOptions,
    FilterSelection initial = const FilterSelection(),
    List<StationOption> stations = const [],
    bool showFuelType = false,
    bool showDate = false,
  }) {
    return showModalBottomSheet<FilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // The list screens are branches of a StatefulShellRoute, so the nearest
      // Navigator is the one *inside* the scaffold that draws the bottom nav
      // bar — a sheet pushed there leaves the bar sitting on top of it. The
      // root navigator covers the whole app.
      useRootNavigator: true,
      builder: (_) => FilterSheet(
        sortOptions: sortOptions,
        initial: initial,
        stations: stations,
        showFuelType: showFuelType,
        showDate: showDate,
      ),
    );
  }

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late FilterSelection _selection = widget.initial;

  void _reset() => setState(() => _selection = const FilterSelection());

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // The app's own calendar, not Material's: `showDatePicker` brings chrome
    // that looks nothing like the rest of these screens.
    final picked = await showAppDatePicker(
      context,
      selected: _selection.date,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selection = _selection.copyWith(date: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      // Half the screen at most. The sections are opt-in, so a screen showing
      // only a sort row still gets a short sheet — this is the ceiling, not a
      // fixed height, so nothing sits over dead space.
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _DragHandle(),
            _Header(onClose: () => Navigator.of(context).pop()),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.sortOptions.isNotEmpty) ...[
                      _SectionLabel(FilterKeys.sortBy.tr()),
                      _SortRow(
                        options: widget.sortOptions,
                        selected: _selection.sort,
                        onSelect: (option) => setState(
                          () => _selection = option == _selection.sort
                              ? _selection.copyWith(clearSort: true)
                              : _selection.copyWith(sort: option),
                        ),
                      ),
                    ],
                    if (widget.stations.isNotEmpty) ...[
                      _SectionLabel(FilterKeys.station.tr()),
                      for (final station in widget.stations) ...[
                        _StationCheck(
                          station: station,
                          checked: _selection.stationIds.contains(station.id),
                          onChanged: () => setState(() {
                            final ids = {..._selection.stationIds};
                            ids.contains(station.id)
                                ? ids.remove(station.id)
                                : ids.add(station.id);
                            _selection = _selection.copyWith(stationIds: ids);
                          }),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                    if (widget.showFuelType) ...[
                      _SectionLabel(FilterKeys.fuelType.tr()),
                      _GradeRow(
                        selected: _selection.grade,
                        onSelect: (grade) => setState(
                          () => _selection = grade == _selection.grade
                              ? _selection.copyWith(clearGrade: true)
                              : _selection.copyWith(grade: grade),
                        ),
                      ),
                    ],
                    if (widget.showDate) ...[
                      _SectionLabel(FilterKeys.date.tr()),
                      _DateField(date: _selection.date, onTap: _pickDate),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            _Footer(
              count: _selection.activeCount,
              onReset: _reset,
              onApply: () => Navigator.of(context).pop(_selection),
            ),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: Container(
          width: 44,
          height: 5,
          decoration: BoxDecoration(
            color: context.colors.textTertiary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              FilterKeys.title.tr(),
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close, color: context.colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.md),
      child: Text(
        text,
        style: TextStyle(
          color: context.colors.textTertiary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// The sort chips. Scrolls rather than wrapping: four chips of Arabic copy
/// already fill the width, and English runs longer still.
class _SortRow extends StatelessWidget {
  const _SortRow({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<SortOption> options;
  final SortOption? selected;
  final ValueChanged<SortOption> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (index, option) in options.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: option == selected
                      ? colors.brandBlue
                      : colors.surface2,
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
                child: Text(
                  option.labelKey.tr(),
                  style: TextStyle(
                    color: option == selected
                        ? Colors.white
                        : colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StationCheck extends StatelessWidget {
  const _StationCheck({
    required this.station,
    required this.checked,
    required this.onChanged,
  });

  final StationOption station;
  final bool checked;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isArabic = context.locale.languageCode == 'ar';

    return InkWell(
      onTap: onChanged,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(color: colors.borderHairline),
        ),
        child: Row(
          children: [
            // Pin leads, checkbox trails — right and left respectively under
            // Arabic, mirrored under English.
            Icon(
              Icons.location_on_outlined,
              size: AppSizes.iconLg,
              color: colors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.md),
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
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: checked,
                onChanged: (_) => onChanged(),
                activeColor: colors.surface,
                checkColor: colors.brandBlue,
                side: BorderSide(color: colors.borderHairline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The fuel-grade tiles, reusing the order form's pump artwork so the two
/// screens cannot drift apart.
class _GradeRow extends StatelessWidget {
  const _GradeRow({required this.selected, required this.onSelect});

  final FuelGrade? selected;
  final ValueChanged<FuelGrade> onSelect;

  static const _tileWidth = 92.0;
  static const _pumpSize = 38.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (index, grade) in FuelGrade.values.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: () => onSelect(grade),
              child: Container(
                width: _tileWidth,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: grade == selected ? colors.greenTint : colors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                  border: Border.all(
                    color: grade == selected
                        ? colors.brandGreen
                        : colors.borderHairline,
                    width: grade == selected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        FuelPumpIcon(
                          grade: grade.badge,
                          color: grade.color,
                          size: _pumpSize,
                        ),
                        if (grade == selected)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.surface,
                              ),
                              child: Icon(
                                Icons.check_circle,
                                size: AppSizes.iconMd,
                                color: colors.brandGreen,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      grade.titleKey.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(color: colors.borderHairline),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CreateOrderKeys.scheduleTitle.tr(),
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date == null
                        ? CreateOrderKeys.scheduleSubtitle.tr()
                        : DateFormat.yMMMd(
                            context.locale.toLanguageTag(),
                          ).format(date!),
                    style: TextStyle(color: colors.textTertiary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(Icons.event_outlined, size: 28, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.count,
    required this.onReset,
    required this.onApply,
  });

  final int count;
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            flex: 55,
            child: FilledButton.icon(
              onPressed: onApply,
              style: FilledButton.styleFrom(
                backgroundColor: colors.brandBlue,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
              label: Text(
                FilterKeys.apply.tr(namedArgs: {'count': '$count'}),
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 45,
            child: OutlinedButton.icon(
              onPressed: onReset,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                side: BorderSide(color: colors.borderHairline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              icon: Icon(Icons.refresh, color: colors.brandBlue),
              label: Text(
                FilterKeys.reset.tr(),
                maxLines: 1,
                style: TextStyle(
                  color: colors.brandBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
