import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_text_field.dart';

class TeacherAssignHomeworkScreen extends StatefulWidget {
  const TeacherAssignHomeworkScreen({super.key});

  @override
  State<TeacherAssignHomeworkScreen> createState() => _TeacherAssignHomeworkScreenState();
}

class _TeacherAssignHomeworkScreenState extends State<TeacherAssignHomeworkScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _auth = AuthService();
  final _firestore = FirestoreService();
  String? _studentId;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 3));
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _assignHomework() async {
    final user = _auth.currentUser;
    final studentId = _studentId;
    final title = _title.text.trim();
    final description = _description.text.trim();
    if (user == null) {
      _showMessage('Ödev atamak için giriş yapmalısınız.');
      return;
    }
    if (studentId == null) {
      _showMessage('Lütfen bir öğrenci seçin.');
      return;
    }
    if (title.isEmpty || description.isEmpty) {
      _showMessage('Ödev başlığı ve açıklama boş bırakılamaz.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _firestore.assignHomework(
        teacherId: user.uid,
        studentId: studentId,
        title: title,
        description: description,
        dueDate: _dueDate,
      );
      if (mounted) {
        await context.read<AppState>().notifications.showInstantNotification(
              title: 'Ödev Atandı',
              body: 'Ödev başarıyla kaydedildi.',
            );
      }
      _title.clear();
      _description.clear();
      if (mounted) _showMessage('Ödev başarıyla atandı.');
    } catch (_) {
      if (mounted) _showMessage('Ödev atanamadı. Lütfen tekrar deneyin.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text('Ödev atamak için giriş yapmalısınız.'));
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestore.getTeacherStudents(user.uid),
      builder: (context, snapshot) {
        final students = snapshot.data ?? const <Map<String, dynamic>>[];
        if (_studentId == null && students.isNotEmpty) {
          _studentId = students.first['uid'] as String?;
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Ödev Atama', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(child: CircularProgressIndicator())
            else if (students.isEmpty)
              const Card(child: ListTile(title: Text('Ödev atamak için önce bir öğrenciyle eşleşmelisiniz.')))
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _studentId,
                        decoration: const InputDecoration(labelText: 'Öğrenci'),
                        items: students.map((student) {
                          final id = student['uid'] as String;
                          final name = (student['fullName'] as String?) ?? 'Öğrenci';
                          return DropdownMenuItem(value: id, child: Text(name));
                        }).toList(),
                        onChanged: (value) => setState(() => _studentId = value),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _title, label: 'Ödev başlığı'),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _description, label: 'Açıklama', maxLines: 3),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.event),
                        label: Text('Teslim: ${_dueDate.day}.${_dueDate.month}.${_dueDate.year}'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            initialDate: _dueDate,
                          );
                          if (picked != null) setState(() => _dueDate = picked);
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _loading ? null : _assignHomework,
                          icon: const Icon(Icons.send),
                          label: Text(_loading ? 'Atanıyor...' : 'Ödev Ata'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
