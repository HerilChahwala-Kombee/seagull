import 'package:dio/dio.dart';
import 'dart:math';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  RetryInterceptor(
    this.dio, {
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && _getRetryCount(err.requestOptions) < maxRetries) {
      final retryCount = _incrementRetryCount(err.requestOptions);
      final delay = _calculateDelay(retryCount);

      await Future.delayed(delay);

      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Continue with original error if retry fails
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500) ||
        err.response?.statusCode == 429;
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retry_count'] as int? ?? 0;
  }

  int _incrementRetryCount(RequestOptions options) {
    final count = _getRetryCount(options) + 1;
    options.extra['retry_count'] = count;
    return count;
  }

  Duration _calculateDelay(int retryCount) {
    // Exponential backoff with jitter
    final exponentialDelay = baseDelay * pow(2, retryCount - 1);
    final jitter = Random().nextDouble() * 0.5 + 0.75; // 75-125% of delay
    return Duration(
      milliseconds: (exponentialDelay.inMilliseconds * jitter).round(),
    );
  }
}
