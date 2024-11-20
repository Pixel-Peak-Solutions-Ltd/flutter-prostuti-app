import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/size_config.dart';

class EnrolledCourseLandingView extends ConsumerWidget with CommonWidgets {
  EnrolledCourseLandingView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    List<Map<String, String>> gridDetails = [
      {"image": "assets/icons/video.png", "title": "রেকর্ড ক্লাস"},
      {"image": "assets/icons/resource.png", "title": "রিসোর্স"},
      {"image": "assets/icons/test.png", "title": "টেস্ট"},
      {"image": "assets/icons/assignment.png", "title": "এসাইনমেন্ট"},
      {"image": "assets/icons/routine.png", "title": "রুটিন"},
      {"image": "assets/icons/report.png", "title": "রিপোর্ট কার্ড"},
      {"image": "assets/icons/learderboard.png", "title": "লিডারবোর্ড"},
      {"image": "assets/icons/notice.png", "title": "নোটিশ"},
    ];

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
                  itemCount: 8,
                  itemBuilder: (context, index) {
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
                                gridDetails[index]["image"].toString(),
                                scale: 0.9,
                              ),
                              const Gap(6),
                              Text(
                                gridDetails[index]["title"].toString(),
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
                    title: Text(
                      'লেসন ০১ - বাংলা ভাষা ও সাহিত্য',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
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
                                  RichText(
                                    text: TextSpan(
                                      text: 'রেকর্ড ক্লাস - ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w700),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'সন্ধি ও সমার্থক শব্দ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Icon(
                                Icons.lock_clock_outlined,
                                size: 18,
                              )
                            ],
                          ),
                        )
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
