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

// Helper class for voucher card colors
class VoucherColors {
  final Color startColor;
  final Color endColor;
  final Color badgeColor;
  final Color labelColor;

  VoucherColors({
    required this.startColor,
    required this.endColor,
    required this.badgeColor,
    required this.labelColor,
  });
}

// State provider for search query
final _searchQueryProvider = StateProvider<String>((ref) => '');

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
    final searchQuery = ref.watch(_searchQueryProvider);

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
          _buildSearchInput(context, ref),
          const Gap(16),
          Expanded(
            child: vouchersAsync.when(
              data: (vouchers) {
                // Filter vouchers by search query if one exists
                if (searchQuery.isNotEmpty) {
                  vouchers = vouchers
                      .where((v) =>
                          v.title
                              ?.toLowerCase()
                              .contains(searchQuery.toLowerCase()) ??
                          false)
                      .toList();
                }
                return _buildVoucherList(context, vouchers, ref);
              },
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

  Widget _buildSearchInput(BuildContext context, WidgetRef ref) {
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
      onChanged: (value) {
        ref.read(_searchQueryProvider.notifier).state = value;
      },
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

    // Format display values
    final discountText = voucher.discountType == 'Percentage'
        ? '${voucher.discountValue.toStringAsFixed(0)}%'
        : '৳${voucher.discountValue.toStringAsFixed(0)}';

    final expiryDate = DateFormat('dd MMM yyyy').format(voucher.endDate);

    // Determine voucher type for display
    final voucherTypeText = _getVoucherTypeText(voucher, context);
    final colors = _getVoucherColors(voucher);

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
            colors: [colors.startColor, colors.endColor],
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
                          color: Colors.black,
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
                    color: colors.badgeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    discountText,
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
                  voucherTypeText,
                  style: TextStyle(
                    color: colors.labelColor,
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
                    color: Colors.black,
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

  // Helper method to get voucher type text based on voucher type
  String _getVoucherTypeText(VoucherModel voucher, BuildContext context) {
    if (voucher.voucherType == 'Specific_Student') {
      return context.l10n?.specialForYou ?? 'Special for you!';
    } else if (voucher.voucherType == 'Specific_Course') {
      return context.l10n?.courseSpecific ?? 'Course specific';
    } else {
      return context.l10n?.generalVoucher ?? 'For all courses';
    }
  }

// Updated color scheme for voucher cards in voucher_bottom_sheet.dart

  // Helper method to get colors based on voucher type
  VoucherColors _getVoucherColors(VoucherModel voucher) {
    if (voucher.voucherType == 'Specific_Student') {
      // Warmer, more premium colors for student-specific vouchers
      return VoucherColors(
        startColor: const Color(0xFFFFF3E0), // Light orange
        endColor: const Color(0xFFFFE0B2), // Deeper orange
        badgeColor: const Color(0xFFFF9800), // Orange
        labelColor: const Color(0xFFE65100), // Deep orange
      );
    } else if (voucher.voucherType == 'Specific_Course') {
      // Cooler blue-teal gradient for course-specific vouchers
      return VoucherColors(
        startColor: const Color(0xFFE0F7FA), // Light teal
        endColor: const Color(0xFFB2EBF2), // Deeper teal
        badgeColor: const Color(0xFF00BCD4), // Teal
        labelColor: const Color(0xFF006064), // Deep teal
      );
    } else {
      // Fresh green gradient for general vouchers
      return VoucherColors(
        startColor: const Color(0xFFF1F8E9), // Light green
        endColor: const Color(0xFFDCEDC8), // Deeper green
        badgeColor: const Color(0xFF8BC34A), // Green
        labelColor: const Color(0xFF33691E), // Deep green
      );
    }
  }
}
