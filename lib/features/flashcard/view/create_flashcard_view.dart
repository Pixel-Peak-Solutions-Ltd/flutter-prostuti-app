import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';

import '../model/create_flash_card.dart';
import '../viewmodel/create_flashcard_viewmodel.dart';
import '../viewmodel/flashcard_viewmodel.dart';

class CreateFlashcardView extends ConsumerStatefulWidget {
  const CreateFlashcardView({super.key});

  @override
  CreateFlashcardViewState createState() => CreateFlashcardViewState();
}

class CreateFlashcardViewState extends ConsumerState<CreateFlashcardView>
    with CommonWidgets {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final String _categoryId = "6741c05482bf38e485f98152";
  String _visibility = "EVERYONE";
  final List<FlashcardItemFormField> _flashcardItems = [];

  @override
  void initState() {
    super.initState();
    // Add the first flashcard item by default
    _addFlashcardItem();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var item in _flashcardItems) {
      item.dispose();
    }
    super.dispose();
  }

  void _addFlashcardItem() {
    setState(() {
      _flashcardItems.add(FlashcardItemFormField());
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create the request object
      final request = CreateFlashcardRequest(
        title: _titleController.text.trim(),
        visibility: _visibility,
        categoryId: _categoryId,
        items: _flashcardItems
            .map((item) => FlashcardItemRequest(
                  term: item.termController.text.trim(),
                  answer: item.answerController.text.trim(),
                ))
            .toList(),
      );

      // Submit the request
      final success = await ref
          .read(createFlashcardNotifierProvider.notifier)
          .createFlashcard(request);

      if (success) {
        ref.invalidate(exploreFlashcardsProvider);
        ref.invalidate(userFlashcardsProvider);
        Navigator.pop(context, true);
        Fluttertoast.showToast(msg: 'ফ্লাশকার্ড সফলভাবে তৈরি হয়েছে!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final createFlashcardState = ref.watch(createFlashcardNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ফ্লাশকার্ড তৈরি করুন'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Nav().pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettingsModal,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title section
            Text(
              'টাইটেল',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Gap(8),
            // Input field with dashed border
            Container(
              decoration: DottedDecoration(
                color: const Color(0xFF2970FF),
                borderRadius: BorderRadius.circular(8),
                strokeWidth: 1.5,
                gap: 5,
              ),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'সাবজেক্ট, চাপ্টার এবং ইউনিট',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const Gap(24),

            // Flashcard items
            for (int i = 0; i < _flashcardItems.length; i++) ...[
              // Term field
              Text(
                'টার্ম',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(8),
              TextField(
                controller: _flashcardItems[i].termController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF2970FF), width: 1.5),
                  ),
                ),
              ),
              const Gap(16),

              // Answer field
              Text(
                'বিবরণ',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(8),
              TextField(
                controller: _flashcardItems[i].answerController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF2970FF), width: 1.5),
                  ),
                ),
              ),

              const Gap(24),
            ],

            // Add another flashcard item button
            InkWell(
              onTap: _addFlashcardItem,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF2970FF), width: 1.5),
                    ),
                    child: Icon(Icons.add,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 10),
                  ),
                  const Gap(10),
                  Text(
                    'আরেকটি কার্ড যোগ করুন',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ],
              ),
            ),

            const Gap(32),

            // Create button
            ElevatedButton(
              onPressed: createFlashcardState.isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2970FF),
                disabledBackgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                minimumSize: Size(SizeConfig.w(356), SizeConfig.h(48)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: createFlashcardState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'তৈরি করুন',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSettingsModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      // Enable making the modal fullscreen
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            String localVisibility = _visibility;
            return Padding(
              // Use Padding to avoid overlap with top safe area
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(right: SizeConfig.w(100)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            'অপশন সেট করুন',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Language Dropdown (Disabled)
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: const Text("Language"),
                              trailing: DropdownButton<String>(
                                value: "English",
                                items: ["English"]
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: null,
                              ),
                            ),
                          ),
                          // Visibility Dropdown
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: const Text("Visible By"),
                              trailing: DropdownButton<String>(
                                value: localVisibility,
                                items: ["EVERYONE", "ONLY_ME"]
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.contains("ONLY_ME")
                                              ? "Only me"
                                              : "Everyone"),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setModalState(
                                        () => localVisibility = value);
                                    setState(() => _visibility = value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Helper class to manage form controllers for flashcard items
class FlashcardItemFormField {
  final termController = TextEditingController();
  final answerController = TextEditingController();

  void dispose() {
    termController.dispose();
    answerController.dispose();
  }
}

// Custom class for drawing dotted borders
class DottedDecoration extends Decoration {
  final Color color;
  final BorderRadius borderRadius;
  final double strokeWidth;
  final double gap;

  const DottedDecoration({
    required this.color,
    required this.borderRadius,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DottedDecoration(
      color: color,
      borderRadius: borderRadius,
      strokeWidth: strokeWidth,
      gap: gap,
    );
  }
}

class _DottedDecoration extends BoxPainter {
  final Color color;
  final BorderRadius borderRadius;
  final double strokeWidth;
  final double gap;

  _DottedDecoration({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    final Rect rect = offset & configuration.size!;
    final RRect rrect = borderRadius.toRRect(rect);

    // Draw the dotted border
    final dashPath = _dashPath(
      Path()..addRRect(rrect),
      dashArray: CircularIntervalList<double>([strokeWidth, gap]),
    );

    canvas.drawPath(dashPath, paint);
  }

  Path _dashPath(
    Path source, {
    required CircularIntervalList<double> dashArray,
  }) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final double len = dashArray.next;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }
}

// Helper class for dash pattern
class CircularIntervalList<T> {
  final List<T> _values;
  int _index = 0;

  CircularIntervalList(this._values);

  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}
