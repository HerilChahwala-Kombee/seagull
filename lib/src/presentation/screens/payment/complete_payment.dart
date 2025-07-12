import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/state/booking_confirmation_providers.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/state/booking_confirmation_state.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/widgets/action_buttons_section.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/widgets/booking_summary_card.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/widgets/confirmation_number_card.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/widgets/qr_code_section.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/widgets/view_my_bookings_link.dart';
import 'package:seagull/src/presentation/widgets/booking_progress_steps.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({super.key});

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
          'Booking Confirmed!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const BookingConfirmationView(),
    );
  }
}

class BookingConfirmationView extends ConsumerStatefulWidget {
  const BookingConfirmationView({super.key});

  @override
  ConsumerState<BookingConfirmationView> createState() => _BookingConfirmationViewState();
}

class _BookingConfirmationViewState extends ConsumerState<BookingConfirmationView> {
  @override
  void initState() {
    super.initState();
    // Initialize with sample data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final confirmation = ref.read(bookingConfirmationProvider);
      if (confirmation == null) {
        ref
            .read(bookingConfirmationProvider.notifier)
            .createConfirmation(
              serviceName: 'Deep House Cleaning',
              serviceType: 'Premium Service',
              duration: 3,
              date: DateTime(2024, 8, 15),
              startTime: const TimeOfDay(hour: 10, minute: 30),
              endTime: const TimeOfDay(hour: 13, minute: 30),
              address: '123 Main Street, Apt 4B',
              city: 'San Francisco',
              state: 'CA',
              zipCode: '94105',
              totalPaid: 88.20,
              paymentMethod: 'Visa',
              cardLastFour: '4582',
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final confirmation = ref.watch(bookingConfirmationProvider);

    return Column(
      children: [
        // Progress Steps
        const BookingProgressSteps(currentStep: 3),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 40, color: Colors.white),
                ),

                const SizedBox(height: 24),

                // Confirmation Title
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Your reservation has been successfully\nconfirmed',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666), height: 1.5),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Confirmation Number Card
                ConfirmationNumberCard(confirmationNumber: confirmation?.confirmationNumber ?? 'AB123456'),

                const SizedBox(height: 32),

                // Booking Summary
                BookingSummaryCard(confirmation: confirmation ?? _getDefaultConfirmation()),

                const SizedBox(height: 32),

                // QR Code
                QRCodeSection(confirmationNumber: confirmation?.confirmationNumber ?? 'AB123456'),

                const SizedBox(height: 32),

                // Action Buttons
                const ActionButtonsSection(),

                const SizedBox(height: 24),

                // View My Bookings Link
                const ViewMyBookingsLink(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Default confirmation data fallback
  BookingConfirmation _getDefaultConfirmation() {
    return BookingConfirmation(
      confirmationNumber: 'AB123456',
      serviceName: 'Deep House Cleaning',
      serviceType: 'Premium Service',
      duration: 3,
      date: DateTime(2024, 8, 15),
      startTime: const TimeOfDay(hour: 10, minute: 30),
      endTime: const TimeOfDay(hour: 13, minute: 30),
      address: '123 Main Street, Apt 4B',
      city: 'San Francisco',
      state: 'CA',
      zipCode: '94105',
      totalPaid: 88.20,
      paymentMethod: 'Visa',
      cardLastFour: '4582',
      createdAt: DateTime.now(),
    );
  }
}