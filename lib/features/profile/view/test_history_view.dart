import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/services/localization_service.dart';
import '../model/all_test_history_model.dart';

import '../viewmodel/test_history_view_model.dart';
import '../widgets/no_test_history.dart';
import '../widgets/test_history_card.dart';
import '../widgets/test_history_shimmer.dart';

class TestHistoryScreen extends ConsumerStatefulWidget {
  final String studentId;

  const TestHistoryScreen({super.key, required this.studentId});

  @override
  ConsumerState<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends ConsumerState<TestHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

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
      final viewModel = ref.read(testHistoryViewModelProvider(studentId: widget.studentId).notifier);
      if (viewModel.hasMore) {
        viewModel.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test History'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(testHistoryViewModelProvider(studentId: widget.studentId).notifier)
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

                return ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: tests.length + (ref.read(testHistoryViewModelProvider(studentId: widget.studentId).notifier).hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == tests.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final test = tests[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TestHistoryCard(test: test),
                    );
                  },
                );
              },
              loading: () => const TestHistoryShimmer(),
              error: (error, stackTrace) {
                print("Error : $error");
                print("stackTrace : $stackTrace");
                return Text("${context.l10n!.error}: $error");
              }
            );
          },
        ),
      ),
    );
  }
}