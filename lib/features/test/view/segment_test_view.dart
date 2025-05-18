import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../core/services/nav.dart';
import '../../flashcard/widgets/category_picker.dart';
import '../widgets/test_nevigation_button.dart';

class SegmentTestLandingView extends StatelessWidget with CommonWidgets {
  SegmentTestLandingView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: commonAppbar("সেগমেন্ট টেস্ট"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Text(
                'আপনার লক্ষ্যভিত্তিক পরীক্ষার জন্য নিচের প্রতিটি তথ্য নির্ভুলভাবে নির্বাচন করুন।',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Gap(16),
              CategoryPicker(
                onCategorySelected: (categoryId) {

                },
                onClose: () => Navigator.pop(context),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

