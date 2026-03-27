import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/rental_card.dart';
import '../../providers/rentals_ui_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentals = ref.watch(filteredRentalsProvider);
    final query = ref.watch(rentalSearchQueryProvider);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search stays',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              8.verticalSpace,
              Text(
                'Search by title or city and jump straight into a listing.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
          18.verticalSpace,
          AppTextField(
            label: 'Find a rental',
            hintText: 'Lekki, Abuja, Ocean View Apartment',
            prefixIcon: Icons.search,
            onChanged: (value) =>
                ref.read(rentalSearchQueryProvider.notifier).state = value,
          ),
          16.verticalSpace,
          Row(
            children: [
              Text(
                query.trim().isEmpty
                    ? 'All rentals'
                    : '${rentals.length} result${rentals.length == 1 ? '' : 's'}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (query.trim().isNotEmpty)
                TextButton(
                  onPressed: () =>
                      ref.read(rentalSearchQueryProvider.notifier).state = '',
                  child: const Text('Clear'),
                ),
            ],
          ),
          8.verticalSpace,
          if (rentals.isEmpty)
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                children: [
                  const Icon(Icons.travel_explore_outlined, size: 36),
                  12.verticalSpace,
                  Text(
                    'No rental matches that search yet.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else
            ...rentals.map(
              (rental) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: RentalCard(
                  imageUrl: rental.imageUrl,
                  title: rental.title,
                  location: rental.location,
                  price: '\$${rental.pricePerNight.toStringAsFixed(0)}/night',
                  rating: rental.rating.toStringAsFixed(1),
                  onTap: () {
                    ref.read(selectedRentalIdProvider.notifier).state = rental.id;
                    context.go(AppRoutes.rentalDetails);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}