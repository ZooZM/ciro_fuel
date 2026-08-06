import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';
import '../../constants/order_detail_strings.dart';
import '../../constants/track_order_strings.dart';

/// Consignment, truck and driver details, plus a call button and the
/// driver's photo. Right to left: the consignment, the truck, the driver,
/// and their photo on the far edge — flexes measured off the design.
class DriverCard extends StatelessWidget {
  const DriverCard({
    this.fuelType = 'بنزين 95',
    this.quantity = '20,000 لتر',
    this.truckPlate = 'ABC-1234',
    this.driverName = 'أحمد السبيعي',
    this.onCallDriver,
    super.key,
  });

  final String fuelType;
  final String quantity;
  final String truckPlate;
  final String driverName;
  final VoidCallback? onCallDriver;

  static const _fuelIconBoxSize = 36.0;
  static const _fuelIconTint = Color(0xFFF3E8FF);
  static const _pumpIconSize = 24.0;
  static const _truckImageWidth = 60.0;
  static const _truckImageHeight = 36.0;
  static const _driverPhotoSize = 54.0;

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
                        _Field(label: OrderDetailStrings.fuelType, value: fuelType),
                        const SizedBox(height: 6),
                        _Field(label: OrderDetailStrings.quantity, value: quantity),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: _fuelIconBoxSize,
                    height: _fuelIconBoxSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _fuelIconTint,
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
            const VerticalDivider(
              width: 14,
              thickness: AppSizes.dividerThickness,
              color: AppColors.itemBorder,
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Field(
                    label: TrackOrderStrings.vehicle,
                    value: truckPlate,
                    center: true,
                  ),
                  const Text(
                    TrackOrderStrings.fuelTankerTruck,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.grey, fontSize: 7),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Image.asset(
                    AppAssets.orderTankTruckImage,
                    width: _truckImageWidth,
                    height: _truckImageHeight,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              width: 14,
              thickness: AppSizes.dividerThickness,
              color: AppColors.itemBorder,
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Field(label: OrderDetailStrings.driverLabel, value: driverName),
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: onCallDriver,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
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
                width: _driverPhotoSize,
                height: _driverPhotoSize,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
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
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.grey, fontSize: 8),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
