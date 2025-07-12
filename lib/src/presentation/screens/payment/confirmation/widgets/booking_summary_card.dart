import 'package:flutter/material.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/state/booking_confirmation_state.dart';

class BookingSummaryCard extends StatelessWidget {
  final BookingConfirmation confirmation;

  const BookingSummaryCard({super.key, required this.confirmation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
          ),

          const SizedBox(height: 20),

          // Service Name
          Text(
            confirmation.serviceName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
          ),

          const SizedBox(height: 8),

          // Service Type and Duration
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Color(0xFF5A67D8)),
              const Icon(Icons.star, size: 16, color: Color(0xFF5A67D8)),
              const Icon(Icons.star, size: 16, color: Color(0xFF5A67D8)),
              const SizedBox(width: 8),
              Text(
                confirmation.serviceType,
                style: const TextStyle(fontSize: 14, color: Color(0xFF5A67D8), fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              Text('${confirmation.duration} hours', style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),

          const SizedBox(height: 20),

          // Date and Time
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(_formatDate(confirmation.date), style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(confirmation.timeRange, style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),

          const SizedBox(height: 20),

          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      confirmation.address,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${confirmation.city}, ${confirmation.state} ${confirmation.zipCode}',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Payment Information
          Row(
            children: [
              const Icon(Icons.credit_card, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              const Text('Total Paid', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
              const Spacer(),
              Text(
                '\$${confirmation.totalPaid.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF5A67D8)),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF2196F3), borderRadius: BorderRadius.circular(4)),
                child: Text(
                  confirmation.paymentMethod,
                  style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Text('•••• ${confirmation.cardLastFour}', style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
