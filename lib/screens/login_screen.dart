import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'role_selection_screen.dart';

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
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    final ok = await _auth.login(_email.text, _password.text);
    await _auth.sendVerificationEmail(_email.text);
    setState(() => _loading = false);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doğrulama e-postası gönderildi. Demo için onaylandı.')),
      );
      Navigator.pushReplacementNamed(context, RoleSelectionScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-posta ve şifre alanları boş bırakılamaz.')),
      );
    }
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
