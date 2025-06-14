import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/core/utils/utility.dart';
import 'package:seagull/src/core/utils/widgets/common_button_widget.dart';
import 'package:seagull/src/data/models/otp_model.dart';
import 'package:seagull/src/presentation/screens/otp/widget/circular_process_timer.dart';
import 'package:seagull/src/presentation/screens/otp/widget/otp_input_field.dart';
import 'package:seagull/src/presentation/screens/otp/widget/otp_input_section.dart';
import 'package:seagull/src/presentation/state_management/otp_provider.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(oTPNotifierProvider.notifier).startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(oTPNotifierProvider);
    final otpNotifier = ref.read(oTPNotifierProvider.notifier);

    // Listen to error messages
    ref.listen<OTPState>(oTPNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        Utility().showToast(next.errorMessage!, context);
        // Clear error after showing toast
        Future.microtask(() => ref.read(oTPNotifierProvider.notifier).clearError());
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFF6366F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Profile Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Center(
                child: Text(
                  'A',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFF6366F1)),
                ),
              ),
            ),
            SizedBox(height: 40),
            // OTP Card
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Verification Code',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'We\'ve sent a 6-digit verification code to\nuser@example.com',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.5),
                        ),
                        SizedBox(height: 40),
                        // OTP Input Fields
                        const OTPInputSection(),
                        SizedBox(height: 40),
                        // Circular Progress Timer
                        CircularProgressTimer(),
                        SizedBox(height: 20),
                        // Resend Code Section
                        Column(
                          children: [
                            Text('Didn\'t receive the code?', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                            SizedBox(height: 4),
                            if (otpState.canResend)
                              GestureDetector(
                                onTap: () => otpNotifier.handleResendOTP(context),
                                child: const Text(
                                  'Resend Code',
                                  style: TextStyle(fontSize: 14, color: Color(0xFF6366F1), fontWeight: FontWeight.w600),
                                ),
                              )
                            else
                              Text(
                                'Resend Code in ${otpState.remainingSeconds}s',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                              ),
                          ],
                        ),
                        SizedBox(height: 40),

                        CommonButtonWidget(
                          title: 'Verify',
                          callback: () => otpNotifier.handleVerifyOTP(context),
                          // isLoading: _isLoading,
                        ),
                        SizedBox(height: 20),
                        // Support Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Having trouble? ', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                            GestureDetector(
                              onTap: () {
                                // Handle contact support
                                Utility().showToast('Support contacted!', context, isError: false);
                              },
                              child: Text(
                                'Contact Support',
                                style: TextStyle(fontSize: 14, color: Color(0xFF6366F1), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Bottom Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                ),
                SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.5)),
                ),
                SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Bottom Handle
            Container(
              width: 134,
              height: 5,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2.5)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
