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
      'PENDING_PAYMENT under DEFERRED or CREDIT is awaitingAcceptance — the '
      'platform is blocked on the station owner, and it IS routed here: '
      'approval routes the order onward, then routing prices the transport '
      'leg and sends it BACK to PENDING_PAYMENT for their acceptance',
      () {
        // Read as `confirmed` (what this asserted before), the client was told
        // the order was settled at exactly the moment the platform was waiting
        // on them — and the screen offered no way to accept, so the order could
        // never advance. The premise in the old name, that the backend never
        // routes DEFERRED/CREDIT here, is contradicted by
        // `orders.controller.ts`'s own manual-route guard.
        expect(
          cardKindFor(OrderStatus.pendingPayment, PaymentMethod.deferred),
          OrderCardKind.awaitingAcceptance,
        );
        expect(
          cardKindFor(OrderStatus.pendingPayment, PaymentMethod.credit),
          OrderCardKind.awaitingAcceptance,
        );
      },
    );

    test(
      'no non-DIRECT order ever reaches a pay action — the invariant the case '
      'above was really protecting, kept separate from which card it maps to',
      () {
        for (final status in OrderStatus.values) {
          for (final method in [PaymentMethod.deferred, PaymentMethod.credit]) {
            expect(
              cardKindFor(status, method),
              isNot(OrderCardKind.awaitingPayment),
              reason: '$status under $method must never offer a gateway payment',
            );
          }
        }
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
