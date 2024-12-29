import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/configs/app_colors.dart';
import '../model/mcq_test_details_model.dart';

class MCQQuestionWidget extends StatefulWidget {
  final int questionNumber;
  final ThemeData theme;
  final QuestionList questionList;
  final Map<int, int?> selectedAnswers; 

  const MCQQuestionWidget({
    Key? key,
    required this.questionNumber,
    required this.theme,
    required this.questionList,
    required this.selectedAnswers,
  }) : super(key: key);

  @override
  State<MCQQuestionWidget> createState() => _MCQQuestionWidgetState();
}

class _MCQQuestionWidgetState extends State<MCQQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    final ansOption = ["ক", "খ", "গ", "ঘ"];
    int? selectedOption = widget.selectedAnswers[widget.questionNumber];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.textActionPrimaryLight,
            border: Border.all(color: AppColors.shadeNeutralLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.questionNumber}. ${widget.questionList.title}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: List.generate(4, (index) {
                  return RadioListTile<int>(
                    value: index,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        widget.selectedAnswers[widget.questionNumber] = value;
                      });
                    },
                    title: Text(
                      "${ansOption[index]}. ${widget.questionList.options![index]}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const Gap(24),
      ],
    );
  }
}
