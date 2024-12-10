import 'package:flutter/material.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/services/nav.dart';

class MaterialListSkeleton extends StatelessWidget with CommonWidgets {
  MaterialListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Skeletonizer(
          enabled: true,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                dense: true,
                horizontalTitleGap: 0.0,
                minLeadingWidth: 0,
                child: ExpansionTile(
                  trailing: courseCompletePill(theme),
                  title: lessonName(
                      theme, 'লেসন ${index + 1} - বাংলা ভাষা ও সাহিত্য'),
                  children: [
                    for (int i = 0; i < 3; i++)
                      lessonItem(theme,
                          icon: Icons.abc,
                          itemName: "",
                          trailingIcon: Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 20,
                          ),
                          lessonName: 'রেকর্ড ক্লাস - ${i + 1}')
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
