import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../model/home_screen_model.dart';
import '../viewmodel/home_routine_viewmodel.dart';

class HomeRoutineWidget extends ConsumerWidget {
  const HomeRoutineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineAsync = ref.watch(homeRoutineViewModelProvider);

    return routineAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return _buildNoActivitiesState(context);
        }

        return _buildRoutineSection(context, activities, ref);
      },
      loading: () => _buildLoadingState(context),
      error: (error, __) => _buildErrorState(context, error.toString(), ref),
    );
  }

  Widget _buildRoutineSection(BuildContext context,
      List<HomeRoutineActivity> activities, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n?.todaysRoutine ?? 'আজকের ক্লাসকলাপ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                context.l10n?.seeMore ?? 'আরো দেখুন',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                    ),
              ),
            ],
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF7D92F3), // Color from figma
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show only first 3 activities
                for (var activity in activities.take(3))
                  _buildActivityItem(context, activity, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      BuildContext context, HomeRoutineActivity activity, WidgetRef ref) {
    // Get translated type
    String translatedType;
    switch (activity.type) {
      case 'Class':
        translatedType = context.l10n?.classs ?? 'ক্লাস';
        break;
      case 'Assignment':
        translatedType = context.l10n?.assignment ?? 'অ্যাসাইনমেন্ট';
        break;
      case 'Exam':
        translatedType = context.l10n?.exam ?? 'পরীক্ষা';
        break;
      case 'Resource':
        translatedType = context.l10n?.resource ?? 'রিসোর্স';
        break;
      default:
        translatedType = activity.type;
    }

    // Define colors for different activity types
    final Map<String, Color> activityColors = {
      'Class': Colors.green,
      'Assignment': Colors.amber,
      'Exam': Colors.red,
      'Resource': Colors.blue,
    };

    final color = activityColors[activity.type] ?? Colors.grey;
    final backgroundColor = _getBackgroundColor(activity.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  translatedType,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            activity.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          Row(
            children: [
              Expanded(
                child: Text(
                  activity.courseName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Gap(8),
        ],
      ),
    );
  }

  // No Activities State with Calendar Design
  Widget _buildNoActivitiesState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity, // Ensure full width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(12),
          Container(
            width: double.infinity, // Ensure full width
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF7D92F3), // Match Figma blue color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align content
              children: [
                // Calendar-style date display
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateTime.now().day.toString(),
                        style: const TextStyle(
                          color: Color(0xFF7D92F3),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getMonthAbbreviation(DateTime.now().month),
                        style: const TextStyle(
                          color: Color(0xFF7D92F3),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                // No activities message
                Text(
                  context.l10n?.noActivitiesToday ?? 'আজ কোন কার্যক্রম নেই',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  context.l10n?.enjoyyourFreeTime ??
                      'আপনার ফ্রি সময় উপভোগ করুন!',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                // Rest Icon
                Icon(
                  Icons.more_time_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Loading State with Skeletonizer
  Widget _buildLoadingState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title skeleton
            Container(
              width: 180,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Gap(12),
            // Calendar-like container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7D92F3).withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Calendar header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.chevron_left, color: Colors.white54),
                      Container(
                        width: 120,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white54),
                    ],
                  ),
                  const Gap(16),
                  // Week days
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      7,
                      (index) => Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  // Activity placeholders
                  for (int i = 0; i < 2; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const Gap(8),
                          Container(
                            width: double.infinity,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const Gap(4),
                          Container(
                            width: 200,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Error State with Modern UI
  Widget _buildErrorState(
      BuildContext context, String errorMessage, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n?.todaysRoutine ?? 'আজকের ক্লাসকলাপ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red.shade400,
                    size: 32,
                  ),
                ),
                const Gap(16),
                Text(
                  context.l10n?.routineLoadError ?? 'কার্যক্রম লোড করতে ত্রুটি',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  context.l10n?.tryAgainLater ??
                      'দয়া করে পরে আবার চেষ্টা করুন',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                OutlinedButton(
                  onPressed: () {
                    // Refresh the provider
                    ref.refresh(homeRoutineViewModelProvider);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    side: BorderSide(color: Colors.blue.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(context.l10n?.tryAgain ?? 'আবার চেষ্টা করুন'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return '';
    }
  }

  Color _getBackgroundColor(String type) {
    switch (type) {
      case 'Class':
        return const Color(0xFFE2F7E9); // Light green
      case 'Assignment':
        return const Color(0xFFFFF7E1); // Light yellow
      case 'Exam':
        return const Color(0xFFFFE7E7); // Light red
      case 'Resource':
        return const Color(0xFFE0F3FF); // Light blue
      default:
        return Colors.grey.shade200;
    }
  }
}
