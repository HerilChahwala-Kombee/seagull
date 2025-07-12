import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/booking_confirmation.dart';
import 'package:seagull/src/presentation/screens/payment/complete_payment.dart' hide BookingProgressSteps;

// Data Models
enum PaymentMethod { creditCard, paypal, digitalWallet }

class PaymentInfo {
  final String cardNumber;
  final String expirationDate;
  final String securityCode;
  final String nameOnCard;
  final String billingCountry;
  final PaymentMethod selectedMethod;
  final String currency;
  final double exchangeRate;
  final bool isCardNumberValid;
  final bool isExpirationDateValid;
  final bool isSecurityCodeValid;
  final bool isNameOnCardValid;

  const PaymentInfo({
    this.cardNumber = '',
    this.expirationDate = '',
    this.securityCode = '',
    this.nameOnCard = '',
    this.billingCountry = 'United States',
    this.selectedMethod = PaymentMethod.creditCard,
    this.currency = 'USD (\$)',
    this.exchangeRate = 0.92,
    this.isCardNumberValid = false,
    this.isExpirationDateValid = false,
    this.isSecurityCodeValid = false,
    this.isNameOnCardValid = false,
  });

  PaymentInfo copyWith({
    String? cardNumber,
    String? expirationDate,
    String? securityCode,
    String? nameOnCard,
    String? billingCountry,
    PaymentMethod? selectedMethod,
    String? currency,
    double? exchangeRate,
    bool? isCardNumberValid,
    bool? isExpirationDateValid,
    bool? isSecurityCodeValid,
    bool? isNameOnCardValid,
  }) {
    return PaymentInfo(
      cardNumber: cardNumber ?? this.cardNumber,
      expirationDate: expirationDate ?? this.expirationDate,
      securityCode: securityCode ?? this.securityCode,
      nameOnCard: nameOnCard ?? this.nameOnCard,
      billingCountry: billingCountry ?? this.billingCountry,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isCardNumberValid: isCardNumberValid ?? this.isCardNumberValid,
      isExpirationDateValid: isExpirationDateValid ?? this.isExpirationDateValid,
      isSecurityCodeValid: isSecurityCodeValid ?? this.isSecurityCodeValid,
      isNameOnCardValid: isNameOnCardValid ?? this.isNameOnCardValid,
    );
  }

  bool get isValid {
    switch (selectedMethod) {
      case PaymentMethod.creditCard:
        return isCardNumberValid && isExpirationDateValid && isSecurityCodeValid && isNameOnCardValid;
      case PaymentMethod.paypal:
      case PaymentMethod.digitalWallet:
        return true;
    }
  }
}

// Payment State Notifier
class PaymentNotifier extends StateNotifier<PaymentInfo> {
  PaymentNotifier() : super(const PaymentInfo());

  void updateCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(' ', '');
    final isValid = _validateCardNumber(cleaned);
    state = state.copyWith(cardNumber: _formatCardNumber(cleaned), isCardNumberValid: isValid);
  }

  void updateExpirationDate(String expirationDate) {
    final formatted = _formatExpirationDate(expirationDate);
    final isValid = _validateExpirationDate(formatted);
    state = state.copyWith(expirationDate: formatted, isExpirationDateValid: isValid);
  }

  void updateSecurityCode(String securityCode) {
    final isValid = _validateSecurityCode(securityCode);
    state = state.copyWith(securityCode: securityCode, isSecurityCodeValid: isValid);
  }

  void updateNameOnCard(String nameOnCard) {
    final isValid = _validateNameOnCard(nameOnCard);
    state = state.copyWith(nameOnCard: nameOnCard, isNameOnCardValid: isValid);
  }

  void updateBillingCountry(String billingCountry) {
    state = state.copyWith(billingCountry: billingCountry);
  }

  void updatePaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedMethod: method);
  }

  void updateCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  // Validation methods
  bool _validateCardNumber(String cardNumber) {
    return cardNumber.length >= 13 && cardNumber.length <= 19 && RegExp(r'^[0-9]+$').hasMatch(cardNumber);
  }

  bool _validateExpirationDate(String expirationDate) {
    if (expirationDate.length != 5) return false;
    final parts = expirationDate.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return false;
    }

    return true;
  }

  bool _validateSecurityCode(String securityCode) {
    return securityCode.length >= 3 && securityCode.length <= 4 && RegExp(r'^[0-9]+$').hasMatch(securityCode);
  }

  bool _validateNameOnCard(String nameOnCard) {
    return nameOnCard.trim().length >= 2 && RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameOnCard.trim());
  }

  // Formatting methods
  String _formatCardNumber(String cardNumber) {
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cardNumber[i]);
    }
    return buffer.toString();
  }

  String _formatExpirationDate(String expirationDate) {
    final cleaned = expirationDate.replaceAll('/', '');
    if (cleaned.length >= 2) {
      return '${cleaned.substring(0, 2)}/${cleaned.substring(2, cleaned.length > 4 ? 4 : cleaned.length)}';
    }
    return cleaned;
  }
}

