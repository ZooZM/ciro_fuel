import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/failure.dart';
import 'error_codes.dart';

/// The single place a `DioException` is shaped into a [Failure]
/// (Constitution Principle III). Added after [AuthInterceptor] so a 401
/// only reaches here once silent refresh has already been attempted and
/// failed — see contracts/backend-integration.md error map.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[ErrorInterceptor] ${err.requestOptions.method} '
        '${err.requestOptions.uri} -> type=${err.type} '
        'message=${err.message} underlying=${err.error}',
      );
    }
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        message: err.message,
        error: _toFailure(err),
      ),
    );
  }

  Failure _toFailure(DioException err) {
    if (err.type == DioExceptionType.badResponse) {
      return _fromStatusCode(err);
    }
    return const Failure.network();
  }

  Failure _fromStatusCode(DioException err) {
    final statusCode = err.response?.statusCode;
    final message = _extractMessage(err.response?.data);
    final code = _extractCode(err.response?.data);

    // A recognised application error code (feature 005's ErrorCode enum)
    // always yields a validation-shaped failure regardless of status, so a
    // business-rule response that doesn't fit neatly into 400/409/422 —
    // e.g. SMS_SEND_FAILED's 502 — still reaches the caller as something
    // branchable by `code`, not a generic, undifferentiated server error.
    if (code != null) {
      return Failure.validation(
        message ?? 'Request rejected',
        code: code,
        extra: _extractExtra(err.response?.data),
      );
    }

    return switch (statusCode) {
      401 => const Failure.auth(),
      403 => const Failure.auth(forbidden: true),
      404 => const Failure.notFound(),
      409 || 422 || 400 => Failure.validation(message ?? 'Request rejected'),
      429 => Failure.throttled(retryAfter: _retryAfter(err.response)),
      _ => const Failure.server(),
    };
  }

  String? _extractMessage(Object? data) {
    if (data is Map<String, Object?>) {
      final message = data['message'];
      if (message is String) return message;
      if (message is List) return message.join(', ');
    }
    return null;
  }

  /// The uniform error envelope's `error` field (`HttpExceptionFilter`) is
  /// normally just the thrown exception's class name (`"ConflictException"`,
  /// `"BadRequestException"`) — not a code worth branching on. Only a
  /// feature-005 `ErrorCode` value is meaningful here, so anything else is
  /// treated as absent rather than surfaced as a false-positive `code`.
  String? _extractCode(Object? data) {
    if (data is! Map<String, Object?>) return null;
    final error = data['error'];
    if (error is! String) return null;
    return _knownCodes.contains(error) ? error : null;
  }

  /// Everything in the response body except the two fields already surfaced
  /// as `message`/`code` — e.g. `QUOTE_STALE`'s `currentBreakdown`.
  Map<String, Object?>? _extractExtra(Object? data) {
    if (data is! Map<String, Object?>) return null;
    final rest = Map<String, Object?>.from(data)
      ..remove('message')
      ..remove('error')
      ..remove('statusCode');
    return rest.isEmpty ? null : rest;
  }

  static const Set<String> _knownCodes = {
    ErrorCodes.pricingNotConfigured,
    ErrorCodes.quoteStale,
    ErrorCodes.quoteExpired,
    ErrorCodes.phoneInUse,
    ErrorCodes.smsSendFailed,
    ErrorCodes.lastStation,
    // spec 006: RESET_RATE_LIMITED is a 429 but still recognised here (the
    // `code != null` branch below runs before the status-code switch), so
    // its `retryAfterSeconds` reaches the caller through `extra` — the same
    // path `QUOTE_STALE`'s `currentBreakdown` already uses — rather than
    // needing the header-based `_retryAfter` below, which nothing in this
    // backend actually sets (its 429s carry the wait in the body, not a
    // `Retry-After` header).
    ErrorCodes.resetCodeInvalid,
    ErrorCodes.resetRateLimited,
    ErrorCodes.sessionRevoked,
    // spec 007: both 409s, recognised here so the rating UI can distinguish
    // "not delivered yet" from "already rated" rather than one generic
    // rejection message.
    ErrorCodes.orderNotDelivered,
    ErrorCodes.alreadyRated,
    // spec 008: recognised so the driver's three refusal causes (FR-037)
    // stay distinct codes rather than collapsing into a generic failure —
    // a code absent from this set is discarded before the caller ever sees it.
    ErrorCodes.vehicleMismatch,
    ErrorCodes.vehicleNotVerified,
    ErrorCodes.notAtWarehouse,
    ErrorCodes.locationRequired,
    ErrorCodes.truckUnavailable,
    ErrorCodes.tankUnavailable,
    ErrorCodes.tankCapacityExceeded,
    ErrorCodes.tankGradeUnsupported,
    ErrorCodes.cardAlreadyPaired,
    ErrorCodes.tankCodeInUse,
    ErrorCodes.duplicatePlate,
    ErrorCodes.noWarehouseForGrade,
    ErrorCodes.alreadyDeparted,
  };

  Duration? _retryAfter(Response<dynamic>? response) {
    final header = response?.headers.value('retry-after');
    final seconds = header != null ? int.tryParse(header) : null;
    return seconds != null ? Duration(seconds: seconds) : null;
  }
}
