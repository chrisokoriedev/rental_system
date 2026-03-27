import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../rentals/providers/rentals_ui_provider.dart';
import '../models/booking_model.dart';

final selectedNightsProvider = StateProvider<int>((ref) => 1);
final activeBookingIdProvider = StateProvider<String?>((ref) => null);

final bookingSummaryProvider = Provider<BookingModel?>((ref) {
  final activeBookingId = ref.watch(activeBookingIdProvider);
  if (activeBookingId != null) {
    final board = ref.watch(bookingBoardProvider);
    for (final booking in board) {
      if (booking.id == activeBookingId) {
        return booking;
      }
    }
  }

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
  static const _boardKey = 'bookings.board';

  @override
  List<BookingModel> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final rawItems = prefs.getStringList(_boardKey);

    if (rawItems == null || rawItems.isEmpty) {
      return [];
    }

    try {
      return rawItems
          .map(
            (item) =>
                BookingModel.fromJson(jsonDecode(item) as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addDraftBooking() async {
    final pending = ref.read(bookingSummaryProvider);
    if (pending == null) {
      return;
    }

    final created = BookingModel(
      id: 'draft-${DateTime.now().millisecondsSinceEpoch}',
      rentalId: pending.rentalId,
      rentalTitle: pending.rentalTitle,
      rentalLocation: pending.rentalLocation,
      nights: pending.nights,
      subtotal: pending.subtotal,
      serviceFee: pending.serviceFee,
      total: pending.total,
      status: 'Draft',
    );

    state = [created, ...state];
    ref.read(activeBookingIdProvider.notifier).state = created.id;
    await _saveState();
  }

  Future<void> moveToPendingAndSelect(String bookingId) async {
    ref.read(activeBookingIdProvider.notifier).state = bookingId;
    state =
        state
            .map(
              (booking) => booking.id != bookingId || booking.status == 'Paid'
                  ? booking
                  : _copyWithStatus(booking, 'Pending'),
            )
            .toList();
    await _saveState();
  }

  Future<void> markAsPaid(String bookingId) async {
    state =
        state
            .map(
              (booking) =>
                  booking.id == bookingId ? _copyWithStatus(booking, 'Paid') : booking,
            )
            .toList();
    await _saveState();
  }

  Future<void> removeBooking(String bookingId) async {
    state = state.where((booking) => booking.id != bookingId).toList();
    if (ref.read(activeBookingIdProvider) == bookingId) {
      ref.read(activeBookingIdProvider.notifier).state = null;
    }
    await _saveState();
  }

  bool draftAlreadyExists() {
    return state.any((b) => b.status == 'Draft');
  }

  Future<void> clear() async {
    state = [];
    ref.read(activeBookingIdProvider.notifier).state = null;
    await _saveState();
  }

  BookingModel _copyWithStatus(BookingModel booking, String status) {
    return BookingModel(
      id: booking.id,
      rentalId: booking.rentalId,
      rentalTitle: booking.rentalTitle,
      rentalLocation: booking.rentalLocation,
      nights: booking.nights,
      subtotal: booking.subtotal,
      serviceFee: booking.serviceFee,
      total: booking.total,
      status: status,
    );
  }

  Future<void> _saveState() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final items = state.map((booking) => jsonEncode(booking.toJson())).toList();
    await prefs.setStringList(_boardKey, items);
  }
}

final bookingBoardProvider =
    NotifierProvider<BookingBoardNotifier, List<BookingModel>>(
      BookingBoardNotifier.new,
    );
