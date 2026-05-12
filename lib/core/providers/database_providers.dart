import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pediatrack/data/database/app_database.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final whoGrowthServiceProvider = Provider<WhoGrowthService>((ref) {
  return whoGrowthService;
});

final childrenStreamProvider = StreamProvider<List<ChildrenData>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllChildren();
});

final childProvider = FutureProvider.family<ChildrenData?, int>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.getChildById(id);
});

final growthRecordsStreamProvider =
    StreamProvider.family<List<GrowthRecord>, int>((ref, childId) {
  final db = ref.watch(databaseProvider);
  return db.watchGrowthRecordsForChild(childId);
});

final todayHabitsProvider =
    FutureProvider.family<List<HabitRecord>, int>((ref, childId) async {
  final db = ref.watch(databaseProvider);
  return db.getTodayHabitsForChild(childId);
});

final selectedChildIdProvider = StateProvider<int?>((ref) => null);

final navigationIndexProvider = StateProvider<int>((ref) => 0);

enum AppAlertType { vaccineOverdue, vaccineUpcoming, growthOutOfRange }

class AppAlert {
  final AppAlertType type;
  final int childId;
  final String childName;
  final String title;
  final String message;
  final DateTime createdAt;

  const AppAlert({
    required this.type,
    required this.childId,
    required this.childName,
    required this.title,
    required this.message,
    required this.createdAt,
  });
}

final alertsProvider = FutureProvider<List<AppAlert>>((ref) async {
  final db = ref.watch(databaseProvider);
  final service = ref.watch(whoGrowthServiceProvider);
  final children = await db.getAllChildren();
  final now = DateTime.now();
  final upcomingLimit = now.add(const Duration(days: 30));
  final alerts = <AppAlert>[];

  for (final child in children) {
    final definitions = await db.getAllVaccineDefinitions();
    final appliedVaccines = await db.getChildVaccines(child.id);

    for (final def in definitions) {
      final isApplied = appliedVaccines.any((v) => v.vaccineDefinitionId == def.id);
      if (isApplied) continue;

      final dueDate = child.birthDate.add(Duration(days: def.recommendedAgeMonths * 30));
      if (dueDate.isBefore(now)) {
        alerts.add(AppAlert(
          type: AppAlertType.vaccineOverdue,
          childId: child.id,
          childName: child.name,
          title: 'Vacuna atrasada',
          message: '${def.name} (${def.doseNumber}/${def.totalDoses}) debió aplicarse el ${_date(dueDate)}.',
          createdAt: dueDate,
        ));
      } else if (!dueDate.isAfter(upcomingLimit)) {
        alerts.add(AppAlert(
          type: AppAlertType.vaccineUpcoming,
          childId: child.id,
          childName: child.name,
          title: 'Vacuna próxima',
          message: '${def.name} (${def.doseNumber}/${def.totalDoses}) está programada para ${_date(dueDate)}.',
          createdAt: dueDate,
        ));
      }
    }

    final growthRecords = await db.getGrowthRecordsForChild(child.id);
    if (growthRecords.isNotEmpty) {
      final latest = growthRecords.first;
      final ageMonths = ((now.year - child.birthDate.year) * 12 + (now.month - child.birthDate.month)).clamp(0, 60);

      if (latest.weight != null) {
        final weightEval = service.evaluate(
          value: latest.weight!,
          ageMonths: ageMonths,
          gender: child.gender,
          type: GrowthType.weight,
        );
        if (weightEval.percentile < 3 || weightEval.percentile > 97) {
          alerts.add(AppAlert(
            type: AppAlertType.growthOutOfRange,
            childId: child.id,
            childName: child.name,
            title: 'Peso fuera de curva',
            message: 'El último peso está en P${weightEval.percentile.toStringAsFixed(0)}. Requiere revisión.',
            createdAt: latest.date,
          ));
        }
      }

      if (latest.height != null) {
        final heightEval = service.evaluate(
          value: latest.height!,
          ageMonths: ageMonths,
          gender: child.gender,
          type: GrowthType.height,
        );
        if (heightEval.percentile < 3 || heightEval.percentile > 97) {
          alerts.add(AppAlert(
            type: AppAlertType.growthOutOfRange,
            childId: child.id,
            childName: child.name,
            title: 'Estatura fuera de curva',
            message: 'La última estatura está en P${heightEval.percentile.toStringAsFixed(0)}. Requiere revisión.',
            createdAt: latest.date,
          ));
        }
      }
    }
  }

  alerts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return alerts;
});

final unprocessedAlertsCountProvider = Provider<int>((ref) {
  final alertsAsync = ref.watch(alertsProvider);
  return alertsAsync.maybeWhen(
    data: (alerts) => alerts.length,
    orElse: () => 0,
  );
});

String _date(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final y = date.year.toString();
  return '$d/$m/$y';
}

class GrowthEvaluationParams {
  final double value;
  final int ageMonths;
  final int gender;
  final GrowthType type;

  const GrowthEvaluationParams({
    required this.value,
    required this.ageMonths,
    required this.gender,
    required this.type,
  });
}

class GrowthEvaluationResult {
  final double zScore;
  final String category;
  final double percentile;

  const GrowthEvaluationResult({
    required this.zScore,
    required this.category,
    required this.percentile,
  });
}

final growthEvaluationProvider = Provider.family<GrowthEvaluationResult, GrowthEvaluationParams>(
  (ref, params) {
    final service = ref.watch(whoGrowthServiceProvider);
    final result = service.evaluate(
      value: params.value,
      ageMonths: params.ageMonths,
      gender: params.gender,
      type: params.type,
    );
    return GrowthEvaluationResult(
      zScore: result.zScore,
      category: result.category,
      percentile: result.percentile,
    );
  },
);

final vaccineDefinitionsProvider = StreamProvider<List<VaccineDefinition>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllVaccineDefinitions();
});

final childVaccinesProvider =
    StreamProvider.family<List<ChildVaccine>, int>((ref, childId) {
  final db = ref.watch(databaseProvider);
  return db.watchChildVaccines(childId);
});

class VaccineScheduleItem {
  final VaccineDefinition definition;
  final ChildVaccine? appliedVaccine;
  final DateTime dueDate;
  final bool isOverdue;
  final bool isCompleted;

  VaccineScheduleItem({
    required this.definition,
    this.appliedVaccine,
    required this.dueDate,
    required this.isOverdue,
    required this.isCompleted,
  });
}

final vaccineScheduleProvider = FutureProvider.family<List<VaccineScheduleItem>, int>((ref, childId) async {
  final db = ref.watch(databaseProvider);
  final child = await db.getChildById(childId);
  if (child == null) return [];

  final definitions = await db.getAllVaccineDefinitions();
  final appliedVaccines = await db.getChildVaccines(childId);

  final ageInMonths = DateTime.now().difference(child.birthDate).inDays ~/ 30;

  final schedule = <VaccineScheduleItem>[];
  for (final def in definitions) {
    final applied = appliedVaccines
        .where((av) => av.vaccineDefinitionId == def.id)
        .toList();

    final isCompleted = applied.isNotEmpty;
    final dueDate = child.birthDate.add(Duration(days: def.recommendedAgeMonths * 30));
    final isOverdue = !isCompleted && DateTime.now().isAfter(dueDate);

    schedule.add(VaccineScheduleItem(
      definition: def,
      appliedVaccine: applied.isNotEmpty ? applied.first : null,
      dueDate: dueDate,
      isOverdue: isOverdue,
      isCompleted: isCompleted,
    ));
  }

  schedule.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return schedule;
});

