import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/test/widgets/mcq_quiz_answer_widget.dart';
import 'package:prostuti/features/test/widgets/written_quiz_answer_widget.dart';
import '../../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../../../core/configs/app_colors.dart';
import '../../course/materials/test/widgets/mcq_mock_test_skeleton.dart';
import '../viewmodel/mock_quiz_result_viewmodel.dart';

class HybridMockQuizHistoryScreen extends ConsumerStatefulWidget {
  final String quizId;

  const HybridMockQuizHistoryScreen({
    super.key,
    required this.quizId,
  });

  @override
  MockQuizScreenState createState() => MockQuizScreenState();
}

class MockQuizScreenState extends ConsumerState<HybridMockQuizHistoryScreen>
    with CommonWidgets {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final mCQTestHistoryAsync =
        ref.watch(mockQuizResultViewmodelProvider(widget.quizId));

    return Scaffold(
      appBar: commonAppbar("টেস্ট"),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: mCQTestHistoryAsync.when(
            data: (test) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.onSecondary,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "টেস্ট টাইপ :",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onPrimary),
                            ),
                            Text(
                              "${test!.data!.type}",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onPrimary),
                            ),
                          ],
                        ),
                        const Gap(8),
                        // Points Earned
                        Text(
                          "আপনি MCQ অংশে ${test.data!.score ?? 0} পয়েন্ট পেয়েছেন",
                          style: theme.textTheme.titleSmall!
                              .copyWith(color: Colors.black),
                        ),
                        if (test.data!.isNegativeMarking == true) ...[
                          const Gap(4),
                          Text(
                            "(নেগেটিভ মার্কিং প্রযোজ্য)",
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        const Gap(24),
                        const Gap(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // MCQ Correct count
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xffA1F3A9),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset("assets/icons/correct.svg"),
                                  const Gap(4),
                                  Text(
                                    "${test.data!.rightScore}",
                                    style: theme.textTheme.titleMedium!.copyWith(
                                        color: const Color(0xff159021)),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            // MCQ Wrong count
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFC9C9),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset("assets/icons/wrong.svg"),
                                  const Gap(4),
                                  Text(
                                    "${test.data!.wrongScore}",
                                    style: theme.textTheme.titleMedium!.copyWith(
                                        color: const Color(0xffD60909)),
                                  ),
                                ],
                              ),
                            ),
                            // Skipped count not displayed for hybrid since calculating it relies on missing mcq scores vs missing written scores.
                            // However, we can display written submitted info if needed. For now, skipping displaying the third block.
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: test.data!.answers!.length,
                      itemBuilder: (context, index) {
                        final answer = test.data!.answers![index];
                        final questionType = answer.questionId?.type ?? 'MCQ';

                        if (questionType == 'Written') {
                          return WrittenQuizResultAnswerWidget(
                            questionNumber: index + 1,
                            theme: theme,
                            answerData: answer,
                            selectedOption: answer.selectedOption!,
                            correctOption: answer.questionId?.description ?? '',
                          );
                        } else {
                          // MCQ
                          return MCQQuizResultAnswerWidget(
                            questionNumber: index + 1,
                            theme: theme,
                            answerData: answer,
                            selectedOption: answer.selectedOption ?? 'null',
                            correctOption: answer.questionId?.correctOption ?? '',
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              print(error);
              print(stackTrace);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ফলাফল লোড করতে সমস্যা হয়েছে',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'দয়া করে আবার চেষ্টা করুন',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(
                              mockQuizResultViewmodelProvider(widget.quizId));
                        },
                        child: const Text('আবার চেষ্টা করুন'),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const MockQuestionSkeleton(),
          )),
    );
  }
}
