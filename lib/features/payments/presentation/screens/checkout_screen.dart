// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/providers/auth_session_provider.dart';
import '../../../bookings/providers/bookings_ui_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/payment_ui_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref.watch(selectedPaymentMethodProvider);
    final booking = ref.watch(bookingSummaryProvider);
    final paymentState = ref.watch(paymentProvider);
    final authProfile = ref.watch(authProfileProvider);
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
                  'Total: ₦${(booking.total * 100).toStringAsFixed(0)}',
                  style: TextStyle(
                      fontSize: 14.sp, color: AppColors.textSecondary),
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
              // Show error message if payment fails
              if (paymentState.errorMessage != null) ...[
                16.verticalSpace,
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red.shade600, size: 20.sp),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          paymentState.errorMessage!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              AppButton(
                label: paymentState.isProcessing
                    ? 'Processing...'
                    : 'Pay now with Paystack',
                onPressed: paymentState.isProcessing
                    ? null
                    : () async {
                        if (booking == null ||
                            authProfile == null ||
                            authProfile.email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Missing booking or user data'),
                            ),
                          );
                          return;
                        }

                        // Generate unique reference
                        final reference =
                            'rental_${DateTime.now().millisecondsSinceEpoch}';
                        final amountInKobo =
                            (booking.total * 100).toInt(); // Convert to kobo

                        // Process payment
                        final success = await ref
                            .read(paymentProvider.notifier)
                            .processPayment(
                              email: authProfile.email,
                              amountInKobo: amountInKobo,
                              reference: reference,
                            );

                        if (!context.mounted) return;

                        if (success) {
                          // Save booking
                          await ref
                              .read(bookingHistoryProvider.notifier)
                              .addCurrentBooking();

                          if (!context.mounted) return;

                          // Navigate to payment result
                          context.push(AppRoutes.paymentResult);
                        } else {
                          if (!context.mounted) return;

                          // Error is already shown in UI above
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(paymentState.errorMessage ??
                                  'Payment failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
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

