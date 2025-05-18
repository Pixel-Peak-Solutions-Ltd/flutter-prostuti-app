import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/test/view/written_mock_quiz_screen.dart';
import 'package:prostuti/features/test/viewmodel/quizer_test_viewmodel.dart';
import 'package:prostuti/features/test/viewmodel/quizer_written_test_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import '../../../common/widgets/common_widgets/common_widgets.dart';
import '../viewmodel/mock_test_viewmodel.dart';
import '../viewmodel/subject_selector_viewmodel.dart';
import '../viewmodel/written_quiz_viewmodel.dart';
import '../widgets/question_standard_selector.dart';
import '../widgets/subject_dropdown.dart';
import '../widgets/test_type_selector_button.dart';
import 'mcq_mock_quiz_view.dart';

class QuizerTestLandingView extends ConsumerStatefulWidget {
  const QuizerTestLandingView({super.key});

  @override
  ConsumerState<QuizerTestLandingView> createState() => _QuizerTestLandingViewState();
}

class _QuizerTestLandingViewState extends ConsumerState<QuizerTestLandingView>
    with CommonWidgets {
  final TextEditingController questionCountController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  bool isNegativeMarking = false;
  String selectedQuestionType = "MCQ";
  String selectedStandard = "ইঞ্জিনিয়ারিং";
  List<String> selectedSubjects = ["সাবজেক্ট সিলেক্ট করুন"];
  List<String> questionFilters = [];

  void _startMCQQuizerTest() async {
    final int questionCount = int.tryParse(questionCountController.text) ?? 0;
    final int time = int.tryParse(timeController.text) ?? 0;

    final validSubjects = selectedSubjects
        .where((subject) => subject != "সাবজেক্ট সিলেক্ট করুন")
        .toList();


    if (validSubjects.isEmpty) {
      _showValidationError("কমপক্ষে একটি বিষয় সিলেক্ট করুন।");
      return;
    }

    final validQuestionFilters = questionFilters
        .where((filters) => filters != "প্রশ্নের ধরণ সিলেক্ট করুন")
        .toList();

    if (validQuestionFilters.isEmpty) {
      _showValidationError("কমপক্ষে একটি প্রশ্নের ধরণ সিলেক্ট করুন।");
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

    final response = await ref.read(quizerTestViewmodelProvider.notifier).createMCQQuizer(
      questionType: selectedQuestionType,
      subjects: validSubjects,
      questionFilters: validQuestionFilters,
      questionCount: questionCount,
      isNegativeMarking: isNegativeMarking,
      time: time,
    );

    if (response != null && response.data != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MCQMockQuizScreen(mockQuiz: response),
          ),
        );
    }
  }

  void _startWrittenQuizerTest() async {
    final int questionCount = int.tryParse(questionCountController.text) ?? 0;
    final int time = int.tryParse(timeController.text) ?? 0;

    final validSubjects = selectedSubjects
        .where((subject) => subject != "সাবজেক্ট সিলেক্ট করুন")
        .toList();


    if (validSubjects.isEmpty) {
      _showValidationError("কমপক্ষে একটি বিষয় সিলেক্ট করুন।");
      return;
    }

    final validQuestionFilters = questionFilters
        .where((filters) => filters != "প্রশ্নের ধরণ সিলেক্ট করুন")
        .toList();

    if (validQuestionFilters.isEmpty) {
      _showValidationError("কমপক্ষে একটি প্রশ্নের ধরণ সিলেক্ট করুন।");
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

    final response = await ref.read(quizerWrittenTestViewmodelProvider.notifier).createWrittenQuizer(
      questionType: selectedQuestionType,
      subjects: validSubjects,
      questionFilters: validQuestionFilters,
      questionCount: questionCount,
      isNegativeMarking: isNegativeMarking,
      time: time,
    );

    if (response != null && response.data != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WrittenMockQuizScreen(mockQuiz: response),
          ),
        );
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizerTestViewmodelProvider);
    final subjectState = ref.watch(subjectViewmodelProvider(selectedStandard));
    final isSubjectLoading = subjectState.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("কুইজার"),
      body: Skeletonizer(
        enabled: isSubjectLoading,
        child: state.when(
          data: (data) => _buildContent(context),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: \${err.toString()}")),
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
            Text('টেস্ট টাইপ সিলেক্ট করুন', style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            TestTypeSelector(
              selectedType: selectedQuestionType,
              onTypeChanged: (value) => setState(() => selectedQuestionType = value),
            ),
            const Gap(10),
            Text('প্রশ্নের স্ট্যান্ডার্ড', style: Theme.of(context).textTheme.bodyMedium),
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
              final selectedExcludingCurrent = List<String>.from(selectedSubjects)..removeAt(index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
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
              );
            }),
            const Gap(10),
            Text('প্রশ্নের ধরণ সিলেক্ট করুন*', style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip("Favorite Questions"),
                _buildFilterChip("Unanswered Questions"),
                _buildFilterChip("Wrong Questions"),
              ],
            ),
            const Gap(10),
            TextButton.icon(
              onPressed: () => setState(() => selectedSubjects.add("সাবজেক্ট সিলেক্ট করুন")),
              label: Text("আরেকটি বিষয় যোগ করুন", style: Theme.of(context).textTheme.bodyMedium),
              icon: Icon(CupertinoIcons.plus_app, color: Theme.of(context).colorScheme.onSurface),
            ),

            const Gap(10),
            Text("প্রশ্ন সংখ্যা", style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            TextField(
              controller: questionCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "প্রশ্ন সংখ্যা সিলেক্ট করুন"),
            ),
            const Gap(10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("নেগেটিভ মার্কিং", style: Theme.of(context).textTheme.bodyMedium),
              value: isNegativeMarking,
              activeColor: Theme.of(context).colorScheme.onSecondary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              onChanged: (value) => setState(() => isNegativeMarking = value),
            ),
            const Gap(10),
            Text("সময় (মিনিটে)", style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            TextField(
              controller: timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "30"),
            ),
            const Gap(10),
            LongButton(
              onPressed: selectedQuestionType == "MCQ" ? _startMCQQuizerTest : _startWrittenQuizerTest,
              text: "টেস্ট শুরু করুন",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final selected = questionFilters.contains(label);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (value) {
        setState(() {
          if (value) {
            questionFilters.add(label);
          } else {
            if (questionFilters.length > 1) {
              questionFilters.remove(label);
            }
          }
        });
      },
      checkmarkColor: selected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.secondary,
      selectedColor: Theme.of(context).colorScheme.onSecondary,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: selected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}