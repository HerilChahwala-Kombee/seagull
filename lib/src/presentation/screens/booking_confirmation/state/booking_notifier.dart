import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_state.dart';

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(_initialState);

  static final BookingState _initialState = BookingState(
    service: BookingService(
      id: '1',
      title: 'Deep House Cleaning',
      company: 'CleanCo Professional Services',
      imageUrl: 'assets/images/cleaning.jpg',
      rating: 4.8,
      date: constDate,
      time: TimeOfDay(hour: 10, minute: 30),
      duration: 3,
      price: 80.0,
    ),
    customerInfo: const CustomerInfo(
      fullName: 'John Smith',
      email: 'john.smith@example.com',
      phone: '(555) 123-4567',
      isValidated: true,
    ),
  );

  static final DateTime constDate = DateTime(2023, 8, 15);

  void updateCustomerInfo(CustomerInfo newInfo) {
    state = state.copyWith(customerInfo: newInfo);
  }

  void updateSpecialInstructions(String instructions) {
    state = state.copyWith(specialInstructions: instructions);
  }

  void updateServiceDateTime(DateTime date, TimeOfDay time) {
    final updatedService = state.service.copyWith(date: date, time: time);
    state = state.copyWith(service: updatedService);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 3) {
      state = state.copyWith(currentStep: step);
    }
  }
}
