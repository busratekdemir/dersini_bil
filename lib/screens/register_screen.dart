import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'student/student_dashboard_screen.dart';
import 'teacher/teacher_dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  final _firestore = FirestoreService();
  String _role = 'student';
  String _classLevel = AppConstants.classLevels.first;
  bool _loading = false;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final fullName = _fullName.text.trim();
    final email = _email.text.trim();
    final password = _password.text.trim();
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Lütfen tüm alanları doldurun.');
      return;
    }
    if (password.length < 6) {
      _showMessage('Şifre en az 6 karakter olmalı.');
      return;
    }

    setState(() => _loading = true);
    try {
      final credential = await _auth.registerWithEmailAndPassword(email, password);
      final user = credential.user;
      if (user == null) throw Exception('Kullanıcı oluşturulamadı.');
      await user.updateDisplayName(fullName);
      await _auth.sendEmailVerification();
      await _firestore.createUserProfile(
        uid: user.uid,
        fullName: fullName,
        email: email,
        role: _role,
        classLevel: _role == 'student' ? _classLevel : null,
      );
      if (!mounted) return;
      final state = context.read<AppState>();
      await state.setRole(_role);
      if (_role == 'student') {
        await state.setClassLevel(_classLevel);
      }
      if (!mounted) return;
      _showMessage('Kayıt tamamlandı. Doğrulama e-postası gönderildi.');
      Navigator.pushNamedAndRemoveUntil(
        context,
        _role == 'teacher' ? TeacherDashboardScreen.routeName : StudentDashboardScreen.routeName,
        (route) => false,
      );
    } catch (error) {
      if (mounted) _showMessage(_friendlyError(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _friendlyError(Object error) {
    final text = error.toString();
    if (text.contains('email-already-in-use')) return 'Bu e-posta adresi zaten kayıtlı.';
    if (text.contains('invalid-email')) return 'Geçerli bir e-posta adresi girin.';
    if (text.contains('weak-password')) return 'Şifre en az 6 karakter olmalı.';
    return 'Kayıt sırasında bir hata oluştu. Lütfen tekrar deneyin.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Yeni hesap oluştur', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('Demo için yeni öğrenci veya öğretmen hesabı oluşturabilirsiniz.'),
                  const SizedBox(height: 20),
                  CustomTextField(controller: _fullName, label: 'Ad Soyad', icon: Icons.person),
                  const SizedBox(height: 12),
                  CustomTextField(controller: _email, label: 'E-posta', icon: Icons.mail),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _password,
                    label: 'Şifre',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'student', label: Text('Öğrenci')),
                      ButtonSegment(value: 'teacher', label: Text('Öğretmen')),
                    ],
                    selected: {_role},
                    onSelectionChanged: (values) => setState(() => _role = values.first),
                  ),
                  if (_role == 'student') ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _classLevel,
                      decoration: const InputDecoration(labelText: 'Sınıf'),
                      items: AppConstants.classLevels
                          .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                          .toList(),
                      onChanged: (value) => setState(() => _classLevel = value!),
                    ),
                  ],
                  const SizedBox(height: 20),
                  CustomButton(
                    label: _loading ? 'Kayıt yapılıyor...' : 'Kayıt Ol',
                    icon: Icons.person_add,
                    onPressed: _loading ? () {} : _register,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
