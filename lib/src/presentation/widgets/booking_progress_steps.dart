import 'package:flutter/material.dart';

class BookingProgressSteps extends StatelessWidget {
  final int currentStep;

  const BookingProgressSteps({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildStep(1, 'Details', currentStep >= 1),
          Expanded(child: _buildConnector(currentStep >= 2)),
          _buildStep(2, 'Payment', currentStep >= 2),
          Expanded(child: _buildConnector(currentStep >= 3)),
          _buildStep(3, 'Confirm', currentStep >= 3),
        ],
      ),
    );
  }

  Widget _buildStep(int stepNumber, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF5A67D8) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xFF5A67D8) : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF5A67D8) : Colors.grey[300],
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
