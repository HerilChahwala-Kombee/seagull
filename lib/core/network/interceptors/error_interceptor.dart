import 'package:dio/dio.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:seagull/core/network/models/api_error.dart';
import 'package:seagull/core/network_constants.dart';

class ErrorInterceptor extends Interceptor {
  final Logger _logger = Logger();

  /// Interceptor for mapping Dio errors to ApiError and logging them for analytics/debugging.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiError = _mapDioErrorToApiError(err);
    // Log all errors for analytics/debugging
    _logger.e('Dio Error: ${err.message}', error: err, stackTrace: err.stackTrace);

    // Create a new DioException with our custom error
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: apiError,
      message: apiError.message,
      stackTrace: err.stackTrace,
    );

    handler.next(customError);
  }

  ApiError _mapDioErrorToApiError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(
          message: NetworkConstants.connectionTimeout,
          type: ApiErrorType.connectionTimeout,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case DioExceptionType.sendTimeout:
        return ApiError(
          message: NetworkConstants.sendTimeout,
          type: ApiErrorType.sendTimeout,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: NetworkConstants.receiveTimeout,
          type: ApiErrorType.receiveTimeout,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case DioExceptionType.connectionError:
        return _handleConnectionError(dioError);

      case DioExceptionType.badResponse:
        return _handleHttpError(dioError);

      case DioExceptionType.cancel:
        return ApiError(
          message: NetworkConstants.requestCancelled,
          type: ApiErrorType.cancelled,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case DioExceptionType.unknown:
        return _handleUnknownError(dioError);

      default:
        return ApiError(
          message: NetworkConstants.unknownError,
          type: ApiErrorType.unknown,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );
    }
  }

  ApiError _handleConnectionError(DioException dioError) {
    if (dioError.error is SocketException) {
      final socketException = dioError.error as SocketException;

      // Check for specific SSL/TLS errors
      if (socketException.message.toLowerCase().contains('certificate') ||
          socketException.message.toLowerCase().contains('ssl') ||
          socketException.message.toLowerCase().contains('tls')) {
        return ApiError(
          message: NetworkConstants.sslConnectionError,
          type: ApiErrorType.sslError,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );
      }

      return ApiError(
        message: NetworkConstants.noInternetConnection,
        type: ApiErrorType.noInternet,
        originalError: dioError,
        requestOptions: dioError.requestOptions,
        stackTrace: dioError.stackTrace,
      );
    }

    return ApiError(
      message: NetworkConstants.connectionFailed,
      type: ApiErrorType.connectionError,
      originalError: dioError,
      requestOptions: dioError.requestOptions,
      stackTrace: dioError.stackTrace,
    );
  }

  ApiError _handleUnknownError(DioException dioError) {
    if (dioError.error is SocketException) {
      return ApiError(
        message: NetworkConstants.noInternetConnectionAvailable,
        type: ApiErrorType.noInternet,
        originalError: dioError,
        requestOptions: dioError.requestOptions,
        stackTrace: dioError.stackTrace,
      );
    }

    // Check for parsing errors
    if (dioError.error is FormatException) {
      return ApiError(
        message: NetworkConstants.invalidResponseFormat,
        type: ApiErrorType.parseError,
        originalError: dioError,
        requestOptions: dioError.requestOptions,
        stackTrace: dioError.stackTrace,
      );
    }

    return ApiError(
      message: NetworkConstants.unknownError,
      type: ApiErrorType.unknown,
      originalError: dioError,
      requestOptions: dioError.requestOptions,
      stackTrace: dioError.stackTrace,
    );
  }

  ApiError _handleHttpError(DioException dioError) {
    final statusCode = dioError.response?.statusCode;
    final responseData = dioError.response?.data;

    switch (statusCode) {
      case 400:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.badRequest,
          type: ApiErrorType.badResponse,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case 401:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.authenticationFailed,
          type: ApiErrorType.unauthorized,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case 403:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.accessDenied,
          type: ApiErrorType.forbidden,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case 404:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.notFound,
          type: ApiErrorType.notFound,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case 422:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.validationFailed,
          type: ApiErrorType.validation,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case 429:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.tooManyRequests,
          type: ApiErrorType.rateLimitExceeded,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case 500:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.internalServerError,
          type: ApiErrorType.serverError,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case 501:
      case 502:
      case 504:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.serverError,
          type: ApiErrorType.serverError,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      case 503:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? NetworkConstants.serviceUnavailable,
          type: ApiErrorType.serviceUnavailable,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );

      default:
        return ApiError(
          message: _extractErrorMessage(responseData) ?? '${NetworkConstants.requestFailedWithStatus} $statusCode.',
          type: ApiErrorType.badResponse,
          statusCode: statusCode,
          originalError: dioError,
          requestOptions: dioError.requestOptions,
          stackTrace: dioError.stackTrace,
        );
    }
  }

  String? _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    try {
      if (responseData is Map<String, dynamic>) {
        // Try different common API error message patterns
        final message =
            responseData['message'] as String? ??
            responseData['error'] as String? ??
            responseData['detail'] as String? ??
            responseData['error_description'] as String? ??
            responseData['errors']?['message'] as String?;

        // Handle validation errors array
        if (message == null && responseData['errors'] is List) {
          final errors = responseData['errors'] as List;
          if (errors.isNotEmpty) {
            return errors.first.toString();
          }
        }

        return message;
      } else if (responseData is String) {
        return responseData.isNotEmpty ? responseData : null;
      }
    } catch (e) {
      // If we can't parse the error message, return null
    }

    return null;
  }

  /// Error handling strategy:
  /// - All errors are mapped to ApiError for consistency
  /// - Errors are logged for analytics/debugging
  /// - Custom error types are used for UI and retry logic
}
