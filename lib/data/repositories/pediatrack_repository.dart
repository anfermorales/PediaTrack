import 'package:drift/drift.dart' as drift;
import 'package:pediatrack/core/models/app_models.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';
import 'package:pediatrack/data/database/app_database.dart';

class PediaTrackRepository {
  PediaTrackRepository(this._db, this._growthService);

  final AppDatabase _db;
  final WhoGrowthService _growthService;

  Stream<List<GrowthRecord>> watchGrowthRecordsForChild(int childId) {
    return _db.watchGrowthRecordsForChild(childId);
  }

  Future<List<HabitRecord>> getTodayHabitsForChild(int childId) {
    return _db.getTodayHabitsForChild(childId);
  }

  Future<List<HabitRecord>> getHabitHistoryForChild(int childId) {
    return _db.getHabitRecordsForChild(childId);
  }

  Future<void> deleteGrowthRecord(int id) async {
    await _db.deleteGrowthRecord(id);
  }

  Future<void> saveGrowthMeasurements({
    required int childId,
    required DateTime date,
    double? weightLb,
    double? heightCm,
    double? headCircumferenceCm,
  }) async {
    if (weightLb != null && weightLb > 0) {
      await _db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: childId,
        weight: drift.Value(weightLb / 2.20462),
        date: date,
      ));
    }
    if (heightCm != null && heightCm > 0) {
      await _db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: childId,
        height: drift.Value(heightCm),
        date: date,
      ));
    }
    if (headCircumferenceCm != null && headCircumferenceCm > 0) {
      await _db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: childId,
        headCircumference: drift.Value(headCircumferenceCm),
        date: date,
      ));
    }
  }

  Future<void> addHabitRecord({
    required int childId,
    required int type,
    required DateTime recordedAt,
    String? notes,
  }) async {
    await _db.insertHabitRecord(HabitRecordsCompanion.insert(
      childId: childId,
      type: type,
      recordedAt: recordedAt,
      notes: notes == null || notes.trim().isEmpty
          ? const drift.Value.absent()
          : drift.Value(notes.trim()),
    ));
  }

  Future<void> replaceHabitRecord({
    required HabitRecord original,
    required int newType,
    required DateTime newRecordedAt,
    String? notes,
  }) async {
    await _db.deleteHabitRecord(original.id);
    await addHabitRecord(
      childId: original.childId,
      type: newType,
      recordedAt: newRecordedAt,
      notes: notes,
    );
  }

  Future<void> deleteHabitRecord(int id) async {
    await _db.deleteHabitRecord(id);
  }

  Future<List<VaccineScheduleItem>> getVaccineSchedule(int childId) async {
    final child = await _db.getChildById(childId);
    if (child == null) return [];

    final definitions = await _db.getAllVaccineDefinitions();
    final appliedVaccines = await _db.getChildVaccines(childId);
    final now = DateTime.now();

    final schedule = <VaccineScheduleItem>[];
    for (final def in definitions) {
      final applied = appliedVaccines.where((av) => av.vaccineDefinitionId == def.id).toList();
      final isCompleted = applied.isNotEmpty;
      final dueDate = child.birthDate.add(Duration(days: def.recommendedAgeMonths * 30));
      schedule.add(VaccineScheduleItem(
        definition: def,
        appliedVaccine: applied.isNotEmpty ? applied.first : null,
        dueDate: dueDate,
        isOverdue: !isCompleted && now.isAfter(dueDate),
        isCompleted: isCompleted,
      ));
    }

    schedule.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return schedule;
  }

  Future<List<AppAlert>> getAlerts() async {
    final children = await _db.getAllChildren();
    final definitions = await _db.getAllVaccineDefinitions();
    final now = DateTime.now();
    final upcomingLimit = now.add(const Duration(days: 30));
    final alerts = <AppAlert>[];
    final seen = <String>{};

    for (final child in children) {
      final appliedVaccines = await _db.getChildVaccines(child.id);

      for (final def in definitions) {
        final isApplied = appliedVaccines.any((v) => v.vaccineDefinitionId == def.id);
        if (isApplied) continue;

        final dueDate = child.birthDate.add(Duration(days: def.recommendedAgeMonths * 30));
        if (dueDate.isBefore(now)) {
          _addUniqueAlert(alerts, seen, AppAlert(
            type: AppAlertType.vaccineOverdue,
            childId: child.id,
            childName: child.name,
            title: 'Vacuna atrasada',
            message: '${def.name} dosis ${def.doseNumber}/${def.totalDoses}. Debió aplicarse el ${_date(dueDate)}.',
            createdAt: dueDate,
            priority: AppAlertPriority.high,
          ));
        } else if (!dueDate.isAfter(upcomingLimit)) {
          _addUniqueAlert(alerts, seen, AppAlert(
            type: AppAlertType.vaccineUpcoming,
            childId: child.id,
            childName: child.name,
            title: 'Vacuna próxima',
            message: '${def.name} dosis ${def.doseNumber}/${def.totalDoses}. Programada para ${_date(dueDate)}.',
            createdAt: dueDate,
            priority: AppAlertPriority.low,
          ));
        }
      }

      final growthRecords = await _db.getGrowthRecordsForChild(child.id);
      if (growthRecords.isNotEmpty) {
        final latest = growthRecords.first;
        final ageMonths = ((now.year - child.birthDate.year) * 12 + (now.month - child.birthDate.month)).clamp(0, 60);

        if (latest.weight != null) {
          final weightEval = _growthService.evaluate(
            value: latest.weight!,
            ageMonths: ageMonths,
            gender: child.gender,
            type: GrowthType.weight,
          );
          if (weightEval.percentile < 3 || weightEval.percentile > 97) {
            _addUniqueAlert(alerts, seen, AppAlert(
              type: AppAlertType.growthOutOfRange,
              childId: child.id,
              childName: child.name,
              title: 'Peso fuera de curva',
              message: 'El último peso está en percentil ${weightEval.percentile.toStringAsFixed(0)}. Requiere revisión.',
              createdAt: latest.date,
              priority: AppAlertPriority.medium,
            ));
          }
        }

        if (latest.height != null) {
          final heightEval = _growthService.evaluate(
            value: latest.height!,
            ageMonths: ageMonths,
            gender: child.gender,
            type: GrowthType.height,
          );
          if (heightEval.percentile < 3 || heightEval.percentile > 97) {
            _addUniqueAlert(alerts, seen, AppAlert(
              type: AppAlertType.growthOutOfRange,
              childId: child.id,
              childName: child.name,
              title: 'Estatura fuera de curva',
              message: 'La última estatura está en percentil ${heightEval.percentile.toStringAsFixed(0)}. Requiere revisión.',
              createdAt: latest.date,
              priority: AppAlertPriority.medium,
            ));
          }
        }
      }
    }

    alerts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return alerts;
  }
}

String _date(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final y = date.year.toString();
  return '$d/$m/$y';
}

void _addUniqueAlert(List<AppAlert> alerts, Set<String> seen, AppAlert alert) {
  final key = '${alert.childId}|${alert.type.name}|${alert.title}|${alert.message}|${alert.createdAt.toIso8601String()}';
  if (seen.add(key)) {
    alerts.add(alert);
  }
}

