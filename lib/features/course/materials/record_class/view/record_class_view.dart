import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/materials/record_class/view/record_class_details_view.dart';
import 'package:prostuti/features/course/materials/record_class/viewmodel/record_class_viewmodel.dart';
import 'package:prostuti/features/course/materials/shared/widgets/material_list_skeleton.dart';
import 'package:prostuti/features/course/materials/shared/widgets/trailing_icon.dart';

import '../../shared/helper/functions.dart';

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

    return Scaffold(
      appBar: commonAppbar("রেকর্ড ক্লাস"),
      body: recordClassAsync.when(
        data: (recordClass) {
          return ListView.builder(
            itemCount: recordClass.length,
            itemBuilder: (context, index) {
              bool isItemComplete = true;

              return InkWell(
                onTap: () {
                  Nav().push(RecordClassDetailsView(
                    title:
                        'রেকর্ড ক্লাস: ${recordClass[index].recodeClassName} ',
                  ));
                },
                child: lessonItem(theme,
                    trailingIcon: TrailingIcon(
                      classDate: recordClass[index].classDate!,
                      isCompleted: isItemComplete,
                    ),
                    itemName:
                        "রেকর্ড ক্লাস: ${recordClass[index].recodeClassName}",
                    icon: Icons.video_collection_outlined,
                    lessonName: '${recordClass[index].lessonId!.number} '),
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
