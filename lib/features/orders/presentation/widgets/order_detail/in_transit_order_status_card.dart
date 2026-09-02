import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/widgets/order_flow.dart';
import '../../view/track_order_screen.dart';
import 'status_chip.dart';
import '../../../../../core/theme/theme_context.dart';

/// The order-status card while the delivery is en route: fuel/driver/truck
/// details beside the ETA gauge, the order-flow stepper, and the
/// track/contact actions.
class InTransitOrderStatusCard extends StatelessWidget {
  const InTransitOrderStatusCard({
    required this.orderId,
    this.orderReference = 'ORD-2024-256 · 9 صفر 1448',
    this.fuelType,
    this.quantity,
    this.driverName = 'أحمد السبيعي',
    this.truckPlate = 'ABC-1234',
    this.vehicleVerified = false,
    this.etaMinutes = 35,
    this.progress = 0.75,
    this.onContactDriver,
    super.key,
  });

  final String orderId;
  final String orderReference;
  final String? fuelType;
  final String? quantity;
  final String driverName;
  final String truckPlate;

  /// spec 008 FR-038/FR-047d (SC-006/SC-020): only ever true off the
  /// backend's own `vehicleVerified` — false for an overridden departure,
  /// since an override deliberately records no verification. Never
  /// inferred from `driverSummary`/`truckPlate` merely being present,
  /// which would present an assignment as a proof it never was.
  final bool vehicleVerified;
  final int etaMinutes;
  final double progress;
  final VoidCallback? onContactDriver;

  @override
  Widget build(BuildContext context) {
    final fuelType = this.fuelType ?? FuelKeys.gasoline95.tr();
    final quantity = this.quantity ?? '20,000 ${CommonKeys.litre.tr()}';

    return OrderCard(
      dashed: true,
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: orderReference,
      trailing: StatusChip(
        OrderDetailKeys.inDelivery.tr(),
        color: context.colors.brandBlue,
      ),
      child: Column(
        children: [
          // The journey — gauge, consignment details and the flow — is
          // boxed off from the card's heading and actions.
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(OrderCard.radius),
              border: Border.all(color: context.colors.borderHairline),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _TransitDetailRow(label: fuelType, value: quantity),
                          const SizedBox(height: AppSpacing.md),
                          _TransitDetailRow(
                            label: CommonKeys.driver.tr(),
                            value: driverName,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _TransitDetailRow(
                            label: CommonKeys.truck.tr(),
                            value: truckPlate,
                            icon: Icons.local_shipping_outlined,
                            verified: vehicleVerified,
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
                          builder: (_) => TrackOrderScreen(orderId: orderId),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colors.brandBlue,
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
                      style: const TextStyle(
                        fontSize: 11,
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
                      side: BorderSide(color: context.colors.borderHairline),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.orderTransitButtonPaddingH,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.tile),
                      ),
                    ),
                    icon: Icon(
                      Icons.phone_outlined,
                      color: context.colors.textPrimary,
                      size: AppSizes.icon16,
                    ),
                    label: Text(
                      CommonKeys.contactDriver.tr(),
                      maxLines: 1,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 10.5,
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
    this.verified = false,
  });

  final String label;
  final String value;

  /// Omitted on the consignment line, which the design leaves unglyphed.
  final IconData? icon;

  /// spec 008 FR-038: an honest signal, shown only when the backend's own
  /// `vehicleVerified` says so — never a decoration implying proof the
  /// platform doesn't actually have.
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: context.colors.brandGreen, size: AppSizes.iconLg)
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
                style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (verified) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.verified, size: 14, color: context.colors.brandGreen),
                  ],
                ],
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

  static const _size = 76.0;
  static const _stroke = 8.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: CustomPaint(
        painter: _GaugePainter(
          progress: progress,
          stroke: _stroke,
          color: context.colors.brandGreen,
          trackColor: context.colors.borderHairline,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_shipping, color: context.colors.textPrimary, size: 16),
              Text(
                CommonKeys.arrivalIn.tr(),
                style: TextStyle(color: context.colors.textPrimary, fontSize: 8),
              ),
              Text(
                '$minutes',
                style: TextStyle(
                  color: context.colors.brandGreen,
                  fontSize: 19,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                CommonKeys.minutes.tr(),
                style: TextStyle(color: context.colors.brandGreen, fontSize: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.progress,
    required this.stroke,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final double stroke;

  /// Handed in from the widget above — a painter has no [BuildContext].
  final Color color;
  final Color trackColor;

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
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.stroke != stroke ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}
