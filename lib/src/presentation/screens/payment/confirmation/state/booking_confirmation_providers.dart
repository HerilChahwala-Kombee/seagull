import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/state/booking_confirmation_notifier.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/state/booking_confirmation_state.dart';

final bookingConfirmationProvider = StateNotifierProvider<BookingConfirmationNotifier, BookingConfirmation?>((ref) {
  return BookingConfirmationNotifier();
});
