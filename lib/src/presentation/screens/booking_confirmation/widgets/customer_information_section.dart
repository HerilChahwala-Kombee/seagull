import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';

class CustomerInformationSection extends ConsumerWidget {
  const CustomerInformationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
        ),

        const SizedBox(height: 16),

        // Full Name
        _buildInputField('Full Name', customerInfo.fullName, true),

        const SizedBox(height: 16),

        // Email
        _buildInputField('Email Address', customerInfo.email, true),

        const SizedBox(height: 16),

        // Phone
        _buildInputField('Phone Number', customerInfo.phone, true),
      ],
    );
  }

  Widget _buildInputField(String label, String value, bool isValidated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isValidated ? const Color(0xFF4CAF50) : Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(value, style: const TextStyle(fontSize: 16, color: Color(0xFF2E5266))),
              ),
              if (isValidated)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
