import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class StudentTeacherMatchScreen extends StatefulWidget {
  const StudentTeacherMatchScreen({super.key});

  @override
  State<StudentTeacherMatchScreen> createState() => _StudentTeacherMatchScreenState();
}

class _StudentTeacherMatchScreenState extends State<StudentTeacherMatchScreen> {
  final _code = TextEditingController();
  final _auth = AuthService();
  final _firestore = FirestoreService();
  bool _loading = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _sendRequest() async {
    final code = _code.text.trim().toUpperCase();
    final user = _auth.currentUser;
    if (user == null) {
      _showMessage('Eşleşme isteği için giriş yapmalısınız.');
      return;
    }
    if (code.isEmpty) {
      _showMessage('Lütfen öğretmen kodunu girin.');
      return;
    }

    setState(() => _loading = true);
    try {
      final teacher = await _firestore.findTeacherByCode(code);
      if (teacher == null) {
        _showMessage('Bu koda ait öğretmen bulunamadı.');
        return;
      }
      final studentProfile = await _firestore.getUserProfile(user.uid);
      await _firestore.sendMatchRequest(
        studentId: user.uid,
        studentName: (studentProfile?['fullName'] as String?) ?? user.email ?? 'Öğrenci',
        teacherId: teacher['uid'] as String,
        teacherName: (teacher['fullName'] as String?) ?? 'Öğretmen',
      );
      if (!mounted) return;
      _showMessage('Eşleşme isteği gönderildi.');
    } catch (error) {
      if (!mounted) return;
      if (error.toString().contains('duplicate-match-request')) {
        _showMessage('Bu öğretmene zaten istek gönderdiniz veya eşleşmeniz mevcut.');
      } else {
        _showMessage('Eşleşme isteği gönderilemedi. Lütfen tekrar deneyin.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Öğretmenim')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CustomTextField(controller: _code, label: 'Öğretmen kodu', icon: Icons.key),
          const SizedBox(height: 12),
          CustomButton(
            label: _loading ? 'Gönderiliyor...' : 'Eşleşme İsteği Gönder',
            icon: Icons.handshake,
            onPressed: _loading ? () {} : _sendRequest,
          ),
        ],
      ),
    );
  }
}
