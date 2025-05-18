import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/course/materials/test/model/written_test_details_model.dart';

import '../../../../../core/configs/app_colors.dart';

class WrittenQuizQuestionWidget extends StatefulWidget {
  final int questionNumber;
  final ThemeData theme;
  final QuestionList questionList;
  final Function(String questionId, String answer) onAnswerChange;

  const WrittenQuizQuestionWidget({
    super.key,
    required this.questionNumber,
    required this.theme,
    required this.questionList,
    required this.onAnswerChange,
  });

  @override
  State<WrittenQuizQuestionWidget> createState() => _WrittenQuizQuestionWidgetState();
}

class _WrittenQuizQuestionWidgetState extends State<WrittenQuizQuestionWidget> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _answerController.addListener(_updateAnswer);
  }

  @override
  void dispose() {
    _answerController.removeListener(_updateAnswer);
    _answerController.dispose();
    super.dispose();
  }

  void _updateAnswer() {
    widget.onAnswerChange(widget.questionList.sId.toString(), _answerController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.onPrimary,
            border: Border.all(color:Theme.of(context).colorScheme.onSurface),
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
                controller: _answerController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 4),
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
}