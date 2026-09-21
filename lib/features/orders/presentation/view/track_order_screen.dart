import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/phone_dialer.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../constants/order_formatting.dart';
import '../../../../shared/enums/fuel_grade.dart';
import '../constants/order_presentation.dart';
import '../../domain/entities/otp_challenge.dart';
import '../../domain/usecases/get_driving_route.dart';
import '../cubit/order_detail_cubit.dart';
import '../cubit/order_detail_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../../../tracking/domain/entities/location_sample.dart';
import '../../../tracking/presentation/cubit/tracking_cubit.dart';
import '../../../tracking/presentation/cubit/tracking_state.dart';
import '../widgets/track_order/driver_card.dart';
import '../widgets/track_order/pickup_code_card.dart';
import '../widgets/track_order/track_order_title.dart';
import '../widgets/track_order/tracking_bottom_bar.dart';
import '../widgets/track_order/tracking_map.dart';
import '../widgets/track_order/tracking_stats_card.dart';
import '../widgets/track_order/tracking_timeline_card.dart';
import '../../../../core/theme/theme_context.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({required this.orderId, super.key});

  final String orderId;

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  late final OrderDetailCubit _orderDetailCubit;
  late final TrackingCubit _trackingCubit;

  /// Ticks once a second only to redraw the pickup code's mm:ss countdown —
  /// nothing here holds state of its own.
  Timer? _countdownTicker;

  /// The arrival instant, fixed at the moment an `etaMinutes` arrives.
  ///
  /// `etaMinutes` is a duration from when the server computed it, so
  /// rendering `DateTime.now() + etaMinutes` recomputed the arrival on every
  /// build — and with the one-second ticker above, the expected arrival
  /// advanced one second per second and never drew closer. Anchoring it
  /// once means the clock counts down towards a fixed time, and only a
  /// fresh reading from the server moves it.
  DateTime? _arrivalAt;
  int? _anchoredEtaMinutes;

  /// The driven route, decoded. Empty until one arrives, and whenever the
  /// platform has none to give.
  List<GeoPoint> _route = const [];

  /// Where the truck was when [_route] was fetched, so a refetch happens on
  /// real movement rather than on every socket ping.
  GeoPoint? _routeFetchedAt;
  bool _routeInFlight = false;

  /// Each Directions lookup is a billed outbound call, and the shape of the
  /// road barely changes over a short hop — so the route is refreshed only
  /// once the truck has moved this far from where it was last fetched.
  static const _routeRefreshMeters = 400.0;

  /// Defers [_maybeFetchRoute] to after this frame, returning nothing to
  /// draw — `build` must stay free of side effects.
  Widget _scheduleRouteFetch(GeoPoint? position) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _maybeFetchRoute(position);
    });
    return const SizedBox.shrink();
  }

  /// Fetches the route when there is none yet, or once the truck has moved
  /// far enough for the old one to be misleading.
  void _maybeFetchRoute(GeoPoint? position) {
    if (position == null || _routeInFlight) return;

    final last = _routeFetchedAt;
    if (last != null) {
      final moved = Geolocator.distanceBetween(
        last.lat,
        last.lng,
        position.lat,
        position.lng,
      );
      if (moved < _routeRefreshMeters) return;
    }

    _routeInFlight = true;
    _routeFetchedAt = position;
    unawaited(
      getIt<GetDrivingRoute>()(widget.orderId).then((result) {
        if (!mounted) return;
        setState(() {
          _routeInFlight = false;
          // A failure leaves the previous route in place: a stale road line
          // beats snapping back to a straight one on a blip.
          result.fold((_) {}, (points) => _route = points);
        });
      }),
    );
  }

  void _anchorEta(int? etaMinutes) {
    if (etaMinutes == _anchoredEtaMinutes) return;
    _anchoredEtaMinutes = etaMinutes;
    _arrivalAt = etaMinutes == null
        ? null
        : DateTime.now().add(Duration(minutes: etaMinutes));
  }

  @override
  void initState() {
    super.initState();
    _orderDetailCubit = getIt<OrderDetailCubit>(param1: widget.orderId)
      ..load()
      ..loadCurrentOtp();
    _trackingCubit = getIt<TrackingCubit>()..watch(widget.orderId);
    _countdownTicker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _countdownTicker?.cancel();
    _trackingCubit.unwatch(widget.orderId);
    unawaited(_orderDetailCubit.close());
    unawaited(_trackingCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderDetailCubit>.value(value: _orderDetailCubit),
        BlocProvider<TrackingCubit>.value(value: _trackingCubit),
      ],
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: BlocListener<OrderDetailCubit, OrderDetailState>(
            // Re-anchor only when the server sends a different reading, so
            // the arrival time is stable between refreshes.
            listener: (context, state) {
              if (state is OrderDetailLoaded) _anchorEta(state.order.etaMinutes);
            },
            child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
            builder: (context, orderState) => switch (orderState) {
              OrderDetailLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              OrderDetailFailureState() => _ErrorState(
                onRetry: () => _orderDetailCubit.load(),
              ),
              OrderDetailLoaded(:final order, :final activeOtp) =>
                BlocBuilder<TrackingCubit, TrackingState>(
                  builder: (context, trackingState) =>
                      _buildLoaded(context, order, activeOtp, trackingState),
                ),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    Order order,
    OtpChallenge? activeOtp,
    TrackingState trackingState,
  ) {
    final reference = OrderPresentation.shortReference(order.id);
    final date = OrderPresentation.date(order.statusChangedAt);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(
              top: AppSpacing.lg,
              bottom: AppSpacing.xl,
            ),
            children: [
              _inset(
                AppTopBar(
                  notificationCount:
                      context.watch<NotificationsCubit>().state.unreadBadgeCount,
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: AppSizes.orderSectionGap),
              _inset(
                TrackOrderTitle(
                  orderReference: TrackOrderKeys.orderReference.tr(
                    namedArgs: {'id': '$reference · $date'},
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ..._buildTrackingContent(context, order, trackingState),
              const SizedBox(height: AppSpacing.lg),
              _inset(
                DriverCard(
                  fuelType: OrderPresentation.fuelLabel(order.fuelType),
                  fuelGrade: FuelGrade.forType(order.fuelType),
                  quantity: OrderFormatting.litres(order.quantityLiters),
                  truckPlate: order.driverSummary?.plateNumber ?? '—',
                  driverName: order.driverSummary?.fullName ?? '—',
                  // Withheld rather than shown-and-inert when the backend
                  // has sent no driver phone: DriverCard dims the button on
                  // a null callback, so the control matches what it can do.
                  onCallDriver: order.driverSummary?.phone == null
                      ? null
                      : () => _callDriver(context, order.driverSummary!.phone),
                ),
              ),
              if (activeOtp != null) ...[
                const SizedBox(height: AppSpacing.lg),
                _inset(
                  PickupCodeCard(
                    code: activeOtp.code,
                    timeRemaining: _formatCountdown(activeOtp.expiresAt),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              _inset(const TrackingTimelineCard()),
            ],
          ),
        ),
        const TrackingBottomBar(),
      ],
    );
  }

  /// The map/stats block: the live view once a position exists, or the
  /// stale/not-trackable/connecting states in its place (FR-020/FR-021) —
  /// never an empty map standing in for "nothing has arrived yet".
  List<Widget> _buildTrackingContent(
    BuildContext context,
    Order order,
    TrackingState trackingState,
  ) {
    return switch (trackingState) {
      TrackingWatching(:final location, :final stale) => [
        // Scheduled, not called inline: this can setState, and doing that
        // during a build is illegal.
        _scheduleRouteFetch(_position(location, order)),
        _inset(
          TrackingStatsCard(
            statusLabel: OrderPresentation.statusLabel(order.status),
            distance: _distanceLabel(_position(location, order), order),
            etaTime: _etaTimeLabel(order),
            etaDate: _etaDateLabel(order),
          ),
        ),
        if (stale) ...[
          const SizedBox(height: AppSpacing.sm),
          _inset(_StaleBanner()),
        ],
        const SizedBox(height: AppSpacing.lg),
        TrackingMap(
          driverLocation: _position(location, order),
          destination: order.destination,
          route: _route,
        ),
      ],
      TrackingNotTrackable() => [_inset(const _NotTrackableState())],
      TrackingFailureState() => [
        _inset(_ErrorState(onRetry: () => _trackingCubit.watch(widget.orderId))),
      ],
      TrackingConnecting() || TrackingDisconnected() => const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    };
  }

  /// Opens the platform dialler. A device that cannot place calls (the
  /// simulator, an iPad) reports back rather than failing silently, so the
  /// tap always produces visible feedback.
  Future<void> _callDriver(BuildContext context, String phone) async {
    final placed = await PhoneDialer.call(phone);
    if (placed || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(TrackOrderKeys.callUnavailable.tr())),
    );
  }

  /// Where the truck is, preferring the live socket sample over the last
  /// known position the order was fetched with.
  ///
  /// Without the fallback the map and the distance stay blank until the
  /// driver's next `location:update`, which the gateway throttles to 50m of
  /// movement or a 3-minute heartbeat — so a client could open tracking and
  /// see nothing for minutes while the platform already knew where the truck
  /// was.
  GeoPoint? _position(LocationSample? live, Order order) => live == null
      ? order.driverLocation
      : GeoPoint(lat: live.lat, lng: live.lng);

  String? _distanceLabel(GeoPoint? location, Order order) =>
      OrderPresentation.distanceLabel(location, order.destination);

  // Both read the anchored instant rather than re-deriving it from the
  // clock, so the displayed arrival stays put while the countdown runs.
  // Null whenever the backend omitted `etaMinutes` — it does that
  // deliberately when no driver is assigned or the assigned driver has no
  // position on file, and an omitted estimate must read as unknown rather
  // than be invented.
  String _etaTimeLabel(Order order) {
    final at = _arrivalAt;
    return at == null ? '—' : OrderPresentation.time(at);
  }

  String _etaDateLabel(Order order) {
    final at = _arrivalAt;
    return at == null ? '—' : OrderPresentation.date(at);
  }

  String _formatCountdown(DateTime expiresAt) {
    final remaining = expiresAt.difference(DateTime.now());
    if (remaining.isNegative) return '00:00';
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _inset(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
    child: child,
  );
}

class _StaleBanner extends StatelessWidget {
  const _StaleBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.orangeTint,
        borderRadius: BorderRadius.circular(AppSizes.orderChipRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: context.colors.brandOrange,
            size: AppSizes.iconSm,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              TrackOrderKeys.staleWarning.tr(),
              style: TextStyle(color: context.colors.brandOrange, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotTrackableState extends StatelessWidget {
  const _NotTrackableState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: AppSizes.iconXl,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            TrackOrderKeys.notTrackableTitle.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            TrackOrderKeys.notTrackableBody.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              OrdersKeys.loadFailed.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(onPressed: onRetry, child: Text(OrdersKeys.retry.tr())),
          ],
        ),
      ),
    );
  }
}
