import 'package:seagull/core/network/models/api_error.dart';

// ================================
// Enhanced API Response Model
// ================================

class ApiResponse<T> {
  final T? data;
  final ApiError? error;
  final int? statusCode;
  final String? statusMessage;
  final Map<String, List<String>>? headers;
  final Map<String, dynamic>? extra;

  const ApiResponse({this.data, this.error, this.statusCode, this.statusMessage, this.headers, this.extra});

  /// Check if the response is successful
  bool get isSuccess => error == null && data != null;

  /// Check if the response has error
  bool get hasError => error != null;

  /// Get error message or return default
  String getErrorMessage([String defaultMessage = 'Unknown error']) {
    return error?.message ?? defaultMessage;
  }

  /// Convert to map for logging/debugging
  Map<String, dynamic> toMap() {
    return {
      'hasData': data != null,
      'hasError': error != null,
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'errorMessage': error?.message,
      'errorType': error?.type.toString(),
    };
  }

  @override
  String toString() {
    if (hasError) {
      return 'ApiResponse.error(${error!.message})';
    }
    return 'ApiResponse.success(statusCode: $statusCode)';
  }
}
