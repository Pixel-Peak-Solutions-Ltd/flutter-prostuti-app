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

class _CategoryPickerState extends ConsumerState<CategoryPicker>
    with SingleTickerProviderStateMixin {
  String? _selectedType;
  String? _selectedDivision;
  String? _selectedSubject;
  String? _selectedCategoryId;

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _initializeFromSettings();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    final isDarkMode = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n!.selectCategory,
            style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSecondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface,
                size: 20,
              ),
            ),
            onPressed: widget.onClose,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),
        body: FadeTransition(
          opacity: _fadeInAnimation,
          child: categoriesAsync.when(
            data: (categories) => _buildContent(context, categories),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const Gap(16),
                  Text(
                    '${context.l10n!.error}: $error',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Filter chips with modern design
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? theme.cardColor.withOpacity(0.5)
                : theme.colorScheme.secondary.withOpacity(0.05),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // Type filter
                _buildFilterDropdown(
                  context,
                  context.l10n!.type,
                  Icons.category_outlined,
                  _selectedType,
                  types,
                  (value) {
                    setState(() {
                      _selectedType = value;
                      _selectedDivision = null;
                      _selectedSubject = null;
                      _selectedCategoryId = null;
                    });
                  },
                ),
                if (_selectedType != null && divisions.isNotEmpty) ...[
                  const Gap(8),
                  _buildFilterDropdown(
                    context,
                    context.l10n!.division,
                    Icons.business_outlined,
                    _selectedDivision,
                    divisions,
                    (value) {
                      setState(() {
                        _selectedDivision = value;
                        _selectedSubject = null;
                        _selectedCategoryId = null;
                      });
                    },
                  ),
                ],
                if (_selectedType != null && subjects.isNotEmpty) ...[
                  const Gap(8),
                  _buildFilterDropdown(
                    context,
                    context.l10n!.subject,
                    Icons.subject_outlined,
                    _selectedSubject,
                    subjects,
                    (value) {
                      setState(() {
                        _selectedSubject = value;
                        _selectedCategoryId = null;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ),

        const Gap(16),

        // Categories heading
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                context.l10n!.category,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${filteredCategories.length}',
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              if (_selectedType != null ||
                  _selectedDivision != null ||
                  _selectedSubject != null)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedType = null;
                      _selectedDivision = null;
                      _selectedSubject = null;
                      _selectedCategoryId = null;
                    });
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                  label: Text(
                    context.l10n!.resetFilter,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ),

        // Categories list
        Expanded(
          child: filteredCategories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      const Gap(16),
                      Text(
                        context.l10n!.noCategoriesAvailable,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Text(
                        context.l10n!.tryAgainLater,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.builder(
                    key: ValueKey<String>(
                        '${_selectedType}_${_selectedDivision}_${_selectedSubject}'),
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryItem(
                          context, filteredCategories[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context,
    String label,
    IconData icon,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: selectedValue != null
            ? theme.colorScheme.secondary.withOpacity(0.1)
            : theme.colorScheme.onSecondary.withOpacity(0.1),
        border: Border.all(
          color: selectedValue != null
              ? theme.colorScheme.secondary
              : Colors.transparent,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              const Gap(6),
              Text(
                label,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.secondary,
          ),
          dropdownColor: theme.scaffoldBackgroundColor,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: item == selectedValue
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category) {
    final isSelected = category.sId == _selectedCategoryId;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _selectCategory(category),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.secondary
                    : theme.unselectedWidgetColor.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
              color: isSelected
                  ? theme.colorScheme.secondary.withOpacity(0.1)
                  : isDarkMode
                      ? theme.cardColor
                      : theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.secondary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Left side with radio and selection indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.secondary
                          : theme.unselectedWidgetColor.withOpacity(0.5),
                      width: 2,
                    ),
                    color: isSelected
                        ? theme.colorScheme.secondary.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        )
                      : null,
                ),

                const Gap(16),

                // Content with improved hierarchy
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject as main title
                      Text(
                        category.subject ?? '',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color:
                              isSelected ? theme.colorScheme.secondary : null,
                        ),
                      ),

                      const Gap(4),

                      // Type, Division, Chapter as chips in a row
                      if (category.type != null ||
                          category.division != null ||
                          category.chapter != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (category.type != null &&
                                category.type!.isNotEmpty)
                              _buildCategoryChip(
                                category.type!,
                                Icons.category_outlined,
                                isSelected,
                              ),
                            if (category.division != null &&
                                category.division!.isNotEmpty)
                              _buildCategoryChip(
                                category.division!,
                                Icons.business_outlined,
                                isSelected,
                              ),
                            if (category.chapter != null &&
                                category.chapter!.isNotEmpty)
                              _buildCategoryChip(
                                category.chapter!,
                                Icons.book_outlined,
                                isSelected,
                              ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Selected indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.secondary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool isSelected) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.secondary.withOpacity(0.1)
            : theme.colorScheme.onSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isSelected
                ? theme.colorScheme.secondary
                : theme.colorScheme.onSurface,
          ),
          const Gap(4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
