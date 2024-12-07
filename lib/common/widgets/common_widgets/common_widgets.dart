import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/course_details/model/course_details_model.dart';

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
    required String? price,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          price == "null" || price == null || price == "0"
              ? "Free"
              : "৳ $price",
          style: theme.textTheme.titleLarge!
              .copyWith(color: AppColors.textActionSecondaryLight),
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

  Widget courseCompletePill(ThemeData theme) {
    return Container(
      height: SizeConfig.h(16),
      width: SizeConfig.w(40),
      decoration: BoxDecoration(
          color: const Color(0xffB4EFB9),
          borderRadius: BorderRadius.circular(4)),
      child: Center(
        child: Text(
          'কমপ্লিট',
          style: theme.textTheme.bodySmall!
              .copyWith(color: const Color(0xff159021)),
        ),
      ),
    );
  }

  Widget lessonItem(ThemeData theme,
      {required bool isItemComplete,
      required bool isToday,
      required String lessonName}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16).copyWith(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.video_collection_outlined,
                size: 18,
              ),
              const Gap(8),
              Text(
                lessonName,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (isItemComplete)
            const Icon(
              Icons.check_circle,
              size: 20,
              color: Colors.blue,
            )
          else
            Icon(
              isToday ? Icons.circle_outlined : Icons.lock_outline_rounded,
              size: 20,
            )
        ],
      ),
    );
  }

  Text lessonName(ThemeData theme, String name) {
    return Text(
      name,
      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget lessonMaterial(
      {required IconData icon,
      required String courseDetailsName,
      required int i,
      required int j,
      required ThemeData theme,
      required String type}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16).copyWith(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
              ),
              const Gap(8),
              Text(
                '$type: $courseDetailsName - ${i + 1}',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.lock_outline_rounded,
            size: 18,
          )
        ],
      ),
    );
  }
}
