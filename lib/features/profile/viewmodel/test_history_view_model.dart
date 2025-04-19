import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/all_test_history_model.dart';
import '../repository/test_history_repo.dart';

part 'test_history_view_model.g.dart';

@riverpod
class TestHistoryViewModel extends _$TestHistoryViewModel {
  @override
  FutureOr<List<Data>> build({required String studentId}) {
    _studentId = studentId;
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return fetchTestHistory();
  }

  late String _studentId;
  int _currentPage = 1;
  int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  List<Data> _allTests = [];

  Future<List<Data>> fetchTestHistory({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _allTests = [];
    }

    if (!_hasMore && !refresh) return _allTests;

    final repo = ref.read(testHistoryRepoProvider);
    final result = await repo.getAllTestHistory(
      studentId: _studentId,
      page: _currentPage,
      limit: _limit,
    );

    return result.fold(
      (error) => _allTests,
      (testHistoryModel) {
        if (testHistoryModel.data?.data != null) {
          final meta = testHistoryModel.data?.meta;
          final newTests = testHistoryModel.data?.data;

          if (meta != null &&
              newTests != null &&
              newTests.isNotEmpty &&
              meta.page! * meta.limit! < meta.count!) {
            _currentPage++;
            _hasMore = true;
          } else {
            _hasMore = false;
          }

          if (refresh) {
            _allTests = List<Data>.from(newTests!);
          } else {
            _allTests.addAll(List<Data>.from(newTests!));
          }

          return _allTests;
        }
        return _allTests;
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state is AsyncLoading || _isLoadingMore) return;

    _isLoadingMore = true;

    // Use state.whenData to preserve the current data while loading more
    state.whenData((currentData) {
      // This optional update signals in the UI that more data is loading
      // without showing the full loading state
      state = AsyncData(currentData);
    });

    try {
      final updatedData = await fetchTestHistory();
      state = AsyncData(updatedData);
    } catch (e, stackTrace) {
      // If an error occurs, keep the current data
      state.whenData((currentData) {
        state = AsyncData(currentData);
      });
      // You might want to log the error or notify the user
      print('Error loading more tests: $e\n$stackTrace');
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refreshTests() async {
    state = const AsyncLoading();
    state = AsyncData(await fetchTestHistory(refresh: true));
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}
