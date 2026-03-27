import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../providers/bookings_ui_provider.dart';

class BookingSummaryScreen extends ConsumerWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingSummaryProvider);
    final canPop = context.canPop();

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Summary')),
        body: Center(
          child: Text('No active booking yet.', style: TextStyle(fontSize: 14.sp)),
        ),
      );
    }

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Booking Summary')),
        body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review your booking',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
            ),
            14.verticalSpace,
            Card(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.rentalTitle,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
                    ),
                    6.verticalSpace,
                    Row(
                      children: [
                        const Icon(Icons.place_outlined),
                        4.horizontalSpace,
                        Text(booking.rentalLocation),
                      ],
                    ),
                    14.verticalSpace,
                    _amountRow('Nights', '${booking.nights}'),
                    8.verticalSpace,
                    _amountRow('Subtotal', 'N${booking.subtotal.toStringAsFixed(0)}'),
                    8.verticalSpace,
                    _amountRow('Service fee', 'N${booking.serviceFee.toStringAsFixed(0)}'),
                    10.verticalSpace,
                    const Divider(),
                    10.verticalSpace,
                    _amountRow(
                      'Total',
                      'N${booking.total.toStringAsFixed(0)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Proceed to checkout',
              onPressed: () async {
                // Add current booking to temporary board as Draft if not already there
                if (ref.read(activeBookingIdProvider) == null) {
                  await ref
                      .read(bookingBoardProvider.notifier)
                      .addDraftBooking();
                }
                if (!context.mounted) return;
                context.push(AppRoutes.checkout);
              },
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _amountRow(String label, String value, {bool isBold = false}) {
    final weight = isBold ? FontWeight.w700 : FontWeight.w500;
    return Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(fontWeight: weight))),
        Text(value, style: TextStyle(fontWeight: weight)),
      ],
    );
  }
}
