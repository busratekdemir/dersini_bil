import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class TeacherStudentsScreen extends StatelessWidget {
  const TeacherStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final firestore = FirestoreService();
    if (user == null) {
      return const Center(child: Text('Öğrencileri görmek için giriş yapmalısınız.'));
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Öğrencilerim', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text('Gelen Eşleşme İstekleri', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore.getTeacherMatchRequests(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Card(child: ListTile(title: Text('Eşleşme istekleri yüklenemedi.')));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final requests = snapshot.data!.docs;
            if (requests.isEmpty) {
              return const Card(child: ListTile(title: Text('Bekleyen eşleşme isteği yok.')));
            }
            return Column(
              children: requests.map((request) {
                final data = request.data();
                final studentName = (data['studentName'] as String?) ?? 'Öğrenci';
                final studentId = data['studentId'] as String?;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person_add_alt),
                    title: Text(studentName),
                    subtitle: const Text('Eşleşme isteği gönderdi.'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: studentId == null
                              ? null
                              : () async {
                                  try {
                                    await firestore.acceptMatchRequest(request.id, studentId, user.uid);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Eşleşme isteği kabul edildi.')),
                                      );
                                    }
                                  } catch (_) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('İstek kabul edilemedi.')),
                                      );
                                    }
                                  }
                                },
                          child: const Text('Kabul Et'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await firestore.rejectMatchRequest(request.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Eşleşme isteği reddedildi.')),
                                );
                              }
                            } catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('İstek reddedilemedi.')),
                                );
                              }
                            }
                          },
                          child: const Text('Reddet'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        Text('Eşleşmiş Öğrencilerim', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: firestore.getTeacherStudents(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Card(child: ListTile(title: Text('Öğrenciler yüklenemedi.')));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final students = snapshot.data!;
            if (students.isEmpty) {
              return const Card(child: ListTile(title: Text('Henüz eşleşmiş öğrenciniz yok.')));
            }
            return Column(
              children: students.map((student) {
                final name = (student['fullName'] as String?) ?? 'Öğrenci';
                final classLevel = (student['classLevel'] as String?) ?? 'Sınıf bilgisi yok';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(name.characters.first)),
                    title: Text(name),
                    subtitle: Text(classLevel),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
