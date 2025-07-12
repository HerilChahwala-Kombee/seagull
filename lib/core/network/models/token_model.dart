// lib/src/models/token_response.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenResponse extends Equatable {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  final String? scope;

  const TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    required this.expiresIn,
    this.expiresAt,
    this.scope,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  /// Check if the token is expired
  bool get isExpired {
    if (expiresAt != null) {
      return DateTime.now().isAfter(expiresAt!);
    }
    // If no expiration time is provided, assume it's still valid
    return false;
  }

  /// Check if the token will expire within the given duration
  bool willExpireWithin(Duration duration) {
    if (expiresAt != null) {
      final expirationThreshold = DateTime.now().add(duration);
      return expiresAt!.isBefore(expirationThreshold);
    }
    return false;
  }

  /// Get remaining time until token expires
  Duration? get timeUntilExpiry {
    if (expiresAt != null) {
      final now = DateTime.now();
      if (expiresAt!.isAfter(now)) {
        return expiresAt!.difference(now);
      }
      return Duration.zero;
    }
    return null;
  }

  /// Create a copy of this TokenResponse with updated values
  TokenResponse copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    DateTime? expiresAt,
    String? scope,
  }) =>
      TokenResponse(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        tokenType: tokenType ?? this.tokenType,
        expiresIn: expiresIn ?? this.expiresIn,
        expiresAt: expiresAt ?? this.expiresAt,
        scope: scope ?? this.scope,
      );

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        expiresIn,
        expiresAt,
        scope,
      ];

  @override
  String toString() => 'TokenResponse(tokenType: $tokenType, expiresIn: $expiresIn, '
      'expiresAt: $expiresAt, scope: $scope)';
}
