import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/appbar/common_app_bar.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/features/course_list/widgets/search_container.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.imgPath, required this.index});

  final List<String> imgPath;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10).copyWith(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              imgPath[index],
              height: 36,
              width: 36,
            ),
          ),
          const Gap(10),
          Text(
            'জব প্রিপারেশন',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
