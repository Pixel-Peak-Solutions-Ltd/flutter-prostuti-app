import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/features/test/repository/mock_test_repo.dart';
import 'package:prostuti/features/test/view/hybrid_mock_quiz_history_screen.dart';
import '../../../core/services/debouncer.dart';
import '../../../core/services/nav.dart';
import '../../../core/services/timer.dart';
import '../../course/materials/test/widgets/build_mcq_question_item.dart';
import '../../course/materials/test/widgets/countdown_timer.dart';
import '../model/mock_quiz_model.dart';

class HybridMockQuizScreen extends ConsumerStatefulWidget {
  final MockQuizResponse mockQuiz;
  final bool isSegmentTest;

  const HybridMockQuizScreen({
    super.key,
    required this.mockQuiz,
    this.isSegmentTest = false,
  });

  @override
  ConsumerState<HybridMockQuizScreen> createState() =>
      _HybridMockQuizScreenState();
}

class _HybridMockQuizScreenState extends ConsumerState<HybridMockQuizScreen>
    with CommonWidgets {
  final Map<int, int?> selectedAnswers = {};
  final List<Map<String, dynamic>> answerList = [];
  late int remainingTime;
  late final int totalQuestions;
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
    remainingTime = widget.mockQuiz.data?.time ?? 0;
    totalQuestions = widget.mockQuiz.data?.questions!.length ?? 0;

    final questions = widget.mockQuiz.data?.questions ?? [];
    answerList.clear();
    for (var question in questions) {
      answerList.add({
        "question_id": question.sId,
        "selectedOption": "null",
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize and start the countdown timer
      final duration = Duration(minutes: remainingTime);
      ref.read(countdownProvider.notifier).initialize(duration);
      ref.read(countdownProvider.notifier).startTimer();
    });
  }

  void updateAnswer(String questionId, String answer) {
    if (answer.isEmpty) answer = "null"; // Match 'null' default for empty answers
    final index =
        answerList.indexWhere((item) => item["question_id"] == questionId);
    if (index != -1) {
      setState(() {
        answerList[index]["selectedOption"] = answer;
      });
    }
  }

  Future<void> _submitAnswers() async {
    _debouncer.run(
      action: () async {
        ref.read(countdownProvider.notifier).stopTimer();

        final remainingTime = ref.read(countdownProvider).remainingTime.inSeconds;
        final totalTime = widget.mockQuiz.data!.time!.toInt() * 60;
        final timeTaken = totalTime - remainingTime;

        final payload = {
          "answers": answerList,
        };

        final response = await ref.read(mockTestRepoProvider).submitMockQuiz(
              quizId: widget.mockQuiz.data!.id!,
              payload: payload,
              isSegmentTest: widget.isSegmentTest,
            );

        response.fold(
          (l) => Fluttertoast.showToast(msg: l.message),
          (testResult) => Nav().pushReplacement(
            HybridMockQuizHistoryScreen(
              quizId: widget.mockQuiz.data!.id!,
            ),
          ),
        );
      },
      loadingController: ref.read(_loadingProvider.notifier),
    );
  }

  Widget _buildHybridWrittenQuestion(int index, dynamic question) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.onPrimary,
            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (question.hasImage == true && question.image != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(
                    question.image!.path!,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Image not available');
                    },
                  ),
                ),
              Text(
                "${index + 1}. ${question.title}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (val) {
                   updateAnswer(question.sId.toString(), val);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Write your answer here...",
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 8,
              ),
            ],
          ),
        ),
        const Gap(24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: commonAppbar("Hybrid Mock Test"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test Info Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.onSecondary,
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("টেস্ট টাইপ :",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                      Text(" ${widget.mockQuiz.data?.questionType}",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    "প্রতিটি MCQ প্রশ্নে 1 পয়েন্ট থাকে এবং প্রতিটি ভুল উত্তরের জন্য \n0.5 পয়েন্ট কাটা হবে।",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Gap(16),
            CountdownTimer(
              onTimeUp: _submitAnswers,
            ),
            const Gap(16),
            // Questions List
            Expanded(
              child: ListView.builder(
                itemCount: widget.mockQuiz.data?.questions!.length,
                itemBuilder: (context, index) {
                  final question = widget.mockQuiz.data!.questions![index];
                  if (question.type == "Written") {
                    return _buildHybridWrittenQuestion(index, question);
                  } else {
                    return MCQQuestionWidget(
                      questionNumber: index + 1,
                      theme: theme,
                      questionList: question,
                      selectedAnswers: selectedAnswers,
                      answerList: answerList,
                      isTestify: true,
                    );
                  }
                },
              ),
            ),
            const Gap(12),
            LongButton(
              onPressed: _submitAnswers,
              text: "সাবমিট করুন",
            ),
            const Gap(12),
          ],
        ),
      ),
    );
  }
}
