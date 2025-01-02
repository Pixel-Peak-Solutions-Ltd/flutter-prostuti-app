import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/features/course/materials/test/view/test_result_view.dart';

import '../../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../../../core/configs/app_colors.dart';
import '../../../../../core/services/nav.dart';
import '../../../../../core/services/timer.dart';
import '../repository/test_repo.dart';
import '../viewmodel/mcq_test_details_viewmodel.dart';
import '../widgets/build_mcq_question_item.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/mcq_mock_test_skeleton.dart';

class MCQMockTestScreen extends ConsumerStatefulWidget {
  const MCQMockTestScreen({Key? key}) : super(key: key);

  @override
  MockTestScreenState createState() => MockTestScreenState();
}

class MockTestScreenState extends ConsumerState<MCQMockTestScreen>
    with CommonWidgets {
  final Map<int, int?> selectedAnswers = {};
  final List<Map<String, dynamic>> answerList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final testDetails = ref.read(mCQTestDetailsViewmodelProvider);
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
    final mCQTestDetailsAsync = ref.watch(mCQTestDetailsViewmodelProvider);
/*    final countdownNotifier = ref.read(countdownProvider.notifier);
    final countdownState = ref.watch(countdownProvider);*/

    return Scaffold(
      appBar: commonAppbar("মক টেস্ট"),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: mCQTestDetailsAsync.when(
            data: (test) {
              // countdownNotifier.startTimer();
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
                        return MCQQuestionWidget(
                          questionNumber: index + 1,
                          theme: theme,
                          questionList: test.data!.questionList![index],
                          selectedAnswers: selectedAnswers,
                          answerList: answerList,
                        );
                      },
                    ),
                  ),
                  LongButton(
                      onPressed: () async {
                        ref.read(countdownProvider.notifier).stopTimer();

                        int remainingTime =
                            ref.read(countdownProvider).remainingTime.inSeconds;
                        int totalTime = test.data!.time!.toInt() * 60;
                        print(totalTime - remainingTime);

                        final payload = {
                          "course_id": test.data!.courseId,
                          "lesson_id": test.data!.lessonId!.sId,
                          "test_id": test.data!.sId,
                          "answers": answerList,
                          "timeTaken": 600
                        };

                        if (answerList.length !=
                            test.data!.questionList!.length) {
                          Fluttertoast.showToast(
                              msg: "Please ans all the question.");
                        } else {
                          final response = await ref
                              .read(testRepoProvider)
                              .submitMCQTest(payload: payload);

                          print(response);

                          response.fold(
                            (l) {
                              print(l.message);
                            },
                            (testResult) {
                              Nav().pushReplacement(TestResultScreen(
                                resultData: {
                                  "testTitle": test.data!.name,
                                  "scorePercentage":
                                      ((testResult.data!.rightScore!.toInt() /
                                                  testResult.data!.totalScore!
                                                      .toInt()) *
                                              100)
                                          .toInt(),
                                  "feedback": "চমৎকার",
                                  "pointsEarned":
                                      testResult.data!.score!.toInt(),
                                  "timeTaken": "২০ঃ২২",
                                  "correctAns": testResult.data!.rightScore,
                                  "wrongAns": testResult.data!.wrongScore,
                                  "skippedAns": 0,
                                },
                              ));
                            },
                          );
                        }
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
}
