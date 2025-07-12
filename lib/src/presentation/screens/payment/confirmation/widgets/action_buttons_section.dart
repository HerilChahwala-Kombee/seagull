import 'package:flutter/material.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Download Confirmation Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle download confirmation
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Confirmation downloaded'), duration: Duration(seconds: 2)));
            },
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Download Confirmation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A67D8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Share Details Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle share details
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sharing booking details'), duration: Duration(seconds: 2)));
            },
            icon: const Icon(Icons.share, size: 20),
            label: const Text('Share Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5A67D8),
              side: const BorderSide(color: Color(0xFF5A67D8)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Add to Calendar Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle add to calendar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Added to calendar'), duration: Duration(seconds: 2)));
            },
            icon: const Icon(Icons.calendar_today, size: 20),
            label: const Text('Add to Calendar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5A67D8),
              side: const BorderSide(color: Color(0xFF5A67D8)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
