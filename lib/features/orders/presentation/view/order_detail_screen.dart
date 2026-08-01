import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/realtime/tracking_socket.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../tracking/presentation/cubit/tracking_cubit.dart';
import '../../../tracking/presentation/cubit/tracking_state.dart';
import '../../domain/usecases/cancel_order.dart';
import '../../domain/usecases/redispatch.dart';
import '../cubit/order_detail_cubit.dart';
import '../cubit/order_detail_state.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OrderDetailCubit(
            orderId: orderId,
            getOrder: getIt(),
            getCurrentOtp: getIt(),
            socket: getIt(),
          )..load(),
        ),
        BlocProvider(
          create: (_) =>
              PaymentCubit(
                orderId: orderId,
                gateway: getIt(),
                socket: getIt(),
                getOrder: getIt(),
              ),
        ),
        BlocProvider(create: (_) => TrackingCubit(socket: getIt<TrackingSocket>())),
      ],
      child: _OrderDetailView(orderId: orderId),
    );
  }
}

class _OrderDetailView extends StatefulWidget {
  const _OrderDetailView({required this.orderId});

  final String orderId;

  @override
  State<_OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<_OrderDetailView> {
  bool _watching = false;
  Timer? _countdownTicker;

  @override
  void dispose() {
    _countdownTicker?.cancel();
    if (_watching) {
      getIt<TrackingSocket>().unwatchOrder(widget.orderId);
    }
    super.dispose();
  }

  void _maybeStartWatching(OrderStatus status) {
    final trackable =
        status == OrderStatus.inTransit || status == OrderStatus.unloading;
    if (trackable && !_watching) {
      _watching = true;
      unawaited(context.read<TrackingCubit>().watch(widget.orderId));
    }
  }

  Future<void> _decline() async {
    await getIt<CancelOrder>()(widget.orderId);
    if (!mounted) return;
    unawaited(context.read<OrderDetailCubit>().load());
  }

  Future<void> _retryDispatch() async {
    await getIt<Redispatch>()(widget.orderId);
    if (!mounted) return;
    unawaited(context.read<OrderDetailCubit>().load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: BlocConsumer<OrderDetailCubit, OrderDetailState>(
        listener: (context, state) {
          if (state case OrderDetailLoaded(:final order)) {
            _maybeStartWatching(order.status);
            if (order.status == OrderStatus.unloading) {
              unawaited(context.read<OrderDetailCubit>().loadCurrentOtp());
            }
          }
        },
        builder: (context, state) => switch (state) {
          OrderDetailLoading() => const Center(child: CircularProgressIndicator()),
          OrderDetailFailureState() => Center(
            child: TextButton(
              onPressed: () => context.read<OrderDetailCubit>().load(),
              child: const Text('Could not load this order. Tap to retry.'),
            ),
          ),
          OrderDetailLoaded(:final order, :final activeOtp) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('${order.quantityLiters} L · ${order.fuelType.name}'),
              const SizedBox(height: 8),
              Text('Status: ${order.status.wire}'),
              const SizedBox(height: 16),
              if (order.finalPrice != null)
                Text('Final price: ${_formatMoney(order.finalPrice!)}'),
              if (order.status == OrderStatus.approved ||
                  order.status == OrderStatus.pendingPayment)
                _PaymentSection(order: order, onDecline: _decline),
              if (order.status == OrderStatus.approved)
                OutlinedButton(
                  onPressed: _retryDispatch,
                  child: const Text('Retry dispatch'),
                ),
              if (activeOtp != null) _OtpBanner(code: activeOtp.code),
              if (order.status == OrderStatus.inTransit ||
                  order.status == OrderStatus.unloading)
                const _LiveMap(),
            ],
          ),
        },
      ),
    );
  }

  String _formatMoney(Money money) =>
      '${(money.amountMinor / 100).toStringAsFixed(2)} ${money.currency}';
}

class _PaymentSection extends StatelessWidget {
  const _PaymentSection({required this.order, required this.onDecline});

  final Order order;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state case PaymentFailureState(:final failure)) {
          presentFailure(context, failure);
        }
      },
      builder: (context, state) {
        final isBusy = state is PaymentInitiating || state is PaymentAwaitingConfirmation;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state is PaymentConfirmed)
              const Text('Payment confirmed')
            else if (state is PaymentWindowExpired)
              const Text('Payment window expired')
            else ...[
              FilledButton(
                onPressed: (order.finalPrice == null || isBusy)
                    ? null
                    : () => context.read<PaymentCubit>().pay(order.finalPrice!),
                child: isBusy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Pay'),
              ),
              TextButton(onPressed: onDecline, child: const Text('Decline')),
            ],
          ],
        );
      },
    );
  }
}

class _OtpBanner extends StatelessWidget {
  const _OtpBanner({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Share this code with your driver'),
            const SizedBox(height: 8),
            Text(code, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class _LiveMap extends StatelessWidget {
  const _LiveMap();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        if (state case TrackingWatching(:final location, :final stale)) {
          if (location == null) {
            return const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return SizedBox(
            height: 240,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(location.lat, location.lng),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('driver'),
                      position: LatLng(location.lat, location.lng),
                    ),
                  },
                ),
                if (stale)
                  const Positioned(
                    top: 8,
                    left: 8,
                    child: Card(
                      color: Colors.amber,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text('Position may be out of date'),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        if (state is TrackingNotTrackable) {
          return const Text('Live tracking is not available yet.');
        }
        return const SizedBox(
          height: 240,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
