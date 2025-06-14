import 'package:flutter/material.dart';

class ServiceDetailsCoverage extends StatelessWidget {
  const ServiceDetailsCoverage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Coverage',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _CoverageChip(text: 'Floor cleaning'),
              _CoverageChip(text: 'Bathroom cleaning'),
              _CoverageChip(text: 'Kitchen cleaning'),
              _CoverageChip(text: 'Dusting'),
              _CoverageChip(text: 'Window cleaning'),
              _CoverageChip(text: 'Surface sanitization'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverageChip extends StatelessWidget {
  final String text;
  const _CoverageChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF6366F1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6366F1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
