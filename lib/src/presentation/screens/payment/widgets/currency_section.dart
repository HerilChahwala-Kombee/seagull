import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_providers.dart';

class CurrencySection extends ConsumerWidget {
  const CurrencySection({super.key});

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
            DropdownMenuItem(value: 'USD (\u0024)', child: Text('USD (\u0024)')),
            DropdownMenuItem(value: 'EUR (€)', child: Text('EUR (€)')),
            DropdownMenuItem(value: 'GBP (£)', child: Text('GBP (£)')),
            DropdownMenuItem(value: 'CAD (C\u0024)', child: Text('CAD (C\u0024)')),
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
