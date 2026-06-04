class LessonSchedule {
  const LessonSchedule({
    required this.id,
    required this.title,
    required this.lessonType,
    required this.dateTime,
  });

  final String id;
  final String title;
  final String lessonType;
  final DateTime dateTime;
}
