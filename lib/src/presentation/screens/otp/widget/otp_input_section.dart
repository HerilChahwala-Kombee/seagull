import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/data/models/otp_model.dart';
import 'package:seagull/src/presentation/state_management/otp_provider.dart';
import 'otp_input_field.dart';

class OTPInputSection extends ConsumerStatefulWidget {
  const OTPInputSection({Key? key}) : super(key: key);

  @override
  ConsumerState<OTPInputSection> createState() => _OTPInputSectionState();
}

class _OTPInputSectionState extends ConsumerState<OTPInputSection> {
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];

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
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otpCode = _controllers.map((controller) => controller.text).join();
    ref.read(oTPNotifierProvider.notifier).updateOTPCode(otpCode);
  }

  void _clearOTPFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OTPState>(oTPNotifierProvider, (previous, next) {
      // Clear fields when OTP is cleared from provider
      if (next.otpCode.isEmpty && previous?.otpCode.isNotEmpty == true) {
        _clearOTPFields();
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return OTPInputField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onChanged: (value) => _onOTPChanged(value, index),
          isActive: _focusNodes[index].hasFocus,
        );
      }),
    );
  }
}
