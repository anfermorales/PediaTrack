import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pediatrack/app.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';
import 'package:pediatrack/core/services/notification_service.dart';
import 'package:pediatrack/core/services/auto_backup_scheduler.dart';
import 'package:pediatrack/data/database/app_database.dart';
import 'package:pediatrack/core/providers/database_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await whoGrowthService.loadData();
  await NotificationService.initialize();
  await AutoBackupScheduler.initialize();
  await AutoBackupScheduler.syncFromDatabase();

  final db = AppDatabase();
  final savedTheme = await db.getSetting('theme_mode');
  setInitialThemeMode(_themeFromString(savedTheme));
  await db.close();

  runApp(
    const ProviderScope(
      child: PediaTrackApp(initialTheme: ThemeMode.light),
    ),
  );
}

ThemeMode _themeFromString(String? value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.light;
  }
}
