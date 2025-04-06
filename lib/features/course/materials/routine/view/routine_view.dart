import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/course/course_details/widgets/course_details_skeleton.dart';
import 'package:table_calendar/table_calendar.dart';

import '../viewmodel/routine_viewmodel.dart';

class RoutineView extends ConsumerStatefulWidget {
  const RoutineView({Key? key}) : super(key: key);

  @override
  ConsumerState<RoutineView> createState() => _RoutineViewState();
}

class _RoutineViewState extends ConsumerState<RoutineView> with CommonWidgets {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final Map<String, Color> _activityColors = {
    'Class': Colors.green,
    'Assignment': Colors.amber,
    'Exam': Colors.red,
    'Resource': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    final routineAsync = ref.watch(routineViewModelProvider);

    return Scaffold(
      body: routineAsync.when(
        data: (activities) => _buildRoutineContent(activities),
        loading: () => const CourseDetailsSkeleton(),
        error: (error, stack) => Center(
          child: Text('${context.l10n?.error}: $error'),
        ),
      ),
    );
  }

  Widget _buildRoutineContent(List<RoutineActivity> activities) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar section
            _buildCalendar(),
            const Gap(20),

            // Selected day section with activity buttons
            _buildSelectedDaySection(),
            const Gap(16),

            // Daily activities timeline
            _buildDailyActivitiesTimeline(),
            const Gap(25),

            // Upcoming activity section
            _buildUpcomingActivitySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: true,
            weekendTextStyle: TextStyle(color: Colors.red),
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: Theme.of(context).textTheme.titleMedium!,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final eventTypes = ref
                  .read(routineViewModelProvider.notifier)
                  .getEventTypesForDay(date);
              return _buildEventMarkers(eventTypes);
            },
          ),
        ),
      ),
    );
  }

  Widget? _buildEventMarkers(Map<String, bool> eventTypes) {
    List<Widget> dots = [];

    eventTypes.forEach((type, hasEvent) {
      if (hasEvent) {
        dots.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _activityColors[type] ?? Colors.grey,
            ),
          ),
        );
      }
    });

    if (dots.isEmpty) return null;

    return Positioned(
      bottom: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: dots,
      ),
    );
  }

  Widget _buildSelectedDaySection() {
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedDate,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: _buildCategoryButton('Class', Colors.green.shade100),
            ),
            const Gap(8),
            Expanded(
              child: _buildCategoryButton('Assignment', Colors.amber.shade100),
            ),
            const Gap(8),
            Expanded(
              child: _buildCategoryButton('Exam', Colors.red.shade100),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String title, Color color) {
    String translatedTitle;
    switch (title) {
      case 'Class':
        translatedTitle = context.l10n?.classs ?? 'Class';
        break;
      case 'Assignment':
        translatedTitle = context.l10n?.assignment ?? 'Assignment';
        break;
      case 'Exam':
        translatedTitle = context.l10n?.exam ?? 'Exam';
        break;
      case 'Resource':
        translatedTitle = context.l10n?.resource ?? 'Resource';
        break;
      default:
        translatedTitle = title;
    }

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          translatedTitle,
          style: TextStyle(
            color: _activityColors[title] ?? Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDailyActivitiesTimeline() {
    final activitiesForDay = ref
        .read(routineViewModelProvider.notifier)
        .getActivitiesForDay(_selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n?.activity ?? 'Activity',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const Gap(16),
        if (activitiesForDay.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                context.l10n?.noActivitiesForDay ??
                    'No activities for this day',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activitiesForDay.length,
            itemBuilder: (context, index) {
              final activity = activitiesForDay[index];
              final bool isLastItem = index == activitiesForDay.length - 1;

              return _buildActivityTimelineItem(
                activity: activity,
                isLastItem: isLastItem,
              );
            },
          ),
      ],
    );
  }

  Widget _buildActivityTimelineItem({
    required RoutineActivity activity,
    required bool isLastItem,
  }) {
    final color = _activityColors[activity.type] ?? Colors.grey;

    // Translate the activity type
    String translatedType;
    switch (activity.type) {
      case 'Class':
        translatedType = context.l10n?.classs ?? 'Class';
        break;
      case 'Assignment':
        translatedType = context.l10n?.assignment ?? 'Assignment';
        break;
      case 'Exam':
        translatedType = context.l10n?.exam ?? 'Exam';
        break;
      case 'Resource':
        translatedType = context.l10n?.resource ?? 'Resource';
        break;
      default:
        translatedType = activity.type;
    }

    final String timeText = activity.type == 'Assignment'
        ? '${context.l10n?.dueTill ?? 'Due till'} ${activity.timeString}'
        : '${context.l10n?.at ?? 'at'} ${activity.timeString}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot and line
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLastItem)
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
        ),
        const Gap(12),
        // Activity content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$translatedType $timeText',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (activity.details != null && activity.details!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    activity.details!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              const Gap(16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingActivitySection() {
    final groupedUpcomingActivities = ref
        .read(routineViewModelProvider.notifier)
        .getGroupedUpcomingActivities();

    if (groupedUpcomingActivities.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n?.upcomingActivity ?? 'Upcoming Activity',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                context.l10n?.noUpcomingActivities ?? 'No upcoming activities',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n?.upcomingActivity ?? 'Upcoming Activity',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const Gap(16),
        ...groupedUpcomingActivities.entries.map((entry) {
          final dateString = entry.key;
          final activities = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: activities.map((activity) {
              return _buildUpcomingActivityCard(activity, dateString);
            }).toList(),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildUpcomingActivityCard(
      RoutineActivity activity, String dateString) {
    final color = _activityColors[activity.type] ?? Colors.grey;

    // Translate the activity type
    String translatedType;
    switch (activity.type) {
      case 'Class':
        translatedType = context.l10n?.classs ?? 'Class';
        break;
      case 'Assignment':
        translatedType = context.l10n?.assignment ?? 'Assignment';
        break;
      case 'Exam':
        translatedType = context.l10n?.exam ?? 'Exam';
        break;
      case 'Resource':
        translatedType = context.l10n?.resource ?? 'Resource';
        break;
      default:
        translatedType = activity.type;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity type badge
            Container(
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                translatedType,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Activity details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateString,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${context.l10n?.dueTill ?? 'Due till'} ${activity.timeString}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey.shade700,
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
}
