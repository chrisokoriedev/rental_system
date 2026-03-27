import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/providers/bookings_ui_provider.dart';
import '../../providers/rentals_ui_provider.dart';

class RentalDetailsScreen extends ConsumerWidget {
  const RentalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rental = ref.watch(selectedRentalProvider);
    final nights = ref.watch(selectedNightsProvider);

    if (rental == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rental Details')),
        body: Center(
          child: Text(
            'No rental selected yet.',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Rental Details')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.network(rental.imageUrl, height: 220.h, fit: BoxFit.cover),
          ),
          14.verticalSpace,
          Text(
            rental.title,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
          ),
          6.verticalSpace,
          Row(
            children: [
              const Icon(Icons.place_outlined),
              6.horizontalSpace,
              Expanded(child: Text(rental.location, style: TextStyle(fontSize: 14.sp))),
              const Icon(Icons.star_rounded, color: AppColors.ratingStar),
              4.horizontalSpace,
              Text(rental.rating.toStringAsFixed(1)),
            ],
          ),
          14.verticalSpace,
          Text(rental.description, style: TextStyle(fontSize: 14.sp, height: 1.5)),
          18.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: rental.amenities.map((a) => Chip(label: Text(a))).toList(),
          ),
          20.verticalSpace,
          Card(
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                children: [
                  Text('Nights', style: TextStyle(fontSize: 14.sp)),
                  const Spacer(),
                  IconButton(
                    onPressed: nights > 1
                        ? () => ref.read(selectedNightsProvider.notifier).state--
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$nights', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp)),
                  IconButton(
                    onPressed: () => ref.read(selectedNightsProvider.notifier).state++,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          AppButton(
            label: 'Book now - \$${rental.pricePerNight.toStringAsFixed(0)}/night',
            onPressed: () => context.go(AppRoutes.bookingSummary),
          ),
        ],
      ),
    );
  }
}
