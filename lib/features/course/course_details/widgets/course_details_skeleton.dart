// course_details_skeleton.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../model/course_review_model.dart';
import 'course_details_pills.dart';
import 'course_details_review_card.dart';

class CourseDetailsSkeleton extends StatelessWidget {
  const CourseDetailsSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course header section skeleton
                    _buildCourseHeaderSkeleton(context),
                    const Gap(32),

                    // About section skeleton
                    _buildSectionHeaderSkeleton(context, "About"),
                    const Gap(8),
                    // Placeholder text blocks for details
                    _buildPlaceholderTextBlocks(context),
                    const Gap(32),

                    // Curriculum section skeleton
                    _buildSectionHeaderSkeleton(context, "Curriculum"),
                    const Gap(16),
                    _buildCurriculumSkeleton(context),
                    const Gap(32),

                    // Reviews section skeleton
                    _buildSectionHeaderSkeleton(context, "Reviews"),
                    const Gap(16),
                    _buildReviewStatsSkeleton(context),
                    const Gap(24),
                    _buildReviewListSkeleton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseHeaderSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course image skeleton
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.grey[300],
            ),
          ),
        ),
        const Gap(16),

        // Course title skeleton
        Container(
          height: 28,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Gap(8),

        // Rating and price row skeleton
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CourseDetailsPills(
              value: '4.5 rating',
              icon: "assets/icons/assignment.svg",
            ),
            Container(
              height: 32,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
        const Gap(24),

        // Course stats pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CourseDetailsPills(
                  value: '${index + 1} items',
                  icon: "assets/icons/assignment.svg",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeaderSkeleton(BuildContext context, String placeholder) {
    return Container(
      height: 24,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildPlaceholderTextBlocks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurriculumSkeleton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: List.generate(
          2,
          (index) => _buildLessonSkeleton(context),
        ),
      ),
    );
  }

  Widget _buildLessonSkeleton(BuildContext context) {
    return ExpansionTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Container(
        height: 20,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    height: 16,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewStatsSkeleton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Average rating summary
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Gap(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: Colors.grey[300],
                      size: 16,
                    ),
                  ),
                ),
                const Gap(8),
                Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 80,
            width: 1,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          // Rating breakdown
          Expanded(
            flex: 5,
            child: Column(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        "${5 - index}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        color: Colors.grey[300],
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 16,
                        width: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewListSkeleton(BuildContext context) {
    // Create dummy review data for skeleton
    final dummyStudent = StudentInfo(
      id: '',
      userId: '',
      studentId: '',
      name: 'Student Name',
      email: 'student@example.com',
    );

    final dummyReview = CourseReview(
      id: '',
      courseId: '',
      studentInfo: dummyStudent,
      review:
          'This is a placeholder review text that will be shown as a skeleton.',
      rating: 5,
      isArrived: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    return Column(
      children: List.generate(
        3,
        (index) => CourseDetailsReviewCard(review: dummyReview),
      ),
    );
  }
}
