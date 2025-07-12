import 'package:flutter/material.dart';

class QRCodeSection extends StatelessWidget {
  final String confirmationNumber;

  const QRCodeSection({super.key, required this.confirmationNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // QR Code (using placeholder as qr_flutter package might not be available)
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Icon(Icons.qr_code, size: 80, color: Color(0xFF666666)),
          ),

          // If you have qr_flutter package, replace above with:
          // QrImageView(
          //   data: confirmationNumber,
          //   size: 150,
          //   backgroundColor: Colors.white,
          // ),
          const SizedBox(height: 16),

          const Text(
            'Show this QR code for check-in',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
