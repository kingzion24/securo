import 'package:dio/dio.dart';

/// A failed API call, reduced to something showable.
///
/// Port of `extractApiError` in `frontend/src/lib/api-errors.ts`: FastAPI puts
/// the message in `detail`, which is a string for hand-raised HTTPExceptions
/// and a list of `{loc, msg}` records for request-validation failures.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.code});

  final String message;
  final int? statusCode;

  /// The machine-readable `detail.code` some endpoints return alongside the
  /// message — passkey ceremonies use it to explain *why* an origin is
  /// unusable, for example.
  final String? code;

  bool get isUnauthorized => statusCode == 401;

  factory ApiException.from(
    DioException error, {
    String fallback = 'An unexpected error occurred',
  }) {
    final response = error.response;

    if (response == null) {
      final message = switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          'The server took too long to respond. Check that you are connected '
              'to your tailnet.',
        DioExceptionType.connectionError =>
          'Could not reach the server. Check that you are connected to your '
              'tailnet and that the server address is correct.',
        DioExceptionType.badCertificate =>
          'The server certificate could not be verified.',
        DioExceptionType.cancel => 'The request was cancelled.',
        _ => fallback,
      };
      return ApiException(message);
    }

    final detail = switch (response.data) {
      Map<String, dynamic> data => data['detail'],
      _ => null,
    };

    return switch (detail) {
      String message when message.trim().isNotEmpty =>
        ApiException(message, statusCode: response.statusCode),
      // Endpoints that return `{"detail": {"code": ..., "message": ...}}`.
      Map<String, dynamic> map => ApiException(
          map['message'] as String? ?? fallback,
          statusCode: response.statusCode,
          code: map['code'] as String?,
        ),
      // Pydantic validation errors: a list of {loc, msg}.
      List<dynamic> items when items.isNotEmpty => ApiException(
          _formatValidationErrors(items, fallback),
          statusCode: response.statusCode,
        ),
      _ => ApiException(fallback, statusCode: response.statusCode),
    };
  }

  static String _formatValidationErrors(List<dynamic> items, String fallback) {
    final parts = <String>[];
    for (final item in items) {
      if (item is! Map) continue;
      final loc = item['loc'];
      final field = loc is List && loc.isNotEmpty ? '${loc.last}' : '';
      final msg = item['msg'] as String? ?? 'invalid';
      parts.add(field.isEmpty ? msg : '$field: $msg');
    }
    final message = parts.join(', ').trim();
    return message.isEmpty ? fallback : message;
  }

  @override
  String toString() => message;
}
