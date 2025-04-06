class HomeRoutineActivity {
  final String type; // Class, Assignment, Exam, Resource
  final String title;
  final String courseName;
  final DateTime time;
  final String timeString;
  final String? details;
  final String? id;

  HomeRoutineActivity({
    required this.type,
    required this.title,
    required this.courseName,
    required this.time,
    required this.timeString,
    this.details,
    this.id,
  });
}
