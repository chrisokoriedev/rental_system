import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/models/auth_profile_model.dart';
import '../../../auth/providers/auth_session_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authProfileProvider);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              color: AppColors.deepNavy,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                  child: Text(
                    _profileInitials(profile),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.fullName ?? 'Guest User',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        profile?.email ?? 'guest@rental.app',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          18.verticalSpace,
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                14.verticalSpace,
                _ProfileDetailRow(
                  label: 'Full name',
                  value: profile?.fullName ?? 'Guest User',
                ),
                12.verticalSpace,
                _ProfileDetailRow(
                  label: 'Email',
                  value: profile?.email ?? 'guest@rental.app',
                ),
              ],
            ),
          ),
          14.verticalSpace,
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  12.verticalSpace,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.home_work_outlined),
                    title: const Text('Browse rentals'),
                    subtitle: const Text('Go back to the home tab'),
                    onTap: () => context.go(AppRoutes.home),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: const Text('View bookings'),
                    subtitle: const Text('Open your booking list'),
                    onTap: () => context.go(AppRoutes.bookings),
                  ),
                ],
              ),
            ),
          ),
          10.verticalSpace,
          FilledButton.tonal(
            onPressed: () async {
              await ref.read(authSessionProvider.notifier).signOut();
              if (context.mounted) {
                context.go(AppRoutes.signIn);
              }
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  String _profileInitials(AuthProfileModel? profile) {
    return profile?.initials ?? 'GU';
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF7A7B86)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
