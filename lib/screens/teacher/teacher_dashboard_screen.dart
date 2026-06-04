import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../login_screen.dart';
import 'teacher_assign_homework_screen.dart';
import 'teacher_profile_screen.dart';
import 'teacher_schedule_screen.dart';
import 'teacher_students_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});
  static const routeName = '/teacher-dashboard';

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
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
      const _TeacherHome(),
      const TeacherStudentsScreen(),
      const TeacherScheduleScreen(),
      const TeacherAssignHomeworkScreen(),
      const TeacherProfileScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğretmen Paneli'),
        actions: [
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Oturumu Kapat'),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Öğrenciler'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Program'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_add), label: 'Ödev Ata'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class _TeacherHome extends StatelessWidget {
  const _TeacherHome();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = AuthService().currentUser;
    final firestore = FirestoreService();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('${state.teacherMode ?? 'Özel ders'} özeti', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _TeacherMetric(title: 'Bugünkü ders', value: '${state.schedules.length}', icon: Icons.today),
            _TeacherMetricStream(
              title: 'Aktif öğrenci',
              stream: user == null ? null : firestore.getTeacherStudentCount(user.uid),
              icon: Icons.groups,
            ),
            _TeacherMetricStream(
              title: 'Bekleyen istek',
              stream: user == null ? null : firestore.getTeacherPendingRequestCount(user.uid),
              icon: Icons.person_add_alt,
            ),
            _TeacherMetricStream(
              title: 'Verilen ödev',
              stream: user == null ? null : firestore.getTeacherAssignedHomeworkCount(user.uid),
              icon: Icons.assignment,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Yaklaşan ders saatleri'),
            subtitle: Text(state.schedules.isEmpty
                ? 'Programdan ders ekleyebilirsiniz.'
                : state.schedules.first.title),
          ),
        ),
      ],
    );
  }
}


class _TeacherMetricStream extends StatelessWidget {
  const _TeacherMetricStream({required this.title, required this.stream, required this.icon});

  final String title;
  final Stream<int>? stream;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final countStream = stream;
    if (countStream == null) {
      return _TeacherMetric(title: title, value: '0', icon: icon);
    }
    return StreamBuilder<int>(
      stream: countStream,
      builder: (context, snapshot) {
        final value = snapshot.data ?? 0;
        return _TeacherMetric(title: title, value: '$value', icon: icon);
      },
    );
  }
}

class _TeacherMetric extends StatelessWidget {
  const _TeacherMetric({required this.title, required this.value, required this.icon});
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
