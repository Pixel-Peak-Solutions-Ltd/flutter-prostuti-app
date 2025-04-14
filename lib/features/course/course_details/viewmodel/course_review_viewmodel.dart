// course_review_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/course_review_model.dart';
import '../repository/course_review_repo.dart';

part 'course_review_viewmodel.g.dart';

@riverpod
class CourseReviewViewModel extends _$CourseReviewViewModel {
  @override
  Future<List<CourseReview>> build(String courseId) async {
    return _fetchReviews(courseId);
  }

  Future<List<CourseReview>> _fetchReviews(String courseId) async {
    final repo = ref.read(courseReviewRepoProvider);
    final result = await repo.getCourseReviews(courseId);

    return result.fold(
      (error) => [],
      (response) => response.data,
    );
  }

  Future<bool> addReview({
    required String courseId,
    required String review,
    required int rating,
    required BuildContext context,
  }) async {
    final repo = ref.read(courseReviewRepoProvider);

    try {
      final result = await repo.createCourseReview({
        'course_id': courseId,
        'review': review,
        'rating': rating,
      });

      if (result.isRight()) {
        // Refresh the reviews list
        ref.invalidateSelf();
        return true;
      }

      return false;
    } catch (e) {
      // Just return false instead of showing a toast here
      return false;
    }
  }
}

// Stats provider to calculate review statistics
@riverpod
class ReviewStats extends _$ReviewStats {
  @override
  Map<String, dynamic> build(List<CourseReview> reviews) {
    // Calculate average rating
    final avgRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    // Count reviews by rating
    final ratingCounts = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingCounts[i] = reviews.where((r) => r.rating == i).length;
    }

    return {
      'averageRating': avgRating,
      'totalReviews': reviews.length,
      'ratingCounts': ratingCounts,
    };
  }
}
