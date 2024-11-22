import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/materials/assignment/view/assignment_view.dart';
import 'package:prostuti/features/course/materials/record_class/view/record_class_view.dart';
import 'package:prostuti/features/course/materials/resources/view/resources_view.dart';

enum GridItem {
  recordedClass("assets/icons/video.png", "রেকর্ড ক্লাস"),
  resource("assets/icons/resource.png", "রিসোর্স"),
  test("assets/icons/test.png", "টেস্ট"),
  assignment("assets/icons/assignment.png", "এসাইনমেন্ট"),
  routine("assets/icons/routine.png", "রুটিন"),
  reportCard("assets/icons/report.png", "রিপোর্ট কার্ড"),
  leaderboard("assets/icons/learderboard.png", "লিডারবোর্ড"),
  notice("assets/icons/notice.png", "নোটিশ");

  final String image;
  final String title;

  const GridItem(this.image, this.title);
}

class EnrolledCourseLandingView extends ConsumerStatefulWidget {
  const EnrolledCourseLandingView({super.key});

  @override
  EnrolledCourseLandingViewState createState() =>
      EnrolledCourseLandingViewState();
}

class EnrolledCourseLandingViewState
    extends ConsumerState<EnrolledCourseLandingView> with CommonWidgets {
  bool isToday = true;
  bool isComplete = true;
  bool isItemComplete = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: commonAppbar("BCS ফাইনাল প্রিলি প্রিপারেশন"),
      body: Padding(
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
                      onTap: () {
                        switch (item) {
                          case GridItem.recordedClass:
                            Nav().push(const RecordClassView());
                          case GridItem.resource:
                            Nav().push(const ResourcesView());
                          case GridItem.assignment:
                            Nav().push(const AssignmentView());
                          case GridItem.test:
                          // TODO: Handle this case.
                          case GridItem.routine:
                          // TODO: Handle this case.
                          case GridItem.reportCard:
                          // TODO: Handle this case.
                          case GridItem.leaderboard:
                          // TODO: Handle this case.
                          case GridItem.notice:
                          // TODO: Handle this case.
                        }
                      },
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
                                item.title,
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
                    trailing:
                        isComplete ? courseCompletePill(theme) : Container(),
                    title: lessonName(
                        theme, 'লেসন ${i + 1} - বাংলা ভাষা ও সাহিত্য'),
                    children: [
                      for (int i = 0; i < 3; i++)
                        lessonItem(theme,
                            isItemComplete: isItemComplete,
                            isToday: isToday,
                            lessonName: 'রেকর্ড ক্লাস - ${i + 1}')
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
