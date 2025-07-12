import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';
import 'package:seagull/src/presentation/screens/payment/complete_payment.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_providers.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_state.dart';

class CompletePaymentButton extends ConsumerWidget {
  const CompletePaymentButton({super.key});

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
