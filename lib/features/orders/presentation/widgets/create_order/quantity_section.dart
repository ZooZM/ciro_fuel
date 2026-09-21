import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/number_formatting.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';
import '../../../../../core/theme/theme_context.dart';

/// "3. الكمية" — one quantity row per selected grade: the لتر box and the
/// preset litre tiles, with the counter folded away underneath. The grade label
/// only shows once more than one grade is being ordered at a time.
class QuantitySection extends StatefulWidget {
  const QuantitySection({
    required this.quantities,
    required this.onPresetSelected,
    required this.tileQuantities,
    required this.counterQuantities,
    required this.emptyMessage,
    super.key,
  });

  /// Grade index → chosen litres. Always one of [counterQuantities]: the
  /// row offers no way to enter an amount off that ladder.
  final Map<int, int> quantities;
  final void Function(int gradeIndex, int litres) onPresetSelected;

  /// The client's own fuel company's tanker capacities (spec 005 FR-017),
  /// smallest-first — sourced from `PricingConfig.tankerCapacitiesLiters`,
  /// never a list fixed in the app. [tileQuantities] (a small, featured
  /// subset) drives the row of quick-pick tiles; [counterQuantities] is the
  /// full ladder the +/− counter steps through — both must stay ascending,
  /// and every [tileQuantities] value must also appear in
  /// [counterQuantities], or a tile could select a size the counter cannot
  /// step away from.
  final List<int> tileQuantities;
  final List<int> counterQuantities;

  /// What the card says when [quantities] is empty. Supplied by the screen
  /// rather than fixed here, because "pick a fuel type first" and "the
  /// company published no tanker sizes to pick from" are different states
  /// that look identical from inside this row.
  final String emptyMessage;

  @override
  State<QuantitySection> createState() => _QuantitySectionState();
}

class _QuantitySectionState extends State<QuantitySection> {
  /// Grade indices whose counter is open. Which grades those are is a property
  /// of this row alone — the screen only cares about the litres it settles on —
  /// so it is kept here rather than pushed up with the quantities.
  final Set<int> _openCounters = {};

  /// Whether the counter can actually reach a size the tiles do not already
  /// offer. With one published tanker capacity — which is a perfectly normal
  /// thing for a fuel company to have — the ladder has a single rung, so both
  /// stepper buttons are correctly disabled and the لتر box opens a control
  /// that provably cannot do anything. Offering it is what's wrong, not the
  /// buttons: a disabled pair reads as broken rather than as "there is only
  /// one size".
  bool get _counterCanMove =>
      widget.counterQuantities.length > widget.tileQuantities.length;

