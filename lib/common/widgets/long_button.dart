import 'package:flutter/material.dart';

import '../../core/configs/app_colors.dart';

class LongButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const LongButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundActionPrimaryLight,
          minimumSize: Size(width, 54),
          maximumSize: Size(width, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 23)),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: AppColors.textActionPrimaryLight),
      ),
    );
  }
}
