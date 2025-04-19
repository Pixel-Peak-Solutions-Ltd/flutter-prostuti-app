import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/all_test_history_model.dart';

class TestHistoryCard extends StatelessWidget {
  final Data test;

  const TestHistoryCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Extract test data
    final testName = test.testId?.name ?? 'Unknown Test';
    final testType = test.testId?.type ?? 'Unknown';
    final score = test.score ?? 0;
    final totalScore = test.totalScore ?? 0;
    final courseName = test.courseId?.name ?? 'Unknown Course';
    final lessonName = test.lessonId?.name ?? 'Unknown Lesson';
    final isPassed = test.isPassed ?? false;
    final isChecked = test.isChecked ?? false;
    final attemptDate = _formatDate(test.attemptedAt);
    final timeTaken = _formatDuration(test.timeTaken ?? 0);
    final double percentage = totalScore > 0 ? (score / totalScore) * 100 : 0;

    // Theme colors
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryColor = isDarkMode ? Colors.white60 : Colors.black54;

    // Status colors
    Color statusColor;
    String statusText;

    if (isPassed) {
      if (percentage >= 80) {
        statusColor = const Color(0xFF4CAF50); // Green
        statusText = 'Excellent';
      } else if (percentage >= 60) {
        statusColor = const Color(0xFF8BC34A); // Light Green
        statusText = 'Good';
      } else {
        statusColor = const Color(0xFFFFC107); // Amber
        statusText = 'Passed';
      }
    } else {
      statusColor = const Color(0xFFE53935); // Red
      statusText = 'Failed';
    }

    // Test type indicator
    final typeColor = testType == 'MCQ'
        ? const Color(0xFF42A5F5) // Blue for MCQ
        : const Color(0xFFFF7043); // Orange for Written

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Top section with course and status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    courseName,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPassed ? Icons.check_circle : Icons.cancel_outlined,
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Test details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              testType,
                              style: TextStyle(
                                color: typeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          if (!isChecked) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Pending',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        testName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 14,
                            color: secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Lesson: $lessonName',
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildInfoItem(
                            context,
                            Icons.calendar_today_outlined,
                            attemptDate,
                            secondaryColor,
                          ),
                          const SizedBox(width: 16),
                          _buildInfoItem(
                            context,
                            Icons.timer_outlined,
                            timeTaken,
                            secondaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right side - Score circle
                const SizedBox(width: 12),
                _buildScoreCircle(score, totalScore, percentage, statusColor,
                    textColor, secondaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCircle(
    int score,
    int totalScore,
    double percentage,
    Color statusColor,
    Color textColor,
    Color secondaryColor,
  ) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: statusColor.withOpacity(0.1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 6,
              backgroundColor: statusColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${percentage.round()}%',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '$score/$totalScore',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
