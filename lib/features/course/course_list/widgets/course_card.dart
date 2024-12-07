import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';

class CourseCard extends StatelessWidget with CommonWidgets {
  CourseCard({
    super.key,
    required this.title,
    required this.price,
    required this.imgPath,
  });

  final String? title;
  final String? price;

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
            child: Image.network(
              imgPath,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
          const Gap(8),
          Text(
            title ?? "No Name",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w800),
            maxLines: 2,
          ),
          const Gap(4),
          courseEnrollRow(
            price: price,
            theme: Theme.of(context),
          )
        ],
      ),
    );
  }
}
