import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/state_management/otp_provider.dart';

class CircularProgressTimer extends ConsumerWidget {
  const CircularProgressTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpState = ref.watch(oTPNotifierProvider);
    final progress = otpState.remainingSeconds / 45.0;

    return Container(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
          Text(
            '${otpState.remainingSeconds}s',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6366F1)),
          ),
        ],
      ),
    );
  }
}
