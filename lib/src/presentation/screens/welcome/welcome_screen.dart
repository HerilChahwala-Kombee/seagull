import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:seagull/src/core/routers/routes.dart';
import '../../../core/constants/asset_constant.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/app_string_constant.dart';
import '../../../core/constants/dimension_constant.dart';
import '../../../core/routers/my_app_route_constant.dart';
import 'widget/feature_item.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A6CF7), Color(0xFF3B5AE0), Color(0xFF2D47CC)],
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Status bar and Skip button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '9:41',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          // Signal bars
                          Container(
                            width: 18,
                            height: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                4,
                                (index) => Container(
                                  width: 3,
                                  height: 3 + (index * 2.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // WiFi icon
                          const Icon(Icons.wifi, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          // Battery icon
                          Container(
                            width: 24,
                            height: 12,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 2,
                                height: 4,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Skip button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D47CC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Welcome text
                  const Text(
                    'Welcome to\nAppName',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold, height: 1.1),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  const Text(
                    'Your business command center',
                    style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w400),
                  ),

                  const SizedBox(height: 60),

                  // Features list
                  Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.people,
                        title: 'Seamless Collaboration',
                        description: 'Work together with your team in real-time',
                      ),
                      const SizedBox(height: 40),
                      _buildFeatureItem(
                        icon: Icons.lock,
                        title: 'Enhanced Security',
                        description: 'Your data is protected with enterprise-grade encryption',
                      ),
                      const SizedBox(height: 40),
                      _buildFeatureItem(
                        icon: Icons.trending_up,
                        title: 'Insightful Analytics',
                        description: 'Make data-driven decisions with powerful insights',
                      ),
                    ],
                  ),

                  // const Spacer(),

                  // Sign Up button
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        AppRouter.goRouter.push(Routes.register);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF2D47CC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Rating and downloads
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Stars
                        Row(
                          children: [
                            ...List.generate(4, (index) => const Icon(Icons.star, color: Colors.amber, size: 20)),
                            const Icon(Icons.star_half, color: Colors.amber, size: 20),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Rating text
                        const Text(
                          '4.9/5',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        // Downloads
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '50,000+',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text('downloads', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), shape: BoxShape.circle),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Home indicator
                  Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2.5)),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}
