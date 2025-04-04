import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:prostuti/features/payment/view/easy_checkout.dart';
import 'package:prostuti/features/payment/viewmodel/check_subscription.dart';
import 'package:prostuti/features/payment/widgets/subscription_card.dart';

import '../../../core/services/debouncer.dart';
import '../viewmodel/selected_index.dart';
import '../widgets/terms_condition.dart';

final _loadingProvider = StateProvider<bool>((ref) => false);

class SubscriptionView extends ConsumerWidget with CommonWidgets {
  SubscriptionView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final List<Map<String, String>> plans = [
      {'plan': 'Premium', 'price': '৳ ${500 * 12}', 'duration': '1 year'},
      {'plan': 'Standard', 'price': '৳ ${500 * 6}', 'duration': '6 months'},
      {'plan': 'Basic', 'price': '৳ ${500}', 'duration': '1 month'},
    ];

    final selectedIndex = ref.watch(selectedIndexNotifierProvider);
    final subscriptionAsyncValue = ref.watch(userSubscribedProvider);
    final _debouncer = Debouncer(milliseconds: 120);
    final isLoading = ref.watch(_loadingProvider);

    return Scaffold(
        appBar: commonAppbar(context.l10n!.subscription),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16)),
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(selectedIndexNotifierProvider.notifier)
                        .updateIndex(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SubscriptionCard(
                      plan: plan['plan']!,
                      price: plan['price']!,
                      duration: plan['duration']!,
                      isSelected: index == selectedIndex,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: subscriptionAsyncValue.when(
          data: (isSubscribed) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: SizeConfig.h(150),
              child: Column(
                children: [
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: isLoading
                              ? () {}
                              : () {
                                  _debouncer.run(
                                      action: () async {
                                        final response = await ref
                                            .read(paymentRepoProvider)
                                            .subscribe({
                                          "requestedPlan":
                                              "${plans[selectedIndex]['duration']}"
                                        });

                                        Nav().pushReplacement(EasyCheckout(
                                            url: response.toString()));
                                      },
                                      loadingController:
                                          ref.read(_loadingProvider.notifier));
                                },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              backgroundColor: const Color(0xff2970FF),
                              fixedSize:
                                  Size(SizeConfig.w(356), SizeConfig.h(54))),
                          child: Text(
                            context.l10n!.payNow,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                          ),
                        ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () {
                      showMaterialModalBottomSheet(
                        enableDrag: true,
                        expand: false,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        bounce: true,
                        context: context,
                        builder: (context) => const TermsCondition(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xff155EEF), width: 3),
                            borderRadius: BorderRadius.circular(4)),
                        backgroundColor: const Color(0xffD1E0FF),
                        fixedSize: Size(SizeConfig.w(356), SizeConfig.h(54))),
                    child: Text(
                      context.l10n!.termsAndConditions,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: const Color(0xff2970FF),
                          fontWeight: FontWeight.w900),
                    ),
                  )
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            Center(
              child: Text('$error'),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
