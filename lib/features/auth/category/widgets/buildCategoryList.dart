import 'package:flutter/material.dart';
import 'package:prostuti/core/configs/app_colors.dart';

Widget buildCategoryList(
    BuildContext context, List<String> icons, List<String> items,
    {bool isSkeleton = false, Function(int)? onTap}) {
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
            onTap: onTap != null ? () => onTap(index) : null,
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        );
      },
    ),
  );
}

// New widget for subcategory selection
Widget buildSubCategoryList(BuildContext context, List<String> subcategories,
    {bool isSkeleton = false, Function(int)? onTap}) {
  // Use different icons for subcategories
  final subIcons = [
    "assets/images/microscope_01.png",
    "assets/images/document_01.png",
    "assets/images/palette_01.png",
    "assets/images/building_02.png",
    "assets/images/stethoscope_01.png",
    "assets/images/graduation_hat_01.png"
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: ListView.builder(
      itemCount: subcategories.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderNormalLight, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(isSkeleton ? '' : subcategories[index]),
            onTap: onTap != null ? () => onTap(index) : null,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    ),
  );
}
