import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/localization_service.dart';

import '../model/all_test_history_model.dart';
import '../viewmodel/test_history_view_model.dart';
import '../widgets/no_test_history.dart';
import '../widgets/test_history_card.dart';
import '../widgets/test_history_graph.dart';
import '../widgets/test_history_shimmer.dart';

class TestHistoryScreen extends ConsumerStatefulWidget {
  final String studentId;

  const TestHistoryScreen({super.key, required this.studentId});

  @override
  ConsumerState<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends ConsumerState<TestHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final viewModel = ref.read(
          testHistoryViewModelProvider(studentId: widget.studentId).notifier);
      if (viewModel.hasMore) {
        viewModel.loadMore();
      }
    }
  }

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
          'Test History',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: textColor,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: accentColor),
            onPressed: () {
              _showFilterMenu(context);
            },
            tooltip: 'Filter tests',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: accentColor,
        onRefresh: () async {
          await ref
              .read(testHistoryViewModelProvider(studentId: widget.studentId)
                  .notifier)
              .refreshTests();
        },
        child: Consumer(
          builder: (context, ref, child) {
            final testHistoryState = ref.watch(
              testHistoryViewModelProvider(studentId: widget.studentId),
            );

            return testHistoryState.when(
              data: (tests) {
                if (tests.isEmpty) {
                  return const TestHistoryEmptyState();
                }

                // Filter tests based on selection
                final filteredTests = _filterTests(tests, _selectedFilter);

                // Calculate stats for the header
                final completedTests = tests.length;
                final passedTests =
                    tests.where((test) => test.isPassed == true).length;
                final passRate = completedTests > 0
                    ? (passedTests / completedTests * 100).round()
                    : 0;

                // Check if more data is being loaded
                final isLoadingMore = ref
                    .read(testHistoryViewModelProvider(
                            studentId: widget.studentId)
                        .notifier)
                    .isLoadingMore;

                return CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Stats header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode
                                    ? Colors.black12
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.assignment_turned_in_rounded,
                                      label: 'Tests Completed',
                                      value: '$completedTests',
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      textColor: textColor,
                                      secondaryColor: secondaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.check_circle_outline_rounded,
                                      label: 'Tests Passed',
                                      value: '$passedTests',
                                      iconColor: const Color(0xFF4CAF50),
                                      textColor: textColor,
                                      secondaryColor: secondaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.auto_graph_rounded,
                                      label: 'Pass Rate',
                                      value: '$passRate%',
                                      iconColor: const Color(0xFF42A5F5),
                                      textColor: textColor,
                                      secondaryColor: secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Performance graph section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Performance Overview',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                            TestPerformanceGraph(tests: tests),
                          ],
                        ),
                      ),
                    ),

                    // Filter chips
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Test Records',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.filter_list_rounded,
                                    size: 16,
                                    color: accentColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _selectedFilter,
                                    style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Filter chips row
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildFilterChip('All', accentColor, isDarkMode),
                              _buildFilterChip(
                                  'Passed', accentColor, isDarkMode),
                              _buildFilterChip(
                                  'Failed', accentColor, isDarkMode),
                              _buildFilterChip('MCQ', accentColor, isDarkMode),
                              _buildFilterChip(
                                  'Written', accentColor, isDarkMode),
                              _buildFilterChip(
                                  'Recent', accentColor, isDarkMode),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Test history cards list
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: filteredTests.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Text(
                                  'No tests match your filter',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index == filteredTests.length) {
                                    // Loading indicator at the end
                                    return ref
                                            .read(testHistoryViewModelProvider(
                                                    studentId: widget.studentId)
                                                .notifier)
                                            .hasMore
                                        ? Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 24),
                                              child: CircularProgressIndicator(
                                                  color: accentColor),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }

                                  final test = filteredTests[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: TestHistoryCard(test: test),
                                  );
                                },
                                childCount: filteredTests.length +
                                    (ref
                                            .read(testHistoryViewModelProvider(
                                                    studentId: widget.studentId)
                                                .notifier)
                                            .hasMore
                                        ? 1
                                        : 0),
                              ),
                            ),
                    ),

                    // Loading more indicator
                    if (isLoadingMore)
                      SliverToBoxAdapter(
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child:
                                CircularProgressIndicator(color: accentColor),
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const TestHistoryShimmer(),
              error: (error, stackTrace) {
                print("Error: $error");
                print("stackTrace: $stackTrace");
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.8),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color textColor,
    required Color secondaryColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: secondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, Color accentColor, bool isDarkMode) {
    final isSelected = _selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedFilter = label;
            });
          }
        },
        labelStyle: TextStyle(
          color: isSelected
              ? isDarkMode
                  ? Colors.white
                  : Colors.black
              : isDarkMode
                  ? Colors.white70
                  : Colors.black87,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        backgroundColor:
            isDarkMode ? Colors.black12 : Colors.black.withOpacity(0.05),
        selectedColor: accentColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  List<Data> _filterTests(List<Data> tests, String filter) {
    switch (filter) {
      case 'Passed':
        return tests.where((test) => test.isPassed == true).toList();
      case 'Failed':
        return tests.where((test) => test.isPassed == false).toList();
      case 'MCQ':
        return tests.where((test) => test.testId?.type == 'MCQ').toList();
      case 'Written':
        return tests.where((test) => test.testId?.type == 'Written').toList();
      case 'Recent':
        final sortedTests = List<Data>.from(tests)
          ..sort((a, b) {
            if (a.attemptedAt == null || b.attemptedAt == null) return 0;
            return DateTime.parse(b.attemptedAt!)
                .compareTo(DateTime.parse(a.attemptedAt!));
          });
        return sortedTests.take(5).toList();
      default:
        return tests;
    }
  }

  void _showFilterMenu(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Tests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              _buildFilterOption(
                  context, 'All Tests', 'All', Icons.list_alt_rounded),
              _buildFilterOption(context, 'Passed Tests', 'Passed',
                  Icons.check_circle_outline_rounded),
              _buildFilterOption(
                  context, 'Failed Tests', 'Failed', Icons.cancel_outlined),
              _buildFilterOption(
                  context, 'MCQ Tests', 'MCQ', Icons.quiz_rounded),
              _buildFilterOption(
                  context, 'Written Tests', 'Written', Icons.edit_note_rounded),
              _buildFilterOption(
                  context, 'Recent Tests', 'Recent', Icons.access_time_rounded),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
      BuildContext context, String title, String value, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedFilter == value;
    final accentColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? accentColor
            : (isDarkMode ? Colors.white70 : Colors.grey[700]),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: accentColor) : null,
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(context);
      },
    );
  }
}
