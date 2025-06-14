import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:seagull/src/core/routers/my_app_route_constant.dart';
import 'package:seagull/src/core/routers/routes.dart';
import 'package:seagull/src/core/utils/utility.dart';
import 'package:seagull/src/data/models/otp_model.dart';
import 'package:seagull/src/presentation/state_management/otp_service.dart';

part 'otp_provider.g.dart';

@riverpod
class OTPNotifier extends _$OTPNotifier {
  Timer? _timer;
  static const int _timerDuration = 45;

  @override
  OTPState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    // startTimer();
    return const OTPState(remainingSeconds: _timerDuration, isTimerRunning: true);
  }

  void updateOTPCode(String code) {
    state = state.copyWith(otpCode: code, errorMessage: null);
  }

  void startTimer() {
    _timer?.cancel();

    state = state.copyWith(remainingSeconds: _timerDuration, isTimerRunning: true, canResend: false);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        timer.cancel();
        state = state.copyWith(isTimerRunning: false, canResend: true);
      }
    });
  }

  Future<OTPResult> verifyOTP() async {
    if (state.otpCode.length != 6) {
      state = state.copyWith(errorMessage: 'Please enter complete OTP');
      return const OTPInvalidLength();
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final otpService = ref.read(otpServiceProvider);
      final isValid = await otpService.verifyOTP(state.otpCode);

      state = state.copyWith(isLoading: false);

      if (isValid) {
        return const OTPSuccess();
      } else {
        clearOTP();
        state = state.copyWith(errorMessage: 'Invalid OTP. Please try again.');
        return const OTPError('Invalid OTP. Please try again.');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Verification failed. Please try again.');
      return const OTPError('Verification failed. Please try again.');
    }
  }

  Future<void> resendOTP() async {
    try {
      startTimer();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to resend OTP. Please try again.');
    }
  }

  void clearOTP() {
    state = state.copyWith(otpCode: '', errorMessage: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void handleVerifyOTP(BuildContext context) async {
    final result = await verifyOTP();

    result.when(
      success: () {
        Utility().showToast('OTP verified successfully!', context, isError: false);
        AppRouter.goRouter.pushReplacement(Routes.booking);
      },
      error: (message) {
        Utility().showToast(message, context);
        startTimer();
      },
      invalidLength: () {
        Utility().showToast('Please enter complete OTP', context);
      },
    );
  }

  void handleResendOTP(BuildContext context) async {
    await resendOTP();
    Utility().showToast('OTP resent successfully!', context, isError: false);
  }
}
