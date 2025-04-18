import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/features/course/materials/test/view/test_view.dart';

import '../../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../../../core/configs/app_colors.dart';
import '../../../../../core/services/debouncer.dart';
import '../../../../../core/services/nav.dart';
import '../../../../../core/services/timer.dart';
import '../../../enrolled_course_landing/repository/enrolled_course_landing_repo.dart';
import '../repository/test_repo.dart';
import '../view/test_result_view.dart';
import '../viewmodel/get_test_by_id.dart';
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
  final List<Map<String, dynamic>> answerList = [];
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final testDetails = ref.read(writtenTestDetailsViewmodelProvider);
      testDetails.whenData((test) {
        for (var question in test.data!.questionList!) {
          answerList.add({
            "question_id": question.sId.toString(),
            "selectedOption": "null",
          });
        }

        final duration = Duration(minutes: test.data!.time!.toInt());
        ref.read(countdownProvider.notifier).initialize(duration);
        ref.read(countdownProvider.notifier).startTimer();
      });
    });
  }

  void updateAnswer(String questionId, String answer) {
    final index = answerList.indexWhere((item) => item["question_id"] == questionId);
    if (index != -1) {
      setState(() {
        answerList[index]["selectedOption"] = answer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final writtenTestDetailsAsync = ref.watch(writtenTestDetailsViewmodelProvider);
    final isLoading = ref.watch(_loadingProvider);

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
                              "বিষয় :",
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
                          onAnswerChange: updateAnswer,
                        );
                      },
                    ),
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : LongButton(
                      onPressed: () {
                        if (answerList.any((answer) => answer['selectedOption'].isNotEmpty)) {
                          _submitTest(test);
                        } else {
                          Fluttertoast.showToast(
                            msg: "You need to submit at least 1 answer.",
                          );
                        }
                      },
                      text: "সাবমিট করুন"
                  )
                ],
              );
            },
            error: (error, stackTrace) {
              print(error);
              print(stackTrace);
              return Text("Error: ${error.toString()}");
            },
            loading: () => const MockQuestionSkeleton(),
          )),
    );
  }

  Future<void> _submitTest(dynamic test) async {
    _debouncer.run(
      action: () async {
        print("Submitting answers: $answerList");
        ref.read(countdownProvider.notifier).stopTimer();

        final remainingTime = ref.read(countdownProvider).remainingTime.inSeconds;
        final totalTime = test.data!.time!.toInt() * 60;
        final timeTaken = totalTime - remainingTime;

        final payload = {
          "course_id": test.data!.courseId,
          "lesson_id": test.data!.lessonId?.sId,
          "test_id": test.data!.sId,
          "answers": answerList,
          "timeTaken": timeTaken,
        };

        print("payload : $payload");
        final response = await ref.read(testRepoProvider).submitWrittenTest(payload: payload);

        response.fold(
              (l) => Fluttertoast.showToast(msg: l.message),
              (testResult) => _navigateToCourse(),
        );
      },
      loadingController: ref.read(_loadingProvider.notifier),
    );
  }

  void _navigateToCourse() async {
    final markAsComplete = await ref
        .read(enrolledCourseLandingRepoProvider)
        .markAsComplete({
      "materialType": "test",
      "material_id": ref.read(getTestByIdProvider)
    });

    if(markAsComplete){
      Fluttertoast.showToast(msg: "Test submitted successfully");

      Nav().pushReplacement(const TestListView());
    }

  }
}