import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/notification_model.dart';
import '../repository/notification_repo.dart';

part 'notification_viewmodel.g.dart';

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  @override
  FutureOr<List<Data>> build() {
    return fetchNotifications();
  }

  List<Data> _todayNotifications = [];
  List<Data> _previousNotifications = [];

  Future<List<Data>> fetchNotifications() async {
    final repo = ref.read(notificationRepoProvider);
    final result = await repo.getNotifications();

    return result.fold(
          (error) => [],
          (notificationModel) {
        if (notificationModel.data != null) {
          final allNotifications = notificationModel.data!;
          _categorizeNotifications(allNotifications);

          return allNotifications;
        }
        return [];
      },
    );
  }

  void _categorizeNotifications(List<Data> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _todayNotifications = [];
    _previousNotifications = [];

    for (var notification in notifications) {
      try {
        final createdAt = DateTime.parse(notification.createdAt ?? '');
        final createdDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

        if (createdDate.isAtSameMomentAs(today)) {
          _todayNotifications.add(notification);
        } else {
          _previousNotifications.add(notification);
        }
      } catch (e) {
        _todayNotifications.add(notification);
      }
    }
  }

  Future<void> refreshNotifications() async {
    state = const AsyncLoading();
    state = AsyncData(await fetchNotifications());
  }

  List<Data> get todayNotifications => _todayNotifications;
  List<Data> get previousNotifications => _previousNotifications;
}