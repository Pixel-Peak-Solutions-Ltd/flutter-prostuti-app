import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/test/widgets/mcq_quiz_answer_widget.dart';
import '../../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../../../core/configs/app_colors.dart';
import '../../course/materials/test/widgets/mcq_mock_test_skeleton.dart';
import '../viewmodel/mock_quiz_result_viewmodel.dart';

class MCQMockQuizHistoryScreen extends ConsumerStatefulWidget {
  final String quizId;

  const MCQMockQuizHistoryScreen({
    super.key,
    required this.quizId,
  });

  @override
  MockQuizScreenState createState() => MockQuizScreenState();
}

class MockQuizScreenState extends ConsumerState<MCQMockQuizHistoryScreen>
    with CommonWidgets {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final mCQTestHistoryAsync =ref.watch(mockQuizResultViewmodelProvider(widget.quizId));

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
                      border:
                          Border.all(color: Theme.of(context).colorScheme.onPrimary),
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
                          "আপনি ${test.data!.score ?? 0} পয়েন্ট পেয়েছেন",
                          style: theme.textTheme.titleSmall!.copyWith(color: Colors.black),
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
                        /*// Time Taken
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
                              "সময় নিয়েছেন ${Func.timeConverterSecToMin(test.data!.timeTaken ?? 00)} মিনিট",
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),*/
                        const Gap(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xffA1F3A9),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset("assets/icons/correct.svg"),
                                  const Gap(4),
                                  Text(
                                    "${test.data!.rightScore}",
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(
                                            color: const Color(0xff159021)),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFC9C9),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset("assets/icons/wrong.svg"),
                                  const Gap(4),
                                  Text(
                                    "${test.data!.wrongScore}",
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(
                                            color: const Color(0xffD60909)),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xffFDD489),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                      "assets/icons/skiped_qus.svg"),
                                  const Gap(4),
                                  Text(
                                    "${test.data!.totalScore! - (test.data!.rightScore!.toInt() + test.data!.wrongScore!.toInt())}",
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(
                                            color: const Color(0xffC9860D)),
                                  ),
                                ],
                              ),
                            ),
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
                        return MCQQuizResultAnswerWidget(
                          questionNumber: index + 1,
                          theme: theme,
                          answerData: test.data!.answers![index],
                          selectedOption:
                              test.data!.answers![index].selectedOption!,
                          correctOption: test
                              .data!.answers![index].questionId!.correctOption!,
                        );
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
                          ref.invalidate(mockQuizResultViewmodelProvider(widget.quizId));
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
