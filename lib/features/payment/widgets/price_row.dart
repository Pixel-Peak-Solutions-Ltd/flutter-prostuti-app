// lib/features/payment/widgets/price_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/payment/viewmodel/voucher_viewmodel.dart';

class PriceRow extends ConsumerWidget {
  final String price;
  final String name;
  final String? id;
  final bool showVoucherDetails;

  const PriceRow({
    super.key,
    required this.price,
    required this.name,
    this.id,
    this.showVoucherDetails = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voucherState = ref.watch(voucherNotifierProvider);
    final originalPrice = double.tryParse(price) ?? 0.0;

    // Only show simple row if not showing voucher details
    if (!showVoucherDetails) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            "৳ $price",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    // If there's an active voucher
    if (voucherState.hasValue && voucherState.value != null) {
      final voucherNotifier = ref.read(voucherNotifierProvider.notifier);
      final discountAmount = voucherNotifier.getDiscountAmount(originalPrice);
      final finalPrice = originalPrice - discountAmount;

      return Column(
        children: [
          // Original course price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                "৳ $price",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Gap(8),

          // Discount amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${context.l10n?.discount ?? 'Discount'} (${voucherState.value!.title})",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.green,
                    ),
              ),
              Text(
                "- ৳ ${discountAmount.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.green,
                    ),
              ),
            ],
          ),
          const Gap(8),

          // Final price after discount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n?.total ?? "Total",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                "৳ ${finalPrice.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      );
    }

    // Regular price row without voucher
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          "৳ $price",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
