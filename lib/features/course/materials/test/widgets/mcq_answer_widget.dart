import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/features/course/materials/test/model/test_history_model.dart';
import '../../../../../core/configs/app_colors.dart';
import '../model/mcq_test_details_model.dart';
import 'explanation_widget.dart';

class MCQResultAnswerWidget extends StatefulWidget {
  final int questionNumber;
  final ThemeData theme;
  final Answers answerData;
  final String selectedOption;
  final String correctOption;

  const MCQResultAnswerWidget({
    Key? key,
    required this.questionNumber,
    required this.answerData,
    required this.selectedOption,
    required this.correctOption,
    required this.theme,
  }) : super(key: key);

  @override
  State<MCQResultAnswerWidget> createState() => _MCQResultAnswerWidgetState();
}

class _MCQResultAnswerWidgetState extends State<MCQResultAnswerWidget> {
  @override
  Widget build(BuildContext context) {
    final ansOption = ["ক", "খ", "গ", "ঘ"];
    final theme = Theme.of(context);
    bool isExplanationVisible = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              if (widget.answerData.questionId!.hasImage == true &&
                  widget.answerData.questionId!.image != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(
                    widget.answerData.questionId!.image!.path!,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Image not available');
                    },
                  ),
                ),
              // Question Title
              Text(
                "${widget.questionNumber}. ${widget.answerData.questionId!.title} (1 Point)",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Options
              Column(
                children: List.generate(4, (index) {
                  final optionText = widget.answerData.questionId!.options![index];
                  bool isSelected = optionText == widget.selectedOption;
                  bool isCorrect = optionText == widget.correctOption;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isCorrect
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1))
                          : (isCorrect
                              ? Colors.green.withOpacity(0.1)
                              : Colors.white),
                      border: Border.all(
                        color: isCorrect
                            ? Colors.green
                            : (isSelected ? Colors.red : Colors.grey.shade300),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? (isCorrect ? Colors.green : Colors.red)
                                : (isCorrect
                                    ? Colors.green
                                    : Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              ansOption[index],
                              style: TextStyle(
                                color: isSelected || isCorrect
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            optionText,
                            style: TextStyle(
                              fontSize: 14,
                              color: isCorrect
                                  ? Colors.green
                                  : (isSelected ? Colors.red : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              // Explanation Button
              ExplanationWidget(explanation: widget.answerData.questionId!.description),
            ],
          ),
        ),
        const Gap(24),
      ],
    );
  }
}
