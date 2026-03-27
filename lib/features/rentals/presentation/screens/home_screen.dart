import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../bookings/providers/bookings_ui_provider.dart';
import '../../providers/rentals_ui_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentals = ref.watch(rentalsProvider);
    final featuredRentals = ref.watch(featuredRentalsProvider);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        children: [
          Text(
            'Good Morning',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          4.verticalSpace,
          Text(
            'Find your next lodge',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          14.verticalSpace,
          InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () => context.go(AppRoutes.search),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColors.white,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 22.w, color: AppColors.textMuted),
                  10.horizontalSpace,
                  Text(
                    'Search lodges, city, landmark',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () => context.go(AppRoutes.search),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.deepNavy,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 20),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          featuredRentals.first.title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.white70,
                    size: 14.w,
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          SizedBox(
            height: 250.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: rentals.length,
              separatorBuilder: (_, _) => 14.horizontalSpace,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                return _RentalPreviewCard(
                  title: rental.title,
                  location: rental.location,
                  pricePerNight: rental.pricePerNight,
                  imageUrl: rental.imageUrl,
                  onTap: () {
                    ref.read(selectedRentalIdProvider.notifier).state =
                        rental.id;
                    ref.read(activeBookingIdProvider.notifier).state = null;
                    context.push(AppRoutes.rentalDetails);
                  },
                );
              },
            ),
          ),

          28.verticalSpace,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Picks',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.search),
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.brandNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          ...rentals.map(
            (rental) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _RentalListCard(
                rental: rental,
                onTap: () {
                  ref.read(selectedRentalIdProvider.notifier).state = rental.id;
                  ref.read(activeBookingIdProvider.notifier).state = null;
                  context.push(AppRoutes.rentalDetails);
                },
              ),
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}

class _RentalPreviewCard extends StatelessWidget {
  const _RentalPreviewCard({
    required this.title,
    required this.location,
    required this.pricePerNight,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String location;
  final double pricePerNight;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: const LinearGradient(
              colors: [AppColors.transparent, AppColors.imageOverlay],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              4.verticalSpace,
              Text(
                location,
                style: TextStyle(color: AppColors.white70, fontSize: 12.sp),
              ),
              8.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'N${pricePerNight.toStringAsFixed(0)}/night',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RentalListCard extends StatelessWidget {
  const _RentalListCard({required this.rental, required this.onTap});

  final dynamic rental;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
              child: Image.network(
                rental.imageUrl,
                width: 110.w,
                height: 100.h,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 110.w,
                  height: 100.h,
                  color: AppColors.chipBackground,
                  child: Icon(Icons.image_outlined, color: AppColors.textMuted),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12.w,
                          color: AppColors.textMuted,
                        ),
                        3.horizontalSpace,
                        Expanded(
                          child: Text(
                            rental.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14.w,
                              color: AppColors.ratingStar,
                            ),
                            3.horizontalSpace,
                            Text(
                              rental.rating.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'N${rental.pricePerNight.toStringAsFixed(0)}/night',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepNavy,
                          ),
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
    );
  }
}
