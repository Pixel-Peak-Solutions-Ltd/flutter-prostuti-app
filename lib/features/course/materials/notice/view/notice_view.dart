import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../viewmodel/notice_viewmodel.dart';
import '../widgets/notice_card.dart';
import '../widgets/notice_section_header.dart';

class NoticeView extends ConsumerWidget with CommonWidgets {
  final String courseId;

  NoticeView({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsyncValue = ref.watch(courseNoticesProvider(courseId));
    final noticesNotifier = ref.watch(courseNoticesProvider(courseId).notifier);

    return Scaffold(
      appBar: commonAppbar(context.l10n!.notices),
      body: noticesAsyncValue.when(
        data: (_) => _buildNoticeList(context, noticesNotifier),
        loading: () => _buildLoadingState(context),
        error: (error, stackTrace) => Center(
          child: Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NoticeSectionHeader(title: "Today's Notices"),
            for (int i = 0; i < 3; i++)
              const NoticeCard(
                notice:
                    "I've finished adding my notes. Happy for us to review whenever you're ready!",
                timeAgo: "2 mins ago",
              ),
            const NoticeSectionHeader(title: "Yesterday's Notices"),
            for (int i = 0; i < 3; i++)
              const NoticeCard(
                notice:
                    "I've finished adding my notes. Happy for us to review whenever you're ready!",
                timeAgo: "2 mins ago",
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeList(BuildContext context, CourseNotices noticesNotifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's notices
            if (noticesNotifier.todaysNotices.isNotEmpty) ...[
              NoticeSectionHeader(title: context.l10n!.todaysNotices),
              ...noticesNotifier.todaysNotices.map((notice) => NoticeCard(
                    notice: notice.notice ?? "",
                    timeAgo: _getTimeAgo(notice.createdAt),
                  )),
            ],

            // Yesterday's notices
            if (noticesNotifier.yesterdaysNotices.isNotEmpty) ...[
              NoticeSectionHeader(title: context.l10n!.yesterdaysNotices),
              ...noticesNotifier.yesterdaysNotices.map((notice) => NoticeCard(
                    notice: notice.notice ?? "",
                    timeAgo: _getTimeAgo(notice.createdAt),
                  )),
            ],

            // Older notices
            if (noticesNotifier.olderNotices.isNotEmpty) ...[
              NoticeSectionHeader(title: context.l10n!.olderNotices),
              ...noticesNotifier.olderNotices.map((notice) => NoticeCard(
                    notice: notice.notice ?? "",
                    timeAgo: _getTimeAgo(notice.createdAt),
                  )),
            ],

            // No notices
            if (noticesNotifier.todaysNotices.isEmpty &&
                noticesNotifier.yesterdaysNotices.isEmpty &&
                noticesNotifier.olderNotices.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    context.l10n!.noNotices,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(String? dateTimeString) {
    if (dateTimeString == null) return "N/A";

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return "${difference.inMinutes} mins ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hours ago";
      } else {
        return "${difference.inDays} days ago";
      }
    } catch (e) {
      return "N/A";
    }
  }
}
