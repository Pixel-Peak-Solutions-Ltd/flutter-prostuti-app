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
          padding: const EdgeInsets.all(16),
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
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ওএমআর',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: totalQuestions,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text('${questionNumber}'),
          Gap(40),
          Row(
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () => onOptionSelected(index),
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedOption == index
                        ? Colors.blue
                        : AppColors.textActionTertiaryDark,
                    border: Border.all(
                      color: selectedOption == index
                          ? Colors.blue
                          : AppColors.textActionTertiaryDark,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      ansOption[index],
                      style: TextStyle(
                        color: selectedOption == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

