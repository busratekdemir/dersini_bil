class ProgressEntry {
  const ProgressEntry({
    required this.id,
    required this.subject,
    required this.questionCount,
    required this.netScore,
    required this.date,
  });

  final String id;
  final String subject;
  final int questionCount;
  final double netScore;
  final DateTime date;

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'questionCount': questionCount,
        'netScore': netScore,
        'date': date.toIso8601String(),
      };

  factory ProgressEntry.fromJson(Map<String, dynamic> json) => ProgressEntry(
        id: json['id'] as String,
        subject: json['subject'] as String,
        questionCount: json['questionCount'] as int,
        netScore: (json['netScore'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );
}
