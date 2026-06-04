class Homework {
  const Homework({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.studentName,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String? studentName;
  final bool isCompleted;

  Homework copyWith({bool? isCompleted}) {
    return Homework(
      id: id,
      title: title,
      subject: subject,
      dueDate: dueDate,
      studentName: studentName,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'dueDate': dueDate.toIso8601String(),
        'studentName': studentName,
        'isCompleted': isCompleted,
      };

  factory Homework.fromJson(Map<String, dynamic> json) => Homework(
        id: json['id'] as String,
        title: json['title'] as String,
        subject: json['subject'] as String,
        dueDate: DateTime.parse(json['dueDate'] as String),
        studentName: json['studentName'] as String?,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}
