import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';

class ServiceSummaryCard extends ConsumerWidget {
  const ServiceSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(bookingServiceProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Service Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue[100]),
            child: const Icon(Icons.cleaning_services, size: 30, color: Colors.blue),
          ),

          const SizedBox(width: 12),

          // Service Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFF666666)),
                    const SizedBox(width: 4),
                    Text(_formatDate(service.date), style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 14, color: Color(0xFF666666)),
                    const SizedBox(width: 4),
                    Text(_formatTime(service.time), style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  '${service.duration} hours service',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${service.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF5A67D8)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
