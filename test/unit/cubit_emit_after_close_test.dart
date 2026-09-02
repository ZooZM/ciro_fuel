import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/orders/domain/entities/otp_challenge.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_current_otp.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_order.dart';
import 'package:mobile_app/features/orders/presentation/cubit/order_detail_cubit.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/otp_purpose.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetOrder extends Mock implements GetOrder {}

class _MockGetCurrentOtp extends Mock implements GetCurrentOtp {}

class _MockTrackingSocket extends Mock implements TrackingSocket {}

final _order = Order(
  id: 'o1',
  status: OrderStatus.inTransit,
  fuelType: FuelType.gasoline91,
  quantityLiters: 5000,
  statusChangedAt: DateTime.utc(2026, 8, 18),
);

void main() {
  // Regression: `TrackingSocket` has no way to unregister a handler, and
  // OrderDetailCubit is created per screen visit — so a closed cubit keeps
  // receiving `order:status` / `order:otp` pushes, each firing an async
  // load that emits. Pull-to-refresh surfaced it as
  // `Bad state: Cannot emit new states after calling close`.
  group('OrderDetailCubit survives a close mid-request', () {
    late _MockGetOrder getOrder;
    late _MockGetCurrentOtp getCurrentOtp;
    late _MockTrackingSocket socket;

    setUp(() {
      getOrder = _MockGetOrder();
      getCurrentOtp = _MockGetCurrentOtp();
      socket = _MockTrackingSocket();
      when(() => socket.onStatus(any())).thenAnswer((_) {});
      when(() => socket.onOtp(any())).thenAnswer((_) {});
    });

    OrderDetailCubit build() => OrderDetailCubit(
      orderId: 'o1',
      getOrder: getOrder,
      getCurrentOtp: getCurrentOtp,
      socket: socket,
    );

    test('load() completing after close does not throw', () async {
      when(() => getOrder('o1')).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return Right(_order);
      });

      final cubit = build();
      final pending = cubit.load();
      await cubit.close(); // the screen is popped mid-flight
      await expectLater(pending, completes);
    });

    test('loadCurrentOtp() completing after close does not throw', () async {
      when(() => getCurrentOtp('o1')).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return Right(
          OtpChallenge(
            orderId: 'o1',
            purpose: OtpPurpose.arrival,
            code: '151760',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
        );
      });

      final cubit = build();
      final pending = cubit.loadCurrentOtp();
      await cubit.close();
      await expectLater(pending, completes);
    });

    test('a failure arriving after close is equally harmless', () async {
      when(() => getOrder('o1')).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return const Left(Failure.server());
      });

      final cubit = build();
      final pending = cubit.load();
      await cubit.close();
      await expectLater(pending, completes);
    });
  });
}
