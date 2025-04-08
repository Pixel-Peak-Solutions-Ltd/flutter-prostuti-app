import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/chat/viewmodel/broadcast_viewmodel.dart';
import 'package:prostuti/features/flashcard/viewmodel/flashcard_filter_viewmodel.dart';

// State provider for broadcast form loading state
final broadcastLoadingProvider = StateProvider<bool>((ref) => false);

class CreateBroadcastView extends ConsumerStatefulWidget {
  const CreateBroadcastView({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateBroadcastView> createState() =>
      _CreateBroadcastViewState();
}

class _CreateBroadcastViewState extends ConsumerState<CreateBroadcastView>
    with CommonWidgets {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _nameController = TextEditingController();
  final _problemController = TextEditingController();

  String? _selectedType;
  String? _selectedDivision;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    // This will trigger the categories provider to load data
    await ref.read(categoriesProvider.future);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _nameController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  Future<void> _submitBroadcast() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    if (_selectedSubject == null || _selectedSubject!.isEmpty) {
      Fluttertoast.showToast(
        msg: context.l10n?.subject ?? 'Please select a subject',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    // Set loading state
    ref.read(broadcastLoadingProvider.notifier).state = true;

    try {
      // Send broadcast request
      final success = await ref
          .read(broadcastNotifierProvider.notifier)
          .createBroadcastRequest(
            message: _messageController.text.trim(),
            subject: _selectedSubject!,
          );

      if (success) {
        Fluttertoast.showToast(
          msg: context.l10n?.questionSent ??
              'Your question has been sent. A teacher will respond soon.',
          toastLength: Toast.LENGTH_LONG,
        );
        Nav().pop();
      } else {
        Fluttertoast.showToast(
          msg: context.l10n?.error ?? 'Failed to send question',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${context.l10n?.error ?? 'Error'}: $e',
        toastLength: Toast.LENGTH_SHORT,
      );
    } finally {
      // Reset loading state
      ref.read(broadcastLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(broadcastLoadingProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(48),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitBroadcast,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    context.l10n?.startChat ?? 'চাট শুরু করুন',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
          ),
        ),
      ),
      appBar: commonAppbar(context.l10n!.broadcast),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course field
              _buildFormField(
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
                      onChanged: (newValue) {
                        setState(() {
                          _selectedType = newValue;
                          _selectedDivision = null;
                          _selectedSubject = null;
                        });
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Failed to load categories'),
                ),
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

              // Name field
              // _buildFormField(
              //   label: context.l10n?.name ?? 'নাম*',
              //   child: TextFormField(
              //     controller: _nameController,
              //     decoration: InputDecoration(
              //       hintText: context.l10n?.yourName ?? 'নাজমুল ইসলাম সিফাত',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       contentPadding: const EdgeInsets.symmetric(
              //           horizontal: 16, vertical: 16),
              //     ),
              //     validator: (value) {
              //       if (value == null || value.trim().isEmpty) {
              //         return context.l10n?.mustNotBeEmpty ??
              //             'Name must not be empty';
              //       }
              //       return null;
              //     },
              //   ),
              // ),

              // Problem field
              // _buildFormField(
              //   label: context.l10n?.problem ?? 'সমস্যা*',
              //   child: TextFormField(
              //     controller: _problemController,
              //     decoration: InputDecoration(
              //       hintText: context.l10n?.problemHint ?? 'সমস্যা ২৪.২',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       contentPadding: const EdgeInsets.symmetric(
              //           horizontal: 16, vertical: 16),
              //     ),
              //     validator: (value) {
              //       if (value == null || value.trim().isEmpty) {
              //         return context.l10n?.mustNotBeEmpty ??
              //             'Problem must not be empty';
              //       }
              //       return null;
              //     },
              //   ),
              // ),

              // Question field
              _buildFormField(
                label: context.l10n!.yourQuestion,
                child: TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: context.l10n?.questionHint ??
                        'জীবনে সবচেয়ে সম্পূর্ণ মানুষরা। কিন্তু সবচেয়ে অসম্পূর্ণ হয় যে জনপ্রিয় করে। যার তাকে তার জীবনযাত্রার অনেক-আনা প্রশ্নের নিয়ে আসে তৃতিয়র মার্খানা থেকে?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusColor: Theme.of(context).unselectedWidgetColor,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n?.mustNotBeEmpty ??
                          'Question must not be empty';
                    }
                    return null;
                  },
                ),
              ),

              const Gap(32),
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.8),
          ),
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
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(hint),
            value: value,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            borderRadius: BorderRadius.circular(8),
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
