import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_notifier.dart';
import 'package:seagull/src/presentation/screens/payment/state/payment_state.dart';

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentInfo>((ref) {
  return PaymentNotifier();
});

final isPaymentValidProvider = Provider<bool>((ref) {
  return ref.watch(paymentProvider).isValid;
});
