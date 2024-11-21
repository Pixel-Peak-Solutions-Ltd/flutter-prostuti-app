import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/materials/record_class/view/record_class_details_view.dart';

class RecordClassView extends ConsumerWidget with CommonWidgets {
  RecordClassView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: commonAppbar("রেকর্ড ক্লাস"),
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
                title: Text(
                  'লেসন ${index + 1} - বাংলা ভাষা ও সাহিত্য',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                children: [
                  for (int i = 0; i < 3; i++)
                    InkWell(
                      onTap: () {
                        Nav().push(RecordClassDetailsView(
                          title: 'রেকর্ড ক্লাস - $i',
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16)
                            .copyWith(top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.video_collection_outlined,
                                  size: 18,
                                ),
                                const Gap(8),
                                Text(
                                  'রেকর্ড ক্লাস - $i',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.lock_clock_outlined,
                              size: 18,
                            )
                          ],
                        ),
                      ),
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
