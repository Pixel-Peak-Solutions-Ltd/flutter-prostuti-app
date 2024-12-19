import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/course_list/view/course_list_view.dart';
import 'package:prostuti/features/payment/widgets/course_name_price.dart';
import 'package:prostuti/features/payment/widgets/price_row.dart';

import '../../../core/services/size_config.dart';
import '../../course/course_list/viewmodel/course_list_viewmodel.dart';
import '../widgets/stepper.dart';

class PaymentView extends ConsumerWidget with CommonWidgets {
  final String id, name, imgPath, price;

  PaymentView({
    super.key,
    required this.id,
    required this.name,
    required this.imgPath,
    required this.price,
  });

  @override
  Widget build(BuildContext context, ref) {
    final publishedCourseNotifier = ref.watch(publishedCourseProvider.notifier);

    return Scaffold(
      appBar: commonAppbar("Cart"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Tracker(),
              const Gap(24),
              const Divider(),
              const Gap(24),
              CourseNamePrice(name: name, imgPath: imgPath, price: "৳ $price"),
              const Gap(24),
              const Divider(),
              const Gap(24),
              Text(
                'আরেকটি কোর্স যোগ করুন',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              SizedBox(
                height: SizeConfig.h(100),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: publishedCourseNotifier.filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course =
                        publishedCourseNotifier.filteredCourses[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                course.image!.path!,
                                height: SizeConfig.h(50),
                                width: SizeConfig.w(80),
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(
                                  id == course.sId!
                                      ? Icons.check_circle
                                      : Icons.add_box,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                        const Gap(16),
                        SizedBox(
                          width: SizeConfig.w(80),
                          child: Text(
                            course.name!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Gap(16),
              TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                onPressed: () {
                  Nav().push(CourseListView());
                },
                child: Text(
                  'আরো কোর্স দেখুন',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
              const Gap(24),
              Text(
                'হিসাবের বিস্তারিত',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("সর্বমোট",
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    "৳ $price",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              Gap(16),
              PriceRow(
                price: price,
                name: name,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          height: SizeConfig.h(60),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  backgroundColor: Color(0xff2970FF),
                  fixedSize: Size(SizeConfig.w(356), SizeConfig.h(54))),
              child: Text(
                'পেমেন্ট পর্যালোচনা করুন',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
