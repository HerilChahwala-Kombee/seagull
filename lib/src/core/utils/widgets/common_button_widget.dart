import 'package:flutter/material.dart';

class CommonButtonWidget extends StatelessWidget {
  final VoidCallback? callback;
  final String? title;
  const CommonButtonWidget({super.key, this.callback, this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          title ?? '',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}
