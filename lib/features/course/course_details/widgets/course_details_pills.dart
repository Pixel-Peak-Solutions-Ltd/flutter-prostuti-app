import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/configs/app_colors.dart';

class CourseDetailsPills extends StatelessWidget {
  const CourseDetailsPills({
    super.key,
    required this.icon,
    required this.value,
  });

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.textTertiaryLight,
          ),
          const Gap(4),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: AppColors.textTertiaryLight),
          ),
        ],
      ),
    );
  }
}
