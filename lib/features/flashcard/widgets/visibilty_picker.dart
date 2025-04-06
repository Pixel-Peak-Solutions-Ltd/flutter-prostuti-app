import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';

import '../viewmodel/flashcard_settings_viewmodel.dart';

class VisibilityPicker extends ConsumerStatefulWidget {
  final String initialVisibility;
  final Function(String) onVisibilitySelected;
  final VoidCallback onClose;

  const VisibilityPicker({
    super.key,
    required this.initialVisibility,
    required this.onVisibilitySelected,
    required this.onClose,
  });

  @override
  ConsumerState<VisibilityPicker> createState() => _VisibilityPickerState();
}

class _VisibilityPickerState extends ConsumerState<VisibilityPicker> {
  late String _selectedVisibility;

  @override
  void initState() {
    super.initState();
    _selectedVisibility = widget.initialVisibility;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n!.visibilityOptions,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              ),
            ],
          ),
          const Gap(16),

          // Description
          Text(
            context.l10n!.visibilityDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(24),

          // Options
          _buildVisibilityOption(
            context,
            "EVERYONE",
            context.l10n!.everyone,
            context.l10n!.everyoneDescription,
            Icons.public,
          ),
          const Gap(16),
          _buildVisibilityOption(
            context,
            "ONLY_ME",
            context.l10n!.onlyMe,
            context.l10n!.onlyMeDescription,
            Icons.lock,
          ),

          const Gap(32),
          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: const Color(0xff2970FF),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                // Save selection to provider
                ref
                    .read(flashcardSettingsNotifierProvider.notifier)
                    .setVisibility(_selectedVisibility);

                // Notify parent through callback
                widget.onVisibilitySelected(_selectedVisibility);

                // Close sheet
                widget.onClose();
              },
              child: Text(
                context.l10n!.confirm,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityOption(
    BuildContext context,
    String value,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedVisibility == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedVisibility = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: !isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).unselectedWidgetColor,
            width: 2,
          ),
          color: !isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Colors.grey.shade200,
              ),
              child: Icon(
                icon,
                color: !isSelected
                    ? Theme.of(context).shadowColor
                    : Theme.of(context).shadowColor,
                size: 24,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Gap(4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Radio(
              value: value,
              groupValue: _selectedVisibility,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedVisibility = newValue;
                  });
                }
              },
              activeColor: Theme.of(context).unselectedWidgetColor,
            ),
          ],
        ),
      ),
    );
  }
}
