import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

// Data Models
class BookingConfirmation {
  final String confirmationNumber;
  final String serviceName;
  final String serviceType;
  final int duration;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double totalPaid;
  final String paymentMethod;
  final String cardLastFour;
  final DateTime createdAt;

  const BookingConfirmation({
    required this.confirmationNumber,
    required this.serviceName,
    required this.serviceType,
    required this.duration,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.totalPaid,
    required this.paymentMethod,
    required this.cardLastFour,
    required this.createdAt,
  });

  String get fullAddress => '$address, $city, $state $zipCode';

  String get timeRange {
    final startFormatted = _formatTime(startTime);
    final endFormatted = _formatTime(endTime);
    return '$startFormatted - $endFormatted';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

// Confirmation State Notifier
class BookingConfirmationNotifier extends StateNotifier<BookingConfirmation?> {
  BookingConfirmationNotifier() : super(null);

  void createConfirmation({
    required String serviceName,
    required String serviceType,
    required int duration,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required double totalPaid,
    required String paymentMethod,
    required String cardLastFour,
  }) {
    final confirmationNumber = _generateConfirmationNumber();

    this.state = BookingConfirmation(
      confirmationNumber: confirmationNumber,
      serviceName: serviceName,
      serviceType: serviceType,
      duration: duration,
      date: date,
      startTime: startTime,
      endTime: endTime,
      address: address,
      city: city,
      state: state,
      zipCode: zipCode,
      totalPaid: totalPaid,
      paymentMethod: paymentMethod,
      cardLastFour: cardLastFour,
      createdAt: DateTime.now(),
    );
  }

  String _generateConfirmationNumber() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    final random = Random();

    String result = '';
    // Generate 2 letters
    for (int i = 0; i < 2; i++) {
      result += letters[random.nextInt(letters.length)];
    }
    // Generate 6 numbers
    for (int i = 0; i < 6; i++) {
      result += numbers[random.nextInt(numbers.length)];
    }

    return result;
  }

  void clearConfirmation() {
    state = null;
  }
}

// Riverpod Providers
final bookingConfirmationProvider = StateNotifierProvider<BookingConfirmationNotifier, BookingConfirmation?>((ref) {
  return BookingConfirmationNotifier();
});

// Booking Confirmation Screen
class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({Key? key}) : super(key: key);

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
  const BookingConfirmationView({Key? key}) : super(key: key);

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

// Progress Steps Widget
class BookingProgressSteps extends StatelessWidget {
  final int currentStep;

  const BookingProgressSteps({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildStep(1, 'Details', currentStep >= 1),
          Expanded(child: _buildConnector(currentStep >= 2)),
          _buildStep(2, 'Payment', currentStep >= 2),
          Expanded(child: _buildConnector(currentStep >= 3)),
          _buildStep(3, 'Confirm', currentStep >= 3),
        ],
      ),
    );
  }

  Widget _buildStep(int stepNumber, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF5A67D8) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xFF5A67D8) : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF5A67D8) : Colors.grey[300],
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

// Confirmation Number Card
class ConfirmationNumberCard extends StatelessWidget {
  final String confirmationNumber;

  const ConfirmationNumberCard({Key? key, required this.confirmationNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5A67D8).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5A67D8).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'Confirmation #',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                confirmationNumber,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A67D8),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: confirmationNumber));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Confirmation number copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A67D8).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.copy, size: 16, color: Color(0xFF5A67D8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Booking Summary Card
class BookingSummaryCard extends StatelessWidget {
  final BookingConfirmation confirmation;

  const BookingSummaryCard({Key? key, required this.confirmation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
          ),

          const SizedBox(height: 20),

          // Service Name
          Text(
            confirmation.serviceName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
          ),

          const SizedBox(height: 8),

          // Service Type and Duration
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Color(0xFF5A67D8)),
              const Icon(Icons.star, size: 16, color: Color(0xFF5A67D8)),
              const Icon(Icons.star, size: 16, color: Color(0xFF5A67D8)),
              const SizedBox(width: 8),
              Text(
                confirmation.serviceType,
                style: const TextStyle(fontSize: 14, color: Color(0xFF5A67D8), fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              Text('${confirmation.duration} hours', style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),

          const SizedBox(height: 20),

          // Date and Time
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(_formatDate(confirmation.date), style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(confirmation.timeRange, style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),

          const SizedBox(height: 20),

          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      confirmation.address,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${confirmation.city}, ${confirmation.state} ${confirmation.zipCode}',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Payment Information
          Row(
            children: [
              const Icon(Icons.credit_card, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              const Text('Total Paid', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
              const Spacer(),
              Text(
                '\$${confirmation.totalPaid.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF5A67D8)),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF2196F3), borderRadius: BorderRadius.circular(4)),
                child: Text(
                  confirmation.paymentMethod,
                  style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Text('•••• ${confirmation.cardLastFour}', style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// QR Code Section
class QRCodeSection extends StatelessWidget {
  final String confirmationNumber;

  const QRCodeSection({Key? key, required this.confirmationNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // QR Code (using placeholder as qr_flutter package might not be available)
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Icon(Icons.qr_code, size: 80, color: Color(0xFF666666)),
          ),

          // If you have qr_flutter package, replace above with:
          // QrImageView(
          //   data: confirmationNumber,
          //   size: 150,
          //   backgroundColor: Colors.white,
          // ),
          const SizedBox(height: 16),

          const Text(
            'Show this QR code for check-in',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// Action Buttons Section
class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Download Confirmation Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle download confirmation
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Confirmation downloaded'), duration: Duration(seconds: 2)));
            },
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Download Confirmation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A67D8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Share Details Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle share details
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sharing booking details'), duration: Duration(seconds: 2)));
            },
            icon: const Icon(Icons.share, size: 20),
            label: const Text('Share Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5A67D8),
              side: const BorderSide(color: Color(0xFF5A67D8)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Add to Calendar Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle add to calendar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Added to calendar'), duration: Duration(seconds: 2)));
            },
            icon: const Icon(Icons.calendar_today, size: 20),
            label: const Text('Add to Calendar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5A67D8),
              side: const BorderSide(color: Color(0xFF5A67D8)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

// View My Bookings Link
class ViewMyBookingsLink extends StatelessWidget {
  const ViewMyBookingsLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle view my bookings
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Navigating to My Bookings'), duration: Duration(seconds: 2)));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'View My Bookings',
            style: TextStyle(fontSize: 16, color: Color(0xFF5A67D8), fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF5A67D8)),
        ],
      ),
    );
  }
}

// Extension to integrate with existing payment flow
extension PaymentScreenExtension on ConsumerWidget {
  void navigateToConfirmation(BuildContext context, WidgetRef ref) {
    // Create sample confirmation data
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

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BookingConfirmationScreen()));
  }
}
