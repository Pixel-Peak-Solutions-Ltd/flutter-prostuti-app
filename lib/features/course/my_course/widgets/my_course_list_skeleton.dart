import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'explore_course_btn.dart';

class MyCourseListSkeleton extends StatelessWidget {
  const MyCourseListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < 10; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.2, color: Colors.grey.shade900),
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                  "assets/images/my_course_thumbnail.png")),
                          const Gap(8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                child: Text(
                                  "name",
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
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.28,
                                    child: LinearProgressIndicator(
                                      value: 0,
                                      backgroundColor:
                                          AppColors.shadePrimaryLight,
                                      color: AppColors
                                          .backgroundActionPrimaryLight,
                                    ),
                                  ),
                                  const Gap(16),
                                  Text(
                                    '${(5 * 100).toInt()}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: AppColors
                                              .textActionSecondaryLight,
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
                ),
              const Gap(16),
              const ExploreCourseBtn()
            ],
          ),
        ),
      ),
    );
  }
}
