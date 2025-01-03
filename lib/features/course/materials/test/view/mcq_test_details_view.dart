import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/features/course/materials/test/viewmodel/mcq_test_details_viewmodel.dart';

import '../../../../../common/helpers/func.dart';
import '../../../../../core/configs/app_colors.dart';
import '../../../../../core/services/nav.dart';
import '../../assignment/widgets/assignment_skeleton.dart';
import '../widgets/build_test_time_row.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/test_skeleton.dart';
import 'mcq_mock_test_view.dart';

class MCQTestDetailsView extends ConsumerStatefulWidget {
  const MCQTestDetailsView({Key? key}) : super(key: key);

  @override
  TestDetailsViewState createState() => TestDetailsViewState();
}

class TestDetailsViewState extends ConsumerState<MCQTestDetailsView>
    with CommonWidgets {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final mCQTestDetailsAsync = ref.watch(mCQTestDetailsViewmodelProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: commonAppbar("টেস্ট"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: mCQTestDetailsAsync.when(
            data: (test) {
              final time = Func.timeConverterMinToHour(test.data!.time!.toInt());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "টপিক",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(6),
                  Container(
                    height: size.height * .06,
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textActionPrimaryLight,
                      border: Border.all(color: AppColors.shadeNeutralLight),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 14),
                      child: Text(
                        test.data!.name.toString(),
                        style: theme.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const Gap(24),
                  Text(
                    "টেস্ট টাইপ",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(6),
                  Container(
                    height: size.height * .06,
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textActionPrimaryLight,
                      border: Border.all(color: AppColors.shadeNeutralLight),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 14),
                      child: Text(
                        test.data!.type.toString(),
                        style: theme.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const Gap(24),
                  Text(
                    "প্রশ্ন সংখ্যা",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(6),
                  Container(
                    height: size.height * .06,
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textActionPrimaryLight,
                      border: Border.all(color: AppColors.shadeNeutralLight),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 14),
                      child: Text(
                        test.data!.questionList!.length.toString(),
                        style: theme.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const Gap(24),
                  buildTestTimeRow(theme, time['hour'].toString(), time['minute'].toString()),
                  const Gap(24),
                  // Start Test Button
                  LongButton(onPressed: () {
                    Nav().pushReplacement(const MCQMockTestScreen());
                  }, text: "টেস্ট শুরু করুন")
                ],
              );
            },
            error: (error, stackTrace) {
              print(error);
              print(stackTrace);
            },
            loading: () => const TestDetailsSkeleton(),
          ),
        ),
      ),
    );
  }
}
