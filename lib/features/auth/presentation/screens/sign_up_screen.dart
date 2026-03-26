import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../providers/auth_session_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.verticalSpace,
              Text(
                'Create Account',
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800),
              ),
              8.verticalSpace,
              Text(
                'Set up your profile to reserve your next stay.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
              ),
              24.verticalSpace,
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      const AppTextField(
                        label: 'Full name',
                        prefixIcon: Icons.person_outline,
                      ),
                      14.verticalSpace,
                      const AppTextField(
                        label: 'Email',
                        prefixIcon: Icons.mail_outline,
                      ),
                      14.verticalSpace,
                      const AppTextField(
                        label: 'Password',
                        obscureText: true,
                        prefixIcon: Icons.lock_outline,
                      ),
                      20.verticalSpace,
                      AppButton(
                        label: 'Create account',
                        onPressed: () async {
                          await ref.read(authSessionProvider.notifier).signIn();
                          if (context.mounted) {
                            context.go(AppRoutes.home);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  4.horizontalSpace,
                  TextButton(
                    onPressed: () => context.go(AppRoutes.signIn),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
