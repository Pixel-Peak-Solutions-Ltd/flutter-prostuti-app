import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/materials/record_class/view/record_class_details_view.dart';
import 'package:prostuti/features/course/materials/record_class/viewmodel/get_record_class_id.dart';
import 'package:prostuti/features/course/materials/record_class/viewmodel/record_class_viewmodel.dart';
import 'package:prostuti/features/course/materials/shared/widgets/material_list_skeleton.dart';
import 'package:prostuti/features/course/materials/shared/widgets/trailing_icon.dart';

import '../../../course_list/viewmodel/get_course_by_id.dart';
import '../../get_material_completion.dart';

class RecordClassView extends ConsumerStatefulWidget {
  const RecordClassView({super.key});

  @override
  RecordClassViewState createState() => RecordClassViewState();
}

class RecordClassViewState extends ConsumerState<RecordClassView>
    with CommonWidgets {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final recordClassAsync = ref.watch(recordClassViewmodelProvider);
    final courseId = ref.read(getCourseByIdProvider);
    final completedAsync = ref.watch(completedIdProvider(courseId));

    return Scaffold(
      appBar: commonAppbar("রেকর্ড ক্লাস"),
      body: recordClassAsync.when(
        data: (recordClass) {
          return completedAsync.when(
            data: (completedId) {
              final completedSet = Set<String>.from(completedId);

              return ListView.builder(
                itemCount: recordClass.length,
                itemBuilder: (context, index) {
                  final isCompleted =
                      completedSet.contains(recordClass[index].sId);

                  return InkWell(
                    onTap: () {
                      DateTime parsedDate =
                          DateTime.parse(recordClass[index].classDate!);
                      DateTime now = DateTime.now();
                      if ((parsedDate.day == now.day &&
                              parsedDate.month == now.month &&
                              parsedDate.year == now.year) ||
                          (parsedDate.isBefore(now))) {
                        ref
                            .watch(getRecordClassIdProvider.notifier)
                            .setRecordClassId(recordClass[index].sId!);
                        Nav().push(RecordClassDetailsView(
                          videoUrl: recordClass[index].classVideoURL!.path!,
                          isCompleted: isCompleted,
                        ));

                        ref.read(completedIdProvider(courseId));
                      }
                    },
                    child: lessonItem(theme,
                        trailingIcon: TrailingIcon(
                          classDate: recordClass[index].classDate!,
                          isCompleted: isCompleted,
                        ),
                        itemName: "${recordClass[index].recodeClassName}",
                        icon: Icons.video_collection_rounded,
                        lessonName: '${recordClass[index].lessonId!.number} '),
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
