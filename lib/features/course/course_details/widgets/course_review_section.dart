// course_reviews_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Add to pubspec.yaml for animations
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';

import '../../course_list/widgets/course_list_header.dart';
import '../model/course_review_model.dart';
import '../viewmodel/course_review_viewmodel.dart';
import '../viewmodel/review_see_more_viewModel.dart';
import 'course_details_review_card.dart';

class CourseReviewsSection extends ConsumerWidget {
  final String courseId;
  final bool isEnrolled;

  const CourseReviewsSection({
    Key? key,
    required this.courseId,
    required this.isEnrolled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reviewsAsync = ref.watch(courseReviewViewModelProvider(courseId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, ref),
        const Gap(16),

        // Reviews content
        reviewsAsync.when(
            data: (reviews) {
              if (reviews.isEmpty) {
                return _buildEmptyReviews(context);
              }

              final reviewStats = ref.watch(reviewStatsProvider(reviews));

              return Column(
                children: [
                  _buildReviewStats(reviewStats, theme, context),
                  const Gap(24),
                  _buildReviewsList(reviews, ref, context),
                ],
              );
            },
            loading: () => Center(
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        const Gap(16),
                        Text(
                          context.l10n!.loadingReviews ?? 'Loading reviews...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            error: (err, stack) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                      size: 48,
                    ),
                    const Gap(16),
                    Text(
                      "${context.l10n!.error}: $err",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(courseReviewViewModelProvider(courseId));
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(context.l10n!.tryAgain ?? 'Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CourseListHeader(text: context.l10n!.testReviews),
        isEnrolled
            ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () => _showReviewBottomSheet(context, ref),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.secondary.withOpacity(0.8),
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary.withOpacity(0.25),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 16,
                          color: theme.colorScheme.onSecondary,
                        ),
                        const Gap(8),
                        Text(
                          context.l10n!.writeReview ?? 'Write a Review',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideX(
                begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad)
            : Container()
      ],
    );
  }

  Widget _buildEmptyReviews(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, _) {
        return Container(
          height: 220,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.rate_review_outlined,
                    size: 48,
                    color: theme.colorScheme.secondary.withOpacity(0.7),
                  ),
                ),
                const Gap(20),
                Text(
                  context.l10n!.noReviewsYet ?? 'No Reviews Yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    context.l10n!.beTheFirstToReview ??
                        'Be the first to share your experience!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(20),
                isEnrolled
                    ? ElevatedButton.icon(
                        onPressed: () => _showReviewBottomSheet(context, ref),
                        icon: const Icon(Icons.add_comment_outlined),
                        label:
                            Text(context.l10n!.writeReview ?? 'Write a Review'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundColor: theme.colorScheme.onSecondary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      )
                    : Container()
              ],
            ).animate().fadeIn(duration: 500.ms).scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                duration: 500.ms),
          ),
        );
      },
    );
  }

  Widget _buildReviewsList(
      List<CourseReview> reviews, WidgetRef ref, BuildContext context) {
    final reviewMoreBtn = ref.watch(reviewSeeMoreViewmodelProvider);
    final visibleReviews = reviewMoreBtn ? reviews : reviews.take(3).toList();
    final theme = Theme.of(context);

    return Column(
      children: [
        ...visibleReviews.asMap().entries.map((entry) {
          final index = entry.key;
          final review = entry.value;
          return CourseDetailsReviewCard(review: review)
              .animate()
              .fadeIn(delay: (100 * index).ms, duration: 400.ms)
              .slideY(
                  begin: 0.1,
                  end: 0,
                  delay: (100 * index).ms,
                  duration: 400.ms);
        }),
        if (reviews.length > 3) ...[
          const Gap(24),
          Center(
            child: TextButton.icon(
              icon: Icon(
                reviewMoreBtn ? Icons.expand_less : Icons.expand_more,
                color: theme.colorScheme.secondary,
              ),
              onPressed: () {
                ref.read(reviewSeeMoreViewmodelProvider.notifier).toggleBtn();
              },
              label: Text(
                reviewMoreBtn
                    ? context.l10n!.showLess ?? 'Show Less'
                    : context.l10n!.showMore ?? 'Show More',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            )
                .animate(
                  target: reviewMoreBtn ? 0 : 1,
                )
                .scaleXY(
                  end: 1.05,
                  duration: 300.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scaleXY(
                  begin: 1.05,
                  end: 1.0,
                  duration: 200.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildReviewStats(
      Map<String, dynamic> stats, ThemeData theme, BuildContext context) {
    final avgRating = stats['averageRating'] as double;
    final totalReviews = stats['totalReviews'] as int;
    final ratingCounts = stats['ratingCounts'] as Map<int, int>;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.5),
            theme.colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.1),
          width: 1,
        ),
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
                Text(
                  avgRating.toStringAsFixed(1),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ).animate().fadeIn(duration: 600.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.easeOutQuad),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < avgRating.round()
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: theme.colorScheme.secondary,
                      size: 20,
                    )
                        .animate()
                        .fadeIn(delay: (100 * index).ms, duration: 300.ms)
                        .scale(
                            begin: const Offset(0, 0),
                            end: const Offset(1, 1),
                            delay: (100 * index).ms,
                            duration: 300.ms);
                  }),
                ),
                const Gap(12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "$totalReviews ${context.l10n!.reviews ?? 'Reviews'}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(
                    begin: 0.3, end: 0, delay: 300.ms, duration: 400.ms),
              ],
            ),
          ),

          // Divider
          Container(
            height: 100,
            width: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.onSurface.withOpacity(0),
                  theme.colorScheme.onSurface.withOpacity(0.1),
                  theme.colorScheme.onSurface.withOpacity(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),

          // Rating breakdown
          Expanded(
            flex: 5,
            child: Column(
              children: List.generate(5, (index) {
                final ratingValue = 5 - index;
                final count = ratingCounts[ratingValue] ?? 0;
                final percentage =
                    totalReviews == 0 ? 0.0 : count / totalReviews;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Row(
                          children: [
                            Text(
                              "$ratingValue",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(4),
                            Icon(
                              Icons.star,
                              color: theme.colorScheme.secondary,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Stack(
                          children: [
                            // Background bar
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            // Filled bar with animation
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutQuart,
                              height: 6,
                              width: percentage *
                                  MediaQuery.of(context).size.width *
                                  0.33,
                              // Approximate width calculation
                              decoration: BoxDecoration(
                                color: _getRatingColor(ratingValue, theme),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getRatingColor(ratingValue, theme)
                                        .withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      SizedBox(
                        width: 24,
                        child: Text(
                          count.toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: (100 * index).ms, duration: 500.ms)
                      .slideX(
                          begin: -0.1,
                          end: 0,
                          delay: (100 * index).ms,
                          duration: 500.ms),
                );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(
        begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuad);
  }

  // Get color based on rating
  Color _getRatingColor(int rating, ThemeData theme) {
    if (rating >= 4) {
      return theme.colorScheme.secondary;
    } else if (rating >= 3) {
      return Colors.amber;
    } else if (rating >= 2) {
      return Colors.orange;
    } else {
      return Colors.redAccent;
    }
  }

  void _showReviewBottomSheet(BuildContext context, WidgetRef ref) {
    final ratingNotifier = ValueNotifier<int>(5);
    final reviewController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bottom sheet header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n!.writeReview ?? 'Write a Review',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Gap(8),
                  Divider(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                  ),
                  const Gap(16),

                  // Rating section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          context.l10n!.rateYourExperience ??
                              'Rate your experience',
                          style: theme.textTheme.titleMedium,
                        ),
                        const Gap(12),
                        ValueListenableBuilder<int>(
                          valueListenable: ratingNotifier,
                          builder: (context, rating, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    ratingNotifier.value = index + 1;
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: index < rating
                                          ? theme.colorScheme.secondary
                                              .withOpacity(0.1)
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      index < rating
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: index < rating
                                          ? theme.colorScheme.secondary
                                          : theme.colorScheme.onSurface
                                              .withOpacity(0.5),
                                      size: 32,
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),

                  // Review text field
                  TextFormField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      hintText: context.l10n!.shareYourExperience ??
                          'Share your experience',
                      filled: true,
                      fillColor: theme.colorScheme.onSurface.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 4,
                    maxLength: 1000,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.trim().length < 5) {
                        return context.l10n!.reviewTooShort ??
                            'Review is too short (min 5 characters)';
                      }
                      return null;
                    },
                  ),

                  const Gap(24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: Consumer(
                      builder: (context, ref, _) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState?.validate() ?? false) {
                              // Show loading indicator
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme
                                              .colorScheme.onInverseSurface,
                                        ),
                                      ),
                                      const Gap(16),
                                      Text(
                                        context.l10n!.submittingReview ??
                                            'Submitting review...',
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor:
                                      theme.colorScheme.inverseSurface,
                                ),
                              );

                              final success = await ref
                                  .read(courseReviewViewModelProvider(courseId)
                                      .notifier)
                                  .addReview(
                                    courseId: courseId,
                                    review: reviewController.text.trim(),
                                    rating: ratingNotifier.value,
                                    context: context,
                                  );

                              if (success) {
                                ref.invalidate(
                                    courseReviewViewModelProvider(courseId));
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.green.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                        const Gap(16),
                                        Expanded(
                                          child: Text(
                                            context.l10n!.reviewSubmitted ??
                                                'Review submitted successfully',
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor:
                                        theme.colorScheme.inverseSurface,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                // Show error message with SnackBar instead of toast
                                ref.invalidate(
                                    courseReviewViewModelProvider(courseId));
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.green.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                        const Gap(16),
                                        Expanded(
                                          child: Text(
                                            context.l10n!.reviewSubmitted ??
                                                'Review submitted successfully',
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor:
                                        theme.colorScheme.inverseSurface,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Submit Review',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.1, end: 0, duration: 400.ms),
            ),
          ),
        ),
      ),
    );
  }
}
