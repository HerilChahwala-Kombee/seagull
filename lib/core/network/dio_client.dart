// lib/src/core/dio_client.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seagull/core/api_config.dart';
import 'package:seagull/core/env_config.dart';
import 'package:seagull/core/network/auth_service.dart';
import 'package:seagull/core/network/interceptors/auth_interceptor.dart';
import 'package:seagull/core/network/interceptors/cache_interceptor.dart';
import 'package:seagull/core/network/interceptors/error_interceptor.dart';
import 'package:seagull/core/network/interceptors/logger_interceptor.dart';
import 'package:seagull/core/network/interceptors/retry_interceptor.dart';
import 'package:seagull/core/token_storage_service.dart';

class DioClient {
  late final Dio _dio;
  final ApiConfig _config;
  final Logger _logger = Logger();
  late final AuthInterceptor _authInterceptor;

  // Singleton support for shared instance
  static DioClient? _sharedInstance;

  static DioClient get shared {
    if (_sharedInstance == null) {
      throw StateError('DioClient not initialized. Call DioClient() first.');
    }
    return _sharedInstance!;
  }

  static Future<DioClient> create(ApiConfig config) async {
    final client = DioClient._internal(config);
    client._configureSSLPinningAdapter();
    return client;
  }

  DioClient._internal(this._config) {
    _dio = Dio();
    _setupDio();
    _setupInterceptors();
    _sharedInstance ??= this;
  }

  Dio get dio => _dio;

  AuthInterceptor get authInterceptor => _authInterceptor;

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: _config.baseUrl,
      connectTimeout: _config.connectTimeout,
      sendTimeout: _config.sendTimeout,
      receiveTimeout: _config.receiveTimeout,
      headers: Map<String, dynamic>.from(_config.defaultHeaders),
    );
  }

  void _setupInterceptors() {
    // Interceptor order:
    // 1. Logging (first to log everything)
    // 2. Authentication (before retry and cache)
    // 3. Retry (after auth, before cache)
    // 4. Cache (after retry)
    // 5. Error handling (last to catch all errors)

    // 1. Logging (first to log everything)
    if (_config.enableLogging && _config.environment != Environment.prod) {
      _dio.interceptors.add(LoggingInterceptor(_logger));
    }

    // 2. Authentication (before retry and cache)
    _authInterceptor = AuthInterceptor(dio: _dio, tokenStorage: TokenStorageService(), authService: AuthService(this));
    _dio.interceptors.add(_authInterceptor);

    // 3. Retry (after auth, before cache)
    _dio.interceptors.add(RetryInterceptor(_dio));

    // 4. Cache (after retry)'
    if (_config.enableCaching) {
      _dio.interceptors.add(ApiCacheInterceptor.create(_config));
    }

    // 5. Error handling (last to catch all errors)
    _dio.interceptors.add(ErrorInterceptor());
  }

  void _configureSSLPinningAdapter() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDir.path}/bwAppfiles/certificate.pem'; //Need to chagne as your requirment
    final file = File(filePath);

    // If the certificate does not exist, download it from Firebase Storage
    if (!await file.exists()) {
      await downloadAndSaveCert(filePath);
    }

    // After downloading, ensure the file exists
    if (!await file.exists()) {
      throw Exception('Certificate file not found after downloading.');
    }

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final SecurityContext sc = SecurityContext()..setTrustedCertificates(file.path);
        final HttpClient client = HttpClient(context: sc);
        return client;
      },
    );

    if (kDebugMode) {
      print('Dio is configured with SSL pinning!');
    }
  }

  ///TODO: Set Download SSL cert logic
  Future<void> downloadAndSaveCert(String filePath) async {
    // final FirebaseStorage storage = FirebaseStorage.instance;
    // try {
    //   final Reference islandRef = storage.ref().child('bwAppfiles/certificate.pem');
    //   final File file = File(filePath);

    //   if (!await file.exists()) {
    //     await file.create(recursive: true);
    //   }

    //   await islandRef.writeToFile(file);
    //   print('Certificate downloaded and saved at $filePath');
    // } catch (e) {
    //   print('Error downloading certificate: $e');
    // }
  }

  /// HTTP Method implementations
  /// These methods provide a clean interface to make HTTP requests using Dio.
  /// Each method corresponds to a standard HTTP verb and includes common parameters:
  /// - path: The endpoint URL
  /// - queryParameters: URL query parameters
  /// - options: Request configuration options
  /// - cancelToken: For cancelling requests
  /// - progress callbacks: For tracking upload/download progress
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) => _dio.get<T>(
    path,
    queryParameters: queryParameters,
    options: _mergeOptions(options, headers),
    cancelToken: cancelToken,
    onReceiveProgress: onReceiveProgress,
  );

  /// POST request for creating new resources
  /// data: The request body data
  /// onSendProgress: Callback for upload progress
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => _dio.post<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: _mergeOptions(options, headers),
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  /// PUT request for updating existing resources
  /// Replaces the entire resource with the provided data
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => _dio.put<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: _mergeOptions(options, headers),
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  /// PATCH request for partial resource updates
  /// Only updates specified fields without replacing the entire resource
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => _dio.patch<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: _mergeOptions(options, headers),
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  /// DELETE request for removing resources
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.delete<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: _mergeOptions(options, headers),
    cancelToken: cancelToken,
  );

  /// HEAD request for retrieving response headers only
  /// Useful for checking resource existence or metadata
  Future<Response<T>> head<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.head<T>(
    path,
    queryParameters: queryParameters,
    options: _mergeOptions(options, headers),
    cancelToken: cancelToken,
  );

  /// Download file with progress tracking
  /// urlPath: Source URL of the file
  /// savePath: Local path where file will be saved
  /// deleteOnError: Whether to delete partially downloaded file on error
  Future<Response> download(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
  }) => _dio.download(
    urlPath,
    savePath,
    onReceiveProgress: onReceiveProgress,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
    deleteOnError: deleteOnError,
    lengthHeader: lengthHeader,
    options: options,
  );

  /// Upload file with progress tracking
  /// path: Upload endpoint URL
  /// formData: Multipart form data containing file and other fields
  Future<Response<T>> upload<T>(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.post<T>(
    path,
    data: formData,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
    options: _mergeOptions(options, headers),
    cancelToken: cancelToken,
  );

  /// Clear authentication and reset interceptors
  Future<void> clearAuth() async => await _authInterceptor.clearAuth();

  /// Manually refresh token
  Future<bool> refreshToken() async => await _authInterceptor.refreshTokenIfNeeded();

  /// Update base URL (useful for switching environments)
  void updateBaseUrl(String newBaseUrl) => _dio.options.baseUrl = newBaseUrl;

  /// Add or update default headers
  void updateHeaders(Map<String, dynamic> headers) => _dio.options.headers.addAll(headers);

  /// Remove header
  void removeHeader(String key) => _dio.options.headers.remove(key);

  /// Get current configuration
  ApiConfig get config => _config;

  /// Close dio and clean up resources
  void close({bool force = false}) => _dio.close(force: force);

  Options? _mergeOptions(Options? options, Map<String, dynamic>? headers) {
    if (headers == null) return options;
    final merged = options?.copyWith() ?? Options();
    merged.headers = {...?options?.headers, ...headers};
    return merged;
  }
}
