import 'package:flutter/material.dart';
import 'widgets/booking_header.dart';
import 'widgets/booking_search_bar.dart';
import 'widgets/booking_category_tabs.dart';
import 'widgets/booking_promo_banner.dart';
import 'widgets/booking_featured_services.dart';
import 'widgets/booking_weekly_deals.dart';
import 'widgets/booking_popular_services.dart';
import 'widgets/booking_bottom_nav_bar.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'All',
    'Cleaning',
    'Repairs',
    'Beauty',
    'Health',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            BookingHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    BookingSearchBar(),
                    const SizedBox(height: 20),
                    BookingCategoryTabs(
                      categories: _categories,
                      selectedIndex: _selectedCategoryIndex,
                      onCategorySelected: (index) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    BookingPromoBanner(),
                    const SizedBox(height: 30),
                    BookingFeaturedServices(),
                    const SizedBox(height: 30),
                    BookingWeeklyDeals(),
                    const SizedBox(height: 30),
                    BookingPopularServices(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BookingBottomNavBar(
        selectedIndex: _selectedIndex,
        onNavItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
