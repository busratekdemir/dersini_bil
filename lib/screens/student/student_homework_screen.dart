import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class StudentHomeworkScreen extends StatefulWidget {
  const StudentHomeworkScreen({super.key});

  @override
  State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
}

class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
  bool _notificationShown = false;

  Future<void> _sendTestNotification() async {
    try {
      await context.read<AppState>().notifications.showInstantNotification(
            title: 'Dersini Bil',
            body: 'Bu bir test bildirimidir.',
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test bildirimi gönderildi.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test bildirimi gönderilemedi.')),
      );
    }
  }

  void _showHomeworkNotificationOnce() {
    if (_notificationShown) return;
    _notificationShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await context.read<AppState>().notifications.showInstantNotification(
              title: 'Yeni ödevlerin var',
              body: 'Ödevler ekranından detayları kontrol edebilirsin.',
            );
      } catch (_) {
        // Snackbar zaten ekranın kendi durumunu gösteriyor; bildirim izni kapalıysa sessiz geç.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final firestore = FirestoreService();
    if (user == null) {
      return const Center(child: Text('Ödevleri görmek için giriş yapmalısınız.'));
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.getStudentHomeworks(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Ödevler yüklenemedi.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final homeworks = snapshot.data!.docs;
          if (homeworks.isNotEmpty) _showHomeworkNotificationOnce();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Ödevlerim', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _sendTestNotification,
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Test Bildirimi Gönder'),
                ),
              ),
              const SizedBox(height: 12),
              if (homeworks.isEmpty)
                const Card(child: ListTile(title: Text('Henüz atanmış ödeviniz yok.')))
              else
                ...homeworks.map((doc) {
                  final data = doc.data();
                  final title = (data['title'] as String?) ?? 'Ödev';
                  final description = (data['description'] as String?) ?? '';
                  final timestamp = data['dueDate'] as Timestamp?;
                  final dueDate = timestamp?.toDate();
                  final isCompleted = (data['isCompleted'] as bool?) ?? false;
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (value) async {
                          try {
                            await firestore.markHomeworkCompleted(doc.id, value ?? false);
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ödev durumu güncellenemedi.')),
                              );
                            }
                          }
                        },
                      ),
                      title: Text(title),
                      subtitle: Text(
                        '${description.isEmpty ? 'Açıklama yok' : description}\nTeslim: ${_formatDate(dueDate)}\n${isCompleted ? 'Tamamlandı' : 'Tamamlanmadı'}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}.${date.month}.${date.year}';
  }
}
