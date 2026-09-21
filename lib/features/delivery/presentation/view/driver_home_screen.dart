import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/fuel_grade.dart';
import '../../../orders/presentation/constants/order_formatting.dart';
import '../../../orders/presentation/constants/order_presentation.dart';
import '../cubit/delivery_cubit.dart';
import '../cubit/delivery_state.dart';
import '../cubit/driver_summary_cubit.dart';
import '../cubit/driver_summary_state.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: 120, // space for nav bar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: AppSpacing.xl),

                // Active Delivery Section (spec 007 US1) — the driver's real
                // assigned work, or an explicit state for why there is none.
                Text(
                  'driver_home.active_order'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                BlocBuilder<DeliveryCubit, DeliveryState>(
                  builder: (context, state) => switch (state) {
                    // FR-004/FR-032/FR-044: distinct from noActiveOrder and
                    // from a load failure — collapsing any pair of these
                    // three is exactly what those requirements forbid.
                    DeliveryLoading() => const _CenteredCard(
                      child: CircularProgressIndicator(),
                    ),
                    DeliveryNoActiveOrder() => _NoActiveDeliveryCard(),
                    DeliveryFailureState(:final failure) => _ActiveDeliveryErrorCard(
                      failure: failure,
                      onRetry: () => context.read<DeliveryCubit>().load(),
                    ),
                    DeliveryActive(:final order, :final streaming) =>
                      _ActiveDeliveryCard(order: order, streaming: streaming),
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Quick Actions
                Text(
                  'driver_home.quick_actions'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<DriverSummaryCubit, DriverSummaryState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.colors.greenTint,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.brandGreen.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildDutyIndicator(context, state)),
              const SizedBox(width: AppSpacing.md),
              _buildFigures(context, state),
            ],
          ),
        );
      },
    );
  }

  /// FR-035/FR-036: `readyForWork` is the platform's own derivation (the same
  /// predicate that gates dispatch eligibility) — there is no control on any
  /// driver screen that sets it, only ever reflects it.
  Widget _buildDutyIndicator(BuildContext context, DriverSummaryState state) {
    final readyForWork = state is DriverSummaryLoaded && state.summary.readyForWork;
    final color = readyForWork ? context.colors.brandGreen : context.colors.textSecondary;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset('assets/driverHomePage/steering.svg', width: 24, height: 24),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (readyForWork ? 'driver_home.online' : 'driver_summary.off_duty').tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
              ),
              Text(
                (readyForWork
                        ? 'driver_home.ready_to_receive'
                        : 'driver_summary.not_receiving_orders')
                    .tr(),
                style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFigures(BuildContext context, DriverSummaryState state) {
    if (state is DriverSummaryFailureState) {
      return Text(
        'driver_summary.could_not_load'.tr(),
        style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
      );
    }

    final summary = state is DriverSummaryLoaded ? state.summary : null;
    // FR-031: absence renders as an explicit "not yet rated" state — never
    // `0`, never a numeral of any kind. FR-045: a genuine zero
    // deliveries-today is a normal loaded value, not a failure — it's
    // rendered as any other count would be.
    final ratingText = summary == null
        ? null // still loading — no figure yet, not "not yet rated" either
        : (summary.ratingAverage?.toStringAsFixed(1) ?? 'driver_summary.not_yet_rated'.tr());
    final deliveriesText = summary?.deliveriesToday.toString();

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'driver_home.rating'.tr(),
              style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, -1.5),
                  child: SvgPicture.asset('assets/driverHomePage/star.svg', width: 14, height: 14),
                ),
                const SizedBox(width: 4),
                Text(
                  ratingText ?? '—',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'driver_home.orders_today'.tr(),
              style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, -1.5),
                  child: SvgPicture.asset('assets/driverHomePage/order.svg', width: 14, height: 14),
                ),
                const SizedBox(width: 4),
                Text(
                  deliveriesText ?? '—',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        // Rightmost (First Child)
        Expanded(child: _buildActionItem(context, 'assets/driverHomePage/bin.svg', 'driver_home.nearby_stations'.tr())),
        const SizedBox(width: 8),
        Expanded(child: _buildActionItem(context, 'assets/driverHomePage/support.svg', 'driver_home.support'.tr())),
        const SizedBox(width: 8),
        Expanded(child: _buildActionItem(context, 'assets/driverHomePage/invoice.svg', 'driver_home.delivery_report'.tr())),
        const SizedBox(width: 8),
        // Leftmost (Last Child)
        Expanded(child: _buildActionItem(context, 'assets/driverHomePage/scan.svg', 'driver_home.scan_qr'.tr())),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, String iconPath, String label) {
    return Container(
      height: 80, // Fixed height so all items are equal
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: 2),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.borderHairline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center contents vertically
        children: [
          SvgPicture.asset(iconPath, width: 24, height: 24),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: context.colors.textSecondary, fontWeight: FontWeight.w500, height: 1.2),
          ),
        ],
      ),
    );
  }
}

