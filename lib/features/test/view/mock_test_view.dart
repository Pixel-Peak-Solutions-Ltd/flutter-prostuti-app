import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/features/test/view/written_mock_quiz_screen.dart';
import 'package:prostuti/features/test/viewmodel/written_quiz_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../common/widgets/common_widgets/common_widgets.dart';
import '../viewmodel/mock_test_viewmodel.dart';
import '../viewmodel/subject_selector_viewmodel.dart';
import '../widgets/question_standard_selector.dart';
import '../widgets/subject_dropdown.dart';
import '../widgets/test_type_selector_button.dart';
import 'mcq_mock_quiz_view.dart';

class MockTestLandingView extends ConsumerStatefulWidget {
  const MockTestLandingView({super.key});

  @override
  ConsumerState<MockTestLandingView> createState() =>
      _MockTestLandingViewState();
}

class _MockTestLandingViewState extends ConsumerState<MockTestLandingView>
    with CommonWidgets {
  final TextEditingController questionCountController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  bool isNegativeMarking = false;
  String selectedQuestionType = "MCQ";
  String selectedStandard = "ইঞ্জিনিয়ারিং";
  List<String> selectedSubjects = ["সাবজেক্ট সিলেক্ট করুন"];

  // Helper method to convert hours, minutes, seconds to total minutes
  int _convertToTotalMinutes() {
    final hours = int.tryParse(hourController.text.trim()) ?? 0;
    final minutes = int.tryParse(minuteController.text.trim()) ?? 0;
    final seconds = int.tryParse(secondController.text.trim()) ?? 0;

    // Convert everything to minutes
    return (hours * 60) + minutes + (seconds > 0 ? 1 : 0); // Round up if seconds > 0
  }

  Widget _buildTimeInputField(TextEditingController controller, String label) {
    return Expanded(
      child: Column(
        children: [
          Center(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "০০",
                hintStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
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

  void _startWrittenMockTest() async {
    final int questionCount = int.tryParse(questionCountController.text) ?? 0;
    final int time = _convertToTotalMinutes();

    final validSubjects = selectedSubjects
        .where((subject) => subject != "সাবজেক্ট সিলেক্ট করুন")
        .toList();

    if (validSubjects.isEmpty) {
      _showValidationError("কমপক্ষে একটি বিষয় সিলেক্ট করুন।");
      return;
    }
    if (questionCount <= 0) {
      _showValidationError("প্রশ্ন সংখ্যাটি সঠিকভাবে লিখুন।");
      return;
    }
    if (time <= 0) {
      _showValidationError("সময়টি সঠিকভাবে লিখুন।");
      return;
    }

    try {
      final response =
          await ref.read(writtenQuizViewmodelProvider.notifier).createMockQuiz(
                questionType: selectedQuestionType,
                subjects: validSubjects,
                questionCount: questionCount,
                isNegativeMarking: isNegativeMarking,
                time: time,
              );

      if (response != null && response.data != null) {
        if(response.success!){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WrittenMockQuizScreen(mockQuiz: response),
            ),
          );
        }else{
          _showValidationError(response.message!);
        }
      }
    } catch (e) {
      _showValidationError(e.toString());
    }
  }

  void _startMCQMockTest() async {
    final int questionCount = int.tryParse(questionCountController.text) ?? 0;
    final int time = _convertToTotalMinutes();

    final validSubjects = selectedSubjects
        .where((subject) => subject != "সাবজেক্ট সিলেক্ট করুন")
        .toList();

    if (validSubjects.isEmpty) {
      _showValidationError("কমপক্ষে একটি বিষয় সিলেক্ট করুন।");
      return;
    }
    if (questionCount <= 0) {
      _showValidationError("প্রশ্ন সংখ্যাটি সঠিকভাবে লিখুন।");
      return;
    }
    if (time <= 0) {
      _showValidationError("সময়টি সঠিকভাবে লিখুন।");
      return;
    }

    try {
      final response =
          await ref.read(mockTestViewmodelProvider.notifier).createMockQuiz(
                questionType: selectedQuestionType,
                subjects: validSubjects,
                questionCount: questionCount,
                isNegativeMarking: isNegativeMarking,
                time: time,
              );

      if (response != null && response.data != null) {
        if(response.success!){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MCQMockQuizScreen(mockQuiz: response),
            ),
          );
        }else{
          _showValidationError(response.message!);
        }
      }
    } catch (e) {
      _showValidationError(e.toString());
    }
  }

  void _showValidationError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "ত্রুটি!",
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: Text("ঠিক আছে",style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mockTestViewmodelProvider);
    final subjectState = ref.watch(subjectViewmodelProvider(selectedStandard));
    final isSubjectLoading = subjectState.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("মক-টেস্ট"),
      body: Skeletonizer(
        enabled: isSubjectLoading,
        child: state.when(
          data: (data) => _buildContent(context),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: ${err.toString()}")),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('টেস্ট টাইপ সিলেক্ট করুন',
                style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            TestTypeSelector(
              selectedType: selectedQuestionType,
              onTypeChanged: (value) =>
                  setState(() => selectedQuestionType = value),
            ),
            const Gap(10),
            Text('প্রশ্নের স্ট্যান্ডার্ড',
                style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            QuestionStandardSelector(
              selectedStandard: selectedStandard,
              onStandardChanged: (value) => setState(() {
                selectedStandard = value;
                selectedSubjects = ["সাবজেক্ট সিলেক্ট করুন"];
              }),
            ),
            const Gap(10),
            Text('সাবজেক্ট*', style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            ...selectedSubjects.asMap().entries.map((entry) {
              final index = entry.key;
              final subject = entry.value;
              final selectedExcludingCurrent =
                  List<String>.from(selectedSubjects)..removeAt(index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SubjectDropdown(
                        selectedStandard: selectedStandard,
                        selectedSubject: subject,
                        onSubjectChanged: (value) {
                          if (!selectedExcludingCurrent.contains(value)) {
                            setState(() => selectedSubjects[index] = value);
                          }
                        },
                        excludedSubjects: selectedExcludingCurrent,
                      ),
                    ),
                    if (selectedSubjects.length > 1)
                      IconButton(
                        onPressed: () =>
                            setState(() => selectedSubjects.removeAt(index)),
                        icon: Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
              );
            }),
            const Gap(10),
            TextButton.icon(
              onPressed: () =>
                  setState(() => selectedSubjects.add("সাবজেক্ট সিলেক্ট করুন")),
              label: Text("আরেকটি বিষয় যোগ করুন",
                  style: Theme.of(context).textTheme.bodyMedium),
              icon: Icon(CupertinoIcons.plus_app,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            const Gap(10),
            Text("প্রশ্ন সংখ্যা",
                style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            TextField(
              controller: questionCountController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "প্রশ্ন সংখ্যা সিলেক্ট করুন"),
            ),
            const Gap(10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("নেগেটিভ মার্কিং",
                  style: Theme.of(context).textTheme.bodyMedium),
              value: isNegativeMarking,
              activeColor: Theme.of(context).colorScheme.onSecondary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              onChanged: (value) => setState(() => isNegativeMarking = value),
            ),
            const Gap(10),
            Text("সময়", style: Theme.of(context).textTheme.bodyMedium),
            const Gap(16),
            Row(
              children: [
                _buildTimeInputField(hourController, "ঘন্টা"),
                const Gap(16),
                _buildTimeInputField(minuteController, "মিনিট"),
                const Gap(16),
                _buildTimeInputField(secondController, "সেকেন্ড"),
              ],
            ),
            const Gap(20),
            LongButton(
              onPressed: selectedQuestionType == "MCQ"
                  ? _startMCQMockTest
                  : _startWrittenMockTest,
              text: "টেস্ট শুরু করুন",
            ),
          ],
        ),
      ),
    );
  }
}
