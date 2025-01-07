import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../../common/widgets/long_button.dart';
import '../../../../../core/services/nav.dart';

class OppsView extends ConsumerWidget {
  const OppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/images/oops.svg",
              height: 120,
              width: 120,
            ),
            Gap(16),
            Text(
              'আপনি টেস্ট টি মিস করেছেন পরবর্তীতে যথাসময়ে টেস্ট দিন ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap(24),
            LongButton(
              onPressed: () {
                Nav().pop();
              },
              text: "টেস্ট মডিউলে ব্যাক করুন",
            ),
          ],
        ),
      ),
    );
  }
}
