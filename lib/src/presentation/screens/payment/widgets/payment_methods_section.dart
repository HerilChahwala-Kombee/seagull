import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_providers.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_state.dart';
import 'package:seagull/src/presentation/screens/payment/widgets/credit_card_form.dart';

class PaymentMethodsSection extends ConsumerWidget {
  const PaymentMethodsSection({super.key});

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
