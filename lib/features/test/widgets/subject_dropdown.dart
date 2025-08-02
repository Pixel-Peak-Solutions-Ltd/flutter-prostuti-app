import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../viewmodel/subject_selector_viewmodel.dart';

class SelectedSubjectAndChapter {
  String subject;
  String chapter;

  SelectedSubjectAndChapter({
    required this.subject,
    this.chapter = "All",
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'chapter': chapter,
    };
  }
}

class SubjectWithChapterSelector extends ConsumerWidget {
  final List<SelectedSubjectAndChapter> selectedPairs;
  final ValueChanged<int> onRemove;
  final void Function(int index, String newSubject) onSubjectChanged;
  final void Function(int index, String newChapter) onChapterChanged;
  final String selectedStandard;

  const SubjectWithChapterSelector({
    super.key,
    required this.selectedPairs,
    required this.onRemove,
    required this.onSubjectChanged,
    required this.onChapterChanged,
    required this.selectedStandard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: selectedPairs.asMap().entries.map((entry) {
        final index = entry.key;
        final pair = entry.value;

        final subjectListAsync = ref.watch(subjectViewmodelProvider(selectedStandard));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0)
              Text('বিষয় ও অধ্যায় নির্বাচন করুন',
                  style: Theme.of(context).textTheme.bodyMedium),
            const Gap(8),
            subjectListAsync.when(
              data: (subjects) {
                final availableSubjects = subjects
                    .where((s) => !selectedPairs
                    .asMap()
                    .entries
                    .where((e) => e.key != index)
                    .map((e) => e.value.subject)
                    .contains(s))
                    .toList();

                final dropdownSubjects = ["সাবজেক্ট সিলেক্ট করুন", ...availableSubjects];

                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: pair.subject.isEmpty ||
                            pair.subject == "সাবজেক্ট সিলেক্ট করুন"
                            ? "সাবজেক্ট সিলেক্ট করুন"
                            : pair.subject,
                        items: dropdownSubjects
                            .map((subject) => DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null && value != "সাবজেক্ট সিলেক্ট করুন") {
                            onSubjectChanged(index, value);
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    if (selectedPairs.length > 1)
                      IconButton(
                        onPressed: () => onRemove(index),
                        icon: Icon(CupertinoIcons.xmark_circle_fill,
                            color: Theme.of(context).colorScheme.error),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text("Error: $err"),
            ),
            const Gap(10),
            if (pair.subject != "সাবজেক্ট সিলেক্ট করুন" &&
                pair.subject.isNotEmpty)
              ref.watch(chapterViewmodelProvider(pair.subject)).when(
                data: (chapters) {
                  final chapterOptions = ["All", ...chapters];
                  return DropdownButtonFormField<String>(
                    value: pair.chapter,
                    items: chapterOptions
                        .map((chapter) => DropdownMenuItem<String>(
                      value: chapter,
                      child: Text(chapter),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onChapterChanged(index, value);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "অধ্যায় নির্বাচন করুন",
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text("Error loading chapters"),
              ),
            const Gap(16),
          ],
        );
      }).toList(),
    );
  }
}
