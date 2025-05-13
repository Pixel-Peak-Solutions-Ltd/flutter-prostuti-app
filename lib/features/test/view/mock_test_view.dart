/*
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../core/services/nav.dart';
import '../../flashcard/widgets/category_picker.dart';
import '../widgets/test_nevigation_button.dart';

class MockTestLandingView extends StatelessWidget with CommonWidgets {
  MockTestLandingView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("সেগমেন্ট টেস্ট"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Text(
                'আপনার লক্ষ্যভিত্তিক পরীক্ষার জন্য নিচের প্রতিটি তথ্য নির্ভুলভাবে নির্বাচন করুন।',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Gap(16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedQuestionType,
                      items: const [
                        DropdownMenuItem(value: "MCQ", child: Text("MCQ")),
                        DropdownMenuItem(value: "Written", child: Text("Written")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedQuestionType = value!;
                        });
                      },
                    ),
                    TextField(
                      controller: questionCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "প্রশ্ন সংখ্যা"),
                    ),
                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "সময় (মিনিটে)"),
                    ),
                    SwitchListTile(
                      title: const Text("নেগেটিভ মার্কিং"),
                      value: isNegativeMarking,
                      onChanged: (value) {
                        setState(() {
                          isNegativeMarking = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: _startMockTest,
                      child: const Text("টেস্ট শুরু করুন"),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../common/widgets/common_widgets/common_widgets.dart';
import '../viewmodel/mock_test_viewmodel.dart';
import '../widgets/test_type_selector_button.dart';

class MockTestLandingView extends ConsumerStatefulWidget {
  const MockTestLandingView({super.key});

  @override
  ConsumerState<MockTestLandingView> createState() => _MockTestLandingViewState();
}

class _MockTestLandingViewState extends ConsumerState<MockTestLandingView>
    with CommonWidgets {
  final TextEditingController questionCountController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  bool isNegativeMarking = false;
  String selectedQuestionType = "MCQ";
  List<String> selectedSubjects = ["Physics 1st Paper"];

  void _startMockTest() async {
    final int questionCount = int.tryParse(questionCountController.text) ?? 0;
    final int time = int.tryParse(timeController.text) ?? 0;

    final response =
        await ref.read(mockTestViewmodelProvider.notifier).createMockQuiz(
              questionType: selectedQuestionType,
              subjects: selectedSubjects,
              questionCount: questionCount,
              isNegativeMarking: isNegativeMarking,
              time: time,
            );

    if (response != null) {
      // Navigate or Show Success Dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Mock Test Created"),
          content: Text("Test ID: ${response.data?.id}"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mockTestViewmodelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("মক-টেস্ট"),
      body: state.when(
        data: (data) => Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'টেস্ট টাইপ সিলেক্ট করুন',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Gap(10),
              Container(
                child: Column(
                  children: [
                    TestTypeSelector(
                      selectedType: selectedQuestionType,
                      onTypeChanged: (value) {
                        setState(() {
                          selectedQuestionType = value;
                        });
                      },
                    ),
                    TextField(
                      controller: questionCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "প্রশ্ন সংখ্যা"),
                    ),
                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "সময় (মিনিটে)"),
                    ),
                    SwitchListTile(
                      title: const Text("নেগেটিভ মার্কিং"),
                      value: isNegativeMarking,
                      onChanged: (value) {
                        setState(() {
                          isNegativeMarking = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: _startMockTest,
                      child: const Text("টেস্ট শুরু করুন"),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: ${err.toString()}")),
      ),
    );
  }
}
