import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/features/course/materials/resources/view/resource_details_view.dart';

import '../../../../../core/services/nav.dart';
import '../../record_class/view/record_class_details_view.dart';

class ResourcesView extends ConsumerStatefulWidget {
  const ResourcesView({super.key});

  @override
  ResourcesViewState createState() => ResourcesViewState();
}

class ResourcesViewState extends ConsumerState<ResourcesView>
    with CommonWidgets {
  bool isToday = true;
  bool isComplete = true;
  bool isItemComplete = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: commonAppbar("রিসোর্স"),
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
                        Nav().push(ResourceDetailsView(
                          title: 'রিসোর্স - ${i + 1}',
                        ));
                      },
                      child: lessonItem(theme,
                          trailingIcon: Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 20,
                          ),
                          icon: Icons.picture_as_pdf,
                          itemName: "রিসোর্স - ${i + 1}",
                          lessonName: 'Lesson - ${i + 1}'),
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
