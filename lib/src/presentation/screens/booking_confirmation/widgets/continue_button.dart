import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';
import 'package:seagull/src/presentation/screens/payment/payment_screen.dart';

class ContinueButton extends ConsumerWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(bookingProvider.notifier).nextStep();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A67D8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Continue to Payment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
