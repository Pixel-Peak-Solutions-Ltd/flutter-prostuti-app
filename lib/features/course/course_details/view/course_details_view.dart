import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';

import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/course_details/viewmodel/review_see_more_viewModel.dart';
import 'package:prostuti/features/course/course_list/viewmodel/get_course_by_id.dart';

import '../../course_list/widgets/course_list_header.dart';
import '../viewmodel/lesson_see_more_viewmodel.dart';
import '../widgets/course_details_pills.dart';
import '../widgets/course_details_review_card.dart';
import '../widgets/expandable_text.dart';

class CourseDetailsView extends ConsumerStatefulWidget {
  CourseDetailsView({super.key});

  @override
  CourseDetailsViewState createState() => CourseDetailsViewState();
}

class CourseDetailsViewState extends ConsumerState<CourseDetailsView>
    with CommonWidgets {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reviewMoreBtn = ref.watch(reviewSeeMoreViewmodelProvider);
    final lessonMoreBtn = ref.watch(lessonSeeMoreViewmodelProvider);
    ThemeData theme = Theme.of(context);

    print(ref.watch(getCourseByIdProvider));

    return Scaffold(
      appBar: commonAppbar("BCS ফাইনাল প্রিলি প্রিপারেশন"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  "assets/images/course_thumbnail.png",
                  fit: BoxFit.cover,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
              const Gap(16),
              Text(
                "BCS ফাইনাল প্রিলি প্রিপারেশন ফুল-টেস্ট",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w800),
                maxLines: 2,
              ),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CourseDetailsPills(
                        value: '4.5 rating',
                        icon: Icons.star_border_outlined,
                      ),
                      Row(
                        children: [
                          Text(
                            "100",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: AppColors.textActionSecondaryLight),
                          ),
                          const Gap(8),
                          Text(
                            "16",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: AppColors.textTertiaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Gap(21),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CourseDetailsPills(
                          value: '৩৪৫ শিক্ষাথী',
                          icon: Icons.groups_2_outlined,
                        ),
                        CourseDetailsPills(
                          value: '২০ টি টেস্ট',
                          icon: Icons.menu_book,
                        ),
                        CourseDetailsPills(
                          value: '২৩+ ঘণ্টা',
                          icon: Icons.timer_sharp,
                        ),
                        CourseDetailsPills(
                          value: 'সার্টিফিকেট',
                          icon: Icons.school_outlined,
                        ),
                      ],
                    ),
                  ),
                  const Gap(32),
                  const CourseListHeader(text: 'টেস্ট সম্পর্কে'),
                  const Gap(8),
                  const ExpandableText(
                    text:
                        "জীবের মধ্যে সবচেয়ে সম্পূর্ণতা মানুষের। কিন্তু সবচেয়ে অসম্পূর্ণ হয়ে সে জন্মগ্রহণ করে। বাঘ ভালুক তার জীবনযাত্রার পনেরো- আনা মূলধন নিয়ে আসে প্রকৃতির মালখানা থেকে। জীবরঙ্গভূমিতে মানুষ এসে দেখা দেয় দুই শূন্য হাতে মুঠো বেঁধে মহাকায় জন্তু ছিল প্রকাণ্ড ",
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'সময়ঃ ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w700),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'সোম ও বুধ  রাত ৮.৩০ - ৯.৪৫ ঘোটীকায়',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )
                ],
              ),
              const Gap(32),
              const CourseListHeader(text: 'কোর্স কারিকুলাম'),
              const Gap(16),
              for (int i = 0; i < (lessonMoreBtn ? 10 : 3); i++)
                ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  dense: true,
                  horizontalTitleGap: 0.0,
                  minLeadingWidth: 0,
                  child: ExpansionTile(
                    title: lessonName(
                        theme, 'লেসন ${i + 1} - বাংলা ভাষা ও সাহিত্য'),
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16)
                              .copyWith(top: 0),
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
                                    'রেকর্ড ক্লাস - ${i + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
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
                        )
                    ],
                  ),
                ),
              const Gap(8),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0),
                  onPressed: () {
                    ref
                        .watch(lessonSeeMoreViewmodelProvider.notifier)
                        .toggleBtn();
                  },
                  child: Text(
                    lessonMoreBtn ? "কম দেখুন" : 'আরও দেখুন',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
              const Gap(32),
              const CourseListHeader(text: 'টেস্ট রিভিউ'),
              const Gap(16),
              for (int i = 0; i < (reviewMoreBtn ? 10 : 3); i++)
                const CourseDetailsReviewCard(),
              const Gap(8),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0),
                  onPressed: () {
                    ref
                        .watch(reviewSeeMoreViewmodelProvider.notifier)
                        .toggleBtn();
                  },
                  child: Text(
                    reviewMoreBtn ? "কম দেখুন" : 'আরও দেখুন',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {},
        child: Container(
          height: SizeConfig.h(60),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: courseEnrollRow(
            price: "100",
            theme: Theme.of(context),
          ),
        ),
      ),
    );
  }
}
