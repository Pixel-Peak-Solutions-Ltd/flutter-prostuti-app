import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/course_details/widgets/course_details_skeleton.dart';
import 'package:prostuti/features/course/enrolled_course_landing/viewmodel/enrolled_course_landing_viewmodel.dart';
import 'package:prostuti/features/course/materials/assignment/view/assignment_view.dart';
import 'package:prostuti/features/course/materials/record_class/view/record_class_view.dart';
import 'package:prostuti/features/course/materials/resources/view/resources_view.dart';
import 'package:prostuti/features/course/materials/shared/widgets/trailing_icon.dart';
import 'package:prostuti/features/course/materials/test/view/test_view.dart';

import '../../course_details/widgets/expandable_text.dart';

class GridItemData {
  final String image;
  final String localizedTitleKey;

  const GridItemData(this.image, this.localizedTitleKey);
}

enum GridItem {
  recordedClass,
  resource,
  test,
  assignment,
  routine,
  reportCard,
  leaderboard,
  notice;

  String get image {
    switch (this) {
      case GridItem.recordedClass:
        return "assets/icons/video.png";
      case GridItem.resource:
        return "assets/icons/resource.png";
      case GridItem.test:
        return "assets/icons/test.png";
      case GridItem.assignment:
        return "assets/icons/assignment.png";
      case GridItem.routine:
        return "assets/icons/routine.png";
      case GridItem.reportCard:
        return "assets/icons/report.png";
      case GridItem.leaderboard:
        return "assets/icons/learderboard.png";
      case GridItem.notice:
        return "assets/icons/notice.png";
    }
  }

  String getTitleKey() {
    switch (this) {
      case GridItem.recordedClass:
        return "recordedClass";
      case GridItem.resource:
        return "resource";
      case GridItem.test:
        return "test";
      case GridItem.assignment:
        return "assignment";
      case GridItem.routine:
        return "routine";
      case GridItem.reportCard:
        return "reportCard";
      case GridItem.leaderboard:
        return "leaderboard";
      case GridItem.notice:
        return "notice";
    }
  }
}

class EnrolledCourseLandingView extends ConsumerStatefulWidget {
  const EnrolledCourseLandingView({super.key});

  @override
  EnrolledCourseLandingViewState createState() =>
      EnrolledCourseLandingViewState();
}

class EnrolledCourseLandingViewState
    extends ConsumerState<EnrolledCourseLandingView> with CommonWidgets {
  bool isToday = true;
  bool isComplete = true;
  bool isItemComplete = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final courseDetailsAsync = ref.watch(enrolledCourseLandingProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: courseDetailsAsync.when(
          data: (data) => commonAppbar(
            data.data!.name!,
            onBack: () {
              Navigator.pop(context, true);
            },
          ),
          error: (error, stackTrace) {
            return commonAppbar("${context.l10n!.error}: $error");
          },
          loading: () {
            return commonAppbar("");
          },
        ),
        body: courseDetailsAsync.when(
          data: (courseDetails) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: SafeArea(
                  bottom: true,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/welcome.png"),
                        const Gap(10),
                        Text(
                          context.l10n!.welcomeMessage,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(24),
                        ExpandableText(text: courseDetails.data!.details!),
                        const Gap(24),
                        Text(
                          context.l10n!.modules,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(24),
                        SizedBox(
                          height: SizeConfig.h(280),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: GridItem.values.length,
                            itemBuilder: (context, index) {
                              final item = GridItem.values[index];
                              String? localizedTitle;

                              // Get localized title based on grid item
                              switch (item) {
                                case GridItem.recordedClass:
                                  localizedTitle = context.l10n!.recordedClass;
                                  break;
                                case GridItem.resource:
                                  localizedTitle = context.l10n!.resource;
                                  break;
                                case GridItem.test:
                                  localizedTitle = context.l10n!.test;
                                  break;
                                case GridItem.assignment:
                                  localizedTitle = context.l10n!.assignment;
                                  break;
                                case GridItem.routine:
                                  localizedTitle = context.l10n!.routine;
                                  break;
                                case GridItem.reportCard:
                                  localizedTitle = context.l10n!.reportCard;
                                  break;
                                case GridItem.leaderboard:
                                  localizedTitle = context.l10n!.leaderboard;
                                  break;
                                case GridItem.notice:
                                  localizedTitle = context.l10n!.notice;
                                  break;
                              }

                              return InkWell(
                                onTap: () {
                                  switch (item) {
                                    case GridItem.recordedClass:
                                      Nav().push(const RecordClassView());
                                    case GridItem.resource:
                                      Nav().push(const ResourcesView());
                                    case GridItem.assignment:
                                      Nav().push(const AssignmentView());
                                    case GridItem.test:
                                      Nav().push(const TestListView());
                                    case GridItem.routine:
                                    // TODO: Handle this case.
                                    case GridItem.reportCard:
                                    // TODO: Handle this case.
                                    case GridItem.leaderboard:
                                    // TODO: Handle this case.
                                    case GridItem.notice:
                                    // TODO: Handle this case.
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: theme.scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          item.image,
                                          scale: 0.9,
                                        ),
                                        Text(
                                          localizedTitle ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Gap(24),
                        Text(
                          context.l10n!.courseCurriculum,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(16),
                        for (int i = 0;
                            i < (courseDetails.data!.lessons!.length);
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
                                              color:
                                                  theme.colorScheme.onSurface,
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
                                                '${context.l10n!.recordedClassItem}${courseDetails.data!.lessons![i].recodedClasses![j].recodeClassName!}',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TrailingIcon(
                                            classDate: courseDetails
                                                .data!
                                                .lessons![i]
                                                .recodedClasses![j]
                                                .classDate!,
                                            isCompleted: false)
                                      ],
                                    ),
                                  ),
                                for (int j = 0;
                                    j <
                                        courseDetails.data!.lessons![i]
                                            .resources!.length;
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
                                              color:
                                                  theme.colorScheme.onSurface,
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
                                                '${context.l10n!.resourceItem}${courseDetails.data!.lessons![i].resources![j].name}',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TrailingIcon(
                                            classDate: courseDetails
                                                .data!
                                                .lessons![i]
                                                .resources![j]
                                                .resourceDate!,
                                            isCompleted: false)
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
                                              color:
                                                  theme.colorScheme.onSurface,
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
                                                '${context.l10n!.assignmentItem}${courseDetails.data!.lessons![i].assignments![j].assignmentNo!}',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TrailingIcon(
                                            classDate: courseDetails
                                                .data!
                                                .lessons![i]
                                                .assignments![j]
                                                .unlockDate!,
                                            isCompleted: false)
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
                                              color:
                                                  theme.colorScheme.onSurface,
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
                                                '${context.l10n!.testItem}${courseDetails.data!.lessons![i].tests![j].name!}',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TrailingIcon(
                                            classDate: courseDetails
                                                .data!
                                                .lessons![i]
                                                .tests![j]
                                                .publishDate!,
                                            isCompleted: false)
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text("${context.l10n!.error}: $error"),
            );
          },
          loading: () => const CourseDetailsSkeleton(),
        ),
      ),
    );
  }
}
