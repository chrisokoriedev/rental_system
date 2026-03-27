import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../rentals/providers/rentals_ui_provider.dart';
import '../models/booking_model.dart';

final selectedNightsProvider = StateProvider<int>((ref) => 1);

final bookingSummaryProvider = Provider<BookingModel?>((ref) {
  final rental = ref.watch(selectedRentalProvider);
  final nights = ref.watch(selectedNightsProvider);

  if (rental == null) {
    return null;
  }

  final subtotal = rental.pricePerNight * nights;
  const serviceFee = 20.0;

  return BookingModel(
    id: 'draft-booking',
    rentalId: rental.id,
    rentalTitle: rental.title,
    rentalLocation: rental.location,
    nights: nights,
    subtotal: subtotal,
    serviceFee: serviceFee,
    total: subtotal + serviceFee,
    status: 'Pending',
  );
});

class BookingBoardNotifier extends Notifier<List<BookingModel>> {
  @override
  List<BookingModel> build() => _temporaryBookingSeed;

  void addDraftBooking() {
    final pending = ref.read(bookingSummaryProvider);
    if (pending == null) {
      return;
    }

    state = [
      BookingModel(
        id: 'draft-${DateTime.now().millisecondsSinceEpoch}',
        rentalId: pending.rentalId,
        rentalTitle: pending.rentalTitle,
        rentalLocation: pending.rentalLocation,
        nights: pending.nights,
        subtotal: pending.subtotal,
        serviceFee: pending.serviceFee,
        total: pending.total,
        status: 'Draft',
      ),
      ...state,
    ];
  }

  void removeBooking(String bookingId) {
    state = state.where((booking) => booking.id != bookingId).toList();
  }

  void clear() {
    state = [];
  }
}

final bookingBoardProvider =
    NotifierProvider<BookingBoardNotifier, List<BookingModel>>(
      BookingBoardNotifier.new,
    );

class BookingHistoryNotifier extends Notifier<List<BookingModel>> {
  static const _bookingsKey = 'bookings.history';

  @override
  List<BookingModel> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final rawItems = prefs.getStringList(_bookingsKey);

    if (rawItems == null || rawItems.isEmpty) {
      return _seedBookings;
    }

    try {
      return rawItems
          .map(
            (item) =>
                BookingModel.fromJson(jsonDecode(item) as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return _seedBookings;
    }
  }

  Future<void> addCurrentBooking() async {
    final pending = ref.read(bookingSummaryProvider);
    if (pending == null) {
      return;
    }

    final confirmed = BookingModel(
      id: 'b${DateTime.now().millisecondsSinceEpoch}',
      rentalId: pending.rentalId,
      rentalTitle: pending.rentalTitle,
      rentalLocation: pending.rentalLocation,
      nights: pending.nights,
      subtotal: pending.subtotal,
      serviceFee: pending.serviceFee,
      total: pending.total,
      status: 'Paid',
    );

    state = [confirmed, ...state];
    await _saveState();
  }

  Future<void> _saveState() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final items = state.map((booking) => jsonEncode(booking.toJson())).toList();
    await prefs.setStringList(_bookingsKey, items);
  }
}

final bookingHistoryProvider =
    NotifierProvider<BookingHistoryNotifier, List<BookingModel>>(
      BookingHistoryNotifier.new,
    );

const _seedBookings = [
  BookingModel(
    id: 'b1',
    rentalId: 'r1',
    rentalTitle: 'Ocean View Apartment',
    rentalLocation: 'Lekki, Lagos',
    nights: 3,
    subtotal: 240,
    serviceFee: 20,
    total: 260,
    status: 'Paid',
  ),
  BookingModel(
    id: 'b2',
    rentalId: 'r3',
    rentalTitle: 'City Loft',
    rentalLocation: 'Abuja',
    nights: 2,
    subtotal: 190,
    serviceFee: 20,
    total: 210,
    status: 'Paid',
  ),
  BookingModel(
    id: 'b3',
    rentalId: 'r2',
    rentalTitle: 'Modern Duplex',
    rentalLocation: 'Ikeja, Lagos',
    nights: 4,
    subtotal: 480,
    serviceFee: 20,
    total: 500,
    status: 'Paid',
  ),
  BookingModel(
    id: 'b4',
    rentalId: 'r1',
    rentalTitle: 'Ocean View Apartment',
    rentalLocation: 'Lekki, Lagos',
    nights: 1,
    subtotal: 80,
    serviceFee: 20,
    total: 100,
    status: 'Pending',
  ),
  BookingModel(
    id: 'b5',
    rentalId: 'r3',
    rentalTitle: 'City Loft',
    rentalLocation: 'Abuja',
    nights: 5,
    subtotal: 475,
    serviceFee: 20,
    total: 495,
    status: 'Paid',
  ),
];

const _temporaryBookingSeed = [
  BookingModel(
    id: 'draft-1',
    rentalId: 'r2',
    rentalTitle: 'Modern Duplex',
    rentalLocation: 'Ikeja, Lagos',
    nights: 2,
    subtotal: 240,
    serviceFee: 20,
    total: 260,
    status: 'Draft',
  ),
  BookingModel(
    id: 'draft-2',
    rentalId: 'r3',
    rentalTitle: 'City Loft',
    rentalLocation: 'Abuja',
    nights: 1,
    subtotal: 95,
    serviceFee: 20,
    total: 115,
    status: 'Pending',
  ),
];
