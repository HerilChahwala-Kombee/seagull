import 'package:flutter/material.dart';
import 'booking_service_card.dart';

class BookingPopularServices extends StatelessWidget {
  const BookingPopularServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Services',
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
                title: 'Lawn Mowing',
                provider: 'GreenThumb',
                rating: 4.7,
                reviewCount: null,
                price: ' 30',
                unit: 'visit',
                discount: null,
                discountColor: null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BookingServiceCard(
                title: 'Dog Walking',
                provider: 'PetPals',
                rating: 4.9,
                reviewCount: null,
                price: ' 15',
                unit: '30min',
                discount: null,
                discountColor: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: BookingServiceCard(
                title: 'Massage Therapy',
                provider: 'RelaxMax',
                rating: 4.8,
                reviewCount: null,
                price: ' 60',
                unit: 'hr',
                discount: null,
                discountColor: null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BookingServiceCard(
                title: 'Car Wash',
                provider: 'SparkleAuto',
                rating: 4.6,
                reviewCount: null,
                price: ' 25',
                unit: 'wash',
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
