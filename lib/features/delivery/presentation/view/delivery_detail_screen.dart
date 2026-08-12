import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/enums/order_status.dart';
import '../cubit/delivery_cubit.dart';
import '../cubit/delivery_state.dart';
import '../cubit/otp_verify_cubit.dart';
import '../cubit/otp_verify_state.dart';

enum _OtpStep { arrival, delivery, done }

class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DeliveryCubit(
            getActiveOrder: getIt(),
            locationStream: getIt(),
            socket: getIt(),
          )..load(),
        ),
        BlocProvider(
          create: (_) => OtpVerifyCubit(
            orderId: orderId,
            markArrived: getIt(),
            verifyArrivalOtp: getIt(),
            requestDeliveryOtp: getIt(),
            verifyDeliveryOtp: getIt(),
          ),
        ),
      ],
      child: const _DeliveryDetailView(),
    );
  }
}

class _DeliveryDetailView extends StatefulWidget {
  const _DeliveryDetailView();

  @override
  State<_DeliveryDetailView> createState() => _DeliveryDetailViewState();
}

class _DeliveryDetailViewState extends State<_DeliveryDetailView> {
  final _otpController = TextEditingController();
  _OtpStep? _step;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _initStepFrom(OrderStatus status) {
    _step ??= status == OrderStatus.unloading
        ? _OtpStep.delivery
        : _OtpStep.arrival;
  }

  String _rejectionMessage(OtpVerifyState state) => switch (state) {
    OtpVerifyThrottled(:final retryAfter) =>
      retryAfter != null
          ? DriverKeys.throttledIn.tr(
              namedArgs: {'minutes': '${retryAfter.inMinutes}'},
            )
          : DriverKeys.throttled.tr(),
    OtpVerifyRejected() => DriverKeys.codeRejected.tr(),
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DriverKeys.delivery.tr())),
      body: BlocListener<OtpVerifyCubit, OtpVerifyState>(
        listener: (context, state) {
          switch (state) {
            case OtpVerifyAdvanced(:final to):
              setState(() {
                _step = to == OrderStatus.delivered
                    ? _OtpStep.done
                    : _OtpStep.delivery;
              });
              _otpController.clear();
            case OtpVerifyRejected() || OtpVerifyThrottled():
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(_rejectionMessage(state))));
            case OtpVerifyIdle() || OtpVerifying():
              break;
          }
        },
        child: BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, deliveryState) => switch (deliveryState) {
            DeliveryNoActiveOrder() => Center(
              child: Text(DriverKeys.noActiveDelivery.tr()),
            ),
            DeliveryFailureState() => Center(
              child: Text(DriverKeys.loadFailed.tr()),
            ),
            DeliveryActive(:final order) => Builder(
              builder: (context) {
                _initStepFrom(order.status);
                return _buildStep(context, order.id);
              },
            ),
          },
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String orderId) {
    return BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
      builder: (context, otpState) {
        final busy = otpState is OtpVerifying;

        if (_step == _OtpStep.done) {
          return Center(child: Text(DriverKeys.deliveryComplete.tr()));
        }

        final isArrival = _step == _OtpStep.arrival;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isArrival)
                FilledButton(
                  onPressed: busy
                      ? null
                      : () => context.read<OtpVerifyCubit>().markArrived(),
                  child: Text(DriverKeys.arrived.tr()),
                )
              else
                FilledButton(
                  onPressed: busy
                      ? null
                      : () =>
                            context.read<OtpVerifyCubit>().requestDeliveryOtp(),
                  child: Text(DriverKeys.requestDeliveryCode.tr()),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: isArrival
                      ? DriverKeys.arrivalCode.tr()
                      : DriverKeys.deliveryCode.tr(),
                ),
              ),
              FilledButton(
                onPressed: busy || _otpController.text.isEmpty
                    ? null
                    : () {
                        final cubit = context.read<OtpVerifyCubit>();
                        if (isArrival) {
                          cubit.submitArrivalOtp(_otpController.text);
                        } else {
                          cubit.submitDeliveryOtp(_otpController.text);
                        }
                      },
                child: busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(DriverKeys.verify.tr()),
              ),
            ],
          ),
        );
      },
    );
  }
}
