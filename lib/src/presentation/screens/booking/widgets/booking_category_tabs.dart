import 'package:flutter/material.dart';

class BookingCategoryTabs extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const BookingCategoryTabs({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index == categories.length - 1 ? 0 : 30,
              ),
              child: Column(
                children: [
                  Text(
                    categories[index],
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : Colors.grey[600],
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2,
                    width: 20,
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
