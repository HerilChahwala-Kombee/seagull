import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_notifier.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_state.dart';

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
