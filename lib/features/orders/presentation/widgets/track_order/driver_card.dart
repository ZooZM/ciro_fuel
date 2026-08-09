import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';
import '../../constants/order_formatting.dart';
import '../../constants/order_mock_data.dart';

/// Consignment, truck and driver details, plus a call button and the
/// driver's photo. Right to left: the consignment, the truck, the driver,
/// and their photo on the far edge — flexes measured off the design.
class DriverCard extends StatelessWidget {
  const DriverCard({
    this.fuelType = OrderMockData.fuelGrade,
    this.quantityLitres = OrderMockData.quantityLitres,
    this.truckPlate = OrderMockData.truckPlate,
    this.driverName = OrderMockData.driverName,
    this.onCallDriver,
    super.key,
  });

  final String fuelType;
  final int quantityLitres;
  final String truckPlate;
  final String driverName;
  final VoidCallback? onCallDriver;

  static const _fuelIconBoxSize = 36.0;
  static const _pumpIconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Field(
                          label: OrderDetailKeys.fuelType.tr(),
                          value: fuelType,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _Field(
                          label: OrderDetailKeys.quantity.tr(),
                          value: OrderFormatting.litres(quantityLitres),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    width: _fuelIconBoxSize,
                    height: _fuelIconBoxSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.light.purpleTint,
                      borderRadius: BorderRadius.circular(
                        AppSizes.orderCreditIconRadius,
                      ),
                    ),
                    child: FuelPumpIcon(
                      grade: FuelGrade.gasoline95.badge,
                      color: FuelGrade.gasoline95.color,
                      size: _pumpIconSize,
                    ),
                  ),
                ],
              ),
            ),
            const _Divider(),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Field(
                    label: TrackOrderKeys.vehicle.tr(),
                    value: truckPlate,
                    center: true,
                  ),
                  Text(
                    TrackOrderKeys.fuelTankerTruck.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: AppFontSizes.nano,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Image.asset(
                    AppAssets.orderTankTruckImage,
                    width: AppSizes.orderTruckImageWidth,
                    height: AppSizes.orderTruckImageHeight,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const _Divider(),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Field(
                    label: OrderDetailKeys.driver.tr(),
                    value: driverName,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: onCallDriver,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.itemBorder),
                        borderRadius: BorderRadius.circular(
                          AppSizes.orderCreditIconRadius,
                        ),
                      ),
                      child: const Icon(
                        Icons.phone_outlined,
                        color: AppColors.navy,
                        size: AppSizes.iconMd,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            ClipOval(
              child: Image.asset(
                AppAssets.orderDriverPhoto,
                width: AppSizes.orderDriverPhotoSize,
                height: AppSizes.orderDriverPhotoSize,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The hairline between the card's three groups.
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      width: AppSizes.orderDividerWidth,
      thickness: AppSizes.dividerThickness,
      color: AppColors.itemBorder,
    );
  }
}

/// A muted label over its value, as the tracking cards stack every fact.
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, this.center = false});

  final String label;
  final String value;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: AppFontSizes.nano,
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: AppFontSizes.caption,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
