import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/confirm_phone_verification.dart';
import '../../domain/usecases/request_phone_verification.dart';
import 'phone_verification_state.dart';

/// One instance per screen visit (spec 005 T101) — a fresh instance for
/// `change_phone_screen.dart` and another for `verify_phone_screen.dart`,
/// each calling the usecase its own step needs directly rather than one
/// instance threaded across the two route pushes (mirrors `CreditCubit`'s
/// one-shot-per-visit shape, not `OrdersCubit`'s session-lifetime one).
class PhoneVerificationCubit extends Cubit<PhoneVerificationState> {
  PhoneVerificationCubit({
    required RequestPhoneVerification requestVerification,
    required ConfirmPhoneVerification confirmVerification,
  }) : _requestVerification = requestVerification,
       _confirmVerification = confirmVerification,
       super(const PhoneVerificationState.idle());

  final RequestPhoneVerification _requestVerification;
  final ConfirmPhoneVerification _confirmVerification;

  Future<void> requestCode(String newPhone) async {
    emit(const PhoneVerificationState.sending());
    final result = await _requestVerification(newPhone);
    result.fold(
      (failure) => emit(PhoneVerificationState.failure(failure)),
      (data) => emit(
        PhoneVerificationState.codeSent(
          newPhone: newPhone,
          expiresAt: data.expiresAt,
          attemptsRemaining: data.attemptsRemaining,
        ),
      ),
    );
  }

  Future<void> confirmCode(String code) async {
    emit(const PhoneVerificationState.confirming());
    final result = await _confirmVerification(code);
    result.fold(
      (failure) => emit(PhoneVerificationState.failure(failure)),
      (_) => emit(const PhoneVerificationState.confirmed()),
    );
  }
}
