import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Ensure this is imported
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/test/view/segment_test_pattern_view.dart';
import '../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../common/widgets/long_button.dart';
import '../../../core/services/nav.dart';
import '../../chat/viewmodel/user_category.dart';
import '../../flashcard/viewmodel/flashcard_filter_viewmodel.dart';
import '../../flashcard/widgets/category_picker.dart';
import '../viewmodel/question_pattern_viewmodel.dart';
import '../widgets/test_nevigation_button.dart';

class SegmentTestLandingView extends ConsumerStatefulWidget {
  const SegmentTestLandingView({super.key});

  @override
  ConsumerState<SegmentTestLandingView> createState() =>
      _SegmentTestLandingViewState();
}

class _SegmentTestLandingViewState extends ConsumerState<SegmentTestLandingView>
    with CommonWidgets {
  String? _selectedType;
  String? _selectedDivision;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await ref.read(categoriesProvider.future);
  }

  void _startSegmentTest() async {
    if (_selectedSubject == null || _selectedSubject!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please select a subject',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      final pattern = await ref
          .read(questionPatternViewmodelProvider.notifier)
          .loadFirstQuestionPattern(
        categoryType: _selectedType,
        categoryDivision: _selectedDivision,
        categorySubject: _selectedSubject,
      );

      if (pattern == null) {
        Fluttertoast.showToast(msg: 'No question pattern found');
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (_) => SegmentTestPatternView( pattern: pattern,)));

    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final userCategoryAsync = ref.watch(userCategoryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("সেগমেন্ট টেস্ট"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                'আপনার লক্ষ্যভিত্তিক পরীক্ষার জন্য নিচের প্রতিটি তথ্য নির্ভুলভাবে নির্বাচন করুন।',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(16),
              // Course field
              userCategoryAsync.when(
                data: (data) {
                  _selectedType = data;
                  return _buildFormField(
                    label: context.l10n?.course ?? 'কোর্স*',
                    child: categoriesAsync.when(
                      data: (categories) {
                        final types = ref
                            .read(categoriesProvider.notifier)
                            .getUniqueTypes(categories);
                        return _buildDropdown(
                          hint: context.l10n!.selectCourse,
                          value: _selectedType,
                          items: types,
                          onChanged: null,
                        );
                      },
                      loading: () => const Center(child: Text("Loading...")),
                      error: (_, __) => const Text('Failed to load categories'),
                    ),
                  );
                },
                loading: () => const Center(child: Text("Loading...")),
                error: (_, __) => const Text('Failed to load categories'),
              ),

              // Class field
              _buildFormField(
                label: context.l10n?.division ?? 'ক্লাস*',
                child: categoriesAsync.when(
                  data: (categories) {
                    final divisions = _selectedType != null
                        ? ref
                            .read(categoriesProvider.notifier)
                            .getUniqueDivisions(categories, _selectedType)
                        : <String>[];
                    return _buildDropdown(
                      hint: context.l10n?.selectDivision ?? 'নবম শ্রেণী',
                      value: _selectedDivision,
                      items: divisions,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDivision = newValue;
                          _selectedSubject = null;
                        });
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Failed to load divisions'),
                ),
              ),

              // Subject field
              _buildFormField(
                label: context.l10n?.subject ?? 'সাবজেক্ট*',
                child: categoriesAsync.when(
                  data: (categories) {
                    final subjects = _selectedType != null
                        ? ref
                            .read(categoriesProvider.notifier)
                            .getUniqueSubjects(
                              categories,
                              _selectedType,
                              _selectedDivision,
                            )
                        : <String>[];
                    return _buildDropdown(
                      hint: context.l10n?.selectSubject ?? 'বিজ্ঞান',
                      value: _selectedSubject,
                      items: subjects,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Failed to load subjects'),
                ),
              ),

              LongButton(
                onPressed:_startSegmentTest,
                text: "পরবর্তী",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Gap(8),
        child,
        const Gap(16),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?)? onChanged,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              hint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: value,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            borderRadius: BorderRadius.circular(8),
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
