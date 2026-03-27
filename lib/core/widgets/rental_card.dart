import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class RentalCard extends StatelessWidget {
  const RentalCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    this.onTap,
  });

  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final String rating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150.h,
              width: double.infinity,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 16.w,
                        color: AppColors.neutralGrey,
                      ),
                      4.horizontalSpace,
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: AppColors.neutralGrey700,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.star_rounded,
                        size: 16.w,
                        color: AppColors.ratingStar,
                      ),
                      4.horizontalSpace,
                      Text(rating, style: TextStyle(fontSize: 13.sp)),
                    ],
                  ),
                  10.verticalSpace,
                  Text(
                    price,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
