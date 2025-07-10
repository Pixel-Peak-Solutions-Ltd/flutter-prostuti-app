import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/profile/viewmodel/get_test_history_of_course.dart';
import 'package:prostuti/features/profile/viewmodel/test_history_view_model.dart';
import 'package:prostuti/features/profile/widgets/test_history_shimmer.dart';

import '../../../profile/model/all_test_history_model.dart';

class TestReportCardView extends ConsumerStatefulWidget {
  final String studentId, courseId;

  const TestReportCardView(
      {super.key, required this.studentId, required this.courseId});

  @override
  ConsumerState<TestReportCardView> createState() => _TestReportCardViewState();
}

class _TestReportCardViewState extends ConsumerState<TestReportCardView> {
  String _selectedPeriod = 'All Time';
  final List<String> _periodOptions = [
    'All Time',
    'This Month',
    'Last 3 Months',
    'Last 6 Months',
    'This Year'
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define theme colors
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF303030);
    final secondaryColor =
        isDarkMode ? Colors.white60 : const Color(0xFF6B7280);
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: textColor,
        title: Text(
          'Report Card',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: textColor,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final testHistoryState = ref.watch(
            TestHistoryViewModelOfCourseProvider(
                studentId: widget.studentId, courseId: widget.courseId),
          );

          return testHistoryState.when(
            data: (allTests) {
              if (allTests.isEmpty) {
                return _buildEmptyState(textColor, secondaryColor);
              }

              // Filter tests based on selected period
              final tests = _filterTestsByPeriod(allTests, _selectedPeriod);

              // Calculate statistics
              final stats = _calculateStatistics(tests);
              final courseStats = _calculateCourseStatistics(tests);
              final grade = _calculateGrade(stats['averageScore']);
              final studentInfo =
                  tests.isNotEmpty ? tests.first.studentId : null;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Period Selector
                    _buildPeriodSelector(
                        cardColor, textColor, secondaryColor, accentColor),

                    // Report Card Header
                    _buildReportHeader(
                      studentInfo,
                      _selectedPeriod,
                      cardColor,
                      textColor,
                      secondaryColor,
                      isDarkMode,
                    ),

                    // Overall Performance Card
                    _buildOverallPerformanceCard(
                      stats,
                      grade,
                      cardColor,
                      textColor,
                      secondaryColor,
                      accentColor,
                      isDarkMode,
                    ),

                    // Course-wise Performance
                    _buildCoursePerformanceSection(
                      courseStats,
                      cardColor,
                      textColor,
                      secondaryColor,
                      accentColor,
                      isDarkMode,
                    ),

                    // Performance Metrics
                    _buildPerformanceMetrics(
                      tests,
                      stats,
                      cardColor,
                      textColor,
                      secondaryColor,
                      isDarkMode,
                    ),

                    // Achievement Badges
                    _buildAchievementSection(
                      stats,
                      tests,
                      cardColor,
                      textColor,
                      secondaryColor,
                      isDarkMode,
                    ),

                    // Footer
                    _buildReportFooter(textColor, secondaryColor),
                  ],
                ),
              );
            },
            loading: () => const TestHistoryShimmer(),
            error: (error, stackTrace) =>
                _buildErrorState(error, textColor, ref),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector(
    Color cardColor,
    Color textColor,
    Color secondaryColor,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'Report Period:',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedPeriod,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: cardColor,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: accentColor,
                ),
                items: _periodOptions.map((period) {
                  return DropdownMenuItem(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPeriod = value;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportHeader(
    StudentId? studentInfo,
    String period,
    Color cardColor,
    Color textColor,
    Color secondaryColor,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ACADEMIC REPORT CARD',
                  style: Theme.of(context).textTheme.bodyMedium),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(DateFormat('yyyy').format(DateTime.now()),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(studentInfo?.name ?? 'Student Name',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildHeaderInfo(
                Icons.badge_outlined,
                'ID: ${studentInfo?.studentId ?? 'N/A'}',
              ),
              const SizedBox(width: 20),
              _buildHeaderInfo(
                Icons.school_outlined,
                studentInfo?.category?.mainCategory ?? 'General',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildHeaderInfo(
                Icons.email_outlined,
                studentInfo?.email ?? 'N/A',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.secondary,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).unselectedWidgetColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildOverallPerformanceCard(
    Map<String, dynamic> stats,
    String grade,
    Color cardColor,
    Color textColor,
    Color secondaryColor,
    Color accentColor,
    bool isDarkMode,
  ) {
    final gradeColor = _getGradeColor(grade);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Performance',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gradeColor.withOpacity(0.1),
                  border: Border.all(
                    color: gradeColor,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        grade,
                        style: TextStyle(
                          color: gradeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        'Grade',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Average Score',
                  '${stats['averageScore'].toStringAsFixed(1)}%',
                  Icons.trending_up_rounded,
                  Colors.deepOrange,
                  textColor,
                  secondaryColor,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Pass Rate',
                  '${stats['passRate'].toStringAsFixed(1)}%',
                  Icons.check_circle_outline_rounded,
                  const Color(0xFF4CAF50),
                  textColor,
                  secondaryColor,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Tests Taken',
                  '${stats['totalTests']}',
                  Icons.assignment_turned_in_rounded,
                  const Color(0xFF42A5F5),
                  textColor,
                  secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            'Overall Progress',
            stats['averageScore'] / 100,
            gradeColor,
            textColor,
            secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    Color textColor,
    Color secondaryColor,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    String label,
    double value,
    Color color,
    Color textColor,
    Color secondaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: secondaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildCoursePerformanceSection(
    List<Map<String, dynamic>> courseStats,
    Color cardColor,
    Color textColor,
    Color secondaryColor,
    Color accentColor,
    bool isDarkMode,
  ) {
    if (courseStats.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Course Performance',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ...courseStats.map((course) {
            final grade = _calculateGrade(course['averageScore']);
            final gradeColor = _getGradeColor(grade);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.white10
                      : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['courseName'],
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${course['totalTests']} Tests • ${course['lessonCount']} Lessons',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: gradeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: gradeColor,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          grade,
                          style: TextStyle(
                            color: gradeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.grade_rounded,
                              size: 16,
                              color: secondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Avg: ${course['averageScore'].toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: secondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Pass: ${course['passRate'].toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: secondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_formatTotalTime(course['totalTime'])}',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: course['averageScore'] / 100,
                    backgroundColor: gradeColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
                    minHeight: 6,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(
    List<Data> tests,
    Map<String, dynamic> stats,
    Color cardColor,
    Color textColor,
    Color secondaryColor,
    bool isDarkMode,
  ) {
    // Calculate test type distribution
    final mcqTests = tests.where((t) => t.testId?.type == 'MCQ').length;
    final writtenTests = tests.where((t) => t.testId?.type == 'Written').length;

    // Calculate average time
    final avgTime = stats['totalTime'] / math.max(tests.length, 1);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Study Time',
                  _formatTotalTime(stats['totalTime']),
                  Icons.schedule_rounded,
                  const Color(0xFFFF7043),
                  textColor,
                  secondaryColor,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Avg. Time/Test',
                  _formatDuration(avgTime.round()),
                  Icons.timer_outlined,
                  const Color(0xFF9C27B0),
                  textColor,
                  secondaryColor,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'MCQ Tests',
                  '$mcqTests',
                  Icons.quiz_rounded,
                  const Color(0xFF42A5F5),
                  textColor,
                  secondaryColor,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Written Tests',
                  '$writtenTests',
                  Icons.edit_note_rounded,
                  const Color(0xFFFF7043),
                  textColor,
                  secondaryColor,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Best Score',
                  '${stats['highestScore'].toStringAsFixed(0)}%',
                  Icons.emoji_events_rounded,
                  const Color(0xFFFFD700),
                  textColor,
                  secondaryColor,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Improvement',
                  _calculateImprovement(tests),
                  Icons.trending_up_rounded,
                  const Color(0xFF4CAF50),
                  textColor,
                  secondaryColor,
                  isDarkMode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    Color textColor,
    Color secondaryColor,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withOpacity(0.2)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection(
    Map<String, dynamic> stats,
    List<Data> tests,
    Color cardColor,
    Color textColor,
    Color secondaryColor,
    bool isDarkMode,
  ) {
    final achievements = _getAchievements(stats, tests);

    if (achievements.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: achievements.map((achievement) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      achievement['color'].withOpacity(0.8),
                      achievement['color'],
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: achievement['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      achievement['icon'],
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      achievement['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportFooter(Color textColor, Color secondaryColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Generated on ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
            style: TextStyle(
              color: secondaryColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This is an official academic report',
            style: TextStyle(
              color: secondaryColor,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color secondaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: secondaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'No Test Data Available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Complete some tests to generate your report card.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error, Color textColor, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              "${context.l10n!.error}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$error",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(testHistoryViewModelProvider(
                            studentId: widget.studentId)
                        .notifier)
                    .refreshTests();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  List<Data> _filterTestsByPeriod(List<Data> tests, String period) {
    final now = DateTime.now();
    DateTime startDate;

    switch (period) {
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Last 3 Months':
        startDate = now.subtract(const Duration(days: 90));
        break;
      case 'Last 6 Months':
        startDate = now.subtract(const Duration(days: 180));
        break;
      case 'This Year':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        return tests;
    }

    return tests.where((test) {
      if (test.attemptedAt == null) return false;
      try {
        final testDate = DateTime.parse(test.attemptedAt!);
        return testDate.isAfter(startDate);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  Map<String, dynamic> _calculateStatistics(List<Data> tests) {
    if (tests.isEmpty) {
      return {
        'totalTests': 0,
        'passedTests': 0,
        'failedTests': 0,
        'averageScore': 0.0,
        'passRate': 0.0,
        'totalTime': 0,
        'highestScore': 0.0,
        'lowestScore': 0.0,
      };
    }

    final passedTests = tests.where((t) => t.isPassed == true).length;
    final failedTests = tests.length - passedTests;

    double totalScore = 0;
    double highestScore = 0;
    double lowestScore = 100;
    int totalTime = 0;

    for (var test in tests) {
      if (test.totalScore != null && test.totalScore! > 0) {
        final percentage = ((test.score ?? 0) / test.totalScore!) * 100;
        totalScore += percentage;
        highestScore = math.max(highestScore, percentage);
        lowestScore = math.min(lowestScore, percentage);
      }
      totalTime += test.timeTaken ?? 0;
    }

    return {
      'totalTests': tests.length,
      'passedTests': passedTests,
      'failedTests': failedTests,
      'averageScore': totalScore / tests.length,
      'passRate': (passedTests / tests.length) * 100,
      'totalTime': totalTime,
      'highestScore': highestScore,
      'lowestScore': lowestScore,
    };
  }

  List<Map<String, dynamic>> _calculateCourseStatistics(List<Data> tests) {
    final courseMap = <String, List<Data>>{};

    // Group tests by course
    for (var test in tests) {
      final courseName = test.courseId?.name ?? 'Unknown Course';
      courseMap[courseName] = (courseMap[courseName] ?? [])..add(test);
    }

    // Calculate stats for each course
    return courseMap.entries.map((entry) {
      final courseTests = entry.value;
      final passedTests = courseTests.where((t) => t.isPassed == true).length;

      double totalScore = 0;
      int totalTime = 0;
      final lessonSet = <String>{};

      for (var test in courseTests) {
        if (test.totalScore != null && test.totalScore! > 0) {
          totalScore += ((test.score ?? 0) / test.totalScore!) * 100;
        }
        totalTime += test.timeTaken ?? 0;
        if (test.lessonId?.sId != null) {
          lessonSet.add(test.lessonId!.sId!);
        }
      }

      return {
        'courseName': entry.key,
        'totalTests': courseTests.length,
        'passedTests': passedTests,
        'averageScore': totalScore / courseTests.length,
        'passRate': (passedTests / courseTests.length) * 100,
        'totalTime': totalTime,
        'lessonCount': lessonSet.length,
      };
    }).toList()
      ..sort((a, b) {
        final aTests = a['totalTests'] as int;
        final bTests = b['totalTests'] as int;
        return bTests.compareTo(aTests);
      });
  }

  String _calculateGrade(double averageScore) {
    if (averageScore >= 90) return 'A+';
    if (averageScore >= 85) return 'A';
    if (averageScore >= 80) return 'A-';
    if (averageScore >= 75) return 'B+';
    if (averageScore >= 70) return 'B';
    if (averageScore >= 65) return 'B-';
    if (averageScore >= 60) return 'C+';
    if (averageScore >= 55) return 'C';
    if (averageScore >= 50) return 'D';
    return 'F';
  }

  Color _getGradeColor(String grade) {
    switch (grade[0]) {
      case 'A':
        return const Color(0xFF4CAF50);
      case 'B':
        return const Color(0xFF2196F3);
      case 'C':
        return const Color(0xFFFFC107);
      case 'D':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFFE53935);
    }
  }

  String _formatTotalTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0m';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    }
    return '${remainingSeconds}s';
  }

  String _calculateImprovement(List<Data> tests) {
    if (tests.length < 2) return 'N/A';

    // Sort tests by date
    final sortedTests = List<Data>.from(tests)
      ..sort((a, b) {
        if (a.attemptedAt == null || b.attemptedAt == null) return 0;
        try {
          final dateA = DateTime.parse(a.attemptedAt!);
          final dateB = DateTime.parse(b.attemptedAt!);
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

    // Get first and last 3 tests
    final firstTests = sortedTests.take(3).toList();
    final lastTests =
        sortedTests.skip(math.max(0, sortedTests.length - 3)).toList();

    double firstAvg = 0;
    double lastAvg = 0;

    for (var test in firstTests) {
      if (test.totalScore != null && test.totalScore! > 0) {
        firstAvg += ((test.score ?? 0) / test.totalScore!) * 100;
      }
    }
    firstAvg /= firstTests.length;

    for (var test in lastTests) {
      if (test.totalScore != null && test.totalScore! > 0) {
        lastAvg += ((test.score ?? 0) / test.totalScore!) * 100;
      }
    }
    lastAvg /= lastTests.length;

    final improvement = lastAvg - firstAvg;

    if (improvement > 0) {
      return '+${improvement.toStringAsFixed(1)}%';
    } else if (improvement < 0) {
      return '${improvement.toStringAsFixed(1)}%';
    }
    return '0%';
  }

  List<Map<String, dynamic>> _getAchievements(
    Map<String, dynamic> stats,
    List<Data> tests,
  ) {
    final achievements = <Map<String, dynamic>>[];

    // Perfect scorer
    if (stats['highestScore'] == 100) {
      achievements.add({
        'title': 'Perfect Score',
        'icon': Icons.star_rounded,
        'color': const Color(0xFFFFD700),
      });
    }

    // High achiever
    if (stats['averageScore'] >= 85) {
      achievements.add({
        'title': 'High Achiever',
        'icon': Icons.emoji_events_rounded,
        'color': const Color(0xFF4CAF50),
      });
    }

    // Consistent performer
    if (stats['passRate'] >= 80 && tests.length >= 5) {
      achievements.add({
        'title': 'Consistent',
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFF2196F3),
      });
    }

    // Test master
    if (tests.length >= 20) {
      achievements.add({
        'title': 'Test Master',
        'icon': Icons.school_rounded,
        'color': const Color(0xFF9C27B0),
      });
    }

    // Quick learner
    final avgTime = stats['totalTime'] / math.max(tests.length, 1);
    if (avgTime < 300 && stats['averageScore'] >= 70) {
      achievements.add({
        'title': 'Quick Learner',
        'icon': Icons.flash_on_rounded,
        'color': const Color(0xFFFF9800),
      });
    }

    return achievements;
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Share Report Card',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing via email...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: const Text('Export as PDF'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating PDF...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.print_outlined),
                title: const Text('Print'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preparing for print...')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _downloadReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Downloading report...'),
          ],
        ),
      ),
    );
  }
}
