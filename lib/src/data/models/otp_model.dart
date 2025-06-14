class OTPState {
  final String otpCode;
  final bool isLoading;
  final bool canResend;
  final int remainingSeconds;
  final bool isTimerRunning;
  final String? errorMessage;

  const OTPState({
    this.otpCode = '',
    this.isLoading = false,
    this.canResend = false,
    this.remainingSeconds = 45,
    this.isTimerRunning = false,
    this.errorMessage,
  });

  OTPState copyWith({
    String? otpCode,
    bool? isLoading,
    bool? canResend,
    int? remainingSeconds,
    bool? isTimerRunning,
    String? errorMessage,
  }) {
    return OTPState(
      otpCode: otpCode ?? this.otpCode,
      isLoading: isLoading ?? this.isLoading,
      canResend: canResend ?? this.canResend,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OTPState &&
        other.otpCode == otpCode &&
        other.isLoading == isLoading &&
        other.canResend == canResend &&
        other.remainingSeconds == remainingSeconds &&
        other.isTimerRunning == isTimerRunning &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(otpCode, isLoading, canResend, remainingSeconds, isTimerRunning, errorMessage);
  }
}

abstract class OTPResult {
  const OTPResult();
}

class OTPSuccess extends OTPResult {
  const OTPSuccess();
}

class OTPError extends OTPResult {
  final String message;
  const OTPError(this.message);
}

class OTPInvalidLength extends OTPResult {
  const OTPInvalidLength();
}

// Extension for pattern matching
extension OTPResultExtension on OTPResult {
  T when<T>({
    required T Function() success,
    required T Function(String message) error,
    required T Function() invalidLength,
  }) {
    if (this is OTPSuccess) {
      return success();
    } else if (this is OTPError) {
      return error((this as OTPError).message);
    } else if (this is OTPInvalidLength) {
      return invalidLength();
    }
    throw Exception('Unknown OTPResult type');
  }
}
