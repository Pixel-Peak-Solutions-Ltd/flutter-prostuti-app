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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isFilterActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFilterActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isFilterActive
              ? [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/filter.svg',
              colorFilter: ColorFilter.mode(
                isFilterActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
              height: 18,
            ),
            if (isFilterActive) ...[
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
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
