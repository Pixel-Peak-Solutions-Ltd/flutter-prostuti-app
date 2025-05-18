import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/subject_selector_viewmodel.dart';

class SubjectDropdown extends ConsumerWidget {
  final String selectedStandard;
  final String? selectedSubject;
  final ValueChanged<String> onSubjectChanged;
  final List<String> excludedSubjects;

  const SubjectDropdown({
    super.key,
    required this.selectedStandard,
    required this.selectedSubject,
    required this.onSubjectChanged,
    this.excludedSubjects = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectListAsync = ref.watch(subjectViewmodelProvider(selectedStandard));

    return subjectListAsync.when(
      data: (subjects) {
        final filteredSubjects = subjects
            .where((subject) => !excludedSubjects.contains(subject))
            .toList();

        final List<String> dropdownItems = [
          "সাবজেক্ট সিলেক্ট করুন",
          ...filteredSubjects
        ];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
          ),
          child: DropdownButton<String>(
            value: selectedSubject ?? "সাবজেক্ট সিলেক্ট করুন",
            isExpanded: true,
            underline: Container(),
            items: dropdownItems.map((subject) {
              return DropdownMenuItem(
                value: subject,
                child: Text(
                  subject,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null && value != "সাবজেক্ট সিলেক্ট করুন") {
                onSubjectChanged(value);
              }
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) {
        print("Error: ${err.toString()}");
        return Center(child: Text("Error: ${err.toString()}"));
      },
    );
  }
}
