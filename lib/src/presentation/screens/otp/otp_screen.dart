import 'package:flutter/material.dart';
import 'package:seagull/src/core/utils/utility.dart';
import 'package:seagull/src/core/utils/widgets/common_button_widget.dart';
import 'package:seagull/src/presentation/screens/otp/widget/circular_process_timer.dart';
import 'package:seagull/src/presentation/screens/otp/widget/otp_input_field.dart';

class OTPVerificationScreen extends StatefulWidget {
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];
  String _otpCode = '';
  bool _isLoading = false;
  bool _canResend = false;
  final String _correctOTP = '123456'; // Demo OTP

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOTPChanged(String value, int index) {
    setState(() {
      if (value.isNotEmpty && index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else if (value.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }

      _otpCode = _controllers.map((controller) => controller.text).join();
    });
  }

  void _verifyOTP() async {
    if (_otpCode.length != 6) {
      Utility().showToast('Please enter complete OTP', context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (_otpCode == _correctOTP) {
      Utility().showToast('OTP verified successfully!', context, isError: false);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Utility().showToast('Invalid OTP. Please try again.', context);
      // Clear OTP fields
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      setState(() {
        _otpCode = '';
      });
    }
  }

  void _resendOTP() {
    setState(() {
      _canResend = false;
    });
    Utility().showToast('OTP resent successfully!', context, isError: false);
  }

  void _onTimerComplete() {
    setState(() {
      _canResend = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return OTPInputField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              onChanged: (value) => _onOTPChanged(value, index),
                              isActive: _focusNodes[index].hasFocus,
                            );
                          }),
                        ),
                        SizedBox(height: 40),
                        // Circular Progress Timer
                        CircularProgressTimer(duration: 45, onComplete: _onTimerComplete),
                        SizedBox(height: 20),
                        // Resend Code Section
                        Column(
                          children: [
                            Text('Didn\'t receive the code?', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                            SizedBox(height: 4),
                            if (_canResend)
                              GestureDetector(
                                onTap: _resendOTP,
                                child: Text(
                                  'Resend Code',
                                  style: TextStyle(fontSize: 14, color: Color(0xFF6366F1), fontWeight: FontWeight.w600),
                                ),
                              )
                            else
                              Text('Resend Code in 45s', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
                          ],
                        ),
                        SizedBox(height: 40),
                        // Verify Button
                        CommonButtonWidget(
                          title: 'Verify',
                          callback: _verifyOTP,
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
