import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';

class ServiceCard extends ConsumerWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(bookingServiceProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Color(0xFF5A67D8), width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Service Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue[100]),
            child: const Icon(Icons.cleaning_services, size: 40, color: Colors.blue),
          ),

          const SizedBox(width: 16),

          // Service Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                ),

                const SizedBox(height: 4),

                Text(service.company, style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < service.rating.floor()
                              ? Icons.star
                              : index < service.rating
                              ? Icons.star_half
                              : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    const SizedBox(width: 4),
                    Text('${service.rating}/5', style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
