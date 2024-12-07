import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/materials/record_class/view/record_class_details_view.dart';
import 'package:prostuti/features/course/materials/record_class/viewmodel/record_class_viewmodel.dart';
import 'package:prostuti/features/course/materials/shared/widgets/material_list_skeleton.dart';

class RecordClassView extends ConsumerStatefulWidget {
  const RecordClassView({super.key});

  @override
  RecordClassViewState createState() => RecordClassViewState();
}

class RecordClassViewState extends ConsumerState<RecordClassView>
    with CommonWidgets {
  bool isToday = true;
  bool isComplete = true;
  bool isItemComplete = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final recordClassAsync = ref.watch(recordClassViewmodelProvider);

    return Scaffold(
      appBar: commonAppbar("রেকর্ড ক্লাস"),
      body: recordClassAsync.when(
        data: (recordClass) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: recordClass.length,
              itemBuilder: (context, index) {
                return ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  dense: true,
                  horizontalTitleGap: 0.0,
                  minLeadingWidth: 0,
                  child: ExpansionTile(
                    trailing:
                        isComplete ? courseCompletePill(theme) : Container(),
                    title: lessonName(theme,
                        '${recordClass[index].lessonId!.number}: ${recordClass[index].lessonId!.name}'),
                    children: [
                      for (int i = 0;
                          i < recordClass[index].classVideoURL!.length;
                          i++)
                        InkWell(
                          onTap: () {
                            Nav().push(RecordClassDetailsView(
                              title:
                                  'রেকর্ড ক্লাস: ${recordClass[index].recodeClassName} ${i + 1}',
                            ));
                          },
                          child: lessonItem(theme,
                              isItemComplete: isItemComplete,
                              isToday: isToday,
                              lessonName:
                                  'রেকর্ড ক্লাস: ${recordClass[index].recodeClassName} ${i + 1}'),
                        )
                    ],
                  ),
                );
              },
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
