import 'package:flutter/material.dart';

class BookingBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavItemSelected;

  const BookingBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onNavItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
          _buildNavItem(Icons.search_outlined, Icons.search, 'Search', 1),
          _buildNavItem(
            Icons.calendar_today_outlined,
            Icons.calendar_today,
            'Bookings',
            2,
          ),
          _buildNavItem(
            Icons.chat_bubble_outline,
            Icons.chat_bubble,
            'Messages',
            3,
          ),
          _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
  ) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onNavItemSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? filledIcon : outlinedIcon,
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF6366F1) : Colors.grey[600],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
