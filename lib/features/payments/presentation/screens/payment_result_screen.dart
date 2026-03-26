import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';

class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Result')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, size: 90.w, color: Colors.green),
            16.verticalSpace,
            Text(
              'Payment successful',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
            ),
            8.verticalSpace,
            Card(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Text(
                  'Your booking has been confirmed. A confirmation email will be sent shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, height: 1.4),
                ),
              ),
            ),
            24.verticalSpace,
            AppButton(
              label: 'Go to profile',
              onPressed: () => context.go(AppRoutes.profile),
            ),
          ],
        ),
      ),
    );
  }
}
