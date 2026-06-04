class StudyNote {
  const StudyNote({
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final String content;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
      };

  factory StudyNote.fromJson(Map<String, dynamic> json) => StudyNote(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
      );
}
