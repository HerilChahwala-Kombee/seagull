import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecurityInformationSection extends ConsumerWidget {
  const SecurityInformationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.security, size: 20, color: Color(0xFF5A67D8)),
            const SizedBox(width: 8),
            const Text(
              'Secure Payment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(4)),
                    child: const Text(
                      'SSL Encrypted',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF2196F3), borderRadius: BorderRadius.circular(4)),
                    child: const Text(
                      'PCI DSS Compliant',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF9C27B0), borderRadius: BorderRadius.circular(4)),
                    child: const Text(
                      '3D Secure',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                'Your payment information is encrypted and secure. We do not store your credit card details.',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
