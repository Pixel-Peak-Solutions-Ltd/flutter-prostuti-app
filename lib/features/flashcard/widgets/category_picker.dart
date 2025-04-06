import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';

import '../model/category_model.dart';
import '../viewmodel/flashcard_filter_viewmodel.dart';
import '../viewmodel/flashcard_settings_viewmodel.dart';

class CategoryPicker extends ConsumerStatefulWidget {
  final Function(String) onCategorySelected;
  final VoidCallback onClose;

  const CategoryPicker({
    super.key,
    required this.onCategorySelected,
    required this.onClose,
  });

  @override
  ConsumerState<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends ConsumerState<CategoryPicker> {
  String? _selectedType;
  String? _selectedDivision;
  String? _selectedSubject;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _initializeFromSettings();
  }

  Future<void> _initializeFromSettings() async {
    final settings = await ref.read(flashcardSettingsNotifierProvider.future);
    setState(() {
      _selectedType = settings.categoryType;
      _selectedDivision = settings.categoryDivision;
      _selectedSubject = settings.categorySubject;
      _selectedCategoryId = settings.categoryId;
    });
  }

  void _selectCategory(Category category) {
    setState(() {
      _selectedCategoryId = category.sId;
    });

    // Save settings
    ref.read(flashcardSettingsNotifierProvider.notifier).setCategoryDetails(
          categoryId: category.sId,
          categoryType: _selectedType,
          categoryDivision: _selectedDivision,
          categorySubject: _selectedSubject,
        );

    // Notify parent
    widget.onCategorySelected(category.sId!);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);
    final isPrimary = theme.colorScheme.secondary;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n!.selectCategory),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: categoriesAsync.when(
            data: (categories) => _buildContent(context, categories),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text('${context.l10n!.error}: $error'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Category> categories) {
    // Get unique values for filters
    final types =
        ref.read(categoriesProvider.notifier).getUniqueTypes(categories);
    final divisions = _selectedType != null
        ? ref.read(categoriesProvider.notifier).getUniqueDivisions(
              categories,
              _selectedType,
            )
        : <String>[];
    final subjects = _selectedType != null
        ? ref.read(categoriesProvider.notifier).getUniqueSubjects(
              categories,
              _selectedType,
              _selectedDivision,
            )
        : <String>[];

    // Filter categories based on selections
    List<Category> filteredCategories = categories;
    if (_selectedType != null) {
      filteredCategories =
          filteredCategories.where((c) => c.type == _selectedType).toList();

      if (_selectedDivision != null) {
        filteredCategories = filteredCategories
            .where((c) => c.division == _selectedDivision)
            .toList();

        if (_selectedSubject != null) {
          filteredCategories = filteredCategories
              .where((c) => c.subject == _selectedSubject)
              .toList();
        }
      }
    }

    return Column(
      children: [
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Type filter
              _buildFilterDropdown(
                context,
                context.l10n!.type,
                _selectedType,
                types,
                (value) {
                  setState(() {
                    _selectedType = value;
                    _selectedDivision = null;
                    _selectedSubject = null;
                  });
                },
              ),
              if (_selectedType != null && divisions.isNotEmpty) ...[
                const Gap(8),
                _buildFilterDropdown(
                  context,
                  context.l10n!.division,
                  _selectedDivision,
                  divisions,
                  (value) {
                    setState(() {
                      _selectedDivision = value;
                      _selectedSubject = null;
                    });
                  },
                ),
              ],
              if (_selectedType != null && subjects.isNotEmpty) ...[
                const Gap(8),
                _buildFilterDropdown(
                  context,
                  context.l10n!.subject,
                  _selectedSubject,
                  subjects,
                  (value) {
                    setState(() {
                      _selectedSubject = value;
                    });
                  },
                ),
              ],
            ],
          ),
        ),

        const Gap(16),

        // Divider
        const Divider(height: 1),

        const Gap(16),

        // Categories list
        Expanded(
          child: filteredCategories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined,
                          size: 48,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5)),
                      const Gap(16),
                      Text(
                        context.l10n!.noCategoriesAvailable,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(
                        context, filteredCategories[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context,
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text(label),
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.keyboard_arrow_down, size: 18),
        borderRadius: BorderRadius.circular(8),
        style: Theme.of(context).textTheme.bodyMedium,
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category) {
    final isSelected = category.sId == _selectedCategoryId;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _selectCategory(category),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: theme.unselectedWidgetColor),
            color: isSelected ? theme.colorScheme.secondary : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: category.sId ?? '',
                groupValue: _selectedCategoryId,
                activeColor: Colors.black,
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                    _selectCategory(category);
                  }
                },
              ),
              const Gap(12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject
                    Text(
                      category.subject ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w100,
                      ),
                    ),

                    // Type > Division > Chapter
                    if (category.type != null ||
                        category.division != null ||
                        category.chapter != null)
                      Text(
                        [
                          category.type,
                          if (category.division != null &&
                              category.division!.isNotEmpty)
                            category.division,
                          if (category.chapter != null &&
                              category.chapter!.isNotEmpty)
                            category.chapter,
                        ].where((e) => e != null).join(' > '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSecondaryContainer,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Selected indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.unselectedWidgetColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
