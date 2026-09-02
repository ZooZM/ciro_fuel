import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/orders/presentation/constants/order_presentation.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/payment_method.dart';

void main() {
  group('cardKindFor', () {
    test('PENDING_APPROVAL is always pendingApproval, regardless of payment method', () {
      for (final method in PaymentMethod.values) {
        expect(
          cardKindFor(OrderStatus.pendingApproval, method),
          OrderCardKind.pendingApproval,
        );
      }
    });

    test(
      'PENDING_PAYMENT shows awaitingPayment for DIRECT only (research R9)',
      () {
        expect(
          cardKindFor(OrderStatus.pendingPayment, PaymentMethod.direct),
          OrderCardKind.awaitingPayment,
        );
      },
    );

    test(
      'PENDING_PAYMENT under DEFERRED or CREDIT never shows a pay action, even though the backend should never route them here',
      () {
        expect(
          cardKindFor(OrderStatus.pendingPayment, PaymentMethod.deferred),
          OrderCardKind.confirmed,
        );
        expect(
          cardKindFor(OrderStatus.pendingPayment, PaymentMethod.credit),
          OrderCardKind.confirmed,
        );
      },
    );

    test(
      'APPROVED is confirmed for every payment method, including DIRECT — '
      'the backend reuses APPROVED for two different moments in a DIRECT '
      "order's life (pre-payment and the post-payment routing pivot), so "
      'it must never imply a pay action is owed',
      () {
        for (final method in PaymentMethod.values) {
          expect(cardKindFor(OrderStatus.approved, method), OrderCardKind.confirmed);
        }
      },
    );

    test(
      'every routing/assignment status is confirmed for every payment method — payment, if any, is already resolved by then',
      () {
        for (final status in [
          OrderStatus.awaitingRouting,
          OrderStatus.routedToTransport,
          OrderStatus.assignedToDriver,
        ]) {
          for (final method in PaymentMethod.values) {
            expect(cardKindFor(status, method), OrderCardKind.confirmed);
          }
        }
      },
    );

    test('IN_TRANSIT and UNLOADING are inTransit for every payment method', () {
      for (final method in PaymentMethod.values) {
        expect(cardKindFor(OrderStatus.inTransit, method), OrderCardKind.inTransit);
        expect(cardKindFor(OrderStatus.unloading, method), OrderCardKind.inTransit);
      }
    });

    test('DELIVERED is delivered for every payment method', () {
      for (final method in PaymentMethod.values) {
        expect(cardKindFor(OrderStatus.delivered, method), OrderCardKind.delivered);
      }
    });

    test('REJECTED and CANCELLED are cancelled for every payment method', () {
      for (final method in PaymentMethod.values) {
        expect(cardKindFor(OrderStatus.rejected, method), OrderCardKind.cancelled);
        expect(cardKindFor(OrderStatus.cancelled, method), OrderCardKind.cancelled);
      }
    });

    test('every OrderStatus × PaymentMethod combination is covered without throwing', () {
      for (final status in OrderStatus.values) {
        for (final method in PaymentMethod.values) {
          expect(() => cardKindFor(status, method), returnsNormally);
        }
      }
    });
  });
}
