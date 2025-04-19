import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/features/course/materials/test/model/written_result_model.dart';
import '../../../../../core/configs/app_colors.dart';
import '../model/mcq_test_details_model.dart';
import 'explanation_widget.dart';

class WrittenResultAnswerWidget extends StatefulWidget {
  int questionNumber;
  ThemeData theme;
  Answers answerData;
  String selectedOption;
  String correctOption;

  WrittenResultAnswerWidget({
    super.key,
    required this.questionNumber,
    required this.answerData,
    required this.selectedOption,
    required this.correctOption,
    required this.theme,
  });

  @override
  State<WrittenResultAnswerWidget> createState() => _WrittenResultAnswerWidgetState();
}

class _WrittenResultAnswerWidgetState extends State<WrittenResultAnswerWidget> {
  @override
  Widget build(BuildContext context) {
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
              TextField(
                controller: TextEditingController(text: widget.selectedOption,),
                enabled: false,
                maxLines: 8,
                minLines: 3,
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.shadeNeutralLight, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.shadeNeutralLight, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
