import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/widgets/order_flow.dart';
import 'package:mobile_app/features/orders/presentation/constants/order_presentation.dart';
import 'package:mobile_app/shared/enums/order_status.dart';

void main() {
  // The dashboard's current-order card used to draw `const OrderFlow()`,
  // taking the widget's `onTheWay` default. Every order therefore rendered
  // as accepted, loaded and dispatched — three green steps — no matter what
  // the platform actually said, including an order still under review.
  group('OrderPresentation.flowStep follows the real status', () {
    test('an order under review has no completed step behind it', () {
      final step = OrderPresentation.flowStep(OrderStatus.pendingApproval);

      // `OrderFlow` paints a step green only when `step.index <
      // current.index`, so sitting on the first stop is what guarantees no
      // step reads as done while the order is still awaiting acceptance.
      expect(step, OrderFlowStep.accepted);
      expect(step.index, 0);
    });

    test('a rejected or cancelled order never shows progress', () {
      for (final status in [OrderStatus.rejected, OrderStatus.cancelled]) {
        expect(OrderPresentation.flowStep(status).index, 0, reason: '$status');
      }
    });

    test('the journey advances monotonically with the lifecycle', () {
      // Each stage must sit no earlier on the timeline than the one before
      // it, or the card would appear to travel backwards.
      const lifecycle = [
        OrderStatus.pendingApproval,
        OrderStatus.approved,
        OrderStatus.awaitingRouting,
        OrderStatus.routedToTransport,
        OrderStatus.assignedToDriver,
        OrderStatus.pendingPayment,
        OrderStatus.inTransit,
        OrderStatus.unloading,
        OrderStatus.delivered,
      ];

      for (var i = 1; i < lifecycle.length; i++) {
        expect(
          OrderPresentation.flowStep(lifecycle[i]).index,
          greaterThanOrEqualTo(
            OrderPresentation.flowStep(lifecycle[i - 1]).index,
          ),
          reason: '${lifecycle[i]} went backwards from ${lifecycle[i - 1]}',
        );
      }
    });

    test('in transit is the step the card paints blue', () {
      expect(
        OrderPresentation.flowStep(OrderStatus.inTransit),
        OrderFlowStep.onTheWay,
      );
    });
  });

  group('OrderPresentation.isTrackable', () {
    test('only an in-transit order offers track and contact', () {
      for (final status in OrderStatus.values) {
        expect(
          OrderPresentation.isTrackable(status),
          status == OrderStatus.inTransit,
          reason:
              '$status must not offer a map to follow or a driver to call — '
              'there is no driver assigned and no position to plot',
        );
      }
    });
  });
}
