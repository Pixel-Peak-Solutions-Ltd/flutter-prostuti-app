import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';

import '../../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../../../core/configs/app_colors.dart';
import '../../../../../core/services/timer.dart';
import '../viewmodel/written_test_details_viewmodel.dart';
import '../widgets/build_written_question_item.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/mcq_mock_test_skeleton.dart';

class WrittenMockTestScreen extends ConsumerStatefulWidget {
  const WrittenMockTestScreen({Key? key}) : super(key: key);

  @override
  MockTestScreenState createState() => MockTestScreenState();
}

class MockTestScreenState extends ConsumerState<WrittenMockTestScreen>
    with CommonWidgets {
  final Map<int, int?> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final testDetails = ref.read(writtenTestDetailsViewmodelProvider);
      testDetails.whenData((test) {
        final duration = Duration(minutes: test.data!.time!.toInt());
        ref.read(countdownProvider.notifier).initialize(duration);
        ref.read(countdownProvider.notifier).startTimer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final writtenTestDetailsAsync =
        ref.watch(writtenTestDetailsViewmodelProvider);

    return Scaffold(
      appBar: commonAppbar("মক টেস্ট"),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: writtenTestDetailsAsync.when(
            data: (test) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.shadeSecondaryLight,
                      border:
                          Border.all(color: AppColors.borderFocusPrimaryLight),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "বিষয় :",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.borderFocusPrimaryLight),
                            ),
                            Text(
                              "${test.data!.name}",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.borderFocusPrimaryLight),
                            ),
                          ],
                        ),
                        const Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "টেস্ট টাইপ :",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.borderFocusPrimaryLight),
                            ),
                            Text(
                              "${test.data!.type}",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.borderFocusPrimaryLight),
                            ),
                          ],
                        ),
                        const Gap(8),
                        Text(
                          "প্রতিটি প্রশ্নে 1 পয়েন্ট থাকে এবং প্রতিটি ভুল উত্তরের জন্য \n0.5 পয়েন্ট কাটা হবে।",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  CountdownTimer(),
                  const Gap(24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: test.data!.questionList!.length,
                      itemBuilder: (context, index) {
                        return WrittenQuestionWidget(
                          questionNumber: index + 1,
                          theme: theme,
                          questionList: test.data!.questionList![index],
                        );
                      },
                    ),
                  ),
                  LongButton(
                      onPressed: () {
                        print("Selected Answers: $selectedAnswers");
                        checkCorrectAns();
                      },
                      text: "সাবমিট করুন")
                ],
              );
            },
            error: (error, stackTrace) {
              print(error);
              print(stackTrace);
            },
            loading: () => const MockQuestionSkeleton(),
          )),
    );
  }

  void checkCorrectAns() {}
}
