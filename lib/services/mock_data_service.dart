import '../models/homework_model.dart';
import '../models/student_model.dart';
import '../models/teacher_model.dart';

class MockDataService {
  static const teacher = Teacher(
    name: 'Ayşe Yılmaz',
    code: 'OGR123',
    subjects: ['Matematik', 'Fen Bilimleri'],
  );

  static final students = [
    const Student(
      name: 'Ece Demir',
      classLevel: '8. sınıf',
      subjects: ['Matematik', 'Türkçe'],
      progress: 0.72,
    ),
    const Student(
      name: 'Mert Kaya',
      classLevel: '7. sınıf',
      subjects: ['Fen Bilimleri', 'İngilizce'],
      progress: 0.54,
    ),
    const Student(
      name: 'Zeynep Arslan',
      classLevel: 'Mezun / sınava hazırlık',
      subjects: ['Matematik', 'Sosyal Bilgiler'],
      progress: 0.81,
    ),
  ];

  static final demoHomework = [
    Homework(
      id: 'hw-demo-1',
      title: 'Üslü ifadeler testini bitir',
      subject: 'Matematik',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Homework(
      id: 'hw-demo-2',
      title: 'Paragraf 40 soru',
      subject: 'Türkçe',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
  ];
}