  void _toggleCounter(int gradeIndex) {
    setState(() {
      if (!_openCounters.remove(gradeIndex)) _openCounters.add(gradeIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final quantities = widget.quantities;
    if (quantities.isEmpty) {
      return OrderCard(
        title: CreateOrderKeys.sectionQuantity.tr(),
        child: Text(
          widget.emptyMessage,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
        ),
      );
    }

    final firstIndex = quantities.keys.first;

    return OrderCard(
      title: CreateOrderKeys.sectionQuantity.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final entry in quantities.entries) ...[
            if (entry.key != firstIndex) ...[
              const SizedBox(height: AppSpacing.md),
              Divider(color: context.colors.borderHairline),
              const SizedBox(height: AppSpacing.md),
            ],
            if (quantities.length > 1) ...[
              Text(
                FuelGrade.values[entry.key].titleKey.tr(),
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (_counterCanMove)
                    SizedBox(
                      width: AppSizes.orderQuantityFieldWidth,
                      child: _CustomQuantityTile(
                        open: _openCounters.contains(entry.key),
                        onTap: () => _toggleCounter(entry.key),
                      ),
                    ),
                  for (final litres in widget.tileQuantities.reversed) ...[
                    const SizedBox(width: AppSpacing.sm),
                    SizedBox(
                      width: AppSizes.orderQuantityTileWidth,
                      child: _QuantityTile(
                        litres: litres,
                        selected: entry.value == litres,
                        onTap: () =>
                            widget.onPresetSelected(entry.key, litres),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // The counter is how the sizes without a tile are reached, so it
            // stays folded away until the لتر box asks for it.
            if (_counterCanMove && _openCounters.contains(entry.key)) ...[
              const SizedBox(height: AppSpacing.sm),
              _QuantityCounter(
                litres: entry.value,
                counterQuantities: widget.counterQuantities,
                onChanged: (litres) =>
                    widget.onPresetSelected(entry.key, litres),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// The counter from the design: the litres in the middle, `−` and `+` on
/// either side. The buttons walk [counterQuantities] rather than adding a
/// free amount, so every order lands on a size the fleet carries. This is the
/// only way to reach the sizes the row has no tile for.
class _QuantityCounter extends StatelessWidget {
  const _QuantityCounter({
    required this.litres,
    required this.counterQuantities,
    required this.onChanged,
  });

  final int litres;
  final List<int> counterQuantities;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // -1 for a quantity off the ladder, which leaves both buttons disabled
    // rather than jumping to an arbitrary end of it.
    final index = counterQuantities.indexOf(litres);
    final previous = index > 0 ? counterQuantities[index - 1] : null;
    final next = index >= 0 && index < counterQuantities.length - 1
        ? counterQuantities[index + 1]
        : null;

    return Container(
      height: AppSizes.orderFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.field),
        // Blue, matching the لتر box that opened it.
        border: Border.all(
          color: colors.brandBlue,
          width: AppSizes.orderTileSelectedBorderWidth,
        ),
      ),
      // `−` sits at the start and `+` at the end, so the pair mirrors with the
      // locale — plus on the left under Arabic, as the design has it.
      child: Row(
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: previous == null ? null : () => onChanged(previous),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  NumberFormatting.thousands(litres),
                  maxLines: 1,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  // "وحدة", as the design labels the counter — the tiles and
                  // the لتر box are the ones that spell out the unit.
                  CommonKeys.unit.tr(),
                  maxLines: 1,
                  style: TextStyle(color: colors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: next == null ? null : () => onChanged(next),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;

  /// Null at either end of the counter ladder — the button greys out instead
  /// of disappearing, so the counter keeps its shape.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.orderQuantityStepperButtonSide,
        height: AppSizes.orderQuantityStepperButtonSide,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(AppRadii.tile),
        ),
        child: Icon(
          icon,
          size: AppSizes.iconXl,
          color: enabled ? colors.brandBlue : colors.textTertiary,
        ),
      ),
    );
  }
}

class _QuantityTile extends StatelessWidget {
  const _QuantityTile({
    required this.litres,
    required this.selected,
    required this.onTap,
  });

  final int litres;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.orderFieldHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? context.colors.blueTint : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? context.colors.brandBlue : context.colors.borderHairline,
            width: selected
                ? AppSizes.orderTileSelectedBorderWidth
                : AppSizes.orderTileBorderWidth,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              NumberFormatting.thousands(litres),
              style: TextStyle(
                color: selected ? context.colors.brandBlue : context.colors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              CommonKeys.litre.tr(),
              style: TextStyle(
                color: selected ? context.colors.brandBlue : context.colors.textPrimary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The لتر box at the head of the quantity row: the handle that opens the
/// counter. A label and the pencil glyph, not a field — quantities are chosen
/// from the tiles and the counter, so there is no typed amount to hold.
class _CustomQuantityTile extends StatelessWidget {
  const _CustomQuantityTile({required this.open, required this.onTap});

  /// Whether the counter it opens is currently showing. Tapping again folds it
  /// away, so the box carries the blue while it is out.
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ink = open ? colors.brandBlue : colors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.orderFieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: open ? colors.brandBlue : colors.borderHairline,
            width: open
                ? AppSizes.orderTileSelectedBorderWidth
                : AppSizes.orderTileBorderWidth,
          ),
        ),
        // Glyph first so the pair mirrors with the locale — pencil on the
        // right under Arabic, as the design has it.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.orderCustomQuantityIcon,
              width: AppSizes.iconLg,
              height: AppSizes.iconLg,
              // The file carries the design's grey inline; recolouring keeps
              // it legible on the dark theme too.
              colorFilter: ColorFilter.mode(ink, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              CommonKeys.litre.tr(),
              style: TextStyle(color: ink, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
