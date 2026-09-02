import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/support_request.dart';
import '../../domain/usecases/create_support_request.dart';
import '../../domain/usecases/get_support_requests.dart';
import 'support_state.dart';

/// Backs both `support_order_problem_card.dart` (submit) and
/// `support_screen.dart`'s own submitted/acknowledged list (spec 005
/// T119/T120/T121) — one instance shared by the whole screen, since both
/// surfaces are the same request/response cycle.
class SupportCubit extends Cubit<SupportState> {
  SupportCubit({
    required GetSupportRequests getSupportRequests,
    required CreateSupportRequest createSupportRequest,
  }) : _getSupportRequests = getSupportRequests,
       _createSupportRequest = createSupportRequest,
       super(const SupportState.loading());

  final GetSupportRequests _getSupportRequests;
  final CreateSupportRequest _createSupportRequest;

  Future<void> loadRequests() async {
    emit(const SupportState.loading());
    final result = await _getSupportRequests();
    result.fold(
      (failure) => emit(SupportState.failure(failure)),
      (requests) => emit(SupportState.loaded(requests: requests)),
    );
  }

  Future<bool> submit({
    required String topic,
    required String message,
    String? orderId,
  }) async {
    final current = state;
    final requests = current is SupportLoaded
        ? current.requests
        : const <SupportRequest>[];

    emit(SupportState.loaded(requests: requests, isSubmitting: true));
    final result = await _createSupportRequest(
      topic: topic,
      message: message,
      orderId: orderId,
    );
    return result.fold(
      (failure) {
        emit(
          SupportState.loaded(
            requests: requests,
            isSubmitting: false,
            submitError: failure,
          ),
        );
        return false;
      },
      (created) {
        emit(SupportState.loaded(requests: [created, ...requests]));
        return true;
      },
    );
  }

  void clearSubmitError() {
    final current = state;
    if (current is SupportLoaded && current.submitError != null) {
      emit(current.copyWith(submitError: null));
    }
  }
}
