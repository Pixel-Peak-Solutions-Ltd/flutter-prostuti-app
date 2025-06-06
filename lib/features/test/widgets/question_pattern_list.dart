import 'package:flutter/material.dart';
import 'package:prostuti/features/test/model/question_pattern_model.dart';

class PatternSubjectList extends StatelessWidget {
  final List<Subject> subjects;

  const PatternSubjectList({
    super.key,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return const Text('No subjects found');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subjects.map((subject) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subject.subject!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              "${subject.questionCount}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }
}
