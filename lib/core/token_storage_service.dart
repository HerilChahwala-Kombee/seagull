import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seagull/core/network_constants.dart';

class TokenStorageService {
  static const _accessTokenKey = NetworkConstants.accessToken;
  static const _refreshTokenKey = NetworkConstants.refreshToken;
  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  /// Initialize and cache tokens on app start
  Future<void> init() async {
    _cachedAccessToken = await _storage.read(key: _accessTokenKey);
    _cachedRefreshToken = await _storage.read(key: _refreshTokenKey);
  }

  /// Use in-memory cached tokens for faster access
  String? getAccessToken() => _cachedAccessToken;
  String? getRefreshToken() => _cachedRefreshToken;

  /// Save tokens to secure storage and update cache
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  /// Clear tokens from secure storage and in-memory cache
  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    await Future.wait([_storage.delete(key: _accessTokenKey), _storage.delete(key: _refreshTokenKey)]);
  }

  /// Check if tokens are valid (using cache)
  bool hasValidTokens() => _cachedAccessToken != null && _cachedRefreshToken != null;
}
