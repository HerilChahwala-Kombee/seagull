import 'package:flutter/material.dart';

class ServiceDetailsDescription extends StatelessWidget {
  const ServiceDetailsDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Our deep cleaning service tackles dirt and grime in every corner of your home. Perfect for seasonal cleaning or before/after events. Our trained professionals use premium equipment and eco-friendly cleaning solutions.',
        style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
      ),
    );
  }
}
