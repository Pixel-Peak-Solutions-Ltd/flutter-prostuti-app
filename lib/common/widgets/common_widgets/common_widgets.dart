import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/configs/app_colors.dart';

mixin CommonWidgets {
  final ThemeData appTheme = ThemeData();

  AppBar commonAppbar(String title) {
    return AppBar(
      title: Text(
        title,
        style: appTheme.textTheme.titleMedium,
      ),
      automaticallyImplyLeading: true,
      centerTitle: true,
      backgroundColor: AppColors.shadeSecondaryLight,
    );
  }

  Widget courseEnrollRow({
    required String price,
    required String discountPrice,
    required String discount,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              price,
              style: theme.textTheme.titleLarge!
                  .copyWith(color: AppColors.textActionSecondaryLight),
            ),
            const Gap(8),
            Text(
              discountPrice,
              style: theme.textTheme.bodySmall!.copyWith(
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
                  style: theme.textTheme.bodySmall!.copyWith(
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
              style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
