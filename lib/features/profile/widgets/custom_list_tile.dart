import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/configs/app_colors.dart';

class CustomListTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(
          width: 2,
          color: AppColors.shadeNeutralLight,
        ),
      ),
      child: ListTile(
        leading: SvgPicture.asset(
          icon,
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.linearToSrgbGamma(),
        ),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
