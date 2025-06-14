import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextfieldWidget extends StatelessWidget {
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool isInputValid;
  final String? hintText;
  const CommonTextfieldWidget({
    super.key,
    this.keyboardType,
    this.controller,
    this.inputFormatters,
    required this.isInputValid,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: _buildInputDecoration(),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400]),
      suffixIcon: isInputValid ? const Icon(Icons.check_circle, color: Colors.green) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isInputValid ? Colors.green : Colors.grey[300]!, width: isInputValid ? 2 : 1),
      ),
    );
  }
}
