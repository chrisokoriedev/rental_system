import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../rentals/providers/rentals_ui_provider.dart';
import '../../models/booking_model.dart';
import '../../providers/bookings_ui_provider.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temporaryBookings = ref.watch(bookingBoardProvider);
    final selectedRental = ref.watch(selectedRentalProvider);
    final selectedNights = ref.watch(selectedNightsProvider);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF102033),
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking board',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.8,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'A temporary list powered by a Riverpod notifier. Add the current rental draft or remove items as you test the flow.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                18.verticalSpace,
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedRental?.title ?? 'No rental selected yet',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              selectedRental == null
                                  ? 'Pick a rental from Home or Search to create a draft.'
                                  : '$selectedNights night draft ready to add',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 122.w,
                        child: AppButton(
                          label: 'Add draft',
                          onPressed: selectedRental == null
                              ? null
                              : () => ref
                                  .read(bookingBoardProvider.notifier)
                                  .addDraftBooking(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          Row(
            children: [
              Text(
                'Temporary bookings',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (temporaryBookings.isNotEmpty)
                TextButton(
                  onPressed: () =>
                      ref.read(bookingBoardProvider.notifier).clear(),
                  child: const Text('Clear all'),
                ),
            ],
          ),
          10.verticalSpace,
          if (temporaryBookings.isEmpty)
            _EmptyBookingState(
              onBrowse: () => context.go(AppRoutes.search),
            )
          else
            ...temporaryBookings.map(
              (booking) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _BookingDraftCard(booking: booking),
              ),
            ),
        ],
      ),
    );
  }
}

class _BookingDraftCard extends ConsumerWidget {
  const _BookingDraftCard({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accentColor = booking.status == 'Draft'
        ? const Color(0xFFE6A44D)
        : const Color(0xFF4D8BFF);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.rentalTitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  booking.status,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            booking.rentalLocation,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF5E6472),
            ),
          ),
          14.verticalSpace,
          Row(
            children: [
              _MetaChip(label: '${booking.nights} nights'),
              8.horizontalSpace,
              _MetaChip(label: '\$${booking.total.toStringAsFixed(0)} total'),
            ],
          ),
          14.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref
                      .read(bookingBoardProvider.notifier)
                      .removeBooking(booking.id),
                  child: const Text('Remove'),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: FilledButton(
                  onPressed: () => context.go(AppRoutes.bookingSummary),
                  child: const Text('Open summary'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyBookingState extends StatelessWidget {
  const _EmptyBookingState({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 38),
          12.verticalSpace,
          Text(
            'No temporary bookings yet.',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          8.verticalSpace,
          Text(
            'Open Search, choose a rental, then add a draft here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF5E6472)),
          ),
          16.verticalSpace,
          FilledButton.tonal(
            onPressed: onBrowse,
            child: const Text('Browse rentals'),
          ),
        ],
      ),
    );
  }
}