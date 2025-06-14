import 'package:flutter/material.dart';

class BookingSearchBar extends StatelessWidget {
  const BookingSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.search, color: Colors.grey, size: 20),
          ),
          const Expanded(
            child: Text(
              'Search for services...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.tune, color: Colors.grey[600], size: 20),
          ),
        ],
      ),
    );
  }
}
