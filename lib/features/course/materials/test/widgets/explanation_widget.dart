import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';

class ExplanationWidget extends StatefulWidget {
  final String? explanation;

  const ExplanationWidget({
    super.key,
    required this.explanation,
  });

  @override
  State<ExplanationWidget> createState() => _ExplanationWidgetState();
}

class _ExplanationWidgetState extends State<ExplanationWidget> {
  bool isExplanationVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isExplanationVisible)
          Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: const Color(0xffE1EAFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xff2970FF)),
            ),
            child: Column(
              children: [
                Text(
                  "ব্যাখ্যা",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium!.copyWith(color: const Color(0xff2970FF)),
                ),
                const Gap(10),
                Text(
                  widget.explanation ?? "No explanation available",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        if (!isExplanationVisible)
          LongButton(onPressed: () {
            setState(() {
              isExplanationVisible = true;
            });
          }, text: "ব্যাখ্যা দেখুন")

      ],
    );
  }
}
