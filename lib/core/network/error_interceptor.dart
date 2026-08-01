import 'package:dio/dio.dart';

import '../error/failure.dart';

/// The single place a `DioException` is shaped into a [Failure]
/// (Constitution Principle III). Added after [AuthInterceptor] so a 401
/// only reaches here once silent refresh has already been attempted and
/// failed — see contracts/backend-integration.md error map.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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

  Duration? _retryAfter(Response<dynamic>? response) {
    final header = response?.headers.value('retry-after');
    final seconds = header != null ? int.tryParse(header) : null;
    return seconds != null ? Duration(seconds: seconds) : null;
  }
}
