import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';

class DateTimeSection extends ConsumerWidget {
  const DateTimeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(bookingServiceProvider);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoRow(Icons.calendar_today_outlined, _formatDate(service.date), 'Change', () {
              // Handle date change
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, String actionText, VoidCallback onTap) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF666666)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 16, color: Color(0xFF2E5266))),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(fontSize: 14, color: Color(0xFF5A67D8), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
