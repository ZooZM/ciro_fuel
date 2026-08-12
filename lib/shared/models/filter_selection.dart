import '../../core/localization/translation_keys.dart';
import '../enums/fuel_grade.dart';

/// One entry in the sheet's "sort by" row.
///
/// The list is passed in rather than fixed, because the three list screens do
/// not sort by the same things — orders sort by quantity, invoices and
/// payments by amount.
enum SortOption {
  newestFirst(FilterKeys.newestFirst),
  oldestFirst(FilterKeys.oldestFirst),
  highestQuantity(FilterKeys.highestQuantity),
  lowestQuantity(FilterKeys.lowestQuantity),
  highestAmount(FilterKeys.highestAmount),
  lowestAmount(FilterKeys.lowestAmount);

  const SortOption(this.labelKey);

  /// Translation key — call `.tr()` where it is drawn so it follows a locale
  /// switch.
  final String labelKey;
}

/// What the filter sheet hands back.
///
/// Every field is optional: a screen that does not show a section simply
/// never sets it, and [activeCount] then leaves it out of the badge on the
/// apply button.
class FilterSelection {
  const FilterSelection({
    this.sort,
    this.stationIds = const {},
    this.grade,
    this.date,
  });

  final SortOption? sort;
  final Set<String> stationIds;
  final FuelGrade? grade;
  final DateTime? date;

  bool get isEmpty =>
      sort == null && stationIds.isEmpty && grade == null && date == null;

  /// What the apply button counts. Stations count once each, which is what
  /// the design's "( 4 )" against two stations, a grade and a sort adds up to.
  int get activeCount =>
      (sort == null ? 0 : 1) +
      stationIds.length +
      (grade == null ? 0 : 1) +
      (date == null ? 0 : 1);

  FilterSelection copyWith({
    SortOption? sort,
    Set<String>? stationIds,
    FuelGrade? grade,
    DateTime? date,
    bool clearSort = false,
    bool clearGrade = false,
    bool clearDate = false,
  }) => FilterSelection(
    sort: clearSort ? null : (sort ?? this.sort),
    stationIds: stationIds ?? this.stationIds,
    grade: clearGrade ? null : (grade ?? this.grade),
    date: clearDate ? null : (date ?? this.date),
  );
}
