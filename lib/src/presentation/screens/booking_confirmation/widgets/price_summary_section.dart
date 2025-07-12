import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';

class PriceSummarySection extends ConsumerWidget {
  const PriceSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal', style: TextStyle(fontSize: 16, color: Color(0xFF666666))),
                  Text(
                    '\$${bookingState.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Service Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Service fee', style: TextStyle(fontSize: 16, color: Color(0xFF666666))),
                  Text(
                    '\$${bookingState.serviceFee.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              Container(height: 1, color: Colors.grey[200]),

              const SizedBox(height: 16),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                  ),
                  Text(
                    '\$${bookingState.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
