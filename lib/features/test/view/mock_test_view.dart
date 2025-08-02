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
  final TextEditingController timeController = TextEditingController();
  bool isNegativeMarking = false;
  String selectedQuestionType = "MCQ";
  String selectedStandard = "ইঞ্জিনিয়ারিং";
  List<SelectedSubjectAndChapter> selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    // Add one subject selector by default
    selectedSubjects
        .add(SelectedSubjectAndChapter(subject: "সাবজেক্ট সিলেক্ট করুন"));
  }

  void _startWrittenMockTest() async {
    final int questionCount = int.tryParse(questionCountController.text) ?? 0;
    final int time = int.tryParse(timeController.text) ?? 0;

    // Filter out placeholder subjects. The list is now of the correct type.
    final validSubjects = selectedSubjects
        .where(
            (s) => s.subject != "সাবজেক্ট সিলেক্ট করুন" && s.subject.isNotEmpty)
        .map((s) => s.toJson()) // Convert to JSON
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

      if (response != null && response.data != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WrittenMockQuizScreen(mockQuiz: response),
          ),
        );
      }
    } catch (e) {
      _showValidationError(e.toString());
    }
  }

  void _startMCQMockTest() async {
    final int questionCount = int.tryParse(questionCountController.text) ?? 0;
    final int time = int.tryParse(timeController.text) ?? 0;

    // Filter out placeholder subjects. The list is now of the correct type.
    final validSubjects = selectedSubjects
        .where(
            (s) => s.subject != "সাবজেক্ট সিলেক্ট করুন" && s.subject.isNotEmpty)
        .map((s) => s.toJson()) // Convert to JSON
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

      if (response != null && response.data != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MCQMockQuizScreen(mockQuiz: response),
          ),
        );
      }
    } catch (e) {
      _showValidationError(e.toString());
    }
  }

  void _showValidationError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
                selectedSubjects = [
                  SelectedSubjectAndChapter(subject: "সাবজেক্ট সিলেক্ট করুন")
                ];
              }),
            ),
            const Gap(10),
            Text('সাবজেক্ট*', style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            ...selectedSubjects.asMap().entries.map((entry) {
              final index = entry.key;
              final subject = entry.value;
              final selectedExcludingCurrent = selectedSubjects
                  .asMap()
                  .entries
                  .where((e) => e.key != index)
                  .map((e) => e.value.subject)
                  .toList();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final subjectListAsync = ref.watch(
                              subjectViewmodelProvider(selectedStandard));

                          return subjectListAsync.when(
                            data: (subjects) {
                              final availableSubjects = subjects;
                              final dropdownSubjects = [
                                "সাবজেক্ট সিলেক্ট করুন",
                                ...availableSubjects
                              ];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Subject Dropdown
                                  DropdownButtonFormField<String>(
                                    value: selectedSubjects[index]
                                                .subject
                                                .isEmpty ||
                                            !dropdownSubjects.contains(
                                                selectedSubjects[index].subject)
                                        ? "সাবজেক্ট সিলেক্ট করুন"
                                        : selectedSubjects[index].subject,
                                    items: dropdownSubjects
                                        .map((subject) =>
                                            DropdownMenuItem<String>(
                                              value: subject,
                                              child: Text(subject),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null &&
                                          value != "সাবজেক্ট সিলেক্ট করুন") {
                                        setState(() {
                                          selectedSubjects[index].subject =
                                              value;
                                          selectedSubjects[index].chapter =
                                              "All"; // reset chapter on subject change
                                        });
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "বিষয় নির্বাচন করুন",
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Chapter Dropdown (shown only if subject selected)
                                  if (selectedSubjects[index].subject !=
                                          "সাবজেক্ট সিলেক্ট করুন" &&
                                      selectedSubjects[index]
                                          .subject
                                          .isNotEmpty)
                                    ref
                                        .watch(chapterViewmodelProvider(
                                            selectedSubjects[index].subject))
                                        .when(
                                          data: (chapters) {
                                            final List<String> chapterOptions = ["All", ...chapters].toSet().toList();
                                            final otherSelectedChapters =
                                                selectedSubjects
                                                    .asMap()
                                                    .entries
                                                    .where((entry) =>
                                                        entry.key != index &&
                                                        entry.value.subject ==
                                                            selectedSubjects[
                                                                    index]
                                                                .subject)
                                                    .map((entry) =>
                                                        entry.value.chapter)
                                                    .toList();
                                            return DropdownButtonFormField<
                                                String>(
                                              value: chapterOptions.contains(
                                                      selectedSubjects[index]
                                                          .chapter)
                                                  ? selectedSubjects[index]
                                                      .chapter
                                                  : chapterOptions.first,
                                              items: chapterOptions
                                                  .map((chapter) {
                                                final isSelectedElsewhere =
                                                    otherSelectedChapters
                                                            .contains(
                                                                chapter) &&
                                                        chapter != 'All';
                                                return DropdownMenuItem<
                                                    String>(
                                                  value: chapter,
                                                  enabled:
                                                      !isSelectedElsewhere,
                                                  child: Text(
                                                    chapter,
                                                    style: TextStyle(
                                                      color:
                                                          isSelectedElsewhere
                                                              ? Colors.grey
                                                              : null,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  if (otherSelectedChapters.contains(value) && value != 'All') {
                                                    _showValidationError(
                                                        "This chapter has already been selected for this subject.");
                                                  } else {
                                                    setState(() =>
                                                        selectedSubjects[index]
                                                            .chapter = value);
                                                  }
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    "অধ্যায় নির্বাচন করুন",
                                              ),
                                            );
                                          },
                                          loading: () => const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          error: (err, _) =>
                                              Text("Error loading chapters"),
                                        ),
                                ],
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (err, _) => Text("Error loading subjects"),
                          );
                        },
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
              onPressed: () => setState(() {
                selectedSubjects.add(SelectedSubjectAndChapter(
                    subject: "সাবজেক্ট সিলেক্ট করুন"));
              }),
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
            Text("সময় (মিনিটে)", style: Theme.of(context).textTheme.bodyMedium),
            const Gap(10),
            TextField(
              controller: timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "30"),
            ),
            const Gap(10),
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
