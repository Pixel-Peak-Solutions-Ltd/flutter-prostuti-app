import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/course_list/viewmodel/get_course_by_id.dart';
import 'package:prostuti/features/course/my_course/viewmodel/my_course_viewmodel.dart';
import 'package:prostuti/features/course/my_course/widgets/my_course_list_skeleton.dart';

import '../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../enrolled_course_landing/view/enrolled_course_landing_view.dart';
import '../widgets/explore_course_btn.dart';
import '../widgets/my_course_widgets.dart';

class MyCourseView extends ConsumerWidget with CommonWidgets {
  MyCourseView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final enrolledListAsync = ref.watch(enrolledCourseViewmodelProvider);
    double _progress = 0.4;

    return Scaffold(
      appBar: commonAppbar("আমার কোর্স"),
      body: enrolledListAsync.when(
        data: (course) {
          if (course.isEmpty) {
            return const Center(
              child: Text("No Course Available"),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < course.length; i++)
                    InkWell(
                        onTap: () {
                          ref
                              .watch(getCourseByIdProvider.notifier)
                              .setId(course[i].courseId!.sId!);
                          Nav().push(const EnrolledCourseLandingView());
                        },
                        child: MyCourseCard(
                          progress: _progress,
                          name: course[i].courseId!.name!,
                          img: course[i].courseId!.image!.path!,
                        )),
                  const Gap(16),
                  const ExploreCourseBtn()
                ],
              ),
            ),
          );
        },
        error: (err, stack) => Center(
          child: Text('$err'),
        ),
        loading: () => const MyCourseListSkeleton(),
      ),
    );
  }
}
