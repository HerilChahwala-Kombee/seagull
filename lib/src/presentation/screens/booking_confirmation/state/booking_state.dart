import 'package:flutter/material.dart';

class BookingService {
  final String id;
  final String title;
  final String company;
  final String imageUrl;
  final double rating;
  final DateTime date;
  final TimeOfDay time;
  final int duration;
  final double price;

  const BookingService({
    required this.id,
    required this.title,
    required this.company,
    required this.imageUrl,
    required this.rating,
    required this.date,
    required this.time,
    required this.duration,
    required this.price,
  });

  BookingService copyWith({
    String? id,
    String? title,
    String? company,
    String? imageUrl,
    double? rating,
    DateTime? date,
    TimeOfDay? time,
    int? duration,
    double? price,
  }) {
    return BookingService(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      price: price ?? this.price,
    );
  }
}

class CustomerInfo {
  final String fullName;
  final String email;
  final String phone;
  final bool isValidated;

  const CustomerInfo({required this.fullName, required this.email, required this.phone, this.isValidated = false});

  CustomerInfo copyWith({String? fullName, String? email, String? phone, bool? isValidated}) {
    return CustomerInfo(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isValidated: isValidated ?? this.isValidated,
    );
  }
}

class BookingState {
  final BookingService service;
  final CustomerInfo customerInfo;
  final String specialInstructions;
  final double serviceFee;
  final int currentStep;

  const BookingState({
    required this.service,
    required this.customerInfo,
    this.specialInstructions = '',
    this.serviceFee = 4.0,
    this.currentStep = 1,
  });

  double get subtotal => service.price;
  double get total => subtotal + serviceFee;

  BookingState copyWith({
    BookingService? service,
    CustomerInfo? customerInfo,
    String? specialInstructions,
    double? serviceFee,
    int? currentStep,
  }) {
    return BookingState(
      service: service ?? this.service,
      customerInfo: customerInfo ?? this.customerInfo,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      serviceFee: serviceFee ?? this.serviceFee,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