// Riverpod Providers
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentInfo>((ref) {
  return PaymentNotifier();
});

final isPaymentValidProvider = Provider<bool>((ref) {
  return ref.watch(paymentProvider).isValid;
});

// Payment Screen
class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({Key? key}) : super(key: key);

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
  const PaymentView({Key? key}) : super(key: key);

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

// Service Summary Card
class ServiceSummaryCard extends ConsumerWidget {
  const ServiceSummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(bookingServiceProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Service Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue[100]),
            child: const Icon(Icons.cleaning_services, size: 30, color: Colors.blue),
          ),

          const SizedBox(width: 12),

          // Service Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFF666666)),
                    const SizedBox(width: 4),
                    Text(_formatDate(service.date), style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 14, color: Color(0xFF666666)),
                    const SizedBox(width: 4),
                    Text(_formatTime(service.time), style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  '${service.duration} hours service',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${service.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF5A67D8)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

// Payment Methods Section
class PaymentMethodsSection extends ConsumerWidget {
  const PaymentMethodsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentInfo = ref.watch(paymentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
        ),

        const SizedBox(height: 16),

        // Credit Card Option
        GestureDetector(
          onTap: () => ref.read(paymentProvider.notifier).updatePaymentMethod(PaymentMethod.creditCard),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: paymentInfo.selectedMethod == PaymentMethod.creditCard
                    ? const Color(0xFF5A67D8)
                    : Colors.grey[300]!,
                width: paymentInfo.selectedMethod == PaymentMethod.creditCard ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF5A67D8), width: 2),
                        color: paymentInfo.selectedMethod == PaymentMethod.creditCard
                            ? const Color(0xFF5A67D8)
                            : Colors.transparent,
                      ),
                      child: paymentInfo.selectedMethod == PaymentMethod.creditCard
                          ? const Icon(Icons.circle, size: 12, color: Colors.white)
                          : null,
                    ),

                    const SizedBox(width: 12),

                    const Text(
                      'Credit Card',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                    ),

                    const Spacer(),

                    // Card Icons
                    Row(
                      children: [
                        _buildCardIcon('assets/visa.png', Colors.blue),
                        const SizedBox(width: 4),
                        _buildCardIcon('assets/mastercard.png', Colors.red),
                        const SizedBox(width: 4),
                        _buildCardIcon('assets/amex.png', Colors.blue),
                        const SizedBox(width: 4),
                        _buildCardIcon('assets/discover.png', Colors.orange),
                      ],
                    ),
                  ],
                ),

                if (paymentInfo.selectedMethod == PaymentMethod.creditCard) ...[
                  const SizedBox(height: 20),
                  const CreditCardForm(),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // PayPal Option
        GestureDetector(
          onTap: () => ref.read(paymentProvider.notifier).updatePaymentMethod(PaymentMethod.paypal),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: paymentInfo.selectedMethod == PaymentMethod.paypal ? const Color(0xFF5A67D8) : Colors.grey[300]!,
                width: paymentInfo.selectedMethod == PaymentMethod.paypal ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF5A67D8), width: 2),
                    color: paymentInfo.selectedMethod == PaymentMethod.paypal
                        ? const Color(0xFF5A67D8)
                        : Colors.transparent,
                  ),
                  child: paymentInfo.selectedMethod == PaymentMethod.paypal
                      ? const Icon(Icons.circle, size: 12, color: Colors.white)
                      : null,
                ),

                const SizedBox(width: 12),

                const Text(
                  'PayPal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF003087), borderRadius: BorderRadius.circular(4)),
                  child: const Text(
                    'PayPal',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        if (paymentInfo.selectedMethod == PaymentMethod.paypal)
          const Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              'Pay quickly using your PayPal account',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          ),

        const SizedBox(height: 12),

        // Digital Wallets Option
        GestureDetector(
          onTap: () => ref.read(paymentProvider.notifier).updatePaymentMethod(PaymentMethod.digitalWallet),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: paymentInfo.selectedMethod == PaymentMethod.digitalWallet
                    ? const Color(0xFF5A67D8)
                    : Colors.grey[300]!,
                width: paymentInfo.selectedMethod == PaymentMethod.digitalWallet ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF5A67D8), width: 2),
                        color: paymentInfo.selectedMethod == PaymentMethod.digitalWallet
                            ? const Color(0xFF5A67D8)
                            : Colors.transparent,
                      ),
                      child: paymentInfo.selectedMethod == PaymentMethod.digitalWallet
                          ? const Icon(Icons.circle, size: 12, color: Colors.white)
                          : null,
                    ),

                    const SizedBox(width: 12),

                    const Text(
                      'Digital Wallets',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                          child: const Text(
                            'Pay',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'G Pay',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4285F4)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        if (paymentInfo.selectedMethod == PaymentMethod.digitalWallet)
          const Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text('Quick and secure checkout', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
          ),
      ],
    );
  }

  Widget _buildCardIcon(String assetPath, Color color) {
    return Container(
      width: 32,
      height: 20,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: const Icon(Icons.credit_card, size: 12, color: Colors.white),
    );
  }
}

