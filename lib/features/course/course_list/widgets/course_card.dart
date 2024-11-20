import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:prostuti/common/widgets/course_enroll_row.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.title,
    required this.price,
    required this.discountPrice,
    required this.discount,
    required this.imgPath,
  });

  final String title;
  final String price;
  final String discountPrice;
  final String discount;

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              "assets/images/course_thumbnail.png",
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
          const Gap(8),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w800),
            maxLines: 2,
          ),
          const Gap(4),
          CourseEnrollRow(
            price: price,
            discountPrice: discountPrice,
            discount: discount,
          )
        ],
      ),
    );
  }
}
