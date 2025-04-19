import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/all_test_history_model.dart';

class TestPerformanceGraph extends StatefulWidget {
  final List<Data> tests;

  const TestPerformanceGraph({
    super.key,
    required this.tests,
  });

  @override
  State<TestPerformanceGraph> createState() => _TestPerformanceGraphState();
}

class _TestPerformanceGraphState extends State<TestPerformanceGraph> {
  int _selectedChartType = 0;
  final List<String> _chartOptions = ['Score Trend', 'Performance Types'];

  @override
  Widget build(BuildContext context) {
    if (widget.tests.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No test data available'),
        ),
      );
    }

    // Theme colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final backgroundColor = Theme.of(context).cardColor;
    final gridColor = isDark ? Colors.white12 : Colors.black12;

    // Colors for chart
    final passingColor = const Color(0xFF4CAF50);
    final failingColor = const Color(0xFFE53935);
    final mcqColor = const Color(0xFF42A5F5);
    final writtenColor = const Color(0xFFFF7043);

    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Chart type selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_chartOptions.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_chartOptions[index]),
                    selected: _selectedChartType == index,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedChartType = index;
                        });
                      }
                    },
                    labelStyle: TextStyle(
                      color: _selectedChartType == index
                          ? isDark
                              ? Colors.white
                              : Colors.black
                          : textColor.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    backgroundColor: isDark
                        ? Colors.black12
                        : Colors.black.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Chart display
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _selectedChartType == 0
                  ? _buildScoreTrendChart(context, textColor, gridColor)
                  : _buildPerformanceTypesChart(context, passingColor,
                      failingColor, mcqColor, writtenColor, textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreTrendChart(
      BuildContext context, Color textColor, Color gridColor) {
    // Sort tests by date for the trend
    final validTests = widget.tests
        .where((test) => test.attemptedAt != null && (test.totalScore ?? 0) > 0)
        .toList();

    if (validTests.isEmpty) {
      return Center(
        child: Text(
          'Not enough data to display chart',
          style: TextStyle(color: textColor),
        ),
      );
    }

    final sortedTests = List<Data>.from(validTests)
      ..sort((a, b) {
        return DateTime.parse(a.attemptedAt!)
            .compareTo(DateTime.parse(b.attemptedAt!));
      });

    // Limit to the most recent 10 tests for clarity
    final displayTests = sortedTests.length > 10
        ? sortedTests.sublist(sortedTests.length - 10)
        : sortedTests;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: isDark ? const Color(0xFF303030) : Colors.white,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final test = displayTests[group.x.toInt()];
              final testName = test.testId?.name ?? 'Unknown Test';
              final courseType = test.testId?.type ?? '';
              final score = test.score ?? 0;
              final totalScore = test.totalScore ?? 1;
              final percentage = (score / totalScore) * 100;
              final isPassed = test.isPassed ?? false;

              String datePart = '';
              if (test.attemptedAt != null) {
                try {
                  final date = DateTime.parse(test.attemptedAt!);
                  datePart = DateFormat('MMM d, yyyy').format(date);
                } catch (_) {
                  datePart = 'Unknown date';
                }
              }

              return BarTooltipItem(
                testName,
                TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(
                    text: '\n$courseType • $datePart\n',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: '${percentage.toStringAsFixed(1)}% • ',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: isPassed ? 'Passed' : 'Failed',
                    style: TextStyle(
                      color: isPassed
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFE53935),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= displayTests.length) {
                  return const SizedBox.shrink();
                }

                // Only show some labels for readability
                if (displayTests.length > 5) {
                  if (index != 0 &&
                      index != displayTests.length - 1 &&
                      index % (displayTests.length ~/ 3) != 0) {
                    return const SizedBox.shrink();
                  }
                }

                final test = displayTests[index];
                String label = '';

                if (test.attemptedAt != null) {
                  try {
                    final date = DateTime.parse(test.attemptedAt!);
                    label = DateFormat('dd/MM').format(date);
                  } catch (_) {
                    label = '';
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: gridColor,
            strokeWidth: 0.8,
            dashArray: [5, 5],
          ),
        ),
        barGroups: List.generate(
          displayTests.length,
          (index) {
            final test = displayTests[index];
            final score = test.score ?? 0;
            final totalScore = test.totalScore ?? 1; // Ensure non-zero
            final percentage = (score / totalScore) * 100;
            final isPassed = test.isPassed ?? false;

            // Ensure width is not NaN or negative
            final barWidth = displayTests.length > 7 ? 8.0 : 14.0;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: percentage.isNaN ? 0 : percentage, // Guard against NaN
                  color: isPassed
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE53935),
                  width: barWidth,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 100,
                    color: (isPassed
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935))
                        .withOpacity(0.1),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.easeInOutCubic,
    );
  }

  Widget _buildPerformanceTypesChart(BuildContext context, Color passingColor,
      Color failingColor, Color mcqColor, Color writtenColor, Color textColor) {
    // Calculate test type stats
    int mcqTests = 0;
    int writtenTests = 0;
    int passedTests = 0;
    int failedTests = 0;

    for (var test in widget.tests) {
      if (test.isPassed ?? false) {
        passedTests++;
      } else {
        failedTests++;
      }

      if (test.testId?.type == 'MCQ') {
        mcqTests++;
      } else if (test.testId?.type == 'Written') {
        writtenTests++;
      }
    }

    final total = passedTests + failedTests;

    if (total == 0) {
      return Center(
        child: Text(
          'Not enough data to display chart',
          style: TextStyle(color: textColor),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            // Pass/Fail distribution
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Pass/Fail',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                        sections: [
                          if (passedTests > 0)
                            PieChartSectionData(
                              value: passedTests.toDouble(),
                              title:
                                  '${((passedTests / total) * 100).round()}%',
                              color: passingColor,
                              radius: 40,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          if (failedTests > 0)
                            PieChartSectionData(
                              value: failedTests.toDouble(),
                              title:
                                  '${((failedTests / total) * 100).round()}%',
                              color: failingColor,
                              radius: 40,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Passed', passingColor, '$passedTests'),
                      const SizedBox(width: 12),
                      _buildLegendItem('Failed', failingColor, '$failedTests'),
                    ],
                  ),
                ],
              ),
            ),

            // Test type distribution
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Test Types',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: mcqTests == 0 && writtenTests == 0
                        ? Center(
                            child: Text(
                              'No test type data',
                              style:
                                  TextStyle(color: textColor.withOpacity(0.7)),
                            ),
                          )
                        : PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 30,
                              sections: [
                                if (mcqTests > 0)
                                  PieChartSectionData(
                                    value: mcqTests.toDouble(),
                                    title:
                                        '${((mcqTests / (mcqTests + writtenTests)) * 100).round()}%',
                                    color: mcqColor,
                                    radius: 40,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (writtenTests > 0)
                                  PieChartSectionData(
                                    value: writtenTests.toDouble(),
                                    title:
                                        '${((writtenTests / (mcqTests + writtenTests)) * 100).round()}%',
                                    color: writtenColor,
                                    radius: 40,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('MCQ', mcqColor, '$mcqTests'),
                      const SizedBox(width: 12),
                      _buildLegendItem(
                          'Written', writtenColor, '$writtenTests'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, [String? count]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          count != null ? '$label ($count)' : label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
