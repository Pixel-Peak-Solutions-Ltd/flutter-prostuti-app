import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../core/services/nav.dart';
import '../../../core/services/size_config.dart';
import '../../course/course_list/view/course_list_view.dart';
import '../../home_screen/view/home_screen_view.dart';

class PaymetSuccessful extends StatelessWidget {
  const PaymetSuccessful({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 250,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                Nav().pushReplacement(HomeScreen());
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xff2970FF),
                  fixedSize: Size(SizeConfig.w(356), SizeConfig.h(54))),
              child: Text(
                'হোমস্ক্রিনে ফেরত যান',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            const Gap(12),
            ElevatedButton(
              onPressed: () async {
                Nav().pushReplacement(CourseListView());
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(color: Color(0xff155EEF), width: 3),
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xffD1E0FF),
                  fixedSize: Size(SizeConfig.w(356), SizeConfig.h(54))),
              child: Text(
                'আরও কোর্স এক্সপ্লোর করুন',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: const Color(0xff2970FF),
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/success_tick.svg",
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                const Gap(16),
                Text(
                  textAlign: TextAlign.center,
                  'আপনার পেমেন্ট সফল হয়েছে',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(16),
                Text(
                  textAlign: TextAlign.center,
                  'সাবস্ক্রাইব্ড ইউজার পছন্দের কোর্স গুলো এনরোল করতে পারবেন',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const Gap(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
