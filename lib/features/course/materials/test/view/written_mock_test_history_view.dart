import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/course/materials/test/viewmodel/get_written_test_history.dart';

import '../../../../../common/helpers/func.dart';
import '../../../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../../../core/configs/app_colors.dart';
import '../widgets/mcq_mock_test_skeleton.dart';
import '../widgets/written_answer_widget.dart';

class WrittenMockTestHistoryScreen extends ConsumerStatefulWidget {
  const WrittenMockTestHistoryScreen({super.key});

  @override
  MockTestScreenState createState() => MockTestScreenState();
}

class MockTestScreenState extends ConsumerState<WrittenMockTestHistoryScreen>
    with CommonWidgets {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final writtenTestHistoryAsync = ref.watch(getWrittenTestHistoryProvider);

    return Scaffold(
      appBar: commonAppbar("মক টেস্ট"),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: writtenTestHistoryAsync.when(
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
                              "${test.data!.testId!.name}",
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
                              "${test.data!.testId!.type}",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.borderFocusPrimaryLight),
                            ),
                          ],
                        ),const Gap(8),
                        // Points Earned
                        Text(
                          "আপনি ${test.data!.score ?? 0} পয়েন্ট পেয়েছেন",
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
                              "সময় নিয়েছেন ${Func.timeConverterSecToMin(test.data!.timeTaken?? 00)} মিনিট",
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
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
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(color: const Color(0xff159021)),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
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
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(color: const Color(0xffD60909)),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xffFDD489),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset("assets/icons/skiped_qus.svg"),
                                  const Gap(4),
                                  Text(
                                    "${test.data!.totalScore!-(test.data!.rightScore!.toInt()+test.data!.wrongScore!.toInt())}",
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(color: const Color(0xffC9860D)),
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
                        return WrittenResultAnswerWidget(
                          questionNumber: index + 1,
                          theme: theme,
                          answerData: test.data!.answers![index],
                          selectedOption: test.data!.answers![index].selectedOption!,
                          correctOption: test.data!.answers![index].questionId!.description!,
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
            },
            loading: () => const MockQuestionSkeleton(),
          )),
    );
  }
}
