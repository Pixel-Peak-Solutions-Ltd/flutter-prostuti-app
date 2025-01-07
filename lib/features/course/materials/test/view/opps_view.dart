import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';

import '../../../../../common/widgets/long_button.dart';
import '../../../../../core/services/nav.dart';

class TestMissedView extends ConsumerWidget with CommonWidgets{
  String testName;

  TestMissedView({super.key, required this.testName});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: commonAppbar(testName),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/oops_image.png',
              height: 180,
              width: 270,
              fit: BoxFit.contain,
            ),
            const Gap(16),
            Text(
              'আপনি $testName মিস করেছেন পরবর্তীতে যথাসময়ে টেস্ট দিন ',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Gap(24),
            LongButton(
              onPressed: () {
                Nav().pop();
              },
              text: "টেস্ট মডিউলে ব্যাক করুন",
            ),
          ],
        ),
      ),
    );
  }
}
