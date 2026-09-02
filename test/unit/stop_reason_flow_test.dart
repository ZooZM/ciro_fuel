import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/delivery/domain/usecases/declare_stop.dart';
import 'package:mobile_app/features/delivery/domain/usecases/submit_stop_reason.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/stop_reason_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/stop_reason_state.dart';
import 'package:mobile_app/shared/enums/stop_reason.dart';
import 'package:mocktail/mocktail.dart';

class _MockSubmitStopReason extends Mock implements SubmitStopReason {}

class _MockDeclareStop extends Mock implements DeclareStop {}

/// spec 011 T033 (FR-005, FR-006, SC-003): the shape of the driver's answer.
///
/// The requirement this pins is a *usability* one with a correctness edge:
/// a driver at the roadside, possibly dealing with the problem itself, must
/// be able to answer in one tap. The natural implementation — one text field,
/// validated as required — satisfies "the driver gave a reason" perfectly
/// and fails SC-003 completely. So the assertions here are about what is
/// *not* required as much as what is.
void main() {
  late _MockSubmitStopReason submitStopReason;
  late _MockDeclareStop declareStop;
  late StopReasonCubit cubit;

  setUpAll(() {
    // mocktail needs a concrete instance to hand back for `any(named:
    // 'reason')` under sound null safety.
    registerFallbackValue(StopReason.traffic);
  });

  setUp(() {
    submitStopReason = _MockSubmitStopReason();
    declareStop = _MockDeclareStop();
    when(
      () => submitStopReason(
        orderId: any(named: 'orderId'),
        stopId: any(named: 'stopId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => declareStop(
        orderId: any(named: 'orderId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
        expectedDurationMinutes: any(named: 'expectedDurationMinutes'),
      ),
    ).thenAnswer((_) async => const Right(null));
    cubit = StopReasonCubit(
      submitStopReason: submitStopReason,
      declareStop: declareStop,
    );
  });

  tearDown(() => cubit.close());

  test('a common reason submits with no text entry at all (SC-003)', () async {
    cubit.select(StopReason.traffic);
    // No setText call anywhere — that is the assertion.
    await cubit.submit(orderId: 'o1', stopId: 's1');

    expect(cubit.state, const StopReasonState.sent());
    final captured = verify(
      () => submitStopReason(
        orderId: 'o1',
        stopId: 's1',
        reason: StopReason.traffic,
        reasonText: captureAny(named: 'reasonText'),
      ),
    ).captured.single;
    // Nothing invented to fill the field: a non-OTHER reason carries no text.
    expect(captured, isNull);
  });

  test('selecting OTHER, and only OTHER, asks for text', () {
    cubit.select(StopReason.traffic);
    expect((cubit.state as StopReasonEditing).needsText, isFalse);

    cubit.select(StopReason.other);
    expect((cubit.state as StopReasonEditing).needsText, isTrue);

    // And changing their mind puts the keyboard away again.
    cubit.select(StopReason.restOrPrayer);
    expect((cubit.state as StopReasonEditing).needsText, isFalse);
  });

  test('OTHER with no text does not submit, and says why (FR-006)', () async {
    cubit.select(StopReason.other);
    await cubit.submit(orderId: 'o1', stopId: 's1');

    expect(cubit.state, isA<StopReasonEditing>());
    expect((cubit.state as StopReasonEditing).textMissing, isTrue);
    verifyNever(
      () => submitStopReason(
        orderId: any(named: 'orderId'),
        stopId: any(named: 'stopId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    );
  });

  test('whitespace is not an answer', () async {
    cubit.select(StopReason.other);
    cubit.setText('   ');
    await cubit.submit(orderId: 'o1', stopId: 's1');

    expect((cubit.state as StopReasonEditing).textMissing, isTrue);
    verifyNever(
      () => submitStopReason(
        orderId: any(named: 'orderId'),
        stopId: any(named: 'stopId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    );
  });

  test('OTHER with text submits, trimmed', () async {
    cubit.select(StopReason.other);
    cubit.setText('  Police checkpoint  ');
    await cubit.submit(orderId: 'o1', stopId: 's1');

    expect(cubit.state, const StopReasonState.sent());
    verify(
      () => submitStopReason(
        orderId: 'o1',
        stopId: 's1',
        reason: StopReason.other,
        reasonText: 'Police checkpoint',
      ),
    ).called(1);
  });

  test('typing clears the missing-text complaint', () {
    cubit.select(StopReason.other);
    cubit.setText('');
    // Provoke the complaint, then start typing.
    cubit.submit(orderId: 'o1', stopId: 's1');
    cubit.setText('B');
    expect((cubit.state as StopReasonEditing).textMissing, isFalse);
    expect((cubit.state as StopReasonEditing).needsText, isTrue);
  });

  test('nothing is sent until a reason is chosen', () async {
    await cubit.submit(orderId: 'o1', stopId: 's1');
    await cubit.declare(orderId: 'o1', expectedDurationMinutes: 20);

    verifyNever(
      () => submitStopReason(
        orderId: any(named: 'orderId'),
        stopId: any(named: 'stopId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    );
    verifyNever(
      () => declareStop(
        orderId: any(named: 'orderId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
        expectedDurationMinutes: any(named: 'expectedDurationMinutes'),
      ),
    );
  });

  test('declaring carries the same reason rules plus a duration (FR-008a)', () async {
    cubit.select(StopReason.restOrPrayer);
    await cubit.declare(orderId: 'o1', expectedDurationMinutes: 20);

    expect(cubit.state, const StopReasonState.sent());
    verify(
      () => declareStop(
        orderId: 'o1',
        reason: StopReason.restOrPrayer,
        reasonText: null,
        expectedDurationMinutes: 20,
      ),
    ).called(1);
  });

  test('a failed send is surfaced, not swallowed', () async {
    when(
      () => submitStopReason(
        orderId: any(named: 'orderId'),
        stopId: any(named: 'stopId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async => const Left(Failure.network()));

    cubit.select(StopReason.accident);
    await cubit.submit(orderId: 'o1', stopId: 's1');

    // The driver must know their answer did not arrive: silently showing
    // "sent" would leave them believing the transport office had been told
    // while the escalation timer was still running.
    expect(cubit.state, isA<StopReasonFailed>());
  });
}
