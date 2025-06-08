import 'package:flutter/material.dart';
import 'package:prostuti/features/test/model/question_pattern_model.dart';

class OptionalSubjectSelectorList extends StatefulWidget {
  final List<Subject> subjects;
  final void Function(Subject subject, bool isSelected)? onSelectionChanged;

  const OptionalSubjectSelectorList({
    super.key,
    required this.subjects,
    this.onSelectionChanged,
  });

  @override
  State<OptionalSubjectSelectorList> createState() =>
      _OptionalSubjectSelectorListState();
}

class _OptionalSubjectSelectorListState
    extends State<OptionalSubjectSelectorList> {
  final Set<String> _selectedSubjects = {};

  @override
  Widget build(BuildContext context) {
    if (widget.subjects.isEmpty) {
      return const Text('No optional subjects found');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.subjects.map((subject) {
        final isSelected = _selectedSubjects.contains(subject.subject);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedSubjects.add(subject.subject!);
                    widget.onSelectionChanged?.call(subject, true);
                  } else {
                    _selectedSubjects.remove(subject.subject!);
                    widget.onSelectionChanged?.call(subject, false);
                  }
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subject.subject ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${subject.questionCount}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
