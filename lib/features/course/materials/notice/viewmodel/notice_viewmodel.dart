import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/notice_model.dart';
import '../repository/notice_repo.dart';

part 'notice_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class CourseNotices extends _$CourseNotices {
  List<NoticeData> _notices = [];
  List<NoticeData> _todaysNotices = [];
  List<NoticeData> _yesterdaysNotices = [];
  List<NoticeData> _olderNotices =
      []; // Changed from twoDaysAgoNotices to olderNotices

  List<NoticeData> get todaysNotices => _todaysNotices;

  List<NoticeData> get yesterdaysNotices => _yesterdaysNotices;

  List<NoticeData> get olderNotices => _olderNotices; // Changed getter name

  @override
  Future<List<NoticeData>> build(String courseId) async {
    _notices = await getNoticesByCourseId(courseId);
    _categorizeNoticesByDate();
    return _notices;
  }

  Future<List<NoticeData>> getNoticesByCourseId(String courseId) async {
    final response =
        await ref.read(noticeRepoProvider).getNoticesByCourseId(courseId);

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (notices) {
        return notices.data ?? [];
      },
    );
  }

  void _categorizeNoticesByDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    _todaysNotices = [];
    _yesterdaysNotices = [];
    _olderNotices = [];

    for (var notice in _notices) {
      if (notice.createdAt != null) {
        try {
          final createdAt = DateTime.parse(notice.createdAt!);
          final createdDate =
              DateTime(createdAt.year, createdAt.month, createdAt.day);
          final difference = today.difference(createdDate).inDays;

          if (difference == 0) {
            _todaysNotices.add(notice);
          } else if (difference == 1) {
            _yesterdaysNotices.add(notice);
          } else {
            _olderNotices.add(notice);
          }
        } catch (e) {
          // If date parsing fails, add to older notices
          _olderNotices.add(notice);
        }
      } else {
        // If no date, add to older notices
        _olderNotices.add(notice);
      }
    }
  }
}
