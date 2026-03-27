import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../providers/payment_provider.dart';

class PaymentResultScreen extends ConsumerWidget {
  const PaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentProvider);
    final canPop = context.canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment Result')),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 90.w,
                color: AppColors.successGreen,
              ),
              16.verticalSpace,
              Text(
                'Payment successful',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
              ),
              8.verticalSpace,
              Card(
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    children: [
                      Text(
                        'Your booking has been confirmed. A confirmation email will be sent shortly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, height: 1.4),
                      ),
                      if (paymentState.transactionReference != null) ...[
                        16.verticalSpace,
                        Divider(height: 1, color: AppColors.white70),
                        16.verticalSpace,
                        Row(
                          children: [
                            Text(
                              'Transaction Reference:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                paymentState.transactionReference!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Courier',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, size: 16.sp),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Reference copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              24.verticalSpace,
              AppButton(
                label: 'Go to Booking',
                onPressed: () {
                  ref.read(paymentProvider.notifier).clearMessages();
                  context.go(AppRoutes.bookings);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

