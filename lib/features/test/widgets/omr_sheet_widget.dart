import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/configs/app_colors.dart';

class OMRSheetWidget extends StatelessWidget {
  final int totalQuestions;
  final Map<int, int?> selectedAnswers;
  final Function(int, int) onAnswerSelected;
  final ScrollController scrollController;

  const OMRSheetWidget({
    Key? key,
    required this.totalQuestions,
    required this.selectedAnswers,
    required this.onAnswerSelected,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Draggable handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(12),
              // Header with better spacing
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'ওএমআর',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(16),

              // Questions list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: totalQuestions,
                  padding: const EdgeInsets.only(top: 4),
                  itemBuilder: (context, index) {
                    return OMRQuestionRow(
                      questionNumber: index + 1,
                      selectedOption: selectedAnswers[index + 1],
                      onOptionSelected: (option) {
                        setState(() {
                          onAnswerSelected(index + 1, option);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OMRQuestionRow extends StatelessWidget {
  final int questionNumber;
  final int? selectedOption;
  final Function(int) onOptionSelected;

  const OMRQuestionRow({
    Key? key,
    required this.questionNumber,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ansOption = ["ক", "খ", "গ", "ঘ"];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              questionNumber.toString().padLeft(2, '0'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                final isSelected = selectedOption == index;
                return GestureDetector(
                  onTap: () => onOptionSelected(index),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.blue
                          : AppColors.textActionTertiaryDark,
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue
                            : AppColors.textActionTertiaryDark,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        ansOption[index],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}