import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
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
  await _seedChildrenWithExpectedData();
  runApp(
    const ProviderScope(
      child: PediaTrackApp(),
    ),
  );
}

Future<void> _seedChildrenWithExpectedData() async {
  final db = AppDatabase();

  final existingChildren = await db.getAllChildren();
  final existingNames = existingChildren.map((c) => c.name).toSet();

  final childrenToSeed = <_ChildSeedData>[
    _ChildSeedData(
      name: 'Sofía Fernanda Morales León',
      birthDate: DateTime(2022, 11, 28),
      gender: 1,
    ),
    _ChildSeedData(
      name: 'Carlos Gustavo Morales León',
      birthDate: DateTime(2025, 3, 17),
      gender: 0,
    ),
  ];

  for (final childData in childrenToSeed) {
    if (existingNames.contains(childData.name)) {
      continue;
    }

    final birthWeightKg = whoGrowthService.valueFromPercentile(
      percentile: 50,
      ageMonths: 0,
      gender: childData.gender,
      type: GrowthType.weight,
    );
    final birthHeightCm = whoGrowthService.valueFromPercentile(
      percentile: 50,
      ageMonths: 0,
      gender: childData.gender,
      type: GrowthType.height,
    );

    final childId = await db.insertChild(ChildrenCompanion.insert(
      name: childData.name,
      birthDate: childData.birthDate,
      gender: childData.gender,
      birthWeight: drift.Value(birthWeightKg),
      birthHeight: drift.Value(birthHeightCm),
    ));

    await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
      childId: childId,
      date: childData.birthDate,
      weight: drift.Value(birthWeightKg),
      height: drift.Value(birthHeightCm),
    ));

    final now = DateTime.now();
    final currentAgeMonths = (now.year - childData.birthDate.year) * 12 +
        (now.month - childData.birthDate.month);

    for (int month = 1; month <= currentAgeMonths && month <= 60; month++) {
      final weightKg = whoGrowthService.valueFromPercentile(
        percentile: 50,
        ageMonths: month,
        gender: childData.gender,
        type: GrowthType.weight,
      );
      final heightCm = whoGrowthService.valueFromPercentile(
        percentile: 50,
        ageMonths: month,
        gender: childData.gender,
        type: GrowthType.height,
      );
      final recordDate = DateTime(
        childData.birthDate.year,
        childData.birthDate.month + month,
        childData.birthDate.day,
      );

      if (recordDate.isAfter(now)) break;

      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: childId,
        date: recordDate,
        weight: drift.Value(weightKg),
        height: drift.Value(heightCm),
      ));
    }
  }

  await db.close();
}

class _ChildSeedData {
  final String name;
  final DateTime birthDate;
  final int gender;

  const _ChildSeedData({
    required this.name,
    required this.birthDate,
    required this.gender,
  });
}


