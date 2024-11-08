import 'package:flutter/material.dart';
import 'package:prostuti/core/configs/app_colors.dart';

AppBar commonAppbar(String title, BuildContext context) {
  return AppBar(
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    automaticallyImplyLeading: true,
    centerTitle: true,
    backgroundColor: AppColors.shadeSecondaryLight,
  );
}
