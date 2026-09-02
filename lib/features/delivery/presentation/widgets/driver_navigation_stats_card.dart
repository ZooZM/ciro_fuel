import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/theme/theme_context.dart';

class DriverNavigationStatsCard extends StatelessWidget {
  const DriverNavigationStatsCard({
    required this.orderId,
    required this.fuelType,
    this.distance,
    this.expectedTime,
    super.key,
  });

  final String orderId;
  final String fuelType;
  // Null (never a guessed figure) until the platform has both a driver
  // position and an ETA to derive these from (FR-029).
  final String? distance;
  final String? expectedTime;

  @override
  Widget build(BuildContext context) {
    final distance = this.distance ?? OrdersKeys.locationUnavailable.tr();
    final expectedTime = this.expectedTime ?? OrdersKeys.locationUnavailable.tr();

    // In RTL, the first child in a Row appears on the RIGHT.
    // Design order (right to left): نوع الوقود | الوقت المتوقع | المسافة المتبقية | رقم الطلب
    return OrderCard(
      child: IntrinsicHeight(
        child: Row(
          children: [
            // نوع الوقود (Fuel Type) — rightmost in RTL
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            DriverNavigationKeys.fuelType.tr(),
                            style: TextStyle(color: context.colors.textSecondary, fontSize: 8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            fuelType,
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0EFFF),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/driverOrderPage/station 98.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8B5CF6),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: AppSizes.dividerThickness,
              color: context.colors.borderHairline,
            ),
            // الوقت المتوقع (Expected Time)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      DriverNavigationKeys.expectedTime.tr(),
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      expectedTime,
                      style: TextStyle(
                        color: context.colors.brandGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: AppSizes.dividerThickness,
              color: context.colors.borderHairline,
            ),
            // المسافة المتبقية (Remaining Distance)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      DriverNavigationKeys.remainingDistance.tr(),
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      distance,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: AppSizes.dividerThickness,
              color: context.colors.borderHairline,
            ),
            // رقم الطلب (Order ID) — leftmost in RTL
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      DriverNavigationKeys.orderId.tr(),
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            orderId,
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        AppAssets.copyIcon,
                        width: AppSizes.iconXs,
                        height: AppSizes.iconXs,
                        colorFilter: ColorFilter.mode(
                          context.colors.brandGreen,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
