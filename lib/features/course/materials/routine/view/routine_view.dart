import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.week;

  final Map<String, Color> _lightModeActivityColors = {
    'Class': const Color(0xFF4CAF50),
    'Assignment': const Color(0xFFFF9800),
    'Exam': const Color(0xFFE53935),
    'Resource': const Color(0xFF2196F3),
  };

  final Map<String, Color> _darkModeActivityColors = {
    'Class': const Color(0xFF81C784),
    'Assignment': const Color(0xFFFFB74D),
    'Exam': const Color(0xFFEF5350),
    'Resource': const Color(0xFF64B5F6),
  };

  Map<String, Color> get _activityColors {
    return Theme.of(context).brightness == Brightness.dark
        ? _darkModeActivityColors
        : _lightModeActivityColors;
  }

  @override
  Widget build(BuildContext context) {
    final routineAsync = ref.watch(routineViewModelProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          context.l10n?.routine ?? 'Routine',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: routineAsync.when(
        data: (activities) => _buildRoutineContent(activities),
        loading: () => const CourseDetailsSkeleton(),
        error: (error, stack) => Center(
          child: Text(
            '${context.l10n?.error}: $error',
            style: GoogleFonts.outfit(),
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineContent(List<RoutineActivity> activities) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar section
            _buildCalendar().animate().fadeIn(duration: 400.ms),
            const Gap(28),

            // Selected day section with activity buttons
            _buildSelectedDaySection().animate().slideX(
                  begin: -0.1,
                  end: 0,
                  delay: 100.ms,
                  duration: 400.ms,
                ),
            const Gap(24),

            // Daily activities timeline
            _buildDailyActivitiesTimeline().animate().slideX(
                  begin: -0.1,
                  end: 0,
                  delay: 200.ms,
                  duration: 500.ms,
                ),
            const Gap(32),

            // Upcoming activity section
            _buildUpcomingActivitySection().animate().slideX(
                  begin: -0.1,
                  end: 0,
                  delay: 300.ms,
                  duration: 500.ms,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2D37) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
              weekendTextStyle: TextStyle(
                color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
              ),
              todayDecoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF3D5AFE).withOpacity(0.25)
                    : const Color(0xFF3D5AFE).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF3D5AFE),
                fontWeight: FontWeight.bold,
              ),
              selectedDecoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF3D5AFE)
                    : const Color(0xFF3D5AFE),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              defaultTextStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              weekNumberTextStyle: TextStyle(
                color: isDarkMode ? Colors.white38 : Colors.black38,
              ),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: true,
              formatButtonDecoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF3D5AFE).withOpacity(0.2)
                    : const Color(0xFF3D5AFE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              formatButtonTextStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : const Color(0xFF3D5AFE),
                fontWeight: FontWeight.w500,
              ),
              titleTextStyle: GoogleFonts.outfit(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left_rounded,
                color: isDarkMode ? Colors.white70 : Colors.black54,
                size: 28,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right_rounded,
                color: isDarkMode ? Colors.white70 : Colors.black54,
                size: 28,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.outfit(
                color: isDarkMode ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              weekendStyle: GoogleFonts.outfit(
                color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF3D5AFE).withOpacity(0.2)
                    : const Color(0xFF3D5AFE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.event_rounded,
                color: isDarkMode ? Colors.white70 : const Color(0xFF3D5AFE),
                size: 20,
              ),
            ),
            const Gap(12),
            Text(
              formattedDate,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: _buildCategoryButton('Class'),
            ),
            const Gap(12),
            Expanded(
              child: _buildCategoryButton('Assignment'),
            ),
            const Gap(12),
            Expanded(
              child: _buildCategoryButton('Exam'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String title) {
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

    final color = _activityColors[title] ?? Colors.grey;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? color.withOpacity(0.2) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(isDarkMode ? 0.3 : 0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              _getIconForActivityType(title),
              color: color,
              height: 18,
              width: 18,
            ),
            const Gap(8),
            Text(
              translatedTitle,
              style: GoogleFonts.outfit(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIconForActivityType(String type) {
    switch (type) {
      case 'Class':
        return "assets/icons/record_class.svg";
      case 'Assignment':
        return "assets/icons/assignment.svg";
      case 'Exam':
        return "assets/icons/test.svg";
      case 'Resource':
        return "assets/icons/resource.svg";
      default:
        return "assets/icons/record_class.svg";
    }
  }

  Widget _buildDailyActivitiesTimeline() {
    final activitiesForDay = ref
        .read(routineViewModelProvider.notifier)
        .getActivitiesForDay(_selectedDay);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF3D5AFE).withOpacity(0.2)
                    : const Color(0xFF3D5AFE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.schedule_rounded,
                color: isDarkMode ? Colors.white70 : const Color(0xFF3D5AFE),
                size: 20,
              ),
            ),
            const Gap(12),
            Text(
              context.l10n?.activity ?? 'Activity',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const Gap(20),
        if (activitiesForDay.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF2A2D37)
                  : const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.event_busy_rounded,
                    size: 48,
                    color: isDarkMode ? Colors.white30 : Colors.black26,
                  ),
                  const Gap(16),
                  Text(
                    context.l10n?.noActivitiesForDay ??
                        'No activities for this day',
                    style: GoogleFonts.outfit(
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2A2D37) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.15)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
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
            ),
          ),
      ],
    );
  }

  Widget _buildActivityTimelineItem({
    required RoutineActivity activity,
    required bool isLastItem,
  }) {
    final color = _activityColors[activity.type] ?? Colors.grey;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (!isLastItem)
                Container(
                  width: 2,
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color,
                        color.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Gap(16),
        // Activity content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      _getIconForActivityType(activity.type),
                      color: color,
                      height: 16,
                      width: 16,
                    ),
                    const Gap(6),
                    Text(
                      translatedType,
                      style: GoogleFonts.outfit(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Text(
                timeText,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              if (activity.details != null && activity.details!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    activity.details!,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              const Gap(24),
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

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF3D5AFE).withOpacity(0.2)
                    : const Color(0xFF3D5AFE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.upcoming_rounded,
                color: isDarkMode ? Colors.white70 : const Color(0xFF3D5AFE),
                size: 20,
              ),
            ),
            const Gap(12),
            Text(
              context.l10n?.upcomingActivity ?? 'Upcoming Activity',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const Gap(20),
        if (groupedUpcomingActivities.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF2A2D37)
                  : const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 48,
                    color: isDarkMode ? Colors.white30 : Colors.black26,
                  ),
                  const Gap(16),
                  Text(
                    context.l10n?.noUpcomingActivities ??
                        'No upcoming activities',
                    style: GoogleFonts.outfit(
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...groupedUpcomingActivities.entries.map((entry) {
            final dateString = entry.key;
            final activities = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 12),
                  child: Text(
                    dateString,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
                ...activities.map((activity) {
                  return _buildUpcomingActivityCard(activity, dateString);
                }).toList(),
                const Gap(24),
              ],
            );
          }).toList(),
      ],
    );
  }

  Widget _buildUpcomingActivityCard(
      RoutineActivity activity, String dateString) {
    final color = _activityColors[activity.type] ?? Colors.grey;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
          color: isDarkMode ? const Color(0xFF2A2D37) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    _getIconForActivityType(activity.type),
                    color: color,
                    height: 20,
                    width: 20,
                  ),
                  const Gap(10),
                  Text(
                    translatedType,
                    style: GoogleFonts.outfit(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            // Activity details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.details ?? activity.type,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          '${context.l10n?.dueTill ?? 'Due till'} ${activity.timeString}',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white54 : Colors.black54,
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
}
