// lib/features/payment/widgets/voucher_input.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/payment/viewmodel/voucher_viewmodel.dart';

final _applyingVoucherProvider = StateProvider<bool>((ref) => false);

class VoucherInput extends ConsumerStatefulWidget {
  final String courseId;
  final double originalPrice;
  final Function(bool) onVoucherApplied;

  const VoucherInput({
    Key? key,
    required this.courseId,
    required this.originalPrice,
    required this.onVoucherApplied,
  }) : super(key: key);

  @override
  _VoucherInputState createState() => _VoucherInputState();
}

class _VoucherInputState extends ConsumerState<VoucherInput> {
  final TextEditingController _voucherController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voucherState = ref.watch(voucherNotifierProvider);
    final isApplyingVoucher = ref.watch(_applyingVoucherProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Gap(16),
        Text(
          context.l10n?.voucher ?? 'Voucher',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(8),

        // Voucher application status
        if (voucherState.hasValue && voucherState.value != null)
          _buildAppliedVoucher(context, voucherState.value!.title ?? 'Voucher',
              widget.originalPrice)
        else
          _buildVoucherInput(context, isApplyingVoucher),

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
      BuildContext context, String voucherTitle, double originalPrice) {
    final voucherNotifier = ref.read(voucherNotifierProvider.notifier);
    final discountAmount = voucherNotifier.getDiscountAmount(originalPrice);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const Gap(8),
                Expanded(
                  child: Text(
                    "$voucherTitle - ${discountAmount.toStringAsFixed(2)} ${context.l10n?.discount ?? 'discount'}",
                    style: const TextStyle(color: Colors.green),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            voucherNotifier.clearVoucher();
            _voucherController.clear();
            widget.onVoucherApplied(false);
          },
          child: Text(
            context.l10n?.remove ?? 'Remove',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherInput(BuildContext context, bool isApplyingVoucher) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _voucherController,
            decoration: InputDecoration(
              hintText: context.l10n?.enterVoucherCode ?? 'Enter voucher code',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const Gap(8),
        ElevatedButton(
          onPressed: isApplyingVoucher ? null : () => _applyVoucher(context),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: const Color(0xff2970FF),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: isApplyingVoucher
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  context.l10n?.apply ?? 'Apply',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }

  void _applyVoucher(BuildContext context) {
    final code = _voucherController.text.trim();
    if (code.isEmpty) {
      Fluttertoast.showToast(
          msg: context.l10n?.enterValidVoucher ??
              'Please enter a valid voucher code');
      return;
    }

    _debouncer.run(
      action: () async {
        final voucherNotifier = ref.read(voucherNotifierProvider.notifier);
        await voucherNotifier.validateVoucher(
          code,
          courseId: widget.courseId,
          originalPrice: widget.originalPrice,
        );

        // Notify the parent if voucher was successfully applied
        final voucherState = ref.read(voucherNotifierProvider);
        if (voucherState.hasValue && voucherState.value != null) {
          Fluttertoast.showToast(
            msg:
                context.l10n?.voucherApplied ?? 'Voucher applied successfully!',
            backgroundColor: Colors.green,
          );
          widget.onVoucherApplied(true);
        }
      },
      loadingController: ref.read(_applyingVoucherProvider.notifier),
    );
  }
}
