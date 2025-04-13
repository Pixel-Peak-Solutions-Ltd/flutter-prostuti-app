import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/size_config.dart';

class CourseNamePrice extends StatelessWidget {
  final String name, imgPath, price;

  const CourseNamePrice({
    super.key,
    required this.name,
    required this.imgPath,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Use Expanded for the left section to prevent overflow
        Expanded(
          child: Row(
            children: [
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
              // Use Expanded for the text to make it flexible
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        // Add some spacing between the name and price
        const Gap(8),
        // Make the price non-flexible
        Text(
          price,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
