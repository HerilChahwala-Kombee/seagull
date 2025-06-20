import 'package:flutter/material.dart';
import 'booking_deal_card.dart';

class BookingWeeklyDeals extends StatelessWidget {
  const BookingWeeklyDeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Weekly Deals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '2d 18h left',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
        BookingDealCard(
          title: 'Deep House Cleaning',
          provider: 'MaidPro',
          rating: 4.9,
          reviewCount: 312,
          price: ' 80',
          unit: 'visit',
          originalPrice: ' 100',
        ),
        const SizedBox(height: 12),
        BookingDealCard(
          title: 'Haircut & Styling',
          provider: 'GlamSquad',
          rating: 4.8,
          reviewCount: 189,
          price: ' 45',
          unit: 'service',
          originalPrice: ' 50',
        ),
      ],
    );
  }
}
