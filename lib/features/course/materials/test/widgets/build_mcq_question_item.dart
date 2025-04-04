
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/configs/app_colors.dart';
import '../model/mcq_test_details_model.dart';

class MCQQuestionWidget extends StatefulWidget {
  final int questionNumber;
  final ThemeData theme;
  final QuestionList questionList;
  final Map<int, int?> selectedAnswers; // Tracks selected answers for each question.
  final List<Map<String, dynamic>> answerList; // List to store answers.

  const MCQQuestionWidget({
    super.key,
    required this.questionNumber,
    required this.theme,
    required this.questionList,
    required this.selectedAnswers,
    required this.answerList,
  });

  @override
  State<MCQQuestionWidget> createState() => _MCQQuestionWidgetState();
}

class _MCQQuestionWidgetState extends State<MCQQuestionWidget> {
  void updateAnswerList(int? selectedIndex) {
    final answerIndex = widget.answerList.indexWhere(
          (answer) => answer['question_id'] == widget.questionList.sId,
    );

    if (answerIndex != -1) {
      widget.answerList[answerIndex]['selectedOption'] =
      selectedIndex != null
          ? widget.questionList.options![selectedIndex]
          : "null";
    }
  }


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
                  bool isSelected = selectedOption == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.selectedAnswers[widget.questionNumber] = index;
                        updateAnswerList(index); // Update the answer list.
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey.shade300,
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
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                            child: Center(
                              child: Text(
                                ansOption[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
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
                                color: isSelected ? Colors.blue : Colors.black,
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