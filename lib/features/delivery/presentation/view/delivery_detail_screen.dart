import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/map_navigator.dart';
import '../../../../core/utils/phone_dialer.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/enums/tank_material.dart';
import '../../../orders/presentation/constants/order_formatting.dart';
import '../../../orders/presentation/constants/order_presentation.dart';
import '../../../orders/presentation/cubit/order_detail_cubit.dart';
import '../../../orders/presentation/cubit/order_detail_state.dart';
import '../../../orders/presentation/widgets/order_detail/status_chip.dart';
import '../cubit/otp_verify_cubit.dart';
import '../widgets/stop_reason_sheet.dart';
import '../cubit/otp_verify_state.dart';
import 'driver_navigation_screen.dart';
import 'driver_scan_screen.dart';
import 'vehicle_verification_screen.dart';

/// Spec 007 US4: replaces a tap-cycled `_OrderMockState` with the order's
/// real status (FR-024/FR-025) and the arrive/request-code actions (pulled
/// forward from Phase 6 alongside US2's T027/T028 — both need the same real
/// status to decide which action is even offered).
///
/// [OrderDetailCubit] (spec 005) already does exactly what this screen
/// needs: load a specific order by id and keep it live via the
/// `order:status` push (FR-026), for either the driver's currently-active
/// delivery or a historical one once US3's list opens this route for those
/// too (`AppRoutes.driverOrderDetailPattern`). Reused as-is rather than
/// adding a second per-order cubit.
class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderDetailCubit>(
          create: (_) => getIt<OrderDetailCubit>(param1: orderId)..load(),
        ),
        // Only issues the arrival/delivery code (T026/FR-009/FR-010) — the
        // driver's app never verifies one itself; that stays on
        // `DeliveryCubit.confirmHandover`, reached via `DriverScanScreen`,
        // since only the driver's one active order can ever be confirmed.
        BlocProvider<OtpVerifyCubit>(
          create: (_) => getIt<OtpVerifyCubit>(param1: orderId),
        ),
      ],
      child: _DeliveryDetailView(orderId: orderId),
    );
  }
}

class _DeliveryDetailView extends StatelessWidget {
  const _DeliveryDetailView({required this.orderId});

  final String orderId;

