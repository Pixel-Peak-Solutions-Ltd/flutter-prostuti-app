import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/services/size_config.dart';

class Tracker extends StatelessWidget {
  const Tracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.blue,
              size: 26,
            ),
            Text(
              'কোর্স',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Gap(SizeConfig.w(12)),
        Container(
          height: 2,
          width: SizeConfig.w(100),
          color: Colors.blue,
        ),
        Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.blue,
              size: 26,
            ),
            Text(
              'কার্ট',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          height: 2,
          width: SizeConfig.w(100),
          color: Colors.blue,
        ),
        Column(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.blue,
              size: 26,
            ),
            Text(
              'চেকআউট',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
