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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.78,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'মোঃ রাসেল ইসলাম',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const CourseDetailsPills(
                        icon: Icons.star_outline, value: "4.5")
                  ],
                ),
              ),
              const Gap(4),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.76,
                child: const ExpandableText(
                    text:
                        "আল্লাহর অশেষ রহমতে আমি ২০২১-২২ সেশনের মেডিক্যাল ভর্তি পরীক্ষায় ৮৫ তম স্থান অধিকার করেছি। এর জন্য আমি আমার পরিবার, আমার আব্বু, আমার আম্মু... আরো দেখুন"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
