import 'package:flutter/material.dart';

class Booking {
  final String service;
  final String address;
  final String date;
  final TimeOfDay time;
  final bool isOld;

  Booking({
    required this.service,
    required this.address,
    required this.date,
    required this.time,
    this.isOld = false,
  });
}

class BookingManager {
  static final List<Booking> _bookings = [];

  static List<Booking> get bookings => _bookings;

  static void addBooking(Booking booking) {
    _bookings.add(booking);
  }

  static List<Booking> get newBookings => _bookings.where((b) => !b.isOld).toList();
  static List<Booking> get oldBookings => _bookings.where((b) => b.isOld).toList();
}
