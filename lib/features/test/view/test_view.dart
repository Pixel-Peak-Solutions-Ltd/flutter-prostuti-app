import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/test/view/quizer_test_view.dart';
import 'package:prostuti/features/test/view/segment_test_view.dart';
import '../../../common/widgets/common_widgets/common_widgets.dart';
import '../../../core/services/nav.dart';
import '../widgets/test_nevigation_button.dart';
import 'mock_test_view.dart';

class TestLandingView extends StatelessWidget with CommonWidgets {
   TestLandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          context.l10n!.test
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: appTheme.appBarTheme.backgroundColor,
      ),
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
                'টেস্টের ধরণ সিলেক্ট করুন',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Gap(16),
              Text(
                'টেস্ট হলো আপনার প্রস্তুতির সবকিছু এক জায়গায় - মক টেস্ট, সেগমেন্ট টেস্ট, কুইজার। নির্বাচন করুন, পরীক্ষা দিন, ফলাফল দেখুন, ভুলগুলো থেকে শিখুন। প্রস্তুতি হোক আরও সহজ ও কার্যকর!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(24),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.antiAlias,

                      child: TestButton(
                        label: 'সেগমেন্ট টেস্ট',
                        borderColor: borderColor,
                        svgAsset: 'assets/images/segment_test_background.svg',
                        onTap: () {
                          Nav().push( const SegmentTestLandingView());
                        },
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: TestButton(
                      label: 'মক-টেস্ট',
                      borderColor: borderColor,
                      svgAsset: 'assets/images/mock_test_background.svg',
                      onTap: () {
                        Nav().push( const MockTestLandingView());
                      },
                    ),
                  ),
                ],
              ),

              const Gap(12),
              TestButton(
                label: 'কুইজার',
                borderColor: borderColor,
                svgAsset: 'assets/images/quizer_background.svg',
                fullWidth: true,
                onTap: () {
                  Nav().push( const QuizerTestLandingView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

