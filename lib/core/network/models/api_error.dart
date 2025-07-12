import 'package:dio/dio.dart';
import 'package:seagull/core/network_constants.dart';
import 'package:equatable/equatable.dart';

enum ApiErrorType {
  // Network errors
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  connectionError,
  noInternet,
  sslError,

  // HTTP errors
  badResponse,
  unauthorized,
  forbidden,
  notFound,
  validation,
  rateLimitExceeded,
  serverError,
  serviceUnavailable,

  // Client errors
  cancelled,
  parseError,
  cacheError,
  unknown,
}

class ApiError extends Equatable implements Exception {
  final String message;
  final ApiErrorType type;
  final int? statusCode;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final RequestOptions? requestOptions;
  final DateTime timestamp;

  ApiError({
    required this.message,
    required this.type,
    this.statusCode,
    this.originalError,
    this.stackTrace,
    this.requestOptions,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Check if error is network related
  bool get isNetworkError => [
    ApiErrorType.connectionTimeout,
    ApiErrorType.sendTimeout,
    ApiErrorType.receiveTimeout,
    ApiErrorType.connectionError,
    ApiErrorType.noInternet,
    ApiErrorType.sslError,
  ].contains(type);

  /// Check if error is server related
  bool get isServerError => [ApiErrorType.serverError, ApiErrorType.serviceUnavailable].contains(type);

  /// Check if error is client related
  bool get isClientError => [
    ApiErrorType.unauthorized,
    ApiErrorType.forbidden,
    ApiErrorType.notFound,
    ApiErrorType.validation,
    ApiErrorType.rateLimitExceeded,
  ].contains(type);

  /// Check if request can be retried
  bool get isRetriable => [
    ApiErrorType.connectionTimeout,
    ApiErrorType.receiveTimeout,
    ApiErrorType.serverError,
    ApiErrorType.serviceUnavailable,
    ApiErrorType.noInternet,
  ].contains(type);

  /// User-friendly error message for UI
  String get userFriendlyMessage {
    switch (type) {
      case ApiErrorType.noInternet:
        return NetworkConstants.noInternetConnectionUI;
      case ApiErrorType.connectionTimeout:
      case ApiErrorType.receiveTimeout:
        return NetworkConstants.requestTimedOut;
      case ApiErrorType.unauthorized:
        return NetworkConstants.pleaseLoginToContinue;
      case ApiErrorType.serverError:
      case ApiErrorType.serviceUnavailable:
        return NetworkConstants.serverTemporarilyUnavailable;
      case ApiErrorType.rateLimitExceeded:
        return NetworkConstants.tooManyRequestsUI;
      default:
        return message;
    }
  }

  /// Convert to map for logging
  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'message': message,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isNetworkError': isNetworkError,
      'isServerError': isServerError,
      'isClientError': isClientError,
      'isRetriable': isRetriable,
      'url': requestOptions?.uri.toString(),
      'method': requestOptions?.method,
    };
  }

  @override
  String toString() => 'ApiError(statusCode: $statusCode, type: $type, message: $message)';

  @override
  List<Object?> get props => [message, type, statusCode, originalError, stackTrace, requestOptions, timestamp];
}
