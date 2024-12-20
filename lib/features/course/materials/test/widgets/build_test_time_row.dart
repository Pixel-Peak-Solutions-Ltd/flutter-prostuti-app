import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


Widget buildTestTimeRow(ThemeData theme, String hour, String minute) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("সময়",
          style: theme.textTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.w500)),
      const Gap(8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTimeBox("ঘন্টা", hour, theme),
          buildTimeBox("মিনিট", minute, theme),
          buildTimeBox("সেকেন্ড", "০০", theme),
        ],
      ),
    ],
  );
}

Widget buildTimeBox(String label, String value, ThemeData theme) {
  return Container(
    width: 100,
    height: 100,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
        const Gap(5),
        Text(
          value.isNotEmpty ? value : "০০",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}