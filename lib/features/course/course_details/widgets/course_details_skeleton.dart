import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Ensure skeletonizer is imported
import 'package:gap/gap.dart';

import 'course_details_pills.dart';
import 'course_details_review_card.dart';

class CourseDetailsSkeleton extends StatelessWidget {
  const CourseDetailsSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true, // Enable the skeleton view
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skeleton for the image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  "assets/images/course_thumbnail.png",
                  // Leave empty to show skeleton
                  fit: BoxFit.cover,
                  width: MediaQuery.sizeOf(context).width,
                  height: 200, // Specify height for skeleton
                ),
              ),
              const Gap(16),
              // Skeleton for the title
              Text(
                "assets/images/course_thumbnail.png",
                // Leave empty to show skeleton
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w800),
                maxLines: 2,
              ),
              const Gap(8),
              // Skeleton for the row with pills and prices
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CourseDetailsPills(
                    value: '', // Leave empty to show skeleton
                    icon: Icons.star_border_outlined,
                  ),
                  Row(
                    children: [
                      Text(
                        "", // Leave empty to show skeleton
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.grey),
                      ),
                      const Gap(8),
                      Text(
                        "", // Leave empty to show skeleton
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(21),
              // Skeleton for horizontal scroll pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: const CourseDetailsPills(
                        value: '', // Leave empty to show skeleton
                        icon: Icons.school_outlined,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(32),
              // Skeleton for section header
              Text(
                "", // Leave empty to show skeleton
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(8),
              // Skeleton for expandable text
              Text(
                "", // Leave empty to show skeleton
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(32),
              // Skeleton for reviews
              Column(
                children: List.generate(
                  3,
                  (index) => const CourseDetailsReviewCard(),
                ),
              ),
              const Gap(16),
              // Skeleton for button
              Center(
                child: ElevatedButton(
                  onPressed: null, // Disabled button
                  child: const Text(""),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
