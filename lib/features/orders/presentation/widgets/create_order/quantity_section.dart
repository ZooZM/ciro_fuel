import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/number_formatting.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';
import 'create_order_data.dart';

/// "3. الكمية" — one quantity row per selected grade: a custom-amount
/// field plus the three preset litre tiles. The grade label only shows
/// once more than one grade is being ordered at a time.
class QuantitySection extends StatelessWidget {
  const QuantitySection({
    required this.quantities,
    required this.controllers,
    required this.onCustomQuantityChanged,
    required this.onPresetSelected,
    super.key,
  });

  /// Grade index → chosen preset litres, or null while a custom amount is
  /// being typed.
  final Map<int, int?> quantities;
  final Map<int, TextEditingController> controllers;
  final void Function(int gradeIndex, String text) onCustomQuantityChanged;
  final void Function(int gradeIndex, int litres) onPresetSelected;

  @override
  Widget build(BuildContext context) {
    if (quantities.isEmpty) {
      return OrderCard(
        title: CreateOrderKeys.sectionQuantity.tr(),
        child: Text(
          CreateOrderKeys.chooseFuelTypeFirst.tr(),
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: AppFontSizes.body,
          ),
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
              const Divider(color: AppColors.itemBorder),
              const SizedBox(height: AppSpacing.md),
            ],
            if (quantities.length > 1) ...[
              Text(
                FuelGrade.values[entry.key].title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: AppFontSizes.body,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            _QuantityTileGrid(
              tiles: [
                _CustomQuantityField(
                  controller: controllers[entry.key]!,
                  onChanged: (text) =>
                      onCustomQuantityChanged(entry.key, text),
                ),
                for (final litres in kOrderQuantities.reversed)
                  _QuantityTile(
                    litres: litres,
                    selected: entry.value == litres,
                    onTap: () => onPresetSelected(entry.key, litres),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Lays the four tiles out on one row where they fit, and folds to two rows
/// of two where they don't — on a narrow phone four across leaves under
/// 70pt each, which clips "33,000" to an ellipsis.
class _QuantityTileGrid extends StatelessWidget {
  const _QuantityTileGrid({required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gaps = tiles.length - 1;
        final singleRowTileWidth =
            (constraints.maxWidth - gaps * AppSpacing.sm) / tiles.length;
        final perRow = singleRowTileWidth >= AppSizes.orderQuantityTileMinWidth
            ? tiles.length
            : 2;

        return Column(
          children: [
            for (var start = 0; start < tiles.length; start += perRow) ...[
              if (start > 0) const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  for (var i = start; i < start + perRow; i++) ...[
                    if (i > start) const SizedBox(width: AppSpacing.sm),
                    // The last row of a folded layout can be short; an empty
                    // Expanded keeps its tiles the same width as the rest.
                    Expanded(
                      child: i < tiles.length ? tiles[i] : const SizedBox(),
                    ),
                  ],
                ],
              ),
            ],
          ],
        );
      },
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
    final color = selected ? AppColors.blue : AppColors.navy;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.orderFieldHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? AppColors.blueTintAlt : Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? AppColors.blue : AppColors.itemBorder,
            width: selected
                ? AppSizes.orderTileSelectedBorderWidth
                : AppSizes.orderTileBorderWidth,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scales rather than truncates: the amount is the whole point of
            // the tile, so it has to stay readable at any tile width.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                NumberFormatting.thousands(litres),
                maxLines: 1,
                style: TextStyle(
                  color: color,
                  fontSize: AppFontSizes.bodyLarge,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              OrdersKeys.litreUnit.tr(),
              maxLines: 1,
              style: TextStyle(color: color, fontSize: AppFontSizes.caption),
            ),
          ],
        ),
      ),
    );
  }
}

/// The "type your own amount" tile. Built to the same silhouette as
/// [_QuantityTile] — value over unit — so the four read as one row.
class _CustomQuantityField extends StatelessWidget {
  const _CustomQuantityField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.orderFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: AppFontSizes.bodyLarge,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: CreateOrderKeys.customQuantity.tr(),
              hintStyle: const TextStyle(
                color: AppColors.grey,
                fontSize: AppFontSizes.footnote,
              ),
            ),
          ),
          // The pencil sits on the unit line rather than beside the input:
          // it is what marks this tile as the editable one, and inline it
          // stole a fifth of an already narrow field.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.edit_outlined,
                size: AppSizes.iconXs,
                color: AppColors.grey,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                OrdersKeys.litreUnit.tr(),
                maxLines: 1,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppFontSizes.caption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
