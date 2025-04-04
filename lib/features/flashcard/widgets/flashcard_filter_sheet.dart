import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';

import '../viewmodel/flashcard_filter_viewmodel.dart';
import '../viewmodel/flashcard_viewmodel.dart';

class FlashcardFilterSheet extends ConsumerStatefulWidget {
  const FlashcardFilterSheet({super.key});

  @override
  FlashcardFilterSheetState createState() => FlashcardFilterSheetState();
}

class FlashcardFilterSheetState extends ConsumerState<FlashcardFilterSheet> {
  bool _isTypeExpanded = true; // Start with type expanded
  bool _isDivisionExpanded = false;
  bool _isSubjectExpanded = false;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final filterState = ref.watch(flashcardFilterProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n!.filter,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Gap(16),

          // Content with scrolling capability for long lists
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Type Filter Section
                  _buildFilterSection(
                    title: context.l10n!.type,
                    isExpanded: _isTypeExpanded,
                    onToggle: () =>
                        setState(() => _isTypeExpanded = !_isTypeExpanded),
                    content: categoriesAsync.when(
                      data: (categories) {
                        final types = ref
                            .read(categoriesProvider.notifier)
                            .getUniqueTypes(categories);

                        return types.isEmpty
                            ? Center(
                                child: Text(context.l10n!.noTypesAvailable))
                            : _buildOptionsList(
                                items: types,
                                selectedValue: filterState.selectedType,
                                onSelected: (value) {
                                  ref
                                      .read(flashcardFilterProvider.notifier)
                                      .setType(value);

                                  // Auto expand the division section
                                  setState(() {
                                    _isDivisionExpanded = true;
                                    _isTypeExpanded = false;
                                  });
                                },
                              );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Center(child: Text('${context.l10n!.error}: $error')),
                    ),
                  ),

                  const Gap(16),

                  // Division Filter Section
                  _buildFilterSection(
                    title: context.l10n!.division,
                    isExpanded: _isDivisionExpanded,
                    onToggle: () => setState(
                        () => _isDivisionExpanded = !_isDivisionExpanded),
                    content: categoriesAsync.when(
                      data: (categories) {
                        if (filterState.selectedType == null) {
                          return Center(
                              child: Text(context.l10n!.selectTypeFirst));
                        }

                        final divisions = ref
                            .read(categoriesProvider.notifier)
                            .getUniqueDivisions(
                                categories, filterState.selectedType);

                        return divisions.isEmpty
                            ? Center(
                                child: Text(context.l10n!.noDivisionsAvailable))
                            : _buildOptionsList(
                                items: divisions,
                                selectedValue: filterState.selectedDivision,
                                onSelected: (value) {
                                  ref
                                      .read(flashcardFilterProvider.notifier)
                                      .setDivision(value);

                                  // Auto expand the subject section
                                  setState(() {
                                    _isSubjectExpanded = true;
                                    _isDivisionExpanded = false;
                                  });
                                },
                              );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Center(child: Text('${context.l10n!.error}: $error')),
                    ),
                  ),

                  const Gap(16),

                  // Subject Filter Section
                  _buildFilterSection(
                    title: context.l10n!.subject,
                    isExpanded: _isSubjectExpanded,
                    onToggle: () => setState(
                        () => _isSubjectExpanded = !_isSubjectExpanded),
                    content: categoriesAsync.when(
                      data: (categories) {
                        if (filterState.selectedType == null) {
                          return Center(
                              child: Text(context.l10n!.selectTypeFirst));
                        }

                        final subjects = ref
                            .read(categoriesProvider.notifier)
                            .getUniqueSubjects(
                              categories,
                              filterState.selectedType,
                              filterState.selectedDivision,
                            );

                        return subjects.isEmpty
                            ? Center(
                                child: Text(context.l10n!.noSubjectsAvailable))
                            : _buildOptionsList(
                                items: subjects,
                                selectedValue: filterState.selectedSubject,
                                onSelected: (value) {
                                  ref
                                      .read(flashcardFilterProvider.notifier)
                                      .setSubject(value);
                                },
                              );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Center(child: Text('${context.l10n!.error}: $error')),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Gap(24),

          // Action Buttons
          Column(
            children: [
              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: const Color(0xff2970FF),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ref.read(flashcardFilterProvider.notifier).applyFilters();

                    // Refresh flashcard lists
                    ref.invalidate(exploreFlashcardsProvider);
                    ref.invalidate(userFlashcardsProvider);

                    Navigator.pop(context);
                  },
                  child: Text(
                    context.l10n!.applyFilter,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),

              if (filterState.isFilterActive) ...[
                const Gap(16),
                // Reset Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(color: Color(0xff2970FF)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      ref.read(flashcardFilterProvider.notifier).resetFilters();

                      // Refresh flashcard lists
                      ref.invalidate(exploreFlashcardsProvider);
                      ref.invalidate(userFlashcardsProvider);

                      Navigator.pop(context);
                    },
                    child: Text(
                      context.l10n!.resetFilter,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: const Color(0xff2970FF),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsList({
    required List<String> items,
    required String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      children: items.map((item) {
        final isSelected = item == selectedValue;

        return InkWell(
          onTap: () => onSelected(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // Radio button
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : null,
                ),
                const Gap(12),
                // Option text
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
