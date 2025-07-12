import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:seagull/core/network/auth_service.dart';
import 'package:seagull/core/network_constants.dart';
import 'dart:async';

import 'package:seagull/core/token_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorageService _tokenStorage;
  final AuthService _authService;
  final Dio _dio;

  bool _isRefreshing = false;
  final List<Completer<Response>> _requestsNeedingToken = [];

  AuthInterceptor({TokenStorageService? tokenStorage, AuthService? authService, required Dio dio})
    : _tokenStorage = tokenStorage ?? TokenStorageService(),
      _authService = authService ?? AuthService(),
      _dio = dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for certain endpoints
    // if (options.headers.containsKey('requiresAuth') &&
    //     options.headers['requiresAuth'] == false) {
    //   options.headers.remove('requiresAuth');
    //   handler.next(options);
    //   return;
    // }

    // Add token to request if available
    final token = _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers[NetworkConstants.authorizationHeader] = '${NetworkConstants.bearerPrefix}$token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    // Handle 401 Unauthorized - token might be expired
    if (statusCode == 401) {
      final refreshToken = _tokenStorage.getRefreshToken();

      if (refreshToken != null && !_isRefreshing) {
        try {
          await _refreshTokenAndRetry(err, handler);
          return;
        } catch (e) {
          // Refresh failed, clear tokens and let error propagate
          await _tokenStorage.clearTokens();
          // You might want to trigger a navigation to login screen here
          _notifyAuthenticationFailed();
        }
      } else if (_isRefreshing) {
        // If we're already refreshing, queue this request
        await _queueRequest(err, handler);
        return;
      } else {
        // No refresh token available, clear any existing tokens
        await _tokenStorage.clearTokens();
        _notifyAuthenticationFailed();
      }
    }

    handler.next(err);
  }

  Future<void> _refreshTokenAndRetry(DioException err, ErrorInterceptorHandler handler) async {
    _isRefreshing = true;

    try {
      final refreshToken = _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Attempt to refresh the token
      final tokenResponse = await _authService.refreshToken(refreshToken);

      // Save new tokens
      await _tokenStorage.saveTokens(accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken);

      // Retry the original request with new token
      final response = await _retryRequest(err.requestOptions);
      handler.resolve(response);

      // Process any queued requests
      await _processQueuedRequests();
    } catch (e) {
      // Refresh failed
      await _tokenStorage.clearTokens();
      _notifyAuthenticationFailed();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token = _tokenStorage.getAccessToken();

    // Update the authorization header with new token
    requestOptions.headers[NetworkConstants.authorizationHeader] = '${NetworkConstants.bearerPrefix}$token';

    // Create a new Dio instance to avoid interceptor loops
    final retryDio = Dio()..options = _dio.options;

    return retryDio.fetch(requestOptions);
  }

  Future<void> _queueRequest(DioException err, ErrorInterceptorHandler handler) async {
    final completer = Completer<Response>();
    _requestsNeedingToken.add(completer);

    try {
      // Wait for the token refresh to complete
      final response = await completer.future;
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  Future<void> _processQueuedRequests() async {
    final queuedRequests = List<Completer<Response>>.from(_requestsNeedingToken);
    _requestsNeedingToken.clear();

    for (final completer in queuedRequests) {
      try {
        // This is a simplified approach - in practice, you'd need to store
        // the original RequestOptions for each queued request
        completer.complete(Response(requestOptions: RequestOptions(path: ''), statusCode: 200));
      } catch (e) {
        completer.completeError(e);
      }
    }
  }

  void _notifyAuthenticationFailed() {
    // This is where you'd notify your app that authentication failed
    // For example, you could use a stream controller or callback
    debugPrint('Authentication failed - user needs to login again');

    // You might want to trigger navigation to login screen
    // or emit an event that the app can listen to
  }

  /// Manually trigger a token refresh (useful for proactive refresh)
  Future<bool> refreshTokenIfNeeded() async {
    try {
      final refreshToken = _tokenStorage.getRefreshToken();
      if (refreshToken != null && !_isRefreshing) {
        _isRefreshing = true;
        final tokenResponse = await _authService.refreshToken(refreshToken);
        await _tokenStorage.saveTokens(
          accessToken: tokenResponse.accessToken,
          refreshToken: tokenResponse.refreshToken,
        );
        _isRefreshing = false;
        return true;
      }
    } catch (e) {
      _isRefreshing = false;
      await _tokenStorage.clearTokens();
    }
    return false;
  }

  /// Clear all authentication data
  Future<void> clearAuth() async {
    await _tokenStorage.clearTokens();
    _requestsNeedingToken.clear();
    _isRefreshing = false;
  }
}
