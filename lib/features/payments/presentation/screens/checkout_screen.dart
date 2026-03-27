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

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                'Order Summary',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22.sp),
              ),
              24.verticalSpace,
              // Booking details card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.white70),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (booking != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Property',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Lovely Apartment',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Number of nights',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${booking.nights} nights',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      Divider(height: 1, color: AppColors.white70),
                      12.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'N${booking.total.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepNavy,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              24.verticalSpace,
              // Payment method info
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.subtleSurface,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.payment, size: 20.sp, color: AppColors.deepNavy),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            'Paystack (Secure Payment)',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    ? 'Processing Payment...'
                    : 'Pay with Paystack',
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
                              context: context,
                            );

                        if (!context.mounted) return;

                        if (success) {
                          final activeBookingId = ref.read(activeBookingIdProvider);
                          if (activeBookingId != null) {
                            await ref
                                .read(bookingBoardProvider.notifier)
                                .markAsPaid(activeBookingId);
                          }

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


