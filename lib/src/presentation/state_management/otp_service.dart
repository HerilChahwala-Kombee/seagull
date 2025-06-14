import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'otp_service.g.dart';

@riverpod
OTPService otpService(OtpServiceRef ref) {
  return OTPService();
}

class OTPService {
  static const String _correctOTP = '123456'; // Demo OTP

  Future<bool> verifyOTP(String otp) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return otp == _correctOTP;
  }

  Future<void> resendOTP() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // In real implementation, this would trigger SMS/Email
  }
}
