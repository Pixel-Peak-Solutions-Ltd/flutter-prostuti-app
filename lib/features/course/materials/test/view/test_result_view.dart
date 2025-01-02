import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import '../../../../../core/configs/app_colors.dart';
import '../../../../../core/services/nav.dart';

class TestResultScreen extends ConsumerWidget with CommonWidgets {
  final Map<String, dynamic> resultData;

  TestResultScreen({
    Key? key,
    required this.resultData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: commonAppbar(resultData['testTitle']),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score Percentage
              Text(
                "আপনি অর্জন করেছেন",
                style: theme.textTheme.titleMedium,
              ),
              const Gap(8),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: (resultData['scorePercentage'] ?? 0) / 100.0,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "${translateToBengaliNumber(resultData['scorePercentage'] ?? 0)}%",
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: Colors.blue,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),

              const Gap(16),
              // Feedback
              Text(
                resultData['feedback'] ?? "চমৎকার",
                style: theme.textTheme.titleMedium,
              ),
              const Gap(8),
              // Points Earned
              Text(
                "আপনি ${translateToBengaliNumber(resultData['pointsEarned'] ?? 0)} পয়েন্ট পেয়েছেন",
                style: theme.textTheme.titleSmall,
              ),
              const Gap(24),
              // Time Taken
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/watch.svg",
                    width: 20,
                    height: 20,
                    color: Colors.black,
                  ),
                  const Gap(8),
                  Text(
                    "সময় নিয়েছেন ${resultData['timeTaken'] ?? "০০ঃ০০"}",
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                    decoration: BoxDecoration(color: const Color(0xffA1F3A9),borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset("assets/icons/correct.svg"),
                        const Gap(4),
                        Text(
                          "${resultData["correctAns"]}",
                          style: theme.textTheme.titleMedium!.copyWith(color: const Color(0xff159021)),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                    decoration: BoxDecoration(color: const Color(0xffFFC9C9),borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset("assets/icons/wrong.svg"),
                        const Gap(4),
                        Text(
                          "${resultData["wrongAns"]}",
                          style: theme.textTheme.titleMedium!.copyWith(color: const Color(0xffD60909)),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                    decoration: BoxDecoration(color: const Color(0xffFDD489),borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset("assets/icons/skiped_qus.svg"),
                        const Gap(4),
                        Text(
                          "${resultData["skippedAns"]}",
                          style: theme.textTheme.titleMedium!.copyWith(color: const Color(0xffC9860D)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Column(
                children: [
                  LongButton(
                    onPressed: () {
                      // Handle view full results
                    },
                    text: "সম্পূর্ণ ফলাফল দেখুন",
                  ),
                  const Gap(16),
                  LongButton(
                    onPressed: () {
                      Nav().pop();
                    },
                    text: "টেস্ট মডিউলে ব্যাক করুন",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String translateToBengaliNumber(int number) {
    const bengaliDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number
        .toString()
        .split('')
        .map((digit) => bengaliDigits[int.parse(digit)])
        .join();
  }
}
