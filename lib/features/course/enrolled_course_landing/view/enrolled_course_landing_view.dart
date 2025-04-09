import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/course_details/widgets/course_details_skeleton.dart';
import 'package:prostuti/features/course/course_list/viewmodel/get_course_by_id.dart';
import 'package:prostuti/features/course/enrolled_course_landing/viewmodel/enrolled_course_landing_viewmodel.dart';
import 'package:prostuti/features/course/materials/assignment/view/assignment_view.dart';
import 'package:prostuti/features/course/materials/notice/view/notice_view.dart';
import 'package:prostuti/features/course/materials/record_class/view/record_class_view.dart';
import 'package:prostuti/features/course/materials/resources/view/resources_view.dart';
import 'package:prostuti/features/course/materials/shared/widgets/trailing_icon.dart';
import 'package:prostuti/features/course/materials/test/view/test_view.dart';
import 'package:prostuti/features/leaderboard/view/course_leaderboard_view.dart';

import '../../course_details/widgets/expandable_text.dart';
import '../../materials/get_material_completion.dart';
import '../../materials/routine/view/course_routineView.dart';

// Constants
const double kBorderRadius = 16.0;
const double kGridSpacing = 16.0;
const double kPadding = 16.0;
const double kVerticalPadding = 24.0;
const int kGridCrossAxisCount = 3;

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

  String svgIconPath() {
    switch (this) {
      case GridItem.recordedClass:
        return "assets/icons/record_class.svg";
      case GridItem.resource:
        return "assets/icons/resource.svg";
      case GridItem.test:
        return "assets/icons/test.svg";
      case GridItem.assignment:
        return "assets/icons/assignment.svg";
      case GridItem.notice:
        return "assets/icons/notice.svg";
      default:
        return "assets/icons/record_class.svg"; // Default icon
    }
  }

  void navigate(BuildContext context, String courseId) {
    switch (this) {
      case GridItem.recordedClass:
        Nav().push(const RecordClassView());
        break;
      case GridItem.resource:
        Nav().push(const ResourcesView());
        break;
      case GridItem.assignment:
        Nav().push(const AssignmentView());
        break;
      case GridItem.test:
        Nav().push(const TestListView());
        break;
      case GridItem.notice:
        Nav().push(NoticeView(courseId: courseId));
        break;
      case GridItem.routine:
        Nav().push(CourseRoutineView());
      case GridItem.leaderboard:
        Nav().push(CourseLeaderboardView(
          courseId: courseId,
        ));
      default:
        // TODO: Implement navigation for other grid items
        break;
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
  // Reusable method to get localized title based on grid item
  String _getLocalizedTitle(GridItem item) {
    switch (item) {
      case GridItem.recordedClass:
        return context.l10n!.recordedClass;
      case GridItem.resource:
        return context.l10n!.resource;
      case GridItem.test:
        return context.l10n!.test;
      case GridItem.assignment:
        return context.l10n!.assignment;
      case GridItem.routine:
        return context.l10n!.routine;
      case GridItem.reportCard:
        return context.l10n!.reportCard;
      case GridItem.leaderboard:
        return context.l10n!.leaderboard;
      case GridItem.notice:
        return context.l10n!.notice;
    }
  }

  // Reusable method to create a grid item
  Widget _buildGridItem(GridItem item, String courseId, ThemeData theme) {
    return InkWell(
      onTap: () => item.navigate(context, courseId),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                item.image,
                scale: 0.9,
              ),
              Text(
                _getLocalizedTitle(item),
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method to create a curriculum item
  Widget _buildCurriculumItem({
    required String itemId,
    required String date,
    required String icon,
    required String name,
    required Set<String> completedSet,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPadding).copyWith(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 20,
                width: 20,
                color: theme.colorScheme.onSurface,
                fit: BoxFit.cover,
              ),
              const Gap(8),
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
          TrailingIcon(
            classDate: date,
            isCompleted: completedSet.contains(itemId),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text("${context.l10n!.error}: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final courseDetailsAsync = ref.watch(enrolledCourseLandingProvider);
    final courseId = ref.read(getCourseByIdProvider);
    final completedAsync = ref.watch(completedIdProvider(courseId));

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
          error: (error, stackTrace) =>
              commonAppbar("${context.l10n!.error}: $error"),
          loading: () => commonAppbar(""),
        ),
        body: courseDetailsAsync.when(
          data: (courseDetails) {
            return completedAsync.when(
              data: (completedId) {
                final completedSet = Set<String>.from(completedId);
                return _buildCourseContent(theme, courseDetails, completedSet);
              },
              error: (error, stackTrace) => _buildErrorWidget(error.toString()),
              loading: () => const CourseDetailsSkeleton(),
            );
          },
          error: (error, stackTrace) => _buildErrorWidget(error.toString()),
          loading: () => const CourseDetailsSkeleton(),
        ),
      ),
    );
  }

  Widget _buildCourseContent(
      ThemeData theme, dynamic courseDetails, Set<String> completedSet) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: SingleChildScrollView(
        child: SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: kVerticalPadding, horizontal: kPadding),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/welcome.png"),
                const Gap(10),
                Text(
                  context.l10n!.welcomeMessage,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(24),
                ExpandableText(text: courseDetails.data!.details!),
                const Gap(24),
                Text(
                  context.l10n!.modules,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(24),
                _buildModulesGrid(theme, courseDetails.data!.sId!),
                const Gap(24),
                Text(
                  context.l10n!.courseCurriculum,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(16),
                _buildCurriculum(theme, courseDetails, completedSet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModulesGrid(ThemeData theme, String courseId) {
    return SizedBox(
      height: SizeConfig.h(280),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kGridCrossAxisCount,
          crossAxisSpacing: kGridSpacing,
          mainAxisSpacing: kGridSpacing,
        ),
        itemCount: GridItem.values.length,
        itemBuilder: (context, index) {
          final item = GridItem.values[index];
          return _buildGridItem(item, courseId, theme);
        },
      ),
    );
  }

  Widget _buildCurriculum(
      ThemeData theme, dynamic courseDetails, Set<String> completedSet) {
    return Column(
      children: [
        for (int i = 0; i < (courseDetails.data!.lessons!.length); i++)
          ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            dense: true,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            child: ExpansionTile(
              title: lessonName(
                  theme, '${courseDetails.data!.lessons![i].name} ${i + 1} '),
              children: [
                // Recorded Classes
                ..._buildLessonItems(
                  itemsList: courseDetails.data!.lessons![i].recodedClasses!,
                  itemType: GridItem.recordedClass,
                  namePrefix: context.l10n!.recordedClassItem,
                  nameKey: 'recodeClassName',
                  dateKey: 'classDate',
                  theme: theme,
                  completedSet: completedSet,
                ),

                // Resources
                ..._buildLessonItems(
                  itemsList: courseDetails.data!.lessons![i].resources!,
                  itemType: GridItem.resource,
                  namePrefix: context.l10n!.resourceItem,
                  nameKey: 'name',
                  dateKey: 'resourceDate',
                  theme: theme,
                  completedSet: completedSet,
                ),

                // Assignments
                ..._buildLessonItems(
                  itemsList: courseDetails.data!.lessons![i].assignments!,
                  itemType: GridItem.assignment,
                  namePrefix: context.l10n!.assignmentItem,
                  nameKey: 'assignmentNo',
                  dateKey: 'unlockDate',
                  theme: theme,
                  completedSet: completedSet,
                ),

                // Tests
                ..._buildLessonItems(
                  itemsList: courseDetails.data!.lessons![i].tests!,
                  itemType: GridItem.test,
                  namePrefix: context.l10n!.testItem,
                  nameKey: 'name',
                  dateKey: 'publishDate',
                  theme: theme,
                  completedSet: completedSet,
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _buildLessonItems({
    required List itemsList,
    required GridItem itemType,
    required String namePrefix,
    required String nameKey,
    required String dateKey,
    required ThemeData theme,
    required Set<String> completedSet,
  }) {
    return [
      for (int j = 0; j < itemsList.length; j++)
        _buildCurriculumItem(
          itemId: itemsList[j].sId ?? "",
          date: _getPropertyValue(itemsList[j], dateKey),
          icon: itemType.svgIconPath(),
          name: "$namePrefix${_getPropertyValue(itemsList[j], nameKey)}",
          completedSet: completedSet,
          theme: theme,
        ),
    ];
  }

  // Helper method to safely access properties based on property name
  String _getPropertyValue(dynamic item, String propertyName) {
    switch (propertyName) {
      case 'classDate':
        return item.classDate ?? "";
      case 'recodeClassName':
        return item.recodeClassName ?? "";
      case 'resourceDate':
        return item.resourceDate ?? "";
      case 'name':
        return item.name ?? "";
      case 'assignmentNo':
        return item.assignmentNo ?? "";
      case 'unlockDate':
        return item.unlockDate ?? "";
      case 'publishDate':
        return item.publishDate ?? "";
      default:
        return "";
    }
  }
}
