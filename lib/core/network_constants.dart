class NetworkConstants {
  NetworkConstants._();
  static const String authTokenKey = 'auth_token';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String jsonContentType = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  static const String unknownError = 'Unknown error occurred';
  static const String connectionTimeout = 'Connection timeout';
  static const String sendTimeout = 'Send timeout';
  static const String receiveTimeout = 'Receive timeout';
  static const String requestCancelled = 'Request cancelled';
  static const String sslConnectionError =
      'SSL connection error. Please check your connection.';
  static const String noInternetConnection =
      'No internet connection. Please check your network.';
  static const String connectionFailed = 'Connection failed. Please try again.';
  static const String noInternetConnectionAvailable =
      'No internet connection available.';
  static const String invalidResponseFormat =
      'Invalid response format received.';
  static const String badRequest = 'Bad request.';
  static const String authenticationFailed =
      'Authentication failed. Please login again.';
  static const String accessDenied =
      'Access denied. You don\'t have permission.';
  static const String notFound = 'The requested resource was not found.';
  static const String validationFailed = 'Validation failed.';
  static const String tooManyRequests =
      'Too many requests. Please try again later.';
  static const String internalServerError =
      'Internal server error. Please try again later.';
  static const String serverError = 'Server error. Please try again later.';
  static const String serviceUnavailable =
      'Service temporarily unavailable. Please try again later.';
  static const String requestFailedWithStatus = 'Request failed with status';
  static const String requestTimedOut = 'Request timed out. Please try again.';
  static const String pleaseLoginToContinue = 'Please log in to continue.';
  static const String serverTemporarilyUnavailable =
      'Server is temporarily unavailable. Please try again later.';
  static const String tooManyRequestsUI =
      'Too many requests. Please wait a moment and try again.';
  static const String noInternetConnectionUI =
      'No internet connection. Please check your network.';
}
