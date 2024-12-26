import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/course_details/viewmodel/course_details_vm.dart';
import 'package:prostuti/features/course/course_details/viewmodel/review_see_more_viewModel.dart';
import 'package:prostuti/features/course/course_details/widgets/course_details_skeleton.dart';
import 'package:prostuti/features/course/course_enrollment_status.dart';
import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:prostuti/features/payment/view/payment_view.dart';
import 'package:prostuti/features/payment/view/subscription_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/services/debouncer.dart';
import '../../../payment/viewmodel/check_subscription.dart';
import '../../course_list/viewmodel/get_course_by_id.dart';
import '../../course_list/widgets/course_list_header.dart';
import '../../enrolled_course_landing/view/enrolled_course_landing_view.dart';
import '../../my_course/view/my_course_view.dart';
import '../viewmodel/lesson_see_more_viewmodel.dart';
import '../widgets/course_details_pills.dart';
import '../widgets/course_details_review_card.dart';
import '../widgets/expandable_text.dart';

class CourseDetailsView extends ConsumerStatefulWidget {
  const CourseDetailsView({super.key});

  @override
  CourseDetailsViewState createState() => CourseDetailsViewState();
}

class CourseDetailsViewState extends ConsumerState<CourseDetailsView>
    with CommonWidgets {
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    final reviewMoreBtn = ref.watch(reviewSeeMoreViewmodelProvider);
    final lessonMoreBtn = ref.watch(lessonSeeMoreViewmodelProvider);
    ThemeData theme = Theme.of(context);

    final courseDetailsAsync = ref.watch(courseDetailsViewmodelProvider);
    final isLoading = ref.watch(_loadingProvider);
    final subscriptionAsyncValue = ref.watch(userSubscribedProvider);

    final isEnrolled = ref.watch(courseEnrollmentStatusProvider);

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
                            courseDetails.data!.priceType == "Free" ||
                                    courseDetails.data!.priceType ==
                                        "Subscription"
                                ? "${courseDetails.data!.priceType}"
                                : '৳ ${courseDetails.data!.price}',
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
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const CourseDetailsPills(
                              value: '৩৪৫ শিক্ষাথী',
                              icon: Icons.groups_2_outlined,
                            ),
                            CourseDetailsPills(
                              value:
                                  '${courseDetails.data!.totalTests}টি টেস্ট',
                              icon: Icons.menu_book,
                            ),
                            CourseDetailsPills(
                              value:
                                  '${courseDetails.data!.totalRecodedClasses}টি রেকর্ডক্লাস',
                              icon: Icons.video_collection_outlined,
                            ),
                            CourseDetailsPills(
                              value:
                                  '${courseDetails.data!.totalLessons}টি লেসন',
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
                              : 1);
                      i++)
                    if (courseDetails.data!.lessons!.isNotEmpty)
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
                                    courseDetails.data!.lessons![i]
                                        .recodedClasses!.length;
                                j++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16)
                                        .copyWith(top: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.video_collection_outlined,
                                          size: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                        const Gap(8),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.7,
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            'Recorded Class: ${courseDetails.data!.lessons![i].recodedClasses![j].recodeClassName!}',
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.lock_outline_rounded,
                                      size: 18,
                                      color: Colors.grey.shade600,
                                    )
                                  ],
                                ),
                              ),
                            for (int j = 0;
                                j <
                                    courseDetails
                                        .data!.lessons![i].resources!.length;
                                j++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16)
                                        .copyWith(top: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf_outlined,
                                          size: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                        const Gap(8),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.7,
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            'Resource: ${courseDetails.data!.lessons![i].resources![j].name}',
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.lock_outline_rounded,
                                      size: 18,
                                      color: Colors.grey.shade600,
                                    )
                                  ],
                                ),
                              ),
                            for (int j = 0;
                                j <
                                    courseDetails
                                        .data!.lessons![i].assignments!.length;
                                j++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16)
                                        .copyWith(top: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.assignment_outlined,
                                          size: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                        const Gap(8),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.7,
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            'Assignment: ${courseDetails.data!.lessons![i].assignments![j].assignmentNo!}',
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.lock_outline_rounded,
                                      size: 18,
                                      color: Colors.grey.shade600,
                                    )
                                  ],
                                ),
                              ),
                            for (int j = 0;
                                j <
                                    courseDetails
                                        .data!.lessons![i].tests!.length;
                                j++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16)
                                        .copyWith(top: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book_rounded,
                                          size: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                        const Gap(8),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.7,
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            'Test: ${courseDetails.data!.lessons![i].tests![j].name!}',
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.lock_outline_rounded,
                                      size: 18,
                                      color: Colors.grey.shade600,
                                    )
                                  ],
                                ),
                              ),
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
      bottomNavigationBar: Container(
          height: SizeConfig.h(60),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: courseDetailsAsync.when(
            data: (data) {
              return Skeletonizer(
                enabled: isLoading,
                child: InkWell(
                  onTap: isLoading ||
                          subscriptionAsyncValue.isLoading ||
                          isEnrolled.isLoading
                      ? () {}
                      : () async {
                          _debouncer.run(
                              action: isEnrolled.value == true
                                  ? () async {
                                      ref
                                          .watch(getCourseByIdProvider.notifier)
                                          .setId(data.data!.sId!);
                                      Nav().pushReplacement(
                                          const EnrolledCourseLandingView());
                                    }
                                  : () async {
                                      if (data.data!.priceType == "Paid") {
                                        Nav().push(PaymentView(
                                            id: data.data!.sId!,
                                            name: data.data!.name!,
                                            imgPath: data.data!.image!.path!,
                                            price:
                                                data.data!.price!.toString()));
                                      } else if (data.data!.priceType ==
                                          "Subscription") {
                                        if (subscriptionAsyncValue.value ==
                                            false) {
                                          Nav().push(SubscriptionView());
                                        } else {
                                          final response = await ref
                                              .read(paymentRepoProvider)
                                              .enrollSubscribedCourse({
                                            "course_id": [data.data!.sId]
                                          });

                                          if (response) {
                                            ref
                                                .watch(getCourseByIdProvider
                                                    .notifier)
                                                .setId(data.data!.sId!);
                                            Nav().pushReplacement(
                                                const EnrolledCourseLandingView());
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Contact Prostuti for enrollment");
                                          }
                                        }
                                      } else if (data.data!.priceType ==
                                          "Free") {
                                        final response = await ref
                                            .read(paymentRepoProvider)
                                            .enrollFreeCourse({
                                          "course_id": [data.data!.sId!]
                                        });

                                        if (response) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Enrolled into the free course. Enjoy");
                                          Nav().pushReplacement(MyCourseView());
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Already Enrolled in the course");
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Contact Prostuti for enrollment");
                                      }
                                    },
                              loadingController:
                                  ref.read(_loadingProvider.notifier));
                        },
                  child: Skeletonizer(
                    enabled: subscriptionAsyncValue.isLoading ||
                        isEnrolled.isLoading,
                    child: courseEnrollRow(
                      priceType: data.data!.priceType,
                      price: '${data.data!.price ?? "Free"}',
                      theme: Theme.of(context),
                      title: isEnrolled.value == true
                          ? "ভিজিট করুন"
                          : "এনরোল করুন",
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return Text("$error");
            },
            loading: () {
              return Skeletonizer(
                enabled: true,
                child: courseEnrollRow(
                  priceType: "",
                  price: "Free",
                  theme: Theme.of(context),
                  title: "",
                ),
              );
            },
          )),
    );
  }
}
