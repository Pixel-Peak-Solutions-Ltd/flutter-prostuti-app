import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';

mixin CommonWidgets {
  final ThemeData appTheme = ThemeData();

  AppBar commonAppbar(String title, {Function()? onBack}) {
    return AppBar(
      title: Text(
        title,
      ),
      automaticallyImplyLeading: false,
      leading: onBack != null
          ? IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            )
          : IconButton(
              onPressed: () {
                Nav().pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
      centerTitle: true,
      backgroundColor: appTheme.appBarTheme.backgroundColor,
    );
  }

  Widget courseEnrollRow(
      {required String? price,
      required String? priceType,
      required ThemeData theme,
      required String title}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          priceType == "Free" || priceType == "Subscription"
              ? "$priceType"
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
              title,
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
      {required Widget trailingIcon,
      required String lessonName,
      required String itemName,
      required String icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
          enableFeedback: true,
          title: Text(
            itemName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            lessonName,
            style: theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600, color: Colors.grey.shade500),
          ),
          leading: SvgPicture.asset(
            icon,
            height: 25,
            width: 25,
            color: theme.colorScheme.onSurface,
            fit: BoxFit.cover,
          ),
          trailing: trailingIcon),
    );
  }

  /*
  Row(
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
              style: theme.textTheme.bodySmall!.copyWith(
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
    );
   */

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
                '$type: $courseDetailsName',
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
