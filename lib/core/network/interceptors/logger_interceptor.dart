import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Interceptor for logging all Dio requests, responses, and errors.
/// Redacts sensitive headers and supports large payload truncation.
class LoggingInterceptor extends Interceptor {
  final Logger logger;
  final bool logRequestHeaders;
  final bool logResponseHeaders;
  final bool logRequestBody;
  final bool logResponseBody;
  final List<String> sensitiveHeaders;

  LoggingInterceptor(
    this.logger, {
    this.logRequestHeaders = true,
    this.logResponseHeaders = true,
    this.logRequestBody = true,
    this.logResponseBody = true,
    this.sensitiveHeaders = const ['authorization', 'cookie', 'set-cookie'],
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('🚀 REQUEST: ${options.method} ${options.uri}');

    if (logRequestHeaders && options.headers.isNotEmpty) {
      final sanitizedHeaders = _sanitizeHeaders(options.headers);
      logger.d('📋 Request Headers: $sanitizedHeaders');
    }

    if (logRequestBody && options.data != null) {
      logger.d('📤 Request Body: ${_formatData(options.data)}');
    }

    if (options.queryParameters.isNotEmpty) {
      logger.d('🔍 Query Parameters: ${options.queryParameters}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
      '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );

    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      final sanitizedHeaders = _sanitizeHeaders(response.headers.map);
      logger.d('📋 Response Headers: $sanitizedHeaders');
    }

    if (logResponseBody && response.data != null) {
      logger.d('📥 Response Body: ${_formatData(response.data)}');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('❌ ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
    logger.e('💥 Error Type: ${err.type}');
    logger.e('💥 Error Message: ${err.message}');

    if (err.response != null) {
      logger.e('💥 Status Code: ${err.response?.statusCode}');
      if (logResponseBody && err.response?.data != null) {
        logger.e('💥 Error Response: ${_formatData(err.response!.data)}');
      }
    }

    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = <String, dynamic>{};
    headers.forEach((key, value) {
      if (sensitiveHeaders.contains(key.toLowerCase())) {
        sanitized[key] = '***REDACTED***';
      } else {
        sanitized[key] = value;
      }
    });
    return sanitized;
  }

  String _formatData(dynamic data) {
    if (data == null) return 'null';

    try {
      if (data is String && data.length > 1000) {
        return '${data.substring(0, 1000)}... [TRUNCATED]';
      }
      return data.toString();
    } catch (e) {
      return '[UNPARSEABLE DATA]';
    }
  }
}
