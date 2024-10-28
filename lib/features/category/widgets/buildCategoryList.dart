import 'package:flutter/material.dart';

import '../../../core/configs/app_colors.dart';

Widget buildCategoryList(
    BuildContext context, List<String> icons, List<String> items,
    {bool isSkeleton = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderNormalLight, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Image.asset(
              icons[index % icons.length], // Cycle through icons
              height: 40,
              width: 40,
            ),
            title: Text(isSkeleton ? '' : items[index]),
            onTap: () {},
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        );
      },
    ),
  );
}
