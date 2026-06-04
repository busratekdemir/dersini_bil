import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'services/app_state.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final storage = LocalStorageService();
  await storage.init();
  final notifications = NotificationService();
  await notifications.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(storage: storage, notifications: notifications)..load(),
      child: const DersiniBilApp(),
    ),
  );
}
