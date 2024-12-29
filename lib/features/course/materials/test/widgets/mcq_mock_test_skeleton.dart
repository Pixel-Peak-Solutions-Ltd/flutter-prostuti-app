import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../common/widgets/long_button.dart';
import '../../../../../core/configs/app_colors.dart';
import 'build_mcq_question_item.dart';
import 'build_test_time_row.dart';
import 'countdown_timer.dart';

class MockQuestionSkeleton extends StatelessWidget {
  const MockQuestionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.shadeSecondaryLight,
              border: Border.all(color: AppColors.borderFocusPrimaryLight),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "বিষয় :",
                      style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.borderFocusPrimaryLight),
                    ),
                    Text(
                      "",
                      style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.borderFocusPrimaryLight),
                    ),
                  ],
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "টেস্ট টাইপ :",
                      style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.borderFocusPrimaryLight),
                    ),
                    Text(
                      "",
                      style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.borderFocusPrimaryLight),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  "প্রতিটি প্রশ্নে 1 পয়েন্ট থাকে এবং প্রতিটি ভুল উত্তরের জন্য \n0.5 পয়েন্ট কাটা হবে।",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Gap(16),
          const CountdownTimer(
            duration: Duration(minutes: 00),
          ),
          const Gap(24),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.textActionPrimaryLight,
                    border: Border.all(color: AppColors.shadeNeutralLight),
                  ),
                  child: const Text(
                      "                                                                                                                                           "),
                );
              },
            ),
          ),
          LongButton(onPressed: () {}, text: "সাবমিট করুন")
        ],
      ),
    );
  }
}
