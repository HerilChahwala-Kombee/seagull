import 'package:flutter/material.dart';

class SocialButtonWidget extends StatelessWidget {
  const SocialButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton('G', Colors.red),
        _buildSocialButton('', Colors.black, icon: Icons.apple),
        _buildSocialButton('f', const Color(0xFF1877F2)),
      ],
    );
  }

  Widget _buildSocialButton(String text, Color color, {IconData? icon}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, color: color, size: 24)
            : Text(
                text,
                style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