/// A plain centering wrapper for the loading/empty/error cards, so each one
/// isn't reinventing its own padding and alignment.
class _CenteredCard extends StatelessWidget {
  const _CenteredCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: child),
      ),
    );
  }
}

class _NoActiveDeliveryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CenteredCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 32,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'driver_home.no_active_delivery'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ActiveDeliveryErrorCard extends StatelessWidget {
  const _ActiveDeliveryErrorCard({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _CenteredCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            failureMessage(failure),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(onPressed: onRetry, child: Text(CommonKeys.retry.tr())),
        ],
      ),
    );
  }
}

/// The driver's real active delivery (spec 007 FR-001/FR-003). Every value
/// here is sourced from the platform — no sample order, no invented
/// percentage-complete figure. The original design's circular progress ring
/// had no real ratio behind it (there is no "trip duration" the platform
/// tracks to compute one against), so it is replaced with a plain ETA
/// figure rather than kept as a fabricated animation (Constitution
/// Principle I / FR-006).
class _ActiveDeliveryCard extends StatelessWidget {
  const _ActiveDeliveryCard({required this.order, this.streaming = false});

  final Order order;

  /// FR-011: `DeliveryActive.streaming` — whether the platform is actually
  /// receiving this delivery's position. Computed by `DeliveryCubit` since
  /// spec 007 and, until now, read by nothing: a driver who refused the
  /// location permission saw a completely normal delivery card while the
  /// customer's map stayed frozen.
  final bool streaming;

  @override
  Widget build(BuildContext context) {
    final etaMinutes = order.etaMinutes;
    return OrderCard(
      child: Column(
        children: [
          if (!streaming) ...[
            _UntrackedStrip(),
            const SizedBox(height: AppSpacing.md),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Right Side: Fuel Info (First Child)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // 'station2.svg' is design artwork with "95" printed
                        // on the pump, and it was drawn for every order — so a
                        // diesel run showed the driver a petrol-95 icon. The
                        // pump now carries the order's own grade.
                        Builder(
                          builder: (context) {
                            final grade = FuelGrade.forType(order.fuelType);
                            return Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: grade.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: FuelPumpIcon(
                                  grade: grade.badge,
                                  color: grade.color,
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('driver_home.fuel_type'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                            Text(
                              OrderPresentation.fuelLabel(order.fuelType),
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('driver_home.quantity'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                    Text(
                      OrderFormatting.litres(order.quantityLiters),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text('driver_home.customer'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                    Text(
                      // spec 007 FR-003/FR-003a: absent on any order assigned
                      // before this feature existed (no clientSummary yet) —
                      // an explicit statement of that, never a blank line.
                      order.clientSummary?.fullName ??
                          'driver_home.customer_unavailable'.tr(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.brandGreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Center: ETA figure (Second Child) — a plain number, never a
              // fabricated percentage-complete ring (see class doc comment).
              SizedBox(
                width: 100,
                height: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.borderHairline, width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/driverHomePage/station.svg', width: 24, height: 24),
                      const SizedBox(height: 2),
                      Text(
                        'driver_home.time_remaining'.tr(),
                        style: TextStyle(fontSize: 8, color: context.colors.textSecondary),
                      ),
                      Text(
                        // FR-032 (edge case): absent rather than zero or a guess.
                        etaMinutes != null ? '$etaMinutes' : '—',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.colors.textPrimary),
                      ),
                      if (etaMinutes != null)
                        Text(
                          'driver_home.minutes'.tr(),
                          style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Left Side: Order Info (Third Child)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.greenTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: context.colors.brandGreen, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text(
                            OrderPresentation.statusLabel(order.status),
                            style: TextStyle(fontSize: 10, color: context.colors.brandGreen, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      OrderPresentation.shortReference(order.id),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              SvgPicture.asset('assets/driverHomePage/bin.svg', width: 16, height: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  OrderPresentation.destinationLabel(order),
                  style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () {
              context.push(AppRoutes.driverOrderDetail(order.id));
            },
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.brandBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 44),
            ),
            child: Text(
              'driver_home.view_delivery'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// FR-011: shown on the active-delivery card when the platform is receiving
/// no position for it — location sharing is off. States what to do about it
/// rather than only that something is wrong.
class _UntrackedStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.borderHairline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_off, size: 18, color: context.colors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DriverKeys.untrackedTitle.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DriverKeys.untrackedBody.tr(),
                  style: TextStyle(
                    fontSize: 10,
                    color: context.colors.textSecondary,
                    height: 1.4,
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
