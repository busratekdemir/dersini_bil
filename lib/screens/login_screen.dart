import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'register_screen.dart';
import 'role_selection_screen.dart';
import 'student/student_dashboard_screen.dart';
import 'teacher/teacher_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'demo@dersinibil.com');
  final _password = TextEditingController(text: '123456');
  final _auth = AuthService();
  final _firestore = FirestoreService();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _email.text.trim();
    final password = _password.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showMessage('E-posta ve şifre alanları boş bırakılamaz.');
      return;
    }

    setState(() => _loading = true);
    try {
      final ok = await _auth.login(email, password);
      if (!ok) {
        _showMessage('E-posta ve şifre alanları boş bırakılamaz.');
        return;
      }
      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı bilgisi alınamadı.');
      if (!_auth.isEmailVerified) {
        _showMessage('E-posta adresinizi doğrulamanız önerilir. Demo için devam ediliyor.');
      }
      final profile = await _firestore.getUserProfile(user.uid);
      if (!mounted) return;
      if (profile == null) {
        _showMessage('Profil bulunamadı. Lütfen rol seçimiyle devam edin.');
        Navigator.pushReplacementNamed(context, RoleSelectionScreen.routeName);
        return;
      }
      final role = profile['role'] as String?;
      final state = context.read<AppState>();
      if (role == 'student') {
        await state.setRole('student');
        final classLevel = profile['classLevel'] as String?;
        if (classLevel != null && classLevel.isNotEmpty) {
          await state.setClassLevel(classLevel);
        }
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          StudentDashboardScreen.routeName,
          (route) => false,
        );
      } else if (role == 'teacher') {
        await state.setRole('teacher');
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          TeacherDashboardScreen.routeName,
          (route) => false,
        );
      } else {
        Navigator.pushReplacementNamed(context, RoleSelectionScreen.routeName);
      }
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
    if (text.contains('user-not-found') || text.contains('wrong-password') || text.contains('invalid-credential')) {
      return 'E-posta veya şifre hatalı.';
    }
    if (text.contains('invalid-email')) return 'Geçerli bir e-posta adresi girin.';
    return 'Giriş sırasında bir hata oluştu. Lütfen tekrar deneyin.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.school, size: 64),
                  const SizedBox(height: 14),
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Demo için yeni öğrenci veya öğretmen hesabı oluşturabilirsiniz.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  CustomTextField(controller: _email, label: 'E-posta', icon: Icons.mail),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _password,
                    label: 'Şifre',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: _loading ? 'Giriş yapılıyor...' : 'Giriş Yap',
                    icon: Icons.login,
                    onPressed: _loading ? () {} : _login,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            ),
                    child: const Text('Hesabın yok mu? Kayıt Ol'),
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
