import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/currency_converter.dart';
import 'package:prostuti/core/services/localization_service.dart';
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
      appBar: commonAppbar(context.l10n!.coursePreview),
      body: courseDetailsAsync.when(
        data: (courseDetails) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16)),
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
                                  : currencyFormatter
                                      .format(courseDetails.data!.price),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color:
                                          AppColors.textActionSecondaryLight),
                            ),
                          ],
                        ),
                        const Gap(21),
                        SingleChildScrollView(
                          child: Row(
                            children: [
                              // CourseDetailsPills(
                              //   value: '৩৪৫ ${context.l10n!.students}',
                              //   icon: Icons.groups_2_outlined,
                              // ),
                              CourseDetailsPills(
                                value:
                                    '${courseDetails.data!.totalTests} ${context.l10n!.tests}',
                                icon: Icons.menu_book,
                              ),
                              CourseDetailsPills(
                                value:
                                    '${courseDetails.data!.totalRecodedClasses} ${context.l10n!.recordedClasses}',
                                icon: Icons.video_collection_outlined,
                              ),
                              CourseDetailsPills(
                                value:
                                    '${courseDetails.data!.totalLessons} ${context.l10n!.lessons}',
                                icon: Icons.view_module_outlined,
                              ),
                            ],
                          ),
                        ),
                        const Gap(32),
                        CourseListHeader(text: context.l10n!.aboutTest),
                        const Gap(8),
                        ExpandableText(text: courseDetails.data!.details!),
                      ],
                    ),
                    const Gap(32),
                    CourseListHeader(text: context.l10n!.courseCurriculum),
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
                                          SvgPicture.asset(
                                            "assets/icons/record_class.svg",
                                            height: 20,
                                            width: 20,
                                            color: theme.colorScheme.onSurface,
                                            fit: BoxFit.cover,
                                          ),
                                          const Gap(8),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.7,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              '${context.l10n!.recordedClass}: ${courseDetails.data!.lessons![i].recodedClasses![j].recodeClassName!}',
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
                                          SvgPicture.asset(
                                            "assets/icons/resource.svg",
                                            height: 20,
                                            width: 20,
                                            color: theme.colorScheme.onSurface,
                                            fit: BoxFit.cover,
                                          ),
                                          const Gap(8),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.7,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              '${context.l10n!.resource}: ${courseDetails.data!.lessons![i].resources![j].name}',
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
                                      courseDetails.data!.lessons![i]
                                          .assignments!.length;
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
                                          SvgPicture.asset(
                                            "assets/icons/assignment.svg",
                                            height: 20,
                                            width: 20,
                                            color: theme.colorScheme.onSurface,
                                            fit: BoxFit.cover,
                                          ),
                                          const Gap(8),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.7,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              '${context.l10n!.assignment}: ${courseDetails.data!.lessons![i].assignments![j].assignmentNo!}',
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
                                          SvgPicture.asset(
                                            "assets/icons/test.svg",
                                            height: 20,
                                            width: 20,
                                            color: theme.colorScheme.onSurface,
                                            fit: BoxFit.cover,
                                          ),
                                          const Gap(8),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.7,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              '${context.l10n!.test}: ${courseDetails.data!.lessons![i].tests![j].name!}',
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
                            lessonMoreBtn
                                ? context.l10n!.showLess
                                : context.l10n!.showMore,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                    const Gap(32),
                    CourseListHeader(text: context.l10n!.testReviews),
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
                          reviewMoreBtn
                              ? context.l10n!.showLess
                              : context.l10n!.showMore,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Text('${context.l10n!.error}: $error');
        },
        loading: () {
          return const CourseDetailsSkeleton();
        },
      ),
      bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          height: SizeConfig.h(60),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                                            price: currencyFormatter
                                                .format(data.data!.price)));
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
                                            Fluttertoast.showToast(
                                                msg: context
                                                    .l10n!.enrolledSuccess);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: context
                                                    .l10n!.contactProstuti);
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
                                              msg: context
                                                  .l10n!.enrolledSuccess);
                                          Nav().pushReplacement(MyCourseView());
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: context
                                                  .l10n!.alreadyEnrolled);
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: context.l10n!.contactProstuti);
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
                      price: currencyFormatter.format(data.data!.price),
                      theme: Theme.of(context),
                      title: isEnrolled.value == true
                          ? context.l10n!.visitCourse
                          : context.l10n!.enrollInCourse,
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return Text("${context.l10n!.error}: $error");
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
