// lib/features/payment/widgets/voucher_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/payment/viewmodel/voucher_viewmodel.dart';
import 'package:prostuti/features/payment/widgets/voucher_bottom_sheet.dart';

import '../model/voucher_model.dart';

class VoucherSelector extends ConsumerWidget {
  final String? courseId;
  final double originalPrice;
  final Function(bool) onVoucherApplied;

  const VoucherSelector({
    Key? key,
    this.courseId,
    required this.originalPrice,
    required this.onVoucherApplied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voucherState = ref.watch(voucherNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Gap(16),
        Text(
          context.l10n?.vouchers ?? 'Vouchers',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(8),

        // Selected voucher or button to select
        if (voucherState.hasValue && voucherState.value != null)
          _buildAppliedVoucher(context, ref, voucherState.value!)
        else
          _buildSelectVoucherButton(context, ref),

        // Show error if any
        if (voucherState.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              voucherState.error.toString(),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),

        const Divider(),
        const Gap(16),
      ],
    );
  }

  Widget _buildAppliedVoucher(
      BuildContext context, WidgetRef ref, VoucherModel voucher) {
    final voucherNotifier = ref.read(voucherNotifierProvider.notifier);
    final discountAmount = voucherNotifier.getDiscountAmount(originalPrice);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.local_offer, color: Colors.green, size: 20),
                const Gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher.title ?? 'Discount Voucher',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${context.l10n?.discountApplied ?? 'Discount applied'}: ৳${discountAmount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              voucherNotifier.clearVoucher();
              onVoucherApplied(false);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 36),
            ),
            child: Text(context.l10n?.remove ?? 'Remove'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectVoucherButton(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _showVoucherBottomSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const Gap(8),
                Text(
                  context.l10n?.selectVoucher ?? 'Select voucher',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  void _showVoucherBottomSheet(BuildContext context, WidgetRef ref) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => VoucherBottomSheet(
        courseId: courseId,
        originalPrice: originalPrice,
        onVoucherSelected: (voucher) {
          _applyVoucher(ref, voucher);
        },
      ),
    );
  }

  void _applyVoucher(WidgetRef ref, VoucherModel voucher) {
    final voucherNotifier = ref.read(voucherNotifierProvider.notifier);

    // Apply the voucher
    ref.read(voucherNotifierProvider.notifier).state = AsyncValue.data(voucher);

    // Notify the parent that a voucher has been applied
    onVoucherApplied(true);

    // Show success toast
    Fluttertoast.showToast(
      msg: 'Voucher applied successfully!',
      backgroundColor: Colors.green,
    );
  }
}
