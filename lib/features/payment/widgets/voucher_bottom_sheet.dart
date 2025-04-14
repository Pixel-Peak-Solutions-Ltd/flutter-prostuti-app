// lib/features/payment/widgets/voucher_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/payment/viewmodel/voucher_list_viewmodel.dart';

import '../model/voucher_model.dart';

class VoucherBottomSheet extends ConsumerWidget {
  final String? courseId;
  final double originalPrice;
  final Function(VoucherModel) onVoucherSelected;

  const VoucherBottomSheet({
    Key? key,
    this.courseId,
    required this.originalPrice,
    required this.onVoucherSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersAsync =
        ref.watch(voucherListNotifierProvider(courseId: courseId));

    return Container(
      height: SizeConfig.screenHeight * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Gap(16),
          _buildSearchInput(context),
          const Gap(16),
          Expanded(
            child: vouchersAsync.when(
              data: (vouchers) => _buildVoucherList(context, vouchers, ref),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n?.availableVouchers ?? 'Available Vouchers',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          onPressed: () => Nav().pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: context.l10n?.searchVouchers ?? 'Search vouchers',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildVoucherList(
      BuildContext context, List<VoucherModel> vouchers, WidgetRef ref) {
    if (vouchers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const Gap(16),
            Text(
              context.l10n?.noVouchersAvailable ?? 'No vouchers available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(voucherListNotifierProvider(courseId: courseId).notifier)
            .refreshVouchers(courseId);
      },
      child: ListView.separated(
        itemCount: vouchers.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final voucher = vouchers[index];
          return _buildVoucherCard(context, voucher);
        },
      ),
    );
  }

  Widget _buildVoucherCard(BuildContext context, VoucherModel voucher) {
    // Calculate the discount amount for this voucher based on the original price
    final discountAmount = voucher.calculateDiscount(originalPrice);
    final discountValue = voucher.discountType == 'Percentage'
        ? '${voucher.discountValue.toStringAsFixed(0)}%'
        : '৳${voucher.discountValue.toStringAsFixed(0)}';

    // Format the expiry date
    final expiryDate = DateFormat('dd MMM yyyy').format(voucher.endDate);

    // Determine if this is a special voucher
    final isStudentSpecific = voucher.voucherType == 'Specific_Student';
    final isCourseSpecific = voucher.voucherType == 'Specific_Course';

    return InkWell(
      onTap: () {
        onVoucherSelected(voucher);
        Nav().pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isStudentSpecific
                ? [Colors.purple.shade50, Colors.purple.shade100]
                : isCourseSpecific
                    ? [Colors.blue.shade50, Colors.blue.shade100]
                    : [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    voucher.title ?? 'Discount Voucher',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isStudentSpecific
                        ? Colors.purple
                        : isCourseSpecific
                            ? Colors.blue
                            : Colors.green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    discountValue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                    const Gap(4),
                    Text(
                      '${context.l10n?.expiresOn ?? 'Expires on'} $expiryDate',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  isStudentSpecific
                      ? (context.l10n?.specialForYou ?? 'Special for you!')
                      : isCourseSpecific
                          ? (context.l10n?.courseSpecific ?? 'Course specific')
                          : (context.l10n?.generalVoucher ?? 'General voucher'),
                  style: TextStyle(
                    color: isStudentSpecific
                        ? Colors.purple.shade700
                        : isCourseSpecific
                            ? Colors.blue.shade700
                            : Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.l10n?.youSave ?? 'You save'}: ৳${discountAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  context.l10n?.tapToApply ?? 'Tap to apply',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
