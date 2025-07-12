import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/payment/confirmation/state/booking_confirmation_state.dart';

class BookingConfirmationNotifier extends StateNotifier<BookingConfirmation?> {
  BookingConfirmationNotifier() : super(null);

  void createConfirmation({
    required String serviceName,
    required String serviceType,
    required int duration,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required double totalPaid,
    required String paymentMethod,
    required String cardLastFour,
  }) {
    final confirmationNumber = _generateConfirmationNumber();

    this.state = BookingConfirmation(
      confirmationNumber: confirmationNumber,
      serviceName: serviceName,
      serviceType: serviceType,
      duration: duration,
      date: date,
      startTime: startTime,
      endTime: endTime,
      address: address,
      city: city,
      state: state,
      zipCode: zipCode,
      totalPaid: totalPaid,
      paymentMethod: paymentMethod,
      cardLastFour: cardLastFour,
      createdAt: DateTime.now(),
    );
  }

  String _generateConfirmationNumber() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    final random = Random();

    String result = '';
    // Generate 2 letters
    for (int i = 0; i < 2; i++) {
      result += letters[random.nextInt(letters.length)];
    }
    // Generate 6 numbers
    for (int i = 0; i < 6; i++) {
      result += numbers[random.nextInt(numbers.length)];
    }

    return result;
  }

  void clearConfirmation() {
    state = null;
  }
}
