import 'package:flutter/material.dart';

class BookingConfirmation {
  final String confirmationNumber;
  final String serviceName;
  final String serviceType;
  final int duration;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double totalPaid;
  final String paymentMethod;
  final String cardLastFour;
  final DateTime createdAt;

  const BookingConfirmation({
    required this.confirmationNumber,
    required this.serviceName,
    required this.serviceType,
    required this.duration,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.totalPaid,
    required this.paymentMethod,
    required this.cardLastFour,
    required this.createdAt,
  });

  String get fullAddress => '$address, $city, $state $zipCode';

  String get timeRange {
    final startFormatted = _formatTime(startTime);
    final endFormatted = _formatTime(endTime);
    return '$startFormatted - $endFormatted';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
