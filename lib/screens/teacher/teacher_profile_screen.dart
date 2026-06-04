import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Profil', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (user == null)
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Profil bilgisi için giriş yapmalısınız.'),
            ),
          )
        else
          FutureBuilder<Map<String, dynamic>?>(
            future: FirestoreService().getUserProfile(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final profile = snapshot.data;
              final fullName = (profile?['fullName'] as String?) ?? user.displayName ?? 'Öğretmen';
              final email = (profile?['email'] as String?) ?? user.email ?? '-';
              final teacherCode = (profile?['teacherCode'] as String?) ?? '-';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(fullName),
                      subtitle: Text('$email\nRol: Öğretmen'),
                      isThreeLine: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Eşleşme Kodum', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          SelectableText(
                            teacherCode,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          const Text('Öğrenciler bu kodu girerek size eşleşme isteği gönderebilir.'),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
