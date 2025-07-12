import 'package:dio/dio.dart';
import 'package:seagull/core/network/dio_client.dart';
import 'package:seagull/core/network/models/token_model.dart';
import 'package:seagull/core/network_constants.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService([DioClient? dioClient]) : _dioClient = dioClient ?? DioClient.shared;

  /// Refreshes the access token using the refresh token
  Future<TokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/refresh',
        data: {NetworkConstants.refreshToken: refreshToken},
        options: Options(
          // Don't include auth header for refresh requests
          // headers: {'requiresAuth': false},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return TokenResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to refresh token: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Refresh token expired or invalid');
      }
      throw Exception('Failed to refresh token: ${e.message}');
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  // /// Authenticates user with credentials
  // Future<TokenResponse> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await _dioClient.dio.post(
  //       '/auth/login',
  //       data: {'email': email, 'password': password},
  //       options: Options(headers: {'requiresAuth': false}),
  //     );

  //     if (response.statusCode == 200 && response.data != null) {
  //       return TokenResponse.fromJson(response.data);
  //     } else {
  //       throw Exception('Login failed: Invalid response');
  //     }
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 401) {
  //       throw Exception('Invalid credentials');
  //     } else if (e.response?.statusCode == 422) {
  //       throw Exception('Invalid input data');
  //     }
  //     throw Exception('Login failed: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Login failed: $e');
  //   }
  // }

  // /// Logs out the current user
  // Future<void> logout(String accessToken) async {
  //   try {
  //     await _dioClient.dio.post(
  //       '/auth/logout',
  //       options: Options(headers: {NetworkConstants.authorizationHeader: '${NetworkConstants.bearerPrefix}[200~$accessToken'}),
  //     );
  //   } on DioException catch (e) {
  //     // Log the error but don't throw - logout should always succeed locally
  //     print('Logout API call failed: ${e.message}');
  //   } catch (e) {
  //     print('Logout error: $e');
  //   }
  // }

  // /// Registers a new user
  // Future<TokenResponse> register({
  //   required String email,
  //   required String password,
  //   required String name,
  //   Map<String, dynamic>? additionalData,
  // }) async {
  //   try {
  //     final data = {
  //       'email': email,
  //       'password': password,
  //       'name': name,
  //       ...?additionalData,
  //     };

  //     final response = await _dioClient.dio.post(
  //       '/auth/register',
  //       data: data,
  //       options: Options(headers: {'requiresAuth': false}),
  //     );

  //     if (response.statusCode == 201 && response.data != null) {
  //       return TokenResponse.fromJson(response.data);
  //     } else {
  //       throw Exception('Registration failed: Invalid response');
  //     }
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 409) {
  //       throw Exception('Email already exists');
  //     } else if (e.response?.statusCode == 422) {
  //       throw Exception('Invalid input data');
  //     }
  //     throw Exception('Registration failed: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Registration failed: $e');
  //   }
  // }

  // /// Validates if the current token is still valid
  // Future<bool> validateToken(String accessToken) async {
  //   try {
  //     final response = await _dioClient.dio.get(
  //       '/auth/validate',
  //       options: Options(headers: {NetworkConstants.authorizationHeader: '${NetworkConstants.bearerPrefix}$accessToken'}),
  //     );

  //     return response.statusCode == 200;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // /// Requests password reset
  // Future<void> requestPasswordReset(String email) async {
  //   try {
  //     await _dioClient.dio.post(
  //       '/auth/password-reset',
  //       data: {'email': email},
  //       options: Options(headers: {'requiresAuth': false}),
  //     );
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 404) {
  //       throw Exception('Email not found');
  //     }
  //     throw Exception('Password reset request failed: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Password reset request failed: $e');
  //   }
  // }

  // /// Resets password with token
  // Future<void> resetPassword({
  //   required String token,
  //   required String newPassword,
  // }) async {
  //   try {
  //     await _dioClient.dio.post(
  //       '/auth/password-reset/confirm',
  //       data: {'token': token, 'password': newPassword},
  //       options: Options(headers: {'requiresAuth': false}),
  //     );
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 400) {
  //       throw Exception('Invalid or expired reset token');
  //     }
  //     throw Exception('Password reset failed: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Password reset failed: $e');
  //   }
  // }
}
