import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../providers/auth_session_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    await ref.read(authSessionProvider.notifier).signIn(
          email: _emailController.text,
        );
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Enter your email.';
    }

    const pattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
    if (!RegExp(pattern).hasMatch(email)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value?.trim() ?? '';
    if (password.isEmpty) {
      return 'Enter your password.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE9EFF7), Color(0xFFF7F2EA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(22.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E2A5A), Color(0xFFEF8A64)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 31.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.8,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        'Sign in to continue browsing stays, saving bookings, and managing your profile.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.5,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x120E1628),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF101422),
                            letterSpacing: -0.5,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          'Use your email and password, or continue with Google for a quick demo profile.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.5,
                            color: const Color(0xFF5E6472),
                          ),
                        ),
                        20.verticalSpace,
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 54.h),
                            side: const BorderSide(color: Color(0xFFD7DDE7)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                          ),
                          onPressed: () async {
                            await ref
                                .read(authSessionProvider.notifier)
                                .signInWithGoogle();
                            if (!context.mounted) {
                              return;
                            }
                            context.go(AppRoutes.home);
                          },
                          icon: CircleAvatar(
                            radius: 12.r,
                            backgroundColor: const Color(0xFFF4F7FB),
                            child: Text(
                              'G',
                              style: TextStyle(
                                color: const Color(0xFF4285F4),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          label: Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E2A5A),
                            ),
                          ),
                        ),
                        18.verticalSpace,
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF7A7B86),
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        18.verticalSpace,
                        AppTextField(
                          label: 'Email',
                          hintText: 'you@example.com',
                          controller: _emailController,
                          prefixIcon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: _validateEmail,
                        ),
                        14.verticalSpace,
                        AppTextField(
                          label: 'Password',
                          hintText: 'Minimum 6 characters',
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                          suffixIcon: IconButton(
                            onPressed: () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        18.verticalSpace,
                        AppButton(
                          label: 'Continue',
                          onPressed: _submit,
                        ),
                        16.verticalSpace,
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Request a new password',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New here?',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFF5E6472),
                              ),
                            ),
                            4.horizontalSpace,
                            TextButton(
                              onPressed: () => context.go(AppRoutes.signUp),
                              child: const Text('Create an account'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
