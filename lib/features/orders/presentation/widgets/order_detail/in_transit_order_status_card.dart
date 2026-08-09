import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/widgets/order_flow.dart';
import '../../constants/order_formatting.dart';
import '../../constants/order_mock_data.dart';
import '../../view/track_order_screen.dart';
import 'status_chip.dart';

/// The order-status card while the delivery is en route: fuel/driver/truck
/// details beside the ETA gauge, the order-flow stepper, and the
/// track/contact actions.
class InTransitOrderStatusCard extends StatelessWidget {
  const InTransitOrderStatusCard({
    this.orderReference = OrderMockData.orderReference,
    this.fuelType = OrderMockData.fuelGrade,
    this.quantityLitres = OrderMockData.quantityLitres,
    this.driverName = OrderMockData.driverName,
    this.truckPlate = OrderMockData.truckPlate,
    this.etaMinutes = OrderMockData.etaMinutes,
    this.progress = OrderMockData.journeyProgress,
    this.onContactDriver,
    super.key,
  });

  final String orderReference;
  final String fuelType;
  final int quantityLitres;
  final String driverName;
  final String truckPlate;
  final int etaMinutes;
  final double progress;
  final VoidCallback? onContactDriver;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      dashed: true,
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: orderReference,
      trailing: StatusChip(
        OrderDetailKeys.inDelivery.tr(),
        color: AppColors.blue,
      ),
      child: Column(
        children: [
          // The journey — gauge, consignment details and the flow — is
          // boxed off from the card's heading and actions.
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(OrderCard.radius),
              border: Border.all(color: AppColors.itemBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _TransitDetailRow(
                            label: fuelType,
                            value: OrderFormatting.litres(quantityLitres),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _TransitDetailRow(
                            label: OrderDetailKeys.driver.tr(),
                            value: driverName,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _TransitDetailRow(
                            label: OrderDetailKeys.truck.tr(),
                            value: truckPlate,
                            icon: Icons.local_shipping_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    _EtaGauge(minutes: etaMinutes, progress: progress),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                const OrderFlow(),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                flex: 55,
                child: SizedBox(
                  height: AppSizes.secondaryButtonHeight,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TrackOrderScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.orderTransitButtonPaddingH,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.tile),
                      ),
                    ),
                    icon: const Icon(
                      Icons.map_outlined,
                      size: AppSizes.icon16,
                      color: Colors.white,
                    ),
                    label: Text(
                      OrderDetailKeys.trackOnMap.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 45,
                child: SizedBox(
                  height: AppSizes.secondaryButtonHeight,
                  child: OutlinedButton.icon(
                    onPressed: onContactDriver ?? () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.itemBorder),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.orderTransitButtonPaddingH,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.tile),
                      ),
                    ),
                    icon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.navy,
                      size: AppSizes.icon16,
                    ),
                    label: Text(
                      OrderDetailKeys.contactDriver.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: AppFontSizes.micro,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A label/value pair with its glyph on the trailing side, as the
/// in-transit card stacks the fuel, driver and truck.
class _TransitDetailRow extends StatelessWidget {
  const _TransitDetailRow({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;

  /// Omitted on the consignment line, which the design leaves unglyphed.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: AppColors.green, size: AppSizes.iconLg)
        else
          const SizedBox(width: AppSizes.iconLg),
        const SizedBox(width: AppSizes.orderTransitIconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppFontSizes.micro,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: AppFontSizes.body,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The "arriving in N minutes" dial: a ring showing how far along the run
/// is, wrapped around the truck and the countdown.
class _EtaGauge extends StatelessWidget {
  const _EtaGauge({required this.minutes, required this.progress});

  final int minutes;

  /// Share of the journey behind the driver. The arc opens at twelve
  /// o'clock and sweeps clockwise, so the gap it leaves sits at the upper
  /// left.
  final double progress;

  static const _countdownLineHeight = 1.1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.orderGaugeSize,
      height: AppSizes.orderGaugeSize,
      child: CustomPaint(
        painter: _GaugePainter(
          progress: progress,
          stroke: AppSizes.orderGaugeStroke,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_shipping,
                color: AppColors.navy,
                size: AppSizes.icon16,
              ),
              Text(
                OrderDetailKeys.arrivalIn.tr(),
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: AppFontSizes.nano,
                ),
              ),
              Text(
                '$minutes',
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: AppFontSizes.titleLarge,
                  height: _countdownLineHeight,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                OrderDetailKeys.minutes.tr(),
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: AppFontSizes.nano,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.progress, required this.stroke});

  final double progress;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = AppColors.track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..color = AppColors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.stroke != stroke;
}
