import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';
import '../../../../../core/theme/theme_context.dart';

/// Consignment, truck and driver details, plus a call button and the
/// driver's photo. Right to left: the consignment, the truck, the driver,
/// and their photo on the far edge — flexes measured off the design.
class DriverCard extends StatelessWidget {
  const DriverCard({
    this.fuelType,
    this.quantity,
    this.truckPlate = 'ABC-1234',
    this.driverName = 'أحمد السبيعي',
    this.onCallDriver,
    super.key,
  });

  final String? fuelType;
  final String? quantity;
  final String truckPlate;
  final String driverName;
  final VoidCallback? onCallDriver;

  static const _fuelIconBoxSize = 36.0;
  static const _pumpIconSize = 24.0;
  static const _truckImageWidth = 60.0;
  static const _truckImageHeight = 36.0;
  static const _driverPhotoSize = 54.0;

  @override
  Widget build(BuildContext context) {
    final fuelType = this.fuelType ?? FuelKeys.gasoline95.tr();
    final quantity = this.quantity ?? '20,000 ${CommonKeys.litre.tr()}';

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
                        const SizedBox(height: 6),
                        _Field(
                          label: OrderDetailKeys.quantity.tr(),
                          value: quantity,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: _fuelIconBoxSize,
                    height: _fuelIconBoxSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.colors.purpleTint,
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
            VerticalDivider(
              width: 14,
              thickness: AppSizes.dividerThickness,
              color: context.colors.borderHairline,
            ),
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
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 7),
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
            VerticalDivider(
              width: 14,
              thickness: AppSizes.dividerThickness,
              color: context.colors.borderHairline,
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Field(label: CommonKeys.driver.tr(), value: driverName),
                  const SizedBox(height: AppSpacing.sm),
                  // Dimmed when there is no number to dial, so the control
                  // reads as unavailable instead of looking identical to a
                  // working one and doing nothing on tap.
                  Opacity(
                    opacity: onCallDriver == null ? 0.4 : 1,
                    child: GestureDetector(
                      onTap: onCallDriver,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: context.colors.borderHairline),
                          borderRadius: BorderRadius.circular(
                            AppSizes.orderCreditIconRadius,
                          ),
                        ),
                        child: Icon(
                          Icons.phone_outlined,
                          color: context.colors.textPrimary,
                          size: AppSizes.iconMd,
                        ),
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
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 8),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
