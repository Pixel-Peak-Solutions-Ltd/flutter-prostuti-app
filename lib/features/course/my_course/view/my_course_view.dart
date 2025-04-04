import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/course/course_list/viewmodel/get_course_by_id.dart';
import 'package:prostuti/features/course/my_course/viewmodel/course_progress.dart';
import 'package:prostuti/features/course/my_course/viewmodel/my_course_viewmodel.dart';
import 'package:prostuti/features/course/my_course/widgets/my_course_list_skeleton.dart';

import '../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../enrolled_course_landing/view/enrolled_course_landing_view.dart';
import '../model/course_progress_model.dart';
import '../model/my_course_model.dart';
import '../widgets/explore_course_btn.dart';
import '../widgets/my_course_widgets.dart';

class MyCourseView extends ConsumerStatefulWidget {
  MyCourseView({super.key});

  @override
  MyCourseViewState createState() => MyCourseViewState();
}

class MyCourseViewState extends ConsumerState<MyCourseView> with CommonWidgets {
  @override
  Widget build(BuildContext context) {
    final enrolledListAsync = ref.watch(enrolledCourseViewmodelProvider);
    final courseProgressAsync = ref.watch(courseProgressNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar(context.l10n!.myCourses),
      body: enrolledListAsync.when(
        data: (course) {
          if (course.isEmpty) {
            return Center(
              child: Text(
                context.l10n!.noCourseAvailable,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          return courseProgressAsync.when(
            data: (progress) {
              final combinedCourseList =
                  combineProgressAndCourses(progress, course);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        for (int i = 0; i < course.length; i++)
                          InkWell(
                              onTap: () {
                                ref
                                    .watch(getCourseByIdProvider.notifier)
                                    .setId(course[i].courseId!.sId!);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EnrolledCourseLandingView()),
                                ).then((value) {
                                  if (value ?? false) {
                                    ref.refresh(courseProgressNotifierProvider);
                                    ref.refresh(
                                        enrolledCourseViewmodelProvider);
                                  }
                                });
                              },
                              child: MyCourseCard(
                                progress: combinedCourseList[i]['progress'],
                                name: course[i].courseId!.name!,
                                img: course[i].courseId!.image!.path!,
                              )),
                        const Gap(16),
                        ExploreCourseBtn(),
                      ],
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
            loading: () => const MyCourseListSkeleton(),
          );
        },
        error: (err, stack) => Center(
          child: Text('${context.l10n!.error}: $err'),
        ),
        loading: () => const MyCourseListSkeleton(),
      ),
    );
  }
}

List<Map<String, dynamic>> combineProgressAndCourses(
    List<CourseProgress> progressList,
    List<EnrolledCourseListData> enrolledCourseList) {
  // Create a Map for fast lookup of course progress by courseId
  Map<String, CourseProgress> progressMap = {
    for (var progress in progressList) progress.courseId: progress
  };

  // Now loop through enrolled courses and match with the progress data
  List<Map<String, dynamic>> combinedList = enrolledCourseList
      .where((enrolledCourse) =>
          progressMap.containsKey(enrolledCourse.courseId?.sId))
      .map((enrolledCourse) {
    var progress = progressMap[enrolledCourse.courseId?.sId];
    return {
      'course': enrolledCourse,
      'progress': progress?.completed ?? 0.0,
    };
  }).toList();

  return combinedList;
}
