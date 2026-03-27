import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/rental_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../providers/rentals_ui_provider.dart';

class RentalListingScreen extends ConsumerWidget {
  const RentalListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentals = ref.watch(filteredRentalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rental Listings')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          AppTextField(
            label: 'Search rentals',
            hintText: 'Search by location or title',
            prefixIcon: Icons.search,
            onChanged: (value) =>
                ref.read(rentalSearchQueryProvider.notifier).state = value,
          ),
          12.verticalSpace,
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
                  context.push(AppRoutes.rentalDetails);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