// Credit Card Form
class CreditCardForm extends ConsumerWidget {
  const CreditCardForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentInfo = ref.watch(paymentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card Number
        const Text(
          'Card Number',
          style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: paymentInfo.cardNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(19)],
          decoration: InputDecoration(
            hintText: '1234 5678 9012 3456',
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF5A67D8), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: const Icon(Icons.credit_card, color: Color(0xFF666666)),
          ),
          onChanged: (value) => ref.read(paymentProvider.notifier).updateCardNumber(value),
        ),

        const SizedBox(height: 16),

        // Expiration Date and Security Code
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expiration Date',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: paymentInfo.expirationDate,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                    decoration: InputDecoration(
                      hintText: 'MM/YY',
                      hintStyle: const TextStyle(color: Color(0xFF999999)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5A67D8), width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onChanged: (value) => ref.read(paymentProvider.notifier).updateExpirationDate(value),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Security Code',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: paymentInfo.securityCode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                    decoration: InputDecoration(
                      hintText: 'CVV',
                      hintStyle: const TextStyle(color: Color(0xFF999999)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5A67D8), width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onChanged: (value) => ref.read(paymentProvider.notifier).updateSecurityCode(value),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Name on Card
        const Text(
          'Name on Card',
          style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: paymentInfo.nameOnCard,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'John Smith',
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF5A67D8), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (value) => ref.read(paymentProvider.notifier).updateNameOnCard(value),
        ),

        const SizedBox(height: 16),

        // Billing Country
        const Text(
          'Billing Country',
          style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: paymentInfo.billingCountry,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF5A67D8), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          items: const [
            DropdownMenuItem(value: 'United States', child: Text('United States')),
            DropdownMenuItem(value: 'Canada', child: Text('Canada')),
            DropdownMenuItem(value: 'United Kingdom', child: Text('United Kingdom')),
            DropdownMenuItem(value: 'Australia', child: Text('Australia')),
          ],
          onChanged: (value) {
            if (value != null) {
              ref.read(paymentProvider.notifier).updateBillingCountry(value);
            }
          },
        ),
      ],
    );
  }
}

