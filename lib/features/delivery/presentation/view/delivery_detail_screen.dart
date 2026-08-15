import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../orders/presentation/widgets/order_detail/status_chip.dart';
import 'driver_navigation_screen.dart';

enum _OrderMockState { assigned, outForDelivery, completed }

class DeliveryDetailScreen extends StatefulWidget {
  const DeliveryDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  _OrderMockState _mockState = _OrderMockState.assigned;

  void _cycleMockState() {
    setState(() {
      if (_mockState == _OrderMockState.assigned) {
        _mockState = _OrderMockState.outForDelivery;
      } else if (_mockState == _OrderMockState.outForDelivery) {
        _mockState = _OrderMockState.completed;
      } else {
        _mockState = _OrderMockState.assigned;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      appBar: AppBar(
        backgroundColor: context.colors.canvas,
        elevation: 0,
        centerTitle: true,
        title: const AppLogo(),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconCard(
            onTap: () => context.pop(),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 2.0),
              child: Icon(Icons.arrow_back_ios_new, size: 20, color: context.colors.textPrimary),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz, color: context.colors.brandGreen),
            onPressed: _cycleMockState,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Header Row (Title and Order ID)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.link, size: 14, color: context.colors.textSecondary),
                    const SizedBox(width: 4),
                    Text(widget.orderId, style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                  ],
                ),
                Text('driver_order.order_details'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.colors.textPrimary)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // 1. Order Progress Card
            _DriverOrderProgressCard(mockState: _mockState),
            const SizedBox(height: AppSpacing.lg),

            // 2. Delivery Station Card
            const _DriverStationCard(),
            const SizedBox(height: AppSpacing.lg),

            // 3. Shipment Details Card
            const _DriverShipmentDetailsCard(),
            const SizedBox(height: AppSpacing.lg),

            // 4. Client Notes Card
            const _DriverClientNotesCard(),
          ],
        ),
      ),
    );
  }
}

class _DriverOrderProgressCard extends StatelessWidget {
  const _DriverOrderProgressCard({required this.mockState});
  final _OrderMockState mockState;

