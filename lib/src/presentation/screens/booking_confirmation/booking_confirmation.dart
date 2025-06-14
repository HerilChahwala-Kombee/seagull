import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Models
class BookingService {
  final String id;
  final String title;
  final String company;
  final String imageUrl;
  final double rating;
  final DateTime date;
  final TimeOfDay time;
  final int duration;
  final double price;

  const BookingService({
    required this.id,
    required this.title,
    required this.company,
    required this.imageUrl,
    required this.rating,
    required this.date,
    required this.time,
    required this.duration,
    required this.price,
  });

  BookingService copyWith({
    String? id,
    String? title,
    String? company,
    String? imageUrl,
    double? rating,
    DateTime? date,
    TimeOfDay? time,
    int? duration,
    double? price,
  }) {
    return BookingService(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      price: price ?? this.price,
    );
  }
}

class CustomerInfo {
  final String fullName;
  final String email;
  final String phone;
  final bool isValidated;

  const CustomerInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    this.isValidated = false,
  });

  CustomerInfo copyWith({
    String? fullName,
    String? email,
    String? phone,
    bool? isValidated,
  }) {
    return CustomerInfo(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isValidated: isValidated ?? this.isValidated,
    );
  }
}

class BookingState {
  final BookingService service;
  final CustomerInfo customerInfo;
  final String specialInstructions;
  final double serviceFee;
  final int currentStep;

  const BookingState({
    required this.service,
    required this.customerInfo,
    this.specialInstructions = '',
    this.serviceFee = 4.0,
    this.currentStep = 1,
  });

  double get subtotal => service.price;
  double get total => subtotal + serviceFee;

  BookingState copyWith({
    BookingService? service,
    CustomerInfo? customerInfo,
    String? specialInstructions,
    double? serviceFee,
    int? currentStep,
  }) {
    return BookingState(
      service: service ?? this.service,
      customerInfo: customerInfo ?? this.customerInfo,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      serviceFee: serviceFee ?? this.serviceFee,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

// Booking State Notifier
class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(_initialState);

  static final BookingState _initialState = BookingState(
    service: BookingService(
      id: '1',
      title: 'Deep House Cleaning',
      company: 'CleanCo Professional Services',
      imageUrl: 'assets/images/cleaning.jpg',
      rating: 4.8,
      date: constDate,
      time: TimeOfDay(hour: 10, minute: 30),
      duration: 3,
      price: 80.0,
    ),
    customerInfo: const CustomerInfo(
      fullName: 'John Smith',
      email: 'john.smith@example.com',
      phone: '(555) 123-4567',
      isValidated: true,
    ),
  );

  static final DateTime constDate = DateTime(2023, 8, 15);

  void updateCustomerInfo(CustomerInfo newInfo) {
    state = state.copyWith(customerInfo: newInfo);
  }

  void updateSpecialInstructions(String instructions) {
    state = state.copyWith(specialInstructions: instructions);
  }

  void updateServiceDateTime(DateTime date, TimeOfDay time) {
    final updatedService = state.service.copyWith(date: date, time: time);
    state = state.copyWith(service: updatedService);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 3) {
      state = state.copyWith(currentStep: step);
    }
  }
}

// Riverpod Providers
final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

final bookingServiceProvider = Provider<BookingService>((ref) {
  return ref.watch(bookingProvider).service;
});

final customerInfoProvider = Provider<CustomerInfo>((ref) {
  return ref.watch(bookingProvider).customerInfo;
});

final bookingTotalProvider = Provider<double>((ref) {
  return ref.watch(bookingProvider).total;
});

// Main Booking Confirmation Page
class BookingConfirmationPage extends ConsumerWidget {
  const BookingConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2E5266),
            size: 20,
          ),
        ),
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E5266),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const BookingConfirmationView(),
    );
  }
}

