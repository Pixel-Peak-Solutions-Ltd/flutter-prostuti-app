import 'package:flutter/material.dart';

class CourseListHeader extends StatelessWidget {
  const CourseListHeader({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(fontWeight: FontWeight.w700),
    );
  }
}
