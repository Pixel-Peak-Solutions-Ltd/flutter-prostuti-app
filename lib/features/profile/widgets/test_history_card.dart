import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/all_test_history_model.dart';

class TestHistoryCard extends StatelessWidget {
  final Data test;

  const TestHistoryCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final testName = test.testId?.name ?? 'Unknown Test';
    final score = test.score ?? 0;
    final totalScore = test.totalScore ?? 0;
    final courseName = test.courseId?.name ?? 'Unknown Course';
    final lessonName = test.lessonId?.name ?? 'Unknown Lesson';
    final isPassed = test.isPassed ?? false;
    final attemptDate = _formatDate(test.attemptedAt);
    final timeTaken = _formatDuration(test.timeTaken ?? 0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    testName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildScoreBadge(score, totalScore, isPassed),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              courseName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Lesson: $lessonName',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(attemptDate),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(timeTaken),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBadge(int score, int totalScore, bool isPassed) {
    final percentage = totalScore > 0 ? (score / totalScore) * 100 : 0;

    Color badgeColor;
    if (isPassed) {
      badgeColor = percentage >= 70 ? Colors.green : Colors.amber;
    } else {
      badgeColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$score/$totalScore',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'No date';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0m 0s';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes}m ${remainingSeconds}s';
  }
}