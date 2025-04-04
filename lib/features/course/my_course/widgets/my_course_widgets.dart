import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/size_config.dart';

import '../../../../core/configs/app_colors.dart';

class MyCourseCard extends StatelessWidget {
  final double progress;
  final String name, img;

  const MyCourseCard(
      {super.key,
      required this.progress,
      required this.name,
      required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(width: 0.2, color: Colors.grey.shade900),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                img,
                width: SizeConfig.w(90),
                height: SizeConfig.h(70),
                fit: BoxFit.cover,
              )),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(16),
                Text(
                  "প্রোগ্রেস",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: LinearProgressIndicator(
                        value: progress,
                        borderRadius: BorderRadius.circular(16),
                        minHeight: 8,
                        backgroundColor: AppColors.shadePrimaryLight,
                        color: AppColors.backgroundActionPrimaryLight,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.textActionSecondaryLight,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
