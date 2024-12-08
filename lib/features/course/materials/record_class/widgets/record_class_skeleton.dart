import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pod_player/pod_player.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecordClassSkeleton extends StatelessWidget {
  const RecordClassSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: MediaQuery.sizeOf(context).width,
            color: Colors.grey,
          ),
          const Gap(16),
          Text(
            "No Name",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(24),
          Text(
            "রেকর্ড সম্পর্কে",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          Text(
            "No Details",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