  void _onOtpVerifyState(BuildContext context, OtpVerifyState state) {
    state.whenOrNull(
      // `idle` following `verifying` means the issue call succeeded — arrive
      // itself never advances the order, only the code was sent.
      idle: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(DriverNavigationKeys.codeSentToCustomer.tr())),
        );
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const DriverScanScreen()),
        );
      },
      rejected: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(DriverNavigationKeys.codeConfirmFailed.tr())),
      ),
      throttled: (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(DriverNavigationKeys.codeTooManyAttempts.tr())),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpVerifyCubit, OtpVerifyState>(
      listener: _onOtpVerifyState,
      child: Scaffold(
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
        ),
        body: SafeArea(
          child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
            builder: (context, state) {
              return switch (state) {
                OrderDetailLoading() => const Center(child: CircularProgressIndicator()),
                OrderDetailFailureState() => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(DriverNavigationKeys.cannotReach.tr()),
                        const SizedBox(height: AppSpacing.md),
                        FilledButton(
                          onPressed: () => context.read<OrderDetailCubit>().load(),
                          child: Text(CommonKeys.retry.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
                OrderDetailLoaded(:final order) => _DeliveryDetailBody(order: order),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _DeliveryDetailBody extends StatelessWidget {
  const _DeliveryDetailBody({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(Icons.link, size: 14, color: context.colors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  OrderPresentation.shortReference(order.id),
                  style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
                ),
              ],
            ),
            Text(
              'driver_order.order_details'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.colors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // FR-005/FR-006: an unanswered stop question, reachable here on a
        // device that never received the alert.
        _OutstandingStopBanner(order: order),

        _DriverOrderProgressCard(order: order),
        const SizedBox(height: AppSpacing.lg),

        _DriverCustomerCard(order: order),
        const SizedBox(height: AppSpacing.lg),

        _DriverShipmentDetailsCard(order: order),
      ],
    );
  }
}

/// FR-005/FR-006: the stop question, rendered from `order.stopEvents` rather
/// than only reachable from the device notification the alert arrived on.
/// Opens the existing `showStopReasonSheet` — a second entry point to the
/// same sheet `StopAlertRouter` opens from a notification tap, never a second
/// sheet — and reloads afterwards so the question clears without a manual
/// refresh (FR-006).
class _OutstandingStopBanner extends StatelessWidget {
  const _OutstandingStopBanner({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final stop = order.outstandingStop;
    if (stop == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.blueTint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.brandBlue.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DriverKeys.outstandingStopTitle.tr(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DriverKeys.outstandingStopBody.tr(),
              style: TextStyle(fontSize: 11, color: context.colors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final detailCubit = context.read<OrderDetailCubit>();
                  unawaited(
                    showStopReasonSheet(
                      context,
                      orderId: order.id,
                      stopId: stop.id,
                    ).then((_) {
                      // Clear this screen's banner without a manual refresh
                      // (FR-006); the sheet itself reloads the app-wide
                      // `DeliveryCubit`.
                      detailCubit.load();
                    }),
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: context.colors.brandBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  DriverKeys.outstandingStopAnswer.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverOrderProgressCard extends StatelessWidget {
  const _DriverOrderProgressCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final status = order.status;
    final isTerminal = status == OrderStatus.delivered || status == OrderStatus.cancelled;
    // spec 008: the truck hasn't verified departure yet (or is still at the
    // depot) — an ETA/stepper toward the customer would show progress that
    // hasn't started, the same reasoning `OrderPresentation.isTrackable`
    // already applies on the client's side.
    final isPreTransit =
        status == OrderStatus.assignedToDriver || status == OrderStatus.loading;

    return OrderCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                OrderPresentation.shortReference(order.id),
                style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
              ),
              StatusChip(
                OrderPresentation.statusLabel(status),
                color: OrderPresentation.statusColor(status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // FR-006: never a fabricated ETA — absent until the driver has
          // reported a position, same rule the active-delivery card follows.
          if (!isTerminal && !isPreTransit && order.etaMinutes != null) ...[
            _DriverEtaGauge(minutes: order.etaMinutes!),
            const SizedBox(height: AppSpacing.xl),
          ],

          if (isPreTransit) ...[
            _DriverLoadingCard(order: order),
            const SizedBox(height: AppSpacing.xl),
          ] else if (status != OrderStatus.cancelled)
            _DriverOrderStepper(status: status),

          const SizedBox(height: AppSpacing.xl),
          _DriverActionRow(order: order),
          if (status == OrderStatus.delivered) ...[
            const SizedBox(height: AppSpacing.xl),
            _DriverRatingSection(rating: order.rating),
          ],
        ],
      ),
    );
  }
}

class _DriverEtaGauge extends StatelessWidget {
  const _DriverEtaGauge({required this.minutes});
  final int minutes;

  static const _size = 110.0;
  static const _stroke = 8.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.colors.brandGreen.withValues(alpha: 0.15), width: _stroke),
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

/// Three real stages (FR-024): en route, arrived/unloading, delivered. A
/// driver's own order never sits in any earlier status — it is IN_TRANSIT
/// from the moment it is assigned to them.
class _DriverOrderStepper extends StatelessWidget {
  const _DriverOrderStepper({required this.status});
  final OrderStatus status;

  int get _stepIndex => switch (status) {
    OrderStatus.delivered => 2,
    OrderStatus.unloading => 1,
    _ => 0,
  };

  @override
  Widget build(BuildContext context) {
    final labels = [
      OrderPresentation.statusLabel(OrderStatus.inTransit),
      OrderPresentation.statusLabel(OrderStatus.unloading),
      OrderPresentation.statusLabel(OrderStatus.delivered),
    ];
    final current = _stepIndex;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _buildStep(context, labels[i], i, current)),
        ],
      ],
    );
  }

  Widget _buildStep(BuildContext context, String title, int index, int current) {
    final done = index <= current;
    final color = done ? context.colors.brandGreen : context.colors.borderHairline;

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
        Container(width: 3, height: 3, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(height: 8, color: context.colors.borderHairline.withValues(alpha: done ? 1 : 0.4)),
          ),
        ),
      ],
    );
  }
}

/// spec 008 FR-033a/FR-033b: the assigned tank's code and material are
/// visible from the moment of assignment, not only after loading begins —
/// so a wrong physical trailer is visible to the driver as early as
/// possible. The warehouse destination only appears once departure has
/// been verified (FR-026) — before that, there is nothing to navigate to yet.
class _DriverLoadingCard extends StatelessWidget {
  const _DriverLoadingCard({required this.order});
  final Order order;

  static String _materialLabel(TankMaterial material) => switch (material) {
    TankMaterial.iron => DriverLoadingKeys.materialIron,
    TankMaterial.aluminium => DriverLoadingKeys.materialAluminium,
  }.tr();

  static Future<void> _navigateToWarehouse(
    BuildContext context,
    WarehouseSummary warehouse,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final opened = await MapNavigator.navigateTo(
      latitude: warehouse.location.lat,
      longitude: warehouse.location.lng,
      label: warehouse.name,
    );
    if (!opened) {
      messenger.showSnackBar(
        SnackBar(content: Text(DriverLoadingKeys.navigateFailed.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tank = order.tankSummary;
    final warehouse = order.warehouseSummary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tank != null) ...[
          Text(
            DriverLoadingKeys.tankDetails.tr(),
            style: TextStyle(fontWeight: FontWeight.w700, color: context.colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _LabelValue(
                  label: DriverLoadingKeys.tankCode.tr(),
                  value: tank.code,
                ),
              ),
              Expanded(
                child: _LabelValue(
                  label: DriverLoadingKeys.tankMaterial.tr(),
                  value: _materialLabel(tank.material),
                ),
              ),
            ],
          ),
        ],
        if (order.status == OrderStatus.loading && warehouse != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            DriverLoadingKeys.destination.tr(),
            style: TextStyle(fontWeight: FontWeight.w700, color: context.colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(warehouse.name, style: TextStyle(color: context.colors.textPrimary)),
          Text(
            warehouse.addressText,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.sm),
          // FR-027: the address on its own is something to read, not
          // somewhere to go — and the driver has to physically arrive
          // before the loading verification will pass its geofence
          // (FR-030a), so getting there is the actual next step of the
          // delivery, not a convenience.
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _navigateToWarehouse(context, warehouse),
              icon: Icon(Icons.navigation_outlined, size: 18, color: context.colors.brandBlue),
              label: Text(
                DriverLoadingKeys.navigateToWarehouse.tr(),
                style: TextStyle(color: context.colors.brandBlue, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: context.colors.borderHairline),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, color: context.colors.textPrimary),
        ),
      ],
    );
  }
}

/// spec 008 US3/US4: the sole action available at ASSIGNED_TO_DRIVER and
/// LOADING — everything past this point is blocked until it succeeds.
class _VehicleVerificationAction extends StatelessWidget {
  const _VehicleVerificationAction({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final isLoadingStage = order.status == OrderStatus.loading;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () async {
          final verified = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => VehicleVerificationScreen(
                orderId: order.id,
                isLoadingStage: isLoadingStage,
              ),
            ),
          );
          if (verified == true && context.mounted) {
            unawaited(context.read<OrderDetailCubit>().load());
          }
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: context.colors.brandBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          (isLoadingStage
                  ? DriverLoadingKeys.confirmLoading
                  : DriverVerificationKeys.verifyVehicle)
              .tr(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// FR-027/FR-009/FR-010: exactly the actions the order's status permits —
/// nothing that would advance a stage the platform hasn't reached.
class _DriverActionRow extends StatelessWidget {
  const _DriverActionRow({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final status = order.status;

    // spec 008 FR-017/FR-020: at ASSIGNED_TO_DRIVER the only action is
    // verifying the vehicle — every later step (arrive, request/verify
    // codes) stays unavailable until that succeeds.
    if (status == OrderStatus.assignedToDriver || status == OrderStatus.loading) {
      return _VehicleVerificationAction(order: order);
    }

    if (status != OrderStatus.inTransit && status != OrderStatus.unloading) {
      // Delivered/cancelled: nothing left to do on this order.
      return const SizedBox.shrink();
    }

    return BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
      builder: (context, otpState) {
        final busy = otpState is OtpVerifying;
        final label = status == OrderStatus.inTransit
            ? DriverNavigationKeys.markArrived.tr()
            : DriverNavigationKeys.requestDeliveryCode.tr();

        return Column(
          children: [
            Row(
              children: [
                if (order.clientSummary?.phone != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => PhoneDialer.call(order.clientSummary!.phone),
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
                ],
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => DriverNavigationScreen(order: order)),
                    ),
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
                        Text(DriverNavigationKeys.startNavigation.tr(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: busy
                    ? null
                    : () {
                        final cubit = context.read<OtpVerifyCubit>();
                        if (status == OrderStatus.inTransit) {
                          unawaited(cubit.markArrived());
                        } else {
                          unawaited(cubit.requestDeliveryOtp());
                        }
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: context.colors.brandBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
            // spec 011 FR-008a (T040): declaring a stop is offered only
            // while IN_TRANSIT — the leg this feature covers. A truck parked
            // at the warehouse or at the customer's gate is where it is
            // supposed to be, so there is nothing there to explain, and the
            // platform refuses a declaration outside this status anyway.
            if (status == OrderStatus.inTransit) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: busy
                      ? null
                      : () => unawaited(
                          showStopReasonSheet(context, orderId: order.id),
                        ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: context.colors.borderHairline),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    DriverKeys.declareStop.tr(),
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// spec 007 US6 (FR-041/FR-041a/FR-037b): the customer's score and review
/// on a completed delivery — real data, replacing the old hard-coded `4.1`
/// and mock review text this card used to show unconditionally. Absent
/// (never a zero or an empty star row) until the customer actually rates.
class _DriverRatingSection extends StatelessWidget {
  const _DriverRatingSection({required this.rating});
  final OrderRating? rating;

  @override
  Widget build(BuildContext context) {
    final rating = this.rating;
    if (rating == null) {
      return Text(
        'driver_summary.not_yet_rated'.tr(),
        style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              Icon(
                i <= rating.score ? Icons.star : Icons.star_border,
                color: Colors.orange,
                size: 18,
              ),
          ],
        ),
        if (rating.review != null && rating.review!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          // FR-037b: plain text only — never interpreted as markup.
          Text(rating.review!, style: TextStyle(fontSize: 12, color: context.colors.textPrimary)),
        ],
      ],
    );
  }
}

class _DriverCustomerCard extends StatelessWidget {
  const _DriverCustomerCard({required this.order});
  final Order order;

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
          PositionedDirectional(
            end: -30,
            bottom: -10,
            child: Transform.scale(
              scaleX: Directionality.of(context) == ui.TextDirection.rtl ? 1 : -1,
              child: SvgPicture.asset('assets/driverOrderPage/fuel_pump.svg', width: 220, height: 220),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 130),
                  child: Text(
                    'driver_order.destination'.tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.colors.brandBlue),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
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
                        padding: const EdgeInsetsDirectional.only(end: 130),
                        child: Text(
                          order.clientSummary?.fullName ?? 'driver_home.customer_unavailable'.tr(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.brandBlue),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
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
                        padding: const EdgeInsetsDirectional.only(end: 130),
                        child: Text(
                          OrderPresentation.destinationLabel(order),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.brandBlue),
                        ),
                      ),
                    ),
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
  const _DriverShipmentDetailsCard({required this.order});
  final Order order;

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
                child: _DetailTile(
                  icon: 'assets/driverOrderPage/station 98.svg',
                  iconColor: context.colors.brandGreen,
                  label: 'driver_order.fuel_type'.tr(),
                  value: OrderPresentation.fuelLabel(order.fuelType),
                ),
              ),
              Expanded(
                child: _DetailTile(
                  icon: 'assets/driverOrderPage/waterDrop.svg',
                  iconColor: context.colors.brandBlue,
                  label: 'driver_order.quantity'.tr(),
                  value: OrderFormatting.litres(order.quantityLiters),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.icon, required this.iconColor, required this.label, required this.value});

  final String icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset(icon, width: 20, height: 20),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
              Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
