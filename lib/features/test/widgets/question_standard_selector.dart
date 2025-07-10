import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/configs/app_colors.dart';

class QuestionStandardSelector extends StatelessWidget {
  final String selectedStandard;
  final ValueChanged<String> onStandardChanged;

  const QuestionStandardSelector({
    super.key,
    required this.selectedStandard,
    required this.onStandardChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildStandardButton(
            context, "ইঞ্জিনিয়ারিং", "assets/icons/engineering.svg"),
        _buildStandardButton(
            context, "ভার্সিটি", "assets/icons/university.svg"),
        _buildStandardButton(context, "মেডিকেল", "assets/icons/medical.svg"),
        _buildStandardButton(context, "একাডেমিক", "assets/icons/academic.svg"),
      ],
    );
  }

  Widget _buildStandardButton(BuildContext context, String type, String icon) {
    final bool isSelected = selectedStandard == type;

    return InkWell(
      onTap: () => onStandardChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.backgroundActionPrimaryLight
              : AppColors.shadePrimaryLight,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondary,
              height: 20,
              width: 20,
            ),
            const Gap(8),
            Text(
              type,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
