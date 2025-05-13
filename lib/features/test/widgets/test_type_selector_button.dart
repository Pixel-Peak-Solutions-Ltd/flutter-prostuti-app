import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/configs/app_colors.dart';

class TestTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const TestTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTypeButton(context, "MCQ", "assets/icons/mcq_test.svg"),
        const SizedBox(width: 12),
        _buildTypeButton(context, "Written", "assets/icons/written_test.svg"),
      ],
    );
  }

  Widget _buildTypeButton(BuildContext context, String type, String icon) {
    final bool isSelected = selectedType == type;

    return InkWell(
      onTap: () => onTypeChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
            color: isSelected
                ? AppColors.backgroundActionPrimaryLight
                : AppColors.shadePrimaryLight,
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.onSurface,
              height: 20,
              width: 20,
            ),
            const Gap(10),
            Text(
              type,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
