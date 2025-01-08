import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/services/nav.dart';
import '../../../core/services/size_config.dart';

class TermsCondition extends StatelessWidget {
  const TermsCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Nav().pop();
                  },
                  icon: const Icon(Icons.close)),
            ),
            const Gap(16),
            Text(
              'প্রিমিয়ামে আপগ্রেড করুন?',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            Text(
              textAlign: TextAlign.center,
              '"টু ডু অ্যাপ" এটি একটি উপকারী মোবাইল অ্যাপ্লিকেশন, যা ব্যবহারকারীদের বিভিন্ন কাজে সাহায্য করে। এই এপ্লিকেশনের মাধ্যমে ব্যবহারকারীরা তাদের কাজ, পরিকল্পনা।',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                const Gap(4),
                Text(
                  '"টু ডু অ্যাপ" এটি একটি উপকারী মোবাইল অ্যাপ্লিকেশন',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const Gap(32),
            Text(
              'আপনি কেনো আপগ্রেড করবেন?',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            for (int i = 0; i < 4; i++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/sub_star.png",
                    height: 40,
                    width: 40,
                  ),
                  const Gap(14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'বর্তমান সব কোর্স অ্যাক্সেস',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Gap(8),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.8,
                        child: Text(
                            'বর্তমান সব কোর্স ও কন্টেন্টের অ্যাক্সেস বর্তমান সব কোর্স অ্যাক্সেস ',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
