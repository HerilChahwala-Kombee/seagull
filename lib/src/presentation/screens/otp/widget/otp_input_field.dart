import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final bool isActive;

  const OTPInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: isActive ? Color(0xFF6366F1) : Color(0xFFE5E7EB), width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
        decoration: InputDecoration(counterText: '', border: InputBorder.none, contentPadding: EdgeInsets.zero),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      ),
    );
  }
}
