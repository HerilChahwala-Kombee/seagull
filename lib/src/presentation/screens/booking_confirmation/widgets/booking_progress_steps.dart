import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';

class BookingProgressSteps extends ConsumerWidget {
  const BookingProgressSteps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(bookingProvider).currentStep;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildStep(1, 'Details', currentStep >= 1, currentStep == 1),
          _buildConnector(currentStep >= 2),
          _buildStep(2, 'Payment', currentStep >= 2, currentStep == 2),
          _buildConnector(currentStep >= 3),
          _buildStep(3, 'Confirm', currentStep >= 3, currentStep == 3),
        ],
      ),
    );
  }

  Widget _buildStep(int stepNumber, String label, bool isCompleted, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF5A67D8)
                  : isCompleted
                  ? const Color(0xFF5A67D8)
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: isActive || isCompleted ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF5A67D8) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      height: 2,
      width: 40,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? const Color(0xFF5A67D8) : Colors.grey[300],
    );
  }
}
