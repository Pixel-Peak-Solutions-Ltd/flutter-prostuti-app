import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
import '../viewmodel/notification_viewmodel.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'নোটিফিকেশন',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade100,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(notificationViewModelProvider.notifier).refreshNotifications();
        },
        child: Consumer(
          builder: (context, ref, child) {
            final notificationsAsync = ref.watch(notificationViewModelProvider);

            return notificationsAsync.when(
              data: (notifications) {
                final notificationViewModel = ref.read(notificationViewModelProvider.notifier);
                final todayNotifications = notificationViewModel.todayNotifications;
                final previousNotifications = notificationViewModel.previousNotifications;

                if (notifications.isEmpty) {
                  return const Center(
                    child: Text('No notifications available'),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Today's Notifications
                      if (todayNotifications.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'আজকের নোটিশ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...todayNotifications.map((notification) =>
                            NotificationCard(notification: notification),
                        ),
                        SizedBox(height: 16),
                      ],

                      // Previous Notifications
                      if (previousNotifications.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'পূর্বের নোটিশ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...previousNotifications.map((notification) =>
                            NotificationCard(notification: notification),
                        ),
                      ],
                    ],
                  ),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error loading notifications: $error'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Data notification;

  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  String _getTimeAgo(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} mins ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } catch (e) {
      return '2 mins ago'; // Default fallback for the design
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Colors.amber,
                  size: 24,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notification.title ?? 'Exam Reminder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _getTimeAgo(notification.createdAt ?? ''),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              notification.message ?? "I've finished adding my notes. Happy for us to review whenever you're ready!",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}