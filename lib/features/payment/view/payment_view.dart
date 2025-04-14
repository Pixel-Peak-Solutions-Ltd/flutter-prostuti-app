// lib/features/payment/view/payment_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/payment/view/easy_checkout.dart';
import 'package:prostuti/features/payment/viewmodel/payment_viewmodel.dart';
import 'package:prostuti/features/payment/viewmodel/voucher_viewmodel.dart';
import 'package:prostuti/features/payment/widgets/course_name_price.dart';
import 'package:prostuti/features/payment/widgets/price_row.dart';
import 'package:prostuti/features/payment/widgets/voucher_selector.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/services/debouncer.dart';
import '../../../core/services/size_config.dart';
import '../../course/course_details/view/course_details_view.dart';
import '../../course/course_list/viewmodel/course_list_viewmodel.dart';
import '../../course/course_list/viewmodel/get_course_by_id.dart';
import '../widgets/stepper.dart';

final _loadingProvider = StateProvider<bool>((ref) => false);
final _voucherAppliedProvider = StateProvider<bool>((ref) => false);

class PaymentView extends ConsumerWidget with CommonWidgets {
  final String id, name, imgPath, price;

  PaymentView({
    super.key,
    required this.id,
    required this.name,
    required this.imgPath,
    required this.price,
  });

  @override
  Widget build(BuildContext context, ref) {
    final _debouncer = Debouncer(milliseconds: 120);

    final publishedCourseNotifier = ref.watch(publishedCourseProvider.notifier);
    final publishedCourseAsync = ref.watch(publishedCourseProvider);
    final isLoading = ref.watch(_loadingProvider);
    final voucherState = ref.watch(voucherNotifierProvider);
    final isVoucherApplied = ref.watch(_voucherAppliedProvider);
    final paymentNotifier = ref.watch(paymentNotifierProvider.notifier);

    // Calculate the final price considering vouchers
    final originalPrice = double.tryParse(price) ?? 0.0;
    final finalPrice = voucherState.hasValue && voucherState.value != null
        ? ref
            .read(voucherNotifierProvider.notifier)
            .getFinalPrice(originalPrice)
        : originalPrice;

    return Scaffold(
      appBar: commonAppbar("Cart"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Tracker(),
                const Gap(24),
                const Divider(),
                const Gap(24),
                CourseNamePrice(
                    name: name, imgPath: imgPath, price: "৳ $price"),
                const Gap(24),

                // Voucher selector with bottom sheet
                VoucherSelector(
                  courseId: id,
                  originalPrice: originalPrice,
                  onVoucherApplied: (applied) {
                    ref.read(_voucherAppliedProvider.notifier).state = applied;
                  },
                ),

                Text(
                  'টপ কোর্সগুলো দেখুন',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(16),
                SizedBox(
                  height: SizeConfig.h(100),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: publishedCourseNotifier.filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course =
                          publishedCourseNotifier.filteredCourses[index];

                      return Skeletonizer(
                        enabled: publishedCourseAsync.isLoading,
                        child: course.priceType == "Paid"
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .watch(getCourseByIdProvider.notifier)
                                        .setId(course.sId!);
                                    Nav().push(const CourseDetailsView());
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              course.image!.path!,
                                              height: SizeConfig.h(50),
                                              width: SizeConfig.w(80),
                                              filterQuality: FilterQuality.high,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                              right: 2,
                                              bottom: 2,
                                              child: Icon(
                                                id == course.sId!
                                                    ? Icons.check_circle
                                                    : Icons.add_box,
                                                size: 22,
                                                color: Colors.purple,
                                              ))
                                        ],
                                      ),
                                      const Gap(16),
                                      SizedBox(
                                        width: SizeConfig.w(80),
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          course.name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      );
                    },
                  ),
                ),
                const Gap(16),
                // TextButton(
                //   style: TextButton.styleFrom(
                //       padding: EdgeInsets.zero,
                //       minimumSize: const Size(50, 30),
                //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //       alignment: Alignment.centerLeft),
                //   onPressed: () {
                //     Nav().pushReplacement(CourseListView());
                //   },
                //   child: Text(
                //     context.l10n!.courses,
                //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                //         color: Colors.blue, fontWeight: FontWeight.w600),
                //   ),
                // ),
                const Gap(24),
                Text(
                  'হিসাবের বিস্তারিত',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(16),

                // Use updated PriceRow with voucher support
                PriceRow(
                  price: price,
                  name: name,
                  id: id,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          height: SizeConfig.h(60),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        backgroundColor: const Color(0xff2970FF),
                        fixedSize: Size(SizeConfig.w(356), SizeConfig.h(54))),
                    onPressed: isLoading
                        ? null
                        : () async {
                            _debouncer.run(
                              action: () async {
                                // Debug print for payload
                                print(
                                    "Initiating payment with amount: $finalPrice, course: $id, voucher: $isVoucherApplied");

                                final paymentUrl =
                                    await paymentNotifier.initiatePayment(
                                  courseId: id,
                                  totalPrice: finalPrice,
                                  applyVoucher: isVoucherApplied,
                                );

                                if (paymentUrl != null &&
                                    paymentUrl.isNotEmpty) {
                                  print("Payment URL received: $paymentUrl");
                                  // Valid URL received, navigate to checkout
                                  Nav().pushReplacement(
                                    EasyCheckout(url: paymentUrl),
                                  );
                                } else {
                                  // No URL received, check for error or already enrolled
                                  final paymentState =
                                      ref.read(paymentNotifierProvider);
                                  if (paymentState.hasError) {
                                    print(
                                        "Payment error: ${paymentState.error}");
                                    Fluttertoast.showToast(
                                      msg: paymentState.error.toString(),
                                    );
                                  } else {
                                    // Could be already enrolled
                                    Fluttertoast.showToast(
                                      msg:
                                          "You are already enrolled in this course",
                                    );
                                  }
                                }
                              },
                              loadingController:
                                  ref.read(_loadingProvider.notifier),
                            );
                          },
                    child: Text(
                      context.l10n!.payNow,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
