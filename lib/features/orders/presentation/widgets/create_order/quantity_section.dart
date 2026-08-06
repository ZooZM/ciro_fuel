import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/number_formatting.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';
import '../../constants/create_order_strings.dart';
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
      return const OrderCard(
        title: CreateOrderStrings.sectionQuantity,
        child: Text(
          CreateOrderStrings.chooseFuelTypeFirst,
          style: TextStyle(color: AppColors.grey, fontSize: 13),
        ),
      );
    }

    final firstIndex = quantities.keys.first;

    return OrderCard(
      title: CreateOrderStrings.sectionQuantity,
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
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Row(
              children: [
                Expanded(
                  child: _CustomQuantityField(
                    controller: controllers[entry.key]!,
                    onChanged: (text) => onCustomQuantityChanged(entry.key, text),
                  ),
                ),
                for (final litres in kOrderQuantities.reversed) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _QuantityTile(
                      litres: litres,
                      selected: entry.value == litres,
                      onTap: () => onPresetSelected(entry.key, litres),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
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
            Text(
              NumberFormatting.thousands(litres),
              style: TextStyle(
                color: selected ? AppColors.blue : AppColors.navy,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              CreateOrderStrings.litre,
              style: TextStyle(
                color: selected ? AppColors.blue : AppColors.navy,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomQuantityField extends StatelessWidget {
  const _CustomQuantityField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.orderFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: CreateOrderStrings.litre,
                hintStyle: TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ),
          ),
          const Icon(Icons.edit_outlined, size: AppSizes.icon16, color: AppColors.grey),
        ],
      ),
    );
  }
}
