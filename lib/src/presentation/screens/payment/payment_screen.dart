import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';
import 'package:seagull/src/presentation/screens/payment/widgets/complete_payment_button.dart';
import 'package:seagull/src/presentation/screens/payment/widgets/currency_section.dart';
import 'package:seagull/src/presentation/screens/payment/widgets/payment_methods_section.dart';
import 'package:seagull/src/presentation/screens/payment/widgets/payment_summary_section.dart';
import 'package:seagull/src/presentation/screens/payment/widgets/security_information_section.dart';
import 'package:seagull/src/presentation/screens/payment/widgets/service_summary_card.dart';
import 'package:seagull/src/presentation/widgets/booking_progress_steps.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.read(bookingProvider.notifier).previousStep();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2E5266), size: 20),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const PaymentView(),
    );
  }
}

class PaymentView extends ConsumerWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Progress Steps
        const BookingProgressSteps(currentStep: 2),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Summary Card
                const ServiceSummaryCard(),

                const SizedBox(height: 24),

                // Payment Methods
                const PaymentMethodsSection(),

                const SizedBox(height: 24),

                // Currency Section
                const CurrencySection(),

                const SizedBox(height: 24),

                // Payment Summary
                const PaymentSummarySection(),

                const SizedBox(height: 24),

                // Security Information
                const SecurityInformationSection(),

                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ),

        // Bottom Button
        const CompletePaymentButton(),
      ],
    );
  }
}