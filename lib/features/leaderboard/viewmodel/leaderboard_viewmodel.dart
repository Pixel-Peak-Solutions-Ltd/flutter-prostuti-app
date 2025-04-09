import 'package:prostuti/features/leaderboard/model/leaderboard_model.dart';
import 'package:prostuti/features/leaderboard/repository/leaderboard_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leaderboard_viewmodel.g.dart';

@riverpod
class GlobalLeaderboard extends _$GlobalLeaderboard {
  List<LeaderboardData> _leaderboardData = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMore => _hasMore;

  @override
  Future<List<LeaderboardData>> build() async {
    _currentPage = 1;
    _leaderboardData = await _fetchLeaderboard();
    return _leaderboardData;
  }

  Future<List<LeaderboardData>> _fetchLeaderboard() async {
    final response =
        await ref.read(leaderboardRepoProvider).getGlobalLeaderboard(
              page: _currentPage,
              limit: _limit,
            );

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (leaderboardResponse) {
        // Check if there are more items to load
        final total = leaderboardResponse.meta?.count ?? 0;
        _hasMore = _currentPage * _limit < total;

        return leaderboardResponse.data ?? [];
      },
    );
  }

  Future<void> loadMoreData() async {
    if (_isLoadingMore || !_hasMore) return;

    try {
      state = const AsyncValue.loading();
      _isLoadingMore = true;
      _currentPage++;

      final moreData = await _fetchLeaderboard();
      _leaderboardData = [..._leaderboardData, ...moreData];

      state = AsyncValue.data(_leaderboardData);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  void refreshLeaderboard() {
    _currentPage = 1;
    _hasMore = true;
    ref.invalidateSelf();
  }
}

@riverpod
class CourseLeaderboard extends _$CourseLeaderboard {
  List<LeaderboardData> _leaderboardData = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String _courseId = '';

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMore => _hasMore;

  @override
  Future<List<LeaderboardData>> build(String courseId) async {
    _courseId = courseId;
    _currentPage = 1;
    _leaderboardData = await _fetchLeaderboard();
    return _leaderboardData;
  }

  Future<List<LeaderboardData>> _fetchLeaderboard() async {
    final response =
        await ref.read(leaderboardRepoProvider).getCourseLeaderboard(
              courseId: _courseId,
              page: _currentPage,
              limit: _limit,
            );

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (leaderboardResponse) {
        // Check if there are more items to load
        final total = leaderboardResponse.meta?.count ?? 0;
        _hasMore = _currentPage * _limit < total;

        return leaderboardResponse.data ?? [];
      },
    );
  }

  Future<void> loadMoreData() async {
    if (_isLoadingMore || !_hasMore) return;

    try {
      state = const AsyncValue.loading();
      _isLoadingMore = true;
      _currentPage++;

      final moreData = await _fetchLeaderboard();
      _leaderboardData = [..._leaderboardData, ...moreData];

      state = AsyncValue.data(_leaderboardData);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  void refreshLeaderboard() {
    _currentPage = 1;
    _hasMore = true;
    ref.invalidateSelf();
  }
}
