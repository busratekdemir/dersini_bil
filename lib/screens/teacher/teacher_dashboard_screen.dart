import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../widgets/app_bottom_nav.dart';
import '../role_selection_screen.dart';
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

  Future<void> _confirmRoleChange() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rol değiştirilsin mi?'),
        content: const Text('Mevcut panelden çıkıp rol seçimi ekranına döneceksiniz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Rol Değiştir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await context.read<AppState>().clearRole();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      RoleSelectionScreen.routeName,
      (route) => false,
    );
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
            onPressed: _confirmRoleChange,
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Rol Değiştir'),
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
            const _TeacherMetric(title: 'Aktif öğrenci', value: '3', icon: Icons.groups),
            _TeacherMetric(title: 'Verilen ödev', value: '${state.assignedHomeworks.length}', icon: Icons.assignment),
            const _TeacherMetric(title: 'Hatırlatıcı', value: 'Açılabilir', icon: Icons.notifications),
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
