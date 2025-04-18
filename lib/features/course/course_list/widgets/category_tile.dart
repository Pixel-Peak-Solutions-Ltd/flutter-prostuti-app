import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(width: 0.2, color: Colors.grey.shade900),
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
