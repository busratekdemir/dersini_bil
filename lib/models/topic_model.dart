class Topic {
  const Topic({
    required this.id,
    required this.subject,
    required this.title,
    this.isCompleted = false,
  });

  final String id;
  final String subject;
  final String title;
  final bool isCompleted;

  Topic copyWith({bool? isCompleted}) {
    return Topic(
      id: id,
      subject: subject,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'title': title,
        'isCompleted': isCompleted,
      };

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'] as String,
        subject: json['subject'] as String,
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}
