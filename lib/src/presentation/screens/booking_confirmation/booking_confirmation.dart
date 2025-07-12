import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/widgets/booking_progress_steps.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/widgets/continue_button.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/widgets/customer_information_section.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/widgets/price_summary_section.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/widgets/service_card.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/widgets/special_instructions_section.dart';

class BookingConfirmationPage extends ConsumerWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2E5266), size: 20),
        ),
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const BookingConfirmationView(),
    );
  }
}

class BookingConfirmationView extends ConsumerWidget {
  const BookingConfirmationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Progress Steps
        const BookingProgressSteps(),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Card
                const ServiceCard(),

                const SizedBox(height: 24),

                // Customer Information
                const CustomerInformationSection(),

                const SizedBox(height: 24),

                // Special Instructions
                const SpecialInstructionsSection(),

                const SizedBox(height: 24),

                // Price Summary
                const PriceSummarySection(),

                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ),

        // Bottom Button
        const ContinueButton(),
      ],
    );
  }
}