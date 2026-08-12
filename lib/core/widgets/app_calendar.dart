import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

/// The app's month calendar.
///
/// Replaces Material's `showDatePicker`, whose chrome is nothing like the rest
/// of the app. Month and weekday names come from the active locale, and the
/// grid mirrors with it — Saturday leads under Arabic the same way Sunday
/// leads under English, because both are simply the first column.
class AppCalendar extends StatefulWidget {
  const AppCalendar({
    this.selected,
    this.initialMonth,
    this.firstDate,
    this.lastDate,
    required this.onSelect,
    super.key,
  });

  final DateTime? selected;

  /// Which month opens. Defaults to [selected]'s, or this month.
  final DateTime? initialMonth;

  /// Days outside these bounds are shown greyed and cannot be picked. Null
  /// means unbounded.
  final DateTime? firstDate;
  final DateTime? lastDate;

  final ValueChanged<DateTime> onSelect;

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _month = _monthOf(
    widget.initialMonth ?? widget.selected ?? DateTime.now(),
  );

  static DateTime _monthOf(DateTime d) => DateTime(d.year, d.month);
  static DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  void _step(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));

  bool _isEnabled(DateTime day) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    if (first != null && day.isBefore(_dayOf(first))) return false;
    if (last != null && day.isAfter(_dayOf(last))) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = context.locale.toLanguageTag();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.sheet),
        border: Border.all(color: colors.borderHairline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(
            label: DateFormat.yMMMM(locale).format(_month),
            onPrevious: () => _step(-1),
            onNext: () => _step(1),
          ),
          const SizedBox(height: AppSpacing.lg),
          _WeekdayRow(locale: locale),
          const SizedBox(height: AppSpacing.sm),
          _MonthGrid(
            month: _month,
            selected: widget.selected,
            isEnabled: _isEnabled,
            onSelect: widget.onSelect,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.label,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const Spacer(),
        // `chevron_left` is `matchTextDirection`, so it points back in either
        // direction — left under English, right under Arabic — and the pair
        // swaps sides with the row. Nothing here may pick the icon by hand.
        _Arrow(icon: Icons.chevron_left, onTap: onPrevious),
        const SizedBox(width: AppSpacing.sm),
        _Arrow(icon: Icons.chevron_right, onTap: onNext),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(icon, size: 26, color: context.colors.brandBlue),
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    // Any Sunday, so the labels come out in the column order the grid uses.
    final sunday = DateTime(2024, 1, 7);
    final format = DateFormat.E(locale);

    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Text(
              format.format(sunday.add(Duration(days: i))).toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: context.colors.textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.selected,
    required this.isEnabled,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime? selected;
  final bool Function(DateTime) isEnabled;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // `DateTime.weekday` runs Monday..Sunday as 1..7; `% 7` turns that into
    // Sunday-first column indices, which is the order the header row uses.
    final leadingBlanks = DateTime(month.year, month.month).weekday % 7;
    final cells = leadingBlanks + daysInMonth;
    final rows = (cells / 7).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < rows; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final dayNumber = row * 7 + col - leadingBlanks + 1;
                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        return const AspectRatio(
                          aspectRatio: 1,
                          child: SizedBox.shrink(),
                        );
                      }
                      final date = DateTime(month.year, month.month, dayNumber);
                      return _DayCell(
                        date: date,
                        selected: selected != null && _sameDay(selected!, date),
                        isToday: _sameDay(DateTime.now(), date),
                        enabled: isEnabled(date),
                        onTap: () => onSelect(date),
                      );
                    },
                  ),
                ),
            ],
          ),
      ],
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.selected,
    required this.isToday,
    required this.enabled,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool isToday;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final Color ink;
    if (!enabled) {
      ink = colors.textTertiary;
    } else if (selected || isToday) {
      ink = colors.brandBlue;
    } else {
      ink = colors.textPrimary;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Only the chosen day carries the disc; today is marked by its
              // ink alone, as in the design.
              color: selected ? colors.blueTint : Colors.transparent,
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: ink,
                fontSize: 16,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens [AppCalendar] in a dialog and resolves to the chosen day, or null if
/// it was dismissed.
Future<DateTime?> showAppDatePicker(
  BuildContext context, {
  DateTime? selected,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: AppCalendar(
        selected: selected,
        firstDate: firstDate,
        lastDate: lastDate,
        onSelect: (date) => Navigator.of(context).pop(date),
      ),
    ),
  );
}
