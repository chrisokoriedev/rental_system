// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/providers/bookings_ui_provider.dart';
import '../../providers/payment_ui_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref.watch(selectedPaymentMethodProvider);
    final booking = ref.watch(bookingSummaryProvider);
    final canPop = context.canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose payment method',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22.sp),
            ),
            8.verticalSpace,
            if (booking != null)
              Text(
                'Total: \$${booking.total.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
            12.verticalSpace,
            ...PaymentMethod.values.map(
              (item) => RadioListTile<PaymentMethod>(
                value: item,
                groupValue: method,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                tileColor: AppColors.white,
                title: Text(
                  item.name.toUpperCase(),
                  style: TextStyle(fontSize: 14.sp),
                ),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(selectedPaymentMethodProvider.notifier).state =
                        value;
                  }
                },
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Pay now (mock)',
              onPressed: () async {
                await ref
                    .read(bookingHistoryProvider.notifier)
                    .addCurrentBooking();
                if (context.mounted) {
                  context.push(AppRoutes.paymentResult);
                }
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
