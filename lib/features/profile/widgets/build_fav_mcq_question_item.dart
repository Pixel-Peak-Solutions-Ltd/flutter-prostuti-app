
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/configs/app_colors.dart';
import 'package:prostuti/features/profile/view/favorite_question_view.dart';

class FavoriteMCQQuestionWidget extends StatefulWidget {
  final int questionNumber;
  final ThemeData theme;
  final QuestionList questionList;
  final List<Map<String, dynamic>> answerList; // List to store answers.

  const FavoriteMCQQuestionWidget({
    super.key,
    required this.questionNumber,
    required this.theme,
    required this.questionList,
    required this.answerList,
  });

  @override
  State<FavoriteMCQQuestionWidget> createState() => _FavoriteMCQQuestionWidgetState();
}

class _FavoriteMCQQuestionWidgetState extends State<FavoriteMCQQuestionWidget> {

  @override
  Widget build(BuildContext context) {
    final ansOption = ["ক", "খ", "গ", "ঘ"];

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
              // Question Title
              Text(
                "${widget.questionNumber}. ${widget.questionList.title}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Options
              Column(
                children: List.generate(4, (index) {

                  final optionText = widget.questionList.options![index];
                  bool isCorrect = optionText == widget.questionList.correctOption;
                  return GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? Colors.green.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isCorrect ? Colors.green : Colors.grey.shade300,
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
                              color: Colors.grey.shade300,
                            ),
                            child: Center(
                              child: Text(
                                ansOption[index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              widget.questionList.options![index],
                              style: TextStyle(
                                fontSize: 14,
                                color: isCorrect ? Colors.blue : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
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