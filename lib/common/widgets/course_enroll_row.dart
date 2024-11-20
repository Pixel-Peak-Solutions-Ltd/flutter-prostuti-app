import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/configs/app_colors.dart';

class CourseEnrollRow extends StatelessWidget {
  const CourseEnrollRow({
    super.key,
    required this.price,
    required this.discountPrice,
    required this.discount,
  });

  final String price;
  final String discountPrice;
  final String discount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              price,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.textActionSecondaryLight),
            ),
            const Gap(8),
            Text(
              discountPrice,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textTertiaryLight,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Gap(8),
            Container(
              height: 13,
              width: 39,
              decoration: BoxDecoration(
                  color: const Color(0xffFF6A38),
                  borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Text(
                  discount,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                ),
              ),
            )
          ],
        ),
        Container(
          height: 48,
          width: 157,
          decoration: BoxDecoration(
            color: const Color(0xff2970FF), // Set the background color
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          child: Center(
            child: Text(
              'এনরোল করুন',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
