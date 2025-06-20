import 'package:flutter/material.dart';
import 'booking_service_card.dart';

class BookingFeaturedServices extends StatelessWidget {
  const BookingFeaturedServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Featured Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                color: const Color(0xFF6366F1),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BookingServiceCard(
                title: 'Home Cleaning',
                provider: 'CleanCo',
                rating: 4.8,
                reviewCount: 245,
                price: ' 25',
                unit: 'hr',
                discount: '15% OFF',
                discountColor: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BookingServiceCard(
                title: 'Appliance',
                provider: 'FixIt Pro',
                rating: 4.5,
                reviewCount: null,
                price: ' 40',
                unit: 'hr',
                discount: null,
                discountColor: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
