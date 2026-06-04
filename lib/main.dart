import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'services/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageService();
  await storage.init();
  final notifications = NotificationService();
  await notifications.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(storage: storage, notifications: notifications)..load(),
      child: const DersiniBilApp(),
    ),
  );
}
