import 'package:flutter/material.dart';

class ServiceDetailsTabSection extends StatelessWidget {
  final TabController tabController;
  const ServiceDetailsTabSection({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: tabController,
        labelColor: const Color(0xFF6366F1),
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: const Color(0xFF6366F1),
        indicatorWeight: 2,
        tabs: const [
          Tab(text: 'Description'),
          Tab(text: 'Reviews'),
          Tab(text: 'Provider'),
        ],
      ),
    );
  }
}