// Currency Section
class CurrencySection extends ConsumerWidget {
  const CurrencySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentInfo = ref.watch(paymentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Currency',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: paymentInfo.currency,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF5A67D8), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
            prefixIcon: const Icon(Icons.language, color: Color(0xFF666666)),
          ),
          items: const [
            DropdownMenuItem(value: 'USD (\$)', child: Text('USD (\$)')),
            DropdownMenuItem(value: 'EUR (€)', child: Text('EUR (€)')),
            DropdownMenuItem(value: 'GBP (£)', child: Text('GBP (£)')),
            DropdownMenuItem(value: 'CAD (C\$)', child: Text('CAD (C\$)')),
          ],
          onChanged: (value) {
            if (value != null) {
              ref.read(paymentProvider.notifier).updateCurrency(value);
            }
          },
        ),

        const SizedBox(height: 8),

        Text(
          'Exchange rate: 1 USD = ${paymentInfo.exchangeRate} EUR',
          style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
        ),
      ],
    );
  }
}

// Payment Summary Section
class PaymentSummarySection extends ConsumerWidget {
  const PaymentSummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
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
                  const Text('Subtotal', style: TextStyle(fontSize: 16, color: Color(0xFF666666))),
                  Text(
                    '\$${bookingState.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Service Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Service fee', style: TextStyle(fontSize: 16, color: Color(0xFF666666))),
                  Text(
                    '\$${bookingState.serviceFee.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              Container(height: 1, color: Colors.grey[200]),

              const SizedBox(height: 16),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
                  ),
                  Text(
                    '\$${bookingState.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF5A67D8)),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text('Price displayed in USD', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
            ],
          ),
        ),
      ],
    );
  }
}

// Security Information Section
class SecurityInformationSection extends ConsumerWidget {
  const SecurityInformationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.security, size: 20, color: Color(0xFF5A67D8)),
            const SizedBox(width: 8),
            const Text(
              'Secure Payment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(4)),
                    child: const Text(
                      'SSL Encrypted',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF2196F3), borderRadius: BorderRadius.circular(4)),
                    child: const Text(
                      'PCI DSS Compliant',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF9C27B0), borderRadius: BorderRadius.circular(4)),
                    child: const Text(
                      '3D Secure',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                'Your payment information is encrypted and secure. We do not store your credit card details.',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Complete Payment Button
class CompletePaymentButton extends ConsumerWidget {
  const CompletePaymentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaymentValid = ref.watch(isPaymentValidProvider);
    final paymentInfo = ref.watch(paymentProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isPaymentValid ? () => _handlePayment(context, ref) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPaymentValid ? const Color(0xFF5A67D8) : Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      _getButtonText(paymentInfo.selectedMethod),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'By completing this payment, you agree to our Terms of Service',
              style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Complete Payment';
      case PaymentMethod.paypal:
        return 'Pay with PayPal';
      case PaymentMethod.digitalWallet:
        return 'Pay with Digital Wallet';
    }
  }

  void _handlePayment(BuildContext context, WidgetRef ref) {
    final paymentInfo = ref.read(paymentProvider);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5A67D8))),
            const SizedBox(height: 16),
            Text(
              _getProcessingText(paymentInfo.selectedMethod),
              style: const TextStyle(fontSize: 16, color: Color(0xFF2E5266)),
            ),
          ],
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog

      // Update booking step
      ref.read(bookingProvider.notifier).nextStep();

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your booking has been confirmed. You will receive a confirmation email shortly.',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close success dialog
                    // Navigator.of(context).pop(); // Go back to previous screen

                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingConfirmationScreen()));

                    // In a real app, you might navigate to a confirmation screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Booking confirmed successfully!'),
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A67D8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _getProcessingText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Processing payment...';
      case PaymentMethod.paypal:
        return 'Redirecting to PayPal...';
      case PaymentMethod.digitalWallet:
        return 'Processing with digital wallet...';
    }
  }
}
