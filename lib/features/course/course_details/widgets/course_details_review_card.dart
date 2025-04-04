import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'course_details_pills.dart';
import 'expandable_text.dart';

class CourseDetailsReviewCard extends StatelessWidget {
  const CourseDetailsReviewCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16).copyWith(top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image - fixed size is fine
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              "assets/icons/my_courses_icon.png",
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(15),
          // Use Expanded for the content column to take remaining width
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and rating row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Use Expanded with the name to allow it to shrink if needed
                    Expanded(
                      child: Text(
                        'মোঃ রাসেল ইসলাম',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Rating pill with some spacing
                    const SizedBox(width: 8),
                    const CourseDetailsPills(
                        icon: Icons.star_outline, value: "4.5")
                  ],
                ),
                const Gap(4),
                // Review text - will automatically take parent width
                const ExpandableText(
                  text:
                      "আল্লাহর অশেষ রহমতে আমি ২০২১-২২ সেশনের মেডিক্যাল ভর্তি পরীক্ষায় ৮৫ তম স্থান অধিকার করেছি। এর জন্য আমি আমার পরিবার, আমার আব্বু, আমার আম্মু... আরো দেখুন",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