class BookingConfirmationView extends ConsumerWidget {
  const BookingConfirmationView({Key? key}) : super(key: key);

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

// Progress Steps Widget
class BookingProgressSteps extends ConsumerWidget {
  const BookingProgressSteps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(bookingProvider).currentStep;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildStep(1, 'Details', currentStep >= 1, currentStep == 1),
          _buildConnector(currentStep >= 2),
          _buildStep(2, 'Payment', currentStep >= 2, currentStep == 2),
          _buildConnector(currentStep >= 3),
          _buildStep(3, 'Confirm', currentStep >= 3, currentStep == 3),
        ],
      ),
    );
  }

  Widget _buildStep(int stepNumber, String label, bool isCompleted, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF5A67D8)
                  : isCompleted
                  ? const Color(0xFF5A67D8)
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: isActive || isCompleted ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? const Color(0xFF5A67D8)
                  : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      height: 2,
      width: 40,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? const Color(0xFF5A67D8) : Colors.grey[300],
    );
  }
}

// Service Card Widget
class ServiceCard extends ConsumerWidget {
  const ServiceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(bookingServiceProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFF5A67D8), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Service Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue[100],
            ),
            child: const Icon(
              Icons.cleaning_services,
              size: 40,
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 16),

          // Service Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E5266),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  service.company,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < service.rating.floor()
                              ? Icons.star
                              : index < service.rating
                              ? Icons.star_half
                              : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${service.rating}/5',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Date and Time Section
class DateTimeSection extends ConsumerWidget {
  const DateTimeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(bookingServiceProvider);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoRow(
              Icons.calendar_today_outlined,
              _formatDate(service.date),
              'Change',
                  () {
                // Handle date change
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, String actionText, VoidCallback onTap) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF666666)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2E5266),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5A67D8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// Customer Information Section
class CustomerInformationSection extends ConsumerWidget {
  const CustomerInformationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E5266),
          ),
        ),

        const SizedBox(height: 16),

        // Full Name
        _buildInputField('Full Name', customerInfo.fullName, true),

        const SizedBox(height: 16),

        // Email
        _buildInputField('Email Address', customerInfo.email, true),

        const SizedBox(height: 16),

        // Phone
        _buildInputField('Phone Number', customerInfo.phone, true),
      ],
    );
  }

  Widget _buildInputField(String label, String value, bool isValidated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isValidated ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2E5266),
                  ),
                ),
              ),
              if (isValidated)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Special Instructions Section
class SpecialInstructionsSection extends ConsumerStatefulWidget {
  const SpecialInstructionsSection({Key? key}) : super(key: key);

  @override
  ConsumerState<SpecialInstructionsSection> createState() => _SpecialInstructionsSectionState();
}

class _SpecialInstructionsSectionState extends ConsumerState<SpecialInstructionsSection> {
  final TextEditingController _controller = TextEditingController();
  static const int maxLength = 200;

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(bookingProvider).specialInstructions;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special Instructions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E5266),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                maxLines: 4,
                maxLength: maxLength,
                decoration: const InputDecoration(
                  hintText: 'Add any special requirements or notes for the service provider...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  counterText: '',
                ),
                onChanged: (value) {
                  ref.read(bookingProvider.notifier).updateSpecialInstructions(value);
                },
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.visibility,
                      size: 16,
                      color: Color(0xFF666666),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Your cleaner will see these instructions before arrival',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    Text(
                      '${_controller.text.length}/$maxLength',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Price Summary Section
class PriceSummarySection extends ConsumerWidget {
  const PriceSummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E5266),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    '\$${bookingState.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Service Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Service fee',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    '\$${bookingState.serviceFee.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              Container(
                height: 1,
                color: Colors.grey[200],
              ),

              const SizedBox(height: 16),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E5266),
                    ),
                  ),
                  Text(
                    '\$${bookingState.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E5266),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Continue Button
class ContinueButton extends ConsumerWidget {
  const ContinueButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(bookingProvider.notifier).nextStep();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Continuing to payment...'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A67D8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Continue to Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}