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
      appBar: commonAppbar(context.l10n!.coursePreview),
      body: courseDetailsAsync.when(
        data: (courseDetails) {
          return _buildMainContent(courseDetails, context);
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

  Widget _buildMainContent(dynamic courseDetails, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding,
        vertical: kVerticalPadding,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: kVerticalPadding,
            horizontal: kPadding,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(kBorderRadius),
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
              _buildReviewsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseHeader(dynamic courseDetails, BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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
        const Gap(kGapMedium),
        Text(
          courseDetails.data!.name ?? "No Name",
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w800,
          ),
          maxLines: 2,
        ),
        const Gap(kGapSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CourseDetailsPills(
              value: '4.5 rating',
              icon: Icons.star_border_outlined,
            ),
            Text(
              courseDetails.data!.priceType == "Free" ||
                      courseDetails.data!.priceType == "Subscription"
                  ? "${courseDetails.data!.priceType}"
                  : currencyFormatter.format(courseDetails.data!.price),
              style: theme.textTheme.titleLarge!.copyWith(
                color: AppColors.textActionSecondaryLight,
              ),
            ),
          ],
        ),
        const Gap(21),
        SingleChildScrollView(
          child: Row(
            children: [
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
        for (int i = 0;
            i < (lessonMoreBtn ? courseDetails.data!.lessons!.length : 1);
            i++)
          if (courseDetails.data!.lessons!.isNotEmpty)
            _buildLessonExpansionTile(
                courseDetails.data!.lessons![i], i, theme, context),

        const Gap(kGapSmall),

        // Show more/less button
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () {
              ref.watch(lessonSeeMoreViewmodelProvider.notifier).toggleBtn();
            },
            child: Text(
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
    return ListTileTheme(
      contentPadding: const EdgeInsets.all(0),
      dense: true,
      horizontalTitleGap: 0.0,
      minLeadingWidth: 0,
      child: ExpansionTile(
        title: lessonName(theme, '${lesson.name} ${index + 1} '),
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
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: kGapMedium).copyWith(top: 0),
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
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  name,
                  style: theme.textTheme.bodySmall!.copyWith(
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
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    final reviewMoreBtn = ref.watch(reviewSeeMoreViewmodelProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourseListHeader(text: context.l10n!.testReviews),
        const Gap(kGapMedium),

        // Review cards
        for (int i = 0; i < (reviewMoreBtn ? 10 : 3); i++)
          const CourseDetailsReviewCard(),

        const Gap(kGapSmall),

        // Show more/less button
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () {
              ref.watch(reviewSeeMoreViewmodelProvider.notifier).toggleBtn();
            },
            child: Text(
              reviewMoreBtn ? context.l10n!.showLess : context.l10n!.showMore,
              style: theme.textTheme.bodySmall!
                  .copyWith(color: theme.colorScheme.secondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(dynamic error, BuildContext context) {
    return Center(
      child: Text("${context.l10n!.error}: $error"),
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
        vertical: kVerticalPadding,
      ),
      child: courseDetailsAsync.when(
        data: (data) => _buildEnrollButton(
          data,
          isLoading,
          subscriptionAsyncValue,
          isEnrolled,
          context,
        ),
        error: (error, stackTrace) => Text("${context.l10n!.error}: $error"),
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

    return Skeletonizer(
      enabled: isLoading,
      child: InkWell(
        onTap: isButtonEnabled
            ? () => _handleEnrollButtonTap(data, isEnrolled, context)
            : null,
        child: Skeletonizer(
          enabled: subscriptionAsyncValue.isLoading || isEnrolled.isLoading,
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
      child: courseEnrollRow(
        priceType: "",
        price: "Free",
        theme: Theme.of(context),
        title: "",
      ),
    );
  }
}
