import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/course/materials/assignment/view/assignment_details_view.dart';
import 'package:prostuti/features/course/materials/assignment/viewmodel/assignment_viewmodel.dart';
import 'package:prostuti/features/course/materials/assignment/viewmodel/get_assignment_by_id.dart';

import '../../../../../core/services/nav.dart';
import '../../shared/widgets/material_list_skeleton.dart';
import '../../shared/widgets/trailing_icon.dart';

class AssignmentView extends ConsumerStatefulWidget {
  const AssignmentView({Key? key}) : super(key: key);

  @override
  AssignmentViewState createState() => AssignmentViewState();
}

class AssignmentViewState extends ConsumerState<AssignmentView>
    with CommonWidgets {
  bool isToday = true;
  bool isComplete = true;
  bool isItemComplete = false;

  @override
  Widget build(BuildContext context) {
    final assignmentListAsync = ref.watch(assignmentViewmodelProvider);

    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: commonAppbar("এসাইনমেন্ট"),
      body: assignmentListAsync.when(
        data: (assignment) {
          return ListView.builder(
            itemCount: assignment.length,
            itemBuilder: (context, index) {
              bool isItemComplete = true;

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
                    Nav().push(const AssignmentDetailsView());
                  }
                },
                child: lessonItem(theme,
                    trailingIcon: TrailingIcon(
                      classDate: assignment[index].unlockDate!,
                      isCompleted: isItemComplete,
                    ),
                    itemName: "${assignment[index].assignmentNo}",
                    icon: Icons.video_collection_rounded,
                    lessonName: '${assignment[index].lessonId!.number} '),
              );
            },
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
