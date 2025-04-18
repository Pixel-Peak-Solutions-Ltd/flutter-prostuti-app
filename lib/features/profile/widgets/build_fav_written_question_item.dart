import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/profile/view/favorite_question_view.dart';

import '../../../../../core/configs/app_colors.dart';

class FavoriteWrittenQuestionWidget extends StatefulWidget {
  final int questionNumber;
  final ThemeData theme;
  final QuestionList questionList;

  const FavoriteWrittenQuestionWidget({
    super.key,
    required this.questionNumber,
    required this.theme,
    required this.questionList,
  });

  @override
  State<FavoriteWrittenQuestionWidget> createState() => _FavoriteWrittenQuestionWidgetState();
}

class _FavoriteWrittenQuestionWidgetState extends State<FavoriteWrittenQuestionWidget> {
  @override
  Widget build(BuildContext context) {

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
              if (widget.questionList.hasImage == true &&
                  widget.questionList.image != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(
                    widget.questionList.image!.path!,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Image not available');
                    },
                  ),
                ),
              Text(
                "${widget.questionNumber}. ${widget.questionList.title}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: widget.questionList.description,),
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
            ],
          ),
        ),
        const Gap(24),
      ],
    );
  }
}
