import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/services/size_config.dart';
import '../view/enrolled_course_landing_view.dart';

class CourseLandingSkeleton extends StatelessWidget with CommonWidgets {
  CourseLandingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/welcome.png"),
              const Gap(10),
              Text(
                'আপনাকে স্বাগতম',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(24),
              Text(
                'আপনি আমাদের কোর্সে যোগদান করেছেন! মূল ক্লাস শুরু হওয়ার আগে, আপনি কোর্সের সাথে সম্পর্কিত ব্লগ, নিবন্ধ, ভিডিও ইত্যাদি অনুশীলন এবং পড়া শুরু করতে পারেন, যা আপনাকে আরও প্রোগ্রামে সহায়তা করবে',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(24),
              Text(
                'মডিউল সমূহ',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(24),
              SizedBox(
                height: SizeConfig.h(280),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: GridItem.values.length,
                  itemBuilder: (context, index) {
                    final item = GridItem.values[index];
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300)),
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset(
                                item.image,
                                scale: 0.9,
                              ),
                              const Gap(6),
                              Text(
                                'item.title',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(24),
              Text(
                'কোর্স কারিকুলাম',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              for (int i = 0; i < 3; i++)
                ListTileTheme(
                  contentPadding: const EdgeInsets.all(0),
                  dense: true,
                  horizontalTitleGap: 0.0,
                  minLeadingWidth: 0,
                  child: ExpansionTile(
                    trailing: Container(),
                    title: Text('লেসন ${i + 1} - বাংলা ভাষা ও সাহিত্য'),
                    children: [
                      for (int i = 0; i < 3; i++)
                        lessonItem(Theme.of(context),
                            trailingIcon: const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 20,
                            ),
                            itemName: "েকর্ড ক্লাস - ${i + 1}",
                            icon: "assets/icons/resource.svg",
                            lessonName: 'Lesson - ${i + 1}')
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
