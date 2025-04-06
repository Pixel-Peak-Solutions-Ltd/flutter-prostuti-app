import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlashcardFilterButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFilterActive;

  const FlashcardFilterButton({
    super.key,
    required this.onTap,
    this.isFilterActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isFilterActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFilterActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.error,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/icons/filter.svg'),
            if (isFilterActive) ...[
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
