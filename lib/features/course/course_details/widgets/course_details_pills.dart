import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class CourseDetailsPills extends StatelessWidget {
  const CourseDetailsPills({
    super.key,
    required this.icon,
    required this.value,
  });

  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: 20,
            width: 20,
            color: Theme.of(context).colorScheme.onSurface,
            fit: BoxFit.cover,
          ),
          const Gap(4),
          Text(value, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
