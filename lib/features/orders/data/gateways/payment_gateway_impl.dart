import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../domain/gateways/payment_gateway.dart';

/// Sadad/Mada ship native Android/iOS SDKs with no official Flutter
/// wrapper, so this bridges to them via a platform channel that the native
/// side implements (`android/.../PaymentGatewayPlugin.kt`,
/// `ios/Runner/PaymentGatewayPlugin.swift` — native project work, out of
/// this Dart layer's scope). The channel surfaces the native SDK's own
/// completion/cancellation, never a payment-confirmed guarantee.
class PaymentGatewayImpl implements PaymentGateway {
  PaymentGatewayImpl({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.ciro.fuel/payment_gateway');

  final MethodChannel _channel;

  @override
  Future<Either<Failure, void>> pay({
    required String orderId,
    required Money amount,
  }) async {
    try {
      await _channel.invokeMethod<void>('pay', {
        'orderId': orderId,
        'amountMinor': amount.amountMinor,
        'currency': amount.currency,
      });
      return const Right(null);
    } on PlatformException catch (e) {
      return Left(_mapPlatformError(e));
    }
  }

  Failure _mapPlatformError(PlatformException e) => switch (e.code) {
    'CANCELLED' => const Failure.validation('Payment was cancelled'),
    'NETWORK' => const Failure.network(),
    _ => const Failure.server(),
  };
}
