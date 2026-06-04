class Student {
  const Student({
    required this.name,
    required this.classLevel,
    required this.subjects,
    required this.progress,
  });

  final String name;
  final String classLevel;
  final List<String> subjects;
  final double progress;
}
