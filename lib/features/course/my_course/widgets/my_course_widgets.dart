import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/configs/app_colors.dart';

class MyCourseCard extends StatelessWidget {
  final double progress;

  const MyCourseCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: Colors.grey.shade900),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset("assets/images/my_course_thumbnail.png")),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    child: Text(
                      'BCS ফাইনাল ভাইবা প্রিপারেশন ফুল গাইডলাইন',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.28,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.shadePrimaryLight,
                          color: AppColors.backgroundActionPrimaryLight,
                        ),
                      ),
                      const Gap(16),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.textActionSecondaryLight,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
