import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/student/student_class_selection_screen.dart';
import 'screens/student/student_dashboard_screen.dart';
import 'screens/teacher/teacher_dashboard_screen.dart';
import 'screens/teacher/teacher_mode_selection_screen.dart';
import 'utils/app_theme.dart';

class DersiniBilApp extends StatelessWidget {
  const DersiniBilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dersini Bil',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        RoleSelectionScreen.routeName: (_) => const RoleSelectionScreen(),
        StudentClassSelectionScreen.routeName: (_) => const StudentClassSelectionScreen(),
        StudentDashboardScreen.routeName: (_) => const StudentDashboardScreen(),
        TeacherModeSelectionScreen.routeName: (_) => const TeacherModeSelectionScreen(),
        TeacherDashboardScreen.routeName: (_) => const TeacherDashboardScreen(),
      },
    );
  }
}
