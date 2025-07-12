import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_providers.dart';

class CreditCardForm extends ConsumerWidget {
  const CreditCardForm({super.key});

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
