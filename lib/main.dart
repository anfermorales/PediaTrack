import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pediatrack/app.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await whoGrowthService.loadData();
  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [Locale('es', 'MX')],
        home: PediaTrackApp(),
      ),
    ),
  );
}