  @override
  Widget build(BuildContext context) {
    final isCompleted = mockState == _OrderMockState.completed;
    final isAssigned = mockState == _OrderMockState.assigned;

    final statusText = isCompleted ? 'driver_order.status_completed'.tr() : (isAssigned ? 'driver_order.status_assigned'.tr() : 'driver_order.status_out_for_delivery'.tr());
    final statusColor = isCompleted
        ? context.colors.textSecondary
        : (isAssigned ? context.colors.brandBlue : context.colors.brandGreen);

    return OrderCard(
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('driver_order_mock.today_time'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
              StatusChip(statusText, color: statusColor),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Gauge
          if (!isCompleted) ...[
            _DriverEtaGauge(
              minutes: 35,
              progress: isAssigned ? 0.35 : 1.0,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          // Stepper
          _DriverOrderStepper(currentState: mockState),
          
          if (isCompleted) ...[
            const SizedBox(height: AppSpacing.xl),
            // Rating Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_border, color: Colors.orange, size: 20),
                    const SizedBox(width: 4),
                    Text('4.1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.colors.textPrimary)),
                  ],
                ),
                Text('driver_order.customer_rating'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.colors.brandBlue)),
              ],
            ),
            const SizedBox(height: 12),
            // Review Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.brandBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: context.colors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'driver_order_mock.review_text'.tr(),
                      style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.xl),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: context.colors.borderHairline),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/driverOrderPage/phone.svg', width: 16, height: 16, colorFilter: ColorFilter.mode(context.colors.brandBlue, BlendMode.srcIn)),
                        const SizedBox(width: 8),
                        Text('driver_order.contact_customer'.tr(), style: TextStyle(color: context.colors.brandBlue, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DriverNavigationScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: context.colors.brandBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/driverOrderPage/share.svg', width: 16, height: 16, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                        const SizedBox(width: 8),
                        Text(isAssigned ? 'driver_order.start_navigation_load'.tr() : 'driver_order.start_navigation_station'.tr(), style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isAssigned) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: context.colors.brandBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('driver_order.scan_delivery_code'.tr(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      SvgPicture.asset('assets/driverOrderPage/scan.svg', width: 18, height: 18, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _DriverEtaGauge extends StatelessWidget {
  const _DriverEtaGauge({required this.minutes, required this.progress});

  final int minutes;
  final double progress;

  static const _size = 110.0;
  static const _stroke = 8.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: CustomPaint(
        painter: _DriverGaugePainter(
          progress: progress,
          stroke: _stroke,
          color: context.colors.brandGreen,
          trackColor: context.colors.brandGreen.withValues(alpha: 0.1),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/driverOrderPage/station.svg', width: 24, height: 24),
              const SizedBox(height: 2),
              Text('driver_order.time_to_arrival'.tr(), style: TextStyle(color: context.colors.textSecondary, fontSize: 8)),
              Text(
                '$minutes',
                style: TextStyle(color: context.colors.textPrimary, fontSize: 24, height: 1.1, fontWeight: FontWeight.w800),
              ),
              Text('driver_order.minutes'.tr(), style: TextStyle(color: context.colors.textSecondary, fontSize: 8)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriverGaugePainter extends CustomPainter {
  const _DriverGaugePainter({
    required this.progress,
    required this.stroke,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final double stroke;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) & Size(size.width - stroke, size.height - stroke);
    canvas.drawArc(rect, 0, math.pi * 2, false, Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = stroke);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant _DriverGaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.stroke != stroke || oldDelegate.color != color || oldDelegate.trackColor != trackColor;
}

enum _DriverStepState { done, onProgress, todo }

class _DriverOrderStepper extends StatelessWidget {
  const _DriverOrderStepper({required this.currentState});
  final _OrderMockState currentState;

  @override
  Widget build(BuildContext context) {
    List<_DriverStepState> states;
    if (currentState == _OrderMockState.assigned) {
      states = [_DriverStepState.done, _DriverStepState.todo, _DriverStepState.todo, _DriverStepState.todo];
    } else if (currentState == _OrderMockState.outForDelivery) {
      states = [_DriverStepState.done, _DriverStepState.done, _DriverStepState.onProgress, _DriverStepState.todo];
    } else {
      states = [_DriverStepState.done, _DriverStepState.done, _DriverStepState.done, _DriverStepState.done];
    }
    final titles = ['driver_order.step_assigned'.tr(), 'driver_order.step_loaded'.tr(), 'driver_order.step_in_transit'.tr(), 'driver_order.step_delivered'.tr()];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < titles.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _buildStep(context, titles[i], states[i]),
          ),
        ],
      ],
    );
  }

  Widget _buildStep(BuildContext context, String title, _DriverStepState state) {
    final color = state == _DriverStepState.done ? context.colors.brandGreen : context.colors.brandBlue;
    final fraction = state == _DriverStepState.done ? 1.0 : (state == _DriverStepState.onProgress ? 0.5 : 0.0);

    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
        ),
        const SizedBox(height: 6),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 8,
              color: context.colors.borderHairline,
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: fraction,
                child: ColoredBox(color: color),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DriverStationCard extends StatelessWidget {
  const _DriverStationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderHairline),
      ),
      child: Stack(
        children: [
          // Background fuel pump at bottom-end
          PositionedDirectional(
            end: -30,
            bottom: -10,
            child: Transform.scale(
              scaleX: Directionality.of(context) == ui.TextDirection.rtl ? 1 : -1,
              child: SvgPicture.asset(
                'assets/driverOrderPage/fuel_pump.svg',
                width: 220,
                height: 220,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 130),
                  child: Text(
                    'driver_order.delivery_station'.tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.colors.brandBlue),
                  ),
                ),
                const SizedBox(height: 20),
                // User Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.colors.borderHairline),
                      ),
                      child: SvgPicture.asset('assets/driverOrderPage/user.svg', width: 20, height: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 130), // Prevent text overlap with background SVG
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('driver_order_mock.user_name'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.brandBlue)),
                            const SizedBox(height: 2),
                            Text('driver_order_mock.station_name'.tr(), style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Station Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.colors.borderHairline),
                      ),
                      child: SvgPicture.asset('assets/driverOrderPage/station.svg', width: 20, height: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 130), // Prevent text overlap with background SVG
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('driver_order_mock.delivery_station_name'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.brandBlue)),
                            const SizedBox(height: 2),
                            Text('driver_order_mock.delivery_address'.tr(), style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on_outlined, color: context.colors.brandGreen, size: 14),
                                const SizedBox(width: 4),
                                Text('driver_order.view_on_map'.tr(), style: TextStyle(fontSize: 12, color: context.colors.brandGreen, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Date and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/driverOrderPage/date.svg',
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 6),
                    Text('driver_order_mock.date'.tr(), style: TextStyle(fontSize: 12, color: context.colors.textPrimary, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 24),
                    Icon(Icons.access_time, color: context.colors.brandGreen, size: 18),
                    const SizedBox(width: 6),
                    Text('driver_order_mock.time'.tr(), style: TextStyle(fontSize: 12, color: context.colors.textPrimary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverShipmentDetailsCard extends StatelessWidget {
  const _DriverShipmentDetailsCard();

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/driverOrderPage/details.svg', width: 16, height: 16),
              const SizedBox(width: 8),
              Text('driver_order.shipment_details'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.colors.brandBlue)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: context.colors.brandGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset('assets/driverOrderPage/station 98.svg', width: 20, height: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('driver_order.fuel_type'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                        Text('driver_order_mock.fuel_type_98'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: context.colors.brandBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset('assets/driverOrderPage/waterDrop.svg', width: 20, height: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('driver_order.quantity'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                        Text('driver_order_mock.quantity_val'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset('assets/driverOrderPage/date.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(Colors.orange, BlendMode.srcIn)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('driver_order.requested_time'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                        Text('driver_order_mock.today_time'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset('assets/driverOrderPage/truck.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('driver_order.distance'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                        Text('driver_order_mock.distance_val'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriverClientNotesCard extends StatelessWidget {
  const _DriverClientNotesCard();

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/driverOrderPage/notes.svg', width: 16, height: 16, colorFilter: ColorFilter.mode(context.colors.textSecondary, BlendMode.srcIn)),
              const SizedBox(width: 8),
              Text('driver_order.customer_notes'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.borderHairline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: context.colors.textSecondary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'driver_order_mock.notes_text'.tr(),
                    style: TextStyle(fontSize: 10, color: context.colors.textSecondary, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
