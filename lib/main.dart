import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pediatrack/app.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';
import 'package:pediatrack/core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await whoGrowthService.loadData();
  await NotificationService.initialize();
  runApp(
    const ProviderScope(
      child: PediaTrackApp(),
    ),
  );
}
