import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/size_config.dart';

class CourseNamePrice extends StatelessWidget {
  final String name, imgPath, price;

  const CourseNamePrice(
      {super.key,
      required this.name,
      required this.imgPath,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imgPath,
              height: SizeConfig.h(50),
              width: SizeConfig.w(80),
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(16),
          SizedBox(
            width: SizeConfig.w(180),
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ]),
        Text(
          price,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
