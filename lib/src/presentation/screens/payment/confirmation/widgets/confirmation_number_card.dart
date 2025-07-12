import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmationNumberCard extends StatelessWidget {
  final String confirmationNumber;

  const ConfirmationNumberCard({super.key, required this.confirmationNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5A67D8).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5A67D8).withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'Confirmation #',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                confirmationNumber,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A67D8),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: confirmationNumber));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Confirmation number copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A67D8).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.copy, size: 16, color: Color(0xFF5A67D8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
