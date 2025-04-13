// course_details_view.dart - Updated with optimized review section
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/currency_converter.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/course_details/viewmodel/course_details_vm.dart';
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
import '../widgets/course_review_section.dart';
import '../widgets/expandable_text.dart';

// Constants for consistent styling
const double kPadding = 16.0;
const double kVerticalPadding = 24.0;
const double kBorderRadius = 16.0;
const double kIconSize = 20.0;
const double kGapSmall = 8.0;
const double kGapMedium = 16.0;
const double kGapLarge = 32.0;

// Material type enum for curriculum items
enum MaterialType { recordedClass, resource, assignment, test }

// Extension to get material properties based on type
extension MaterialTypeExtension on MaterialType {
  String get iconPath {
    switch (this) {
      case MaterialType.recordedClass:
        return "assets/icons/record_class.svg";
      case MaterialType.resource:
        return "assets/icons/resource.svg";
      case MaterialType.assignment:
        return "assets/icons/assignment.svg";
      case MaterialType.test:
        return "assets/icons/test.svg";
    }
  }

  String getLocalizedName(BuildContext context) {
    switch (this) {
      case MaterialType.recordedClass:
        return context.l10n!.recordedClass;
      case MaterialType.resource:
        return context.l10n!.resource;
      case MaterialType.assignment:
        return context.l10n!.assignment;
      case MaterialType.test:
        return context.l10n!.test;
    }
  }
}

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
    final courseDetailsAsync = ref.watch(courseDetailsViewmodelProvider);
    final isLoading = ref.watch(_loadingProvider);
    final subscriptionAsyncValue = ref.watch(userSubscribedProvider);
    final isEnrolled = ref.watch(courseEnrollmentStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n!.coursePreview,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: courseDetailsAsync.when(
        data: (courseDetails) {
          return _buildMainContent(
            courseDetails,
            context,
            isEnrolled:
                ref.watch(courseEnrollmentStatusProvider).value ?? false,
          );
        },
        error: (error, stackTrace) {
          return _buildErrorWidget(error, context);
        },
        loading: () {
          return const CourseDetailsSkeleton();
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        courseDetailsAsync,
        isLoading,
        subscriptionAsyncValue,
        isEnrolled,
        context,
      ),
    );
  }

  Widget _buildMainContent(dynamic courseDetails, BuildContext context,
      {bool isEnrolled = false}) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: kPadding,
            vertical: kVerticalPadding,
          ),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: kVerticalPadding,
                horizontal: kPadding,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(kBorderRadius),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCourseHeader(courseDetails, context),
                  const Gap(kGapLarge),
                  _buildAboutSection(courseDetails, context),
                  const Gap(kGapLarge),
                  _buildCurriculumSection(courseDetails, context),

                  const Gap(kGapLarge),
                  // Use the new review section widget
                  CourseReviewsSection(
                    courseId: courseDetails.data!.sId,
                    isEnrolled: isEnrolled,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseHeader(dynamic courseDetails, BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  courseDetails.data!.image!.path ??
                      "https://www.pngkey.com/png/detail/233-2332677_image-500580-placeholder-transparent.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  filterQuality: FilterQuality.high,
                ),
              ),
              // Optional: Add a gradient overlay for better text visibility if needed
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                      stops: const [0.7, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(kGapMedium),
        Text(
          courseDetails.data!.name ?? "No Name",
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w800,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(kGapSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const CourseDetailsPills(
            //   value: '4.5 rating',
            //   icon: "assets/icons/star.svg",
            // ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                courseDetails.data!.priceType == "Free" ||
                        courseDetails.data!.priceType == "Subscription"
                    ? "${courseDetails.data!.priceType}"
                    : currencyFormatter.format(courseDetails.data!.price),
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const Gap(24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CourseDetailsPills(
                value:
                    '${courseDetails.data!.totalTests} ${context.l10n!.tests}',
                icon: "assets/icons/test.svg",
              ),
              CourseDetailsPills(
                value:
                    '${courseDetails.data!.totalRecodedClasses} ${context.l10n!.recordedClasses}',
                icon: "assets/icons/record_class.svg",
              ),
              CourseDetailsPills(
                value:
                    '${courseDetails.data!.totalAssignments} ${context.l10n!.assignment}',
                icon: "assets/icons/assignment.svg",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(dynamic courseDetails, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourseListHeader(text: context.l10n!.aboutTest),
        const Gap(kGapSmall),
        ExpandableText(text: courseDetails.data!.details!),
      ],
    );
  }

  Widget _buildCurriculumSection(dynamic courseDetails, BuildContext context) {
    final lessonMoreBtn = ref.watch(lessonSeeMoreViewmodelProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourseListHeader(text: context.l10n!.courseCurriculum),
        const Gap(kGapMedium),

        // Lessons and materials
        if (courseDetails.data!.lessons!.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
              ),
            ),
            child: Column(
              children: [
                for (int i = 0;
                    i <
                        (lessonMoreBtn
                            ? courseDetails.data!.lessons!.length
                            : 2);
                    i++)
                  _buildLessonExpansionTile(
                      courseDetails.data!.lessons![i], i, theme, context),
              ],
            ),
          ),

        const Gap(16),

        // Show more/less button
        Center(
          child: ElevatedButton.icon(
            icon: Icon(
              lessonMoreBtn ? Icons.expand_less : Icons.expand_more,
              size: 18,
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.6),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              ref.read(lessonSeeMoreViewmodelProvider.notifier).toggleBtn();
            },
            label: Text(
              lessonMoreBtn ? context.l10n!.showLess : context.l10n!.showMore,
              style: theme.textTheme.bodySmall!
                  .copyWith(color: theme.colorScheme.secondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonExpansionTile(
      dynamic lesson, int index, ThemeData theme, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          lesson.name ?? 'Lesson ${index + 1}',
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          // Recorded Classes
          ...buildMaterialItems(
            items: lesson.recodedClasses,
            type: MaterialType.recordedClass,
            nameGetter: (item) => item.recodeClassName,
            theme: theme,
            context: context,
          ),

          // Resources
          ...buildMaterialItems(
            items: lesson.resources,
            type: MaterialType.resource,
            nameGetter: (item) => item.name,
            theme: theme,
            context: context,
          ),

          // Assignments
          ...buildMaterialItems(
            items: lesson.assignments,
            type: MaterialType.assignment,
            nameGetter: (item) => item.assignmentNo,
            theme: theme,
            context: context,
          ),

          // Tests
          ...buildMaterialItems(
            items: lesson.tests,
            type: MaterialType.test,
            nameGetter: (item) => item.name,
            theme: theme,
            context: context,
          ),
        ],
      ),
    );
  }

  List<Widget> buildMaterialItems({
    required List items,
    required MaterialType type,
    required Function nameGetter,
    required ThemeData theme,
    required BuildContext context,
  }) {
    return [
      for (int j = 0; j < items.length; j++)
        _buildMaterialItem(
          iconPath: type.iconPath,
          name: '${type.getLocalizedName(context)}: ${nameGetter(items[j])}',
          theme: theme,
          context: context,
        ),
    ];
  }

  Widget _buildMaterialItem({
    required String iconPath,
    required String name,
    required ThemeData theme,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath,
                height: kIconSize,
                width: kIconSize,
                color: theme.colorScheme.onSurface,
                fit: BoxFit.cover,
              ),
              const Gap(kGapSmall),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.5,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  name,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: Colors.grey.shade600,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(dynamic error, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const Gap(16),
          Text(
            "${context.l10n!.error}: $error",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(courseDetailsViewmodelProvider);
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n!.tryAgain ?? 'Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    AsyncValue<dynamic> courseDetailsAsync,
    bool isLoading,
    AsyncValue<bool> subscriptionAsyncValue,
    AsyncValue<bool> isEnrolled,
    BuildContext context,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      height: SizeConfig.h(60),
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding,
        vertical: kVerticalPadding / 2,
      ),
      child: courseDetailsAsync.when(
        data: (data) => _buildEnrollButton(
          data,
          isLoading,
          subscriptionAsyncValue,
          isEnrolled,
          context,
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            "${context.l10n!.error}: $error",
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        loading: () => _buildLoadingEnrollButton(context),
      ),
    );
  }

  Widget _buildEnrollButton(
    dynamic data,
    bool isLoading,
    AsyncValue<bool> subscriptionAsyncValue,
    AsyncValue<bool> isEnrolled,
    BuildContext context,
  ) {
    final isButtonEnabled = !isLoading &&
        !subscriptionAsyncValue.isLoading &&
        !isEnrolled.isLoading;
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: isLoading,
      child: InkWell(
        onTap: isButtonEnabled
            ? () => _handleEnrollButtonTap(data, isEnrolled, context)
            : null,
        child: Skeletonizer(
          enabled: subscriptionAsyncValue.isLoading || isEnrolled.isLoading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.secondary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.data!.priceType == "Free"
                      ? context.l10n!.free ?? 'Free'
                      : data.data!.priceType == "Subscription"
                          ? context.l10n!.subscription ?? 'Subscription'
                          : currencyFormatter.format(data.data!.price),
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      isEnrolled.value == true
                          ? context.l10n!.visitCourse ?? 'Visit Course'
                          : context.l10n!.enrollInCourse ?? 'Enroll Now',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    Icon(
                      isEnrolled.value == true
                          ? Icons.login_rounded
                          : Icons.arrow_forward_rounded,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleEnrollButtonTap(
    dynamic data,
    AsyncValue<bool> isEnrolled,
    BuildContext context,
  ) {
    _debouncer.run(
      action: isEnrolled.value == true
          ? () async {
              ref.watch(getCourseByIdProvider.notifier).setId(data.data!.sId!);
              Nav().pushReplacement(const EnrolledCourseLandingView());
            }
          : () async {
              await _handleEnrollment(data, context);
            },
      loadingController: ref.read(_loadingProvider.notifier),
    );
  }

  Future<void> _handleEnrollment(dynamic data, BuildContext context) async {
    final priceType = data.data!.priceType;

    if (priceType == "Paid") {
      _navigateToPayment(data, context);
    } else if (priceType == "Subscription") {
      await _handleSubscriptionEnrollment(data, context);
    } else if (priceType == "Free") {
      await _handleFreeEnrollment(data, context);
    } else {
      Fluttertoast.showToast(msg: context.l10n!.contactProstuti);
    }
  }

  void _navigateToPayment(dynamic data, BuildContext context) {
    Nav().push(PaymentView(
      id: data.data!.sId!,
      name: data.data!.name!,
      imgPath: data.data!.image!.path!,
      price: data.data!.price.toString(),
    ));
  }

  Future<void> _handleSubscriptionEnrollment(
      dynamic data, BuildContext context) async {
    final subscriptionAsyncValue = ref.read(userSubscribedProvider);

    if (subscriptionAsyncValue.value == false) {
      Nav().push(SubscriptionView());
    } else {
      final response =
          await ref.read(paymentRepoProvider).enrollSubscribedCourse({
        "course_id": [data.data!.sId]
      });

      if (response) {
        ref.watch(getCourseByIdProvider.notifier).setId(data.data!.sId!);
        Nav().pushReplacement(const EnrolledCourseLandingView());
        Fluttertoast.showToast(msg: context.l10n!.enrolledSuccess);
      } else {
        Fluttertoast.showToast(msg: context.l10n!.contactProstuti);
      }
    }
  }

  Future<void> _handleFreeEnrollment(dynamic data, BuildContext context) async {
    final response = await ref.read(paymentRepoProvider).enrollFreeCourse({
      "course_id": [data.data!.sId!]
    });

    if (response) {
      Fluttertoast.showToast(msg: context.l10n!.enrolledSuccess);
      Nav().pushReplacement(MyCourseView());
    } else {
      Fluttertoast.showToast(msg: context.l10n!.alreadyEnrolled);
    }
  }

  Widget _buildLoadingEnrollButton(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Price",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
            Text(
              "Enroll Now",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
