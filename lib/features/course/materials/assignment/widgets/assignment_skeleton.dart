import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../common/widgets/long_button.dart';
import 'assignment_widgets.dart';

class AssignmentSkeleton extends StatelessWidget with AssignmentWidgets {
  AssignmentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'এসাইনমেন্ট গাইডলাইন',
                style: theme.textTheme.titleMedium,
              ),
              const Gap(24),
              Text(
                'এসাইনমেন্ট মার্কস',
                style: theme.textTheme.bodyLarge,
              ),
              const Gap(6),
              TextFormField(
                enabled: false,
                decoration: const InputDecoration(hintText: "30"),
              ),
              const Gap(24),
              Text(
                'সাবমিশনের ডিটেইলস',
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(6),
              Text(
                textAlign: TextAlign.justify,
                'জীবের মধ্যে সবচেয়ে সম্পূর্ণতা মানুষের। কিন্তু সবচেয়ে অসম্পূর্ণ হয়ে সে জন্মগ্রহণ করে। বাঘ ভালুক তার জীবনযাত্রার পনেরো- আনা মূলধন নিয়ে আসে প্রকৃতির মালখানা থেকে। জীবরঙ্গভূমিতে মানুষ এসে দেখা দেয় দুই শূন্য হাতে মুঠো বেঁধে মহাকায় জন্তু ছিল প্রকাণ্ড।',
                style: theme.textTheme.bodyMedium,
              ),
              const Gap(24),
              fileBox(theme, ""),
              const Gap(24),
              Text(
                'সাবমিট করুন',
                style: theme.textTheme.titleMedium,
              ),
              const Gap(24),
              InkWell(onTap: () {}, child: submitBox(theme)),
              const Gap(24),
              LongButton(onPressed: () {}, text: "সাবমিশন কনফার্ম করুন")
            ],
          ),
        ),
      ),
    );
  }
}
