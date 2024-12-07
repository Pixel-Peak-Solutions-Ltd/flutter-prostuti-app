import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';

import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/course_details/viewmodel/course_details_vm.dart';
import 'package:prostuti/features/course/course_details/viewmodel/review_see_more_viewModel.dart';
import 'package:prostuti/features/course/course_details/widgets/course_details_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  Widget build(BuildContext context) {
    final reviewMoreBtn = ref.watch(reviewSeeMoreViewmodelProvider);
    final lessonMoreBtn = ref.watch(lessonSeeMoreViewmodelProvider);
    ThemeData theme = Theme.of(context);

    final courseDetailsAsync = ref.watch(courseDetailsViewmodelProvider);

    return Scaffold(
      appBar: commonAppbar("Course Preview"),
      body: courseDetailsAsync.when(
        data: (courseDetails) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      courseDetails.data!.image!.path ??
                          "https://www.pngkey.com/png/detail/233-2332677_image-500580-placeholder-transparent.png",
                      fit: BoxFit.cover,
                      width: MediaQuery.sizeOf(context).width,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    courseDetails.data!.name ?? "No Name",
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
                          Text(
                            "100",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: AppColors.textActionSecondaryLight),
                          ),
                        ],
                      ),
                      const Gap(21),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CourseDetailsPills(
                              value: '৩৪৫ শিক্ষাথী',
                              icon: Icons.groups_2_outlined,
                            ),
                            CourseDetailsPills(
                              value: '${courseDetails.data!.totalTests} টেস্ট',
                              icon: Icons.menu_book,
                            ),
                            CourseDetailsPills(
                              value:
                                  '${courseDetails.data!.totalRecodedClasses} রেকর্ডক্লাস',
                              icon: Icons.video_collection_outlined,
                            ),
                            CourseDetailsPills(
                              value: '${courseDetails.data!.totalLessons} লেসন',
                              icon: Icons.view_module_outlined,
                            ),
                          ],
                        ),
                      ),
                      const Gap(32),
                      const CourseListHeader(text: 'টেস্ট সম্পর্কে'),
                      const Gap(8),
                      ExpandableText(text: courseDetails.data!.details!),
                      // RichText(
                      //   text: TextSpan(
                      //     text: 'সময়ঃ ',
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .bodyMedium!
                      //         .copyWith(fontWeight: FontWeight.w700),
                      //     children: <TextSpan>[
                      //       TextSpan(
                      //           text: 'সোম ও বুধ  রাত ৮.৩০ - ৯.৪৫ ঘোটীকায়',
                      //           style: Theme.of(context).textTheme.bodyMedium),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                  const Gap(32),
                  const CourseListHeader(text: 'কোর্স কারিকুলাম'),
                  const Gap(16),
                  for (int i = 0;
                      i <
                          (lessonMoreBtn
                              ? courseDetails.data!.lessons!.length
                              : 3);
                      i++)
                    ListTileTheme(
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                      horizontalTitleGap: 0.0,
                      minLeadingWidth: 0,
                      child: ExpansionTile(
                        title: lessonName(theme,
                            '${courseDetails.data!.lessons![i].name} ${i + 1} '),
                        children: [
                          for (int j = 0;
                              j <
                                  courseDetails
                                      .data!.lessons![i].recodedClasses!.length;
                              j++)
                            lessonMaterial(
                                icon: Icons.video_collection_outlined,
                                courseDetailsName: courseDetails
                                    .data!
                                    .lessons![i]
                                    .recodedClasses![j]
                                    .recodeClassName!,
                                i: i,
                                j: j,
                                theme: theme,
                                type: "রেকর্ড ক্লাস"),
                          for (int j = 0;
                              j <
                                  courseDetails
                                      .data!.lessons![i].assignments!.length;
                              j++)
                            lessonMaterial(
                                icon: Icons.video_collection_outlined,
                                courseDetailsName: courseDetails.data!
                                    .lessons![i].assignments![j].assignmentNo!,
                                i: i,
                                j: j,
                                theme: theme,
                                type: "এসাইনমেন্ট"),
                          for (int j = 0;
                              j <
                                  courseDetails
                                      .data!.lessons![i].assignments!.length;
                              j++)
                            lessonMaterial(
                                icon: Icons.video_collection_outlined,
                                courseDetailsName: courseDetails
                                    .data!.lessons![i].resources![j].name!,
                                i: i,
                                j: j,
                                theme: theme,
                                type: "রিসোর্স"),
                          for (int j = 0;
                              j < courseDetails.data!.lessons![i].tests!.length;
                              j++)
                            lessonMaterial(
                                icon: Icons.video_collection_outlined,
                                courseDetailsName: courseDetails
                                    .data!.lessons![i].tests![j].name!,
                                i: i,
                                j: j,
                                theme: theme,
                                type: "টেস্ট")
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
          );
        },
        error: (error, stackTrace) {
          return Text('$error');
        },
        loading: () {
          return const CourseDetailsSkeleton();
        },
      ),
      bottomNavigationBar: InkWell(
        onTap: () {},
        child: Skeletonizer(
          enabled: courseDetailsAsync.isLoading,
          child: Container(
            height: SizeConfig.h(60),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: courseEnrollRow(
              price: "100",
              theme: Theme.of(context),
            ),
          ),
        ),
      ),
    );
  }
}
