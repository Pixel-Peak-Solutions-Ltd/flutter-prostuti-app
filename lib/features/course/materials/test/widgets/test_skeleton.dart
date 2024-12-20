import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../common/widgets/long_button.dart';
import '../../../../../core/configs/app_colors.dart';
import 'build_test_time_row.dart';

class TestDetailsSkeleton extends StatelessWidget {
  const TestDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "টপিক",
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const Gap(6),
          Container(
            height: size.height * .06,
            width: size.width * .9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.textActionPrimaryLight,
              border: Border.all(color: AppColors.shadeNeutralLight),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 14),
              child: Text(
                "",
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const Gap(24),
          Text(
            "টেস্ট টাইপ",
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const Gap(6),
          Container(
            height: size.height * .06,
            width: size.width * .9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.textActionPrimaryLight,
              border: Border.all(color: AppColors.shadeNeutralLight),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 14),
              child: Text(
                "",
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const Gap(24),
          Text(
            "প্রশ্ন সংখ্যা",
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const Gap(6),
          Container(
            height: size.height * .06,
            width: size.width * .9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.textActionPrimaryLight,
              border: Border.all(color: AppColors.shadeNeutralLight),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 14),
              child: Text(
                "",
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const Gap(24),
          buildTestTimeRow(theme, "", "২৫"),
          const Gap(24),
          // Start Test Button
          LongButton(onPressed: () {}, text: "টেস্ট শুরু করুন")
        ],
      ),
    );
  }
}

