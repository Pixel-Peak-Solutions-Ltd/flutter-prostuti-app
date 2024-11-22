import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/course/materials/assignment/view/assignment_details_view.dart';

import '../../../../../core/services/nav.dart';

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
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: commonAppbar("এসাইনমেন্ট"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTileTheme(
              contentPadding: const EdgeInsets.all(0),
              dense: true,
              horizontalTitleGap: 0.0,
              minLeadingWidth: 0,
              child: ExpansionTile(
                trailing: isComplete ? courseCompletePill(theme) : Container(),
                title: lessonName(
                    theme, 'লেসন ${index + 1} - বাংলা ভাষা ও সাহিত্য'),
                children: [
                  for (int i = 0; i < 3; i++)
                    InkWell(
                      onTap: () {
                        Nav().push(AssignmentDetailsView(
                          title: 'এসাইনমেন্ট- ${i + 1}',
                        ));
                      },
                      child: lessonItem(theme,
                          isItemComplete: isItemComplete,
                          isToday: isToday,
                          lessonName: 'এসাইনমেন্ট - ${i + 1}'),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
