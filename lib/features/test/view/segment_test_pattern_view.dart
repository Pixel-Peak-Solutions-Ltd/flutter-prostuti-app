import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/test/model/question_pattern_model.dart';
import 'package:prostuti/features/test/view/written_mock_quiz_screen.dart';
import '../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../common/widgets/long_button.dart';
import '../../../core/services/nav.dart';
import '../widgets/optional_subject_list.dart';
import '../widgets/question_pattern_list.dart';

import '../viewmodel/segment_quiz_viewmodel.dart';
import 'mcq_mock_quiz_view.dart';

class SegmentTestPatternView extends ConsumerStatefulWidget {
  final QuestionPattern pattern;

  const SegmentTestPatternView({super.key, required this.pattern});

  @override
  ConsumerState<SegmentTestPatternView> createState() =>
      _SegmentTestPatternViewState();
}

class _SegmentTestPatternViewState extends ConsumerState<SegmentTestPatternView>
    with CommonWidgets {
  final TextEditingController timeController = TextEditingController();
  final List<Subject> selectedOptionalSubjects = [];

  void _toggleOptionalSubject(Subject subject, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedOptionalSubjects.add(subject);
      } else {
        selectedOptionalSubjects
            .removeWhere((s) => s.subject == subject.subject);
      }
    });
  }

  Future<void> _startTest() async {
    final int time = int.tryParse(timeController.text.trim()) ?? 0;
    if (time <= 0) {
      _showValidationError("দয়া করে সময় দিন");
      return;
    }

    try {
      final parsedQuiz =
          await ref.read(segmentQuizViewmodelProvider.notifier).startTest(
                pattern: widget.pattern,
                selectedOptionalSubjects: selectedOptionalSubjects,
                time: time,
                context: context,
              );

      if (widget.pattern.questionType == "MCQ") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MCQMockQuizScreen(
              mockQuiz: parsedQuiz,
              isSegmentTest: true,
            ),
          ),
        );
      } else if (widget.pattern.questionType == "Written") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WrittenMockQuizScreen(
              mockQuiz: parsedQuiz,
              isSegmentTest: true,
            ),
          ),
        );
      }
    } catch (e) {
      _showValidationError("টেস্ট শুরু করতে সমস্যা হয়েছে: $e");
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }


  Widget _buildTimeDisplayField(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const Gap(8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Map<String, String> _getTimeComponents(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    return {
      'hours': hours.toString().padLeft(2, '0'),
      'minutes': minutes.toString().padLeft(2, '0'),
      'seconds': '00',
    };
  }

  @override
  Widget build(BuildContext context) {
    final vmState = ref.watch(segmentQuizViewmodelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("সেগমেন্ট টেস্ট"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: vmState.when(
          data: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "প্রশ্নের মান বন্টন",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const Gap(8),
              PatternSubjectList(subjects: widget.pattern.mainSubjects ?? []),
              const Gap(24),
              Text(
                "অপশনাল সাবজেক্ট",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const Gap(10),
              OptionalSubjectSelectorList(
                subjects: widget.pattern.optionalSubjects ?? [],
                onSelectionChanged: _toggleOptionalSubject,
              ),
              const Gap(10),
              Text(
                "সময়",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const Gap(16),
              Builder(
                builder: (context) {
                  final timeComponents = _getTimeComponents(widget.pattern.time ?? 0);
                  return Row(
                    children: [
                      _buildTimeDisplayField(timeComponents['hours']!, "ঘন্টা"),
                      const Gap(16),
                      _buildTimeDisplayField(timeComponents['minutes']!, "মিনিট"),
                      const Gap(16),
                      _buildTimeDisplayField(timeComponents['seconds']!, "সেকেন্ড"),
                    ],
                  );
                },
              ),
              const Gap(20),
              LongButton(
                onPressed: _startTest,
                text: vmState is AsyncLoading
                    ? "লোড হচ্ছে..."
                    : "টেস্ট শুরু করুন",
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) {
            print(error);
          },
        ),
      ),
    );
  }
}
