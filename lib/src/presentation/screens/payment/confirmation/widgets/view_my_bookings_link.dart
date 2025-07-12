import 'package:flutter/material.dart';

class ViewMyBookingsLink extends StatelessWidget {
  const ViewMyBookingsLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle view my bookings
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Navigating to My Bookings'), duration: Duration(seconds: 2)));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'View My Bookings',
            style: TextStyle(fontSize: 16, color: Color(0xFF5A67D8), fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF5A67D8)),
        ],
      ),
    );
  }
}
