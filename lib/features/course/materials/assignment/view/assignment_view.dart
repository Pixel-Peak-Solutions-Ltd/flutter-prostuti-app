import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/course/materials/assignment/view/assignment_details_view.dart';
import 'package:prostuti/features/course/materials/assignment/viewmodel/assignment_viewmodel.dart';
import 'package:prostuti/features/course/materials/assignment/viewmodel/get_assignment_by_id.dart';

import '../../../../../core/services/nav.dart';
import '../../../course_list/viewmodel/get_course_by_id.dart';
import '../../get_material_completion.dart';
import '../../shared/widgets/material_list_skeleton.dart';
import '../../shared/widgets/trailing_icon.dart';

class AssignmentView extends ConsumerStatefulWidget {
  const AssignmentView({Key? key}) : super(key: key);

  @override
  AssignmentViewState createState() => AssignmentViewState();
}

class AssignmentViewState extends ConsumerState<AssignmentView>
    with CommonWidgets {
  @override
  Widget build(BuildContext context) {
    final assignmentListAsync = ref.watch(assignmentViewmodelProvider);
    final courseId = ref.read(getCourseByIdProvider);
    final completedAsync = ref.watch(completedIdProvider(courseId));

    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: commonAppbar("এসাইনমেন্ট"),
      body: assignmentListAsync.when(
        data: (assignment) {
          return completedAsync.when(
            data: (completedId) {
              final completedSet = Set<String>.from(completedId);
              return ListView.builder(
                itemCount: assignment.length,
                itemBuilder: (context, index) {
                  final isCompleted =
                      completedSet.contains(assignment[index].sId);

                  return InkWell(
                    onTap: () {
                      DateTime parsedDate =
                          DateTime.parse(assignment[index].unlockDate!);
                      DateTime now = DateTime.now();
                      if ((parsedDate.day == now.day &&
                              parsedDate.month == now.month &&
                              parsedDate.year == now.year) ||
                          (parsedDate.isBefore(now))) {
                        ref
                            .watch(getAssignmentByIdProvider.notifier)
                            .setAssignmentId(assignment[index].sId!);

                        Nav().push(AssignmentDetailsView(
                          isCompleted: isCompleted,
                        ));
                      }
                    },
                    child: lessonItem(theme,
                        trailingIcon: TrailingIcon(
                          classDate: assignment[index].unlockDate!,
                          isCompleted: isCompleted,
                        ),
                        itemName: "${assignment[index].assignmentNo}",
                        icon: Icons.video_collection_rounded,
                        lessonName: '${assignment[index].lessonId!.number} '),
                  );
                },
              );
            },
            error: (error, stackTrace) => const Icon(
              Icons.dangerous,
              color: Colors.red,
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        error: (error, stackTrace) {
          return Text("$error");
        },
        loading: () {
          return MaterialListSkeleton();
        },
      ),
    );
  }
}
