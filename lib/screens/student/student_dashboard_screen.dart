import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../login_screen.dart';
import 'student_homework_screen.dart';
import 'student_notes_screen.dart';
import 'student_progress_screen.dart';
import 'student_teacher_match_screen.dart';
import 'student_topic_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});
  static const routeName = '/student-dashboard';

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _index = 0;

  Future<void> _logout() async {
    try {
      await AuthService().logout();
      if (!mounted) return;
      await context.read<AppState>().clearSession();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oturum kapatılamadı. Lütfen tekrar deneyin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _StudentHome(),
      const StudentTopicScreen(),
      const StudentHomeworkScreen(),
      const StudentProgressScreen(),
      const StudentNotesScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dersini Bil'),
        actions: [
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Oturumu Kapat'),
          ),
          IconButton(
            tooltip: 'Öğretmenim',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StudentTeacherMatchScreen()),
            ),
            icon: const Icon(Icons.handshake),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Konular'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Ödevler'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Grafikler'),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: 'Notlar'),
        ],
      ),
    );
  }
}

class _StudentHome extends StatelessWidget {
  const _StudentHome();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final todayHomework = state.homeworks.where((item) => !item.isCompleted).length;
    final plannedQuestions = state.progressEntries.isEmpty
        ? 80
        : state.progressEntries.last.questionCount + 20;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Merhaba, ${state.classLevel ?? '8. sınıf'} planı hazır.',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _SummaryCard(title: 'Bugünkü ödev', value: '$todayHomework', icon: Icons.assignment),
            _SummaryCard(title: 'Planlanan soru', value: '$plannedQuestions', icon: Icons.calculate),
            _SummaryCard(title: 'Tamamlanan konu', value: '${state.completedTopics.length}', icon: Icons.task_alt),
            _SummaryCard(title: 'Aktif Hatırlatıcı', value: 'Açık', icon: Icons.notifications),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.bolt),
            title: const Text('Motivasyon'),
            subtitle: const Text('Bugün küçük ama net bir adım at. Düzenli takip büyük fark yaratır.'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Yaklaşan hatırlatmalar'),
            subtitle: Text(state.homeworks.isEmpty
                ? 'Henüz ödev yok'
                : '${state.homeworks.first.title}; teslim tarihi yaklaşıyor.'),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(title),
          ],
        ),
      ),
    );
  }
}
