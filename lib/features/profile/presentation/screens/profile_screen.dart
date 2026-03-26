import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../auth/providers/auth_session_provider.dart';
import '../../../bookings/providers/bookings_ui_provider.dart';
import '../../providers/profile_ui_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showOnlyPaid = ref.watch(showOnlyPaidBookingsProvider);
    final bookings = ref.watch(bookingHistoryProvider);
    final visibleBookings = showOnlyPaid
        ? bookings.where((item) => item.status == 'Paid').toList()
        : bookings;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Bookings')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text('Guest User', style: TextStyle(fontSize: 15.sp)),
              subtitle: Text(
                'guest@rental.app',
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
          ),
          10.verticalSpace,
          SwitchListTile(
            value: showOnlyPaid,
            title: const Text('Show only paid bookings'),
            onChanged: (value) =>
                ref.read(showOnlyPaidBookingsProvider.notifier).state = value,
          ),
          10.verticalSpace,
          ...visibleBookings.map(
            (booking) => Card(
              child: ListTile(
                title: Text(booking.rentalTitle),
                subtitle: Text('${booking.status} - ${booking.nights} nights'),
                trailing: Text(
                  '\$${booking.total.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          14.verticalSpace,
          OutlinedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Back to Home'),
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
}
