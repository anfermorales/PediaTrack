import 'package:workmanager/workmanager.dart';

import '../../data/database/app_database.dart';
import 'backup_export_service.dart';

const String autoBackupTaskName = 'pediatrack_auto_backup_task';
const String autoBackupUniqueName = 'pediatrack_auto_backup_unique';

@pragma('vm:entry-point')
void autoBackupCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != autoBackupTaskName) {
      return true;
    }
    return AutoBackupScheduler.runBackupNow();
  });
}

class AutoBackupScheduler {
  const AutoBackupScheduler._();

  static Future<void> initialize() async {
    await Workmanager().initialize(autoBackupCallbackDispatcher, isInDebugMode: false);
  }

  static Future<void> syncFromDatabase() async {
    final db = AppDatabase();
    final enabled = (await db.getSetting('auto_backup_enabled') ?? 'false') == 'true';

    await Workmanager().cancelByUniqueName(autoBackupUniqueName);
    if (!enabled) {
      return;
    }

    final hour = int.tryParse(await db.getSetting('auto_backup_hour') ?? '23') ?? 23;
    final minute = int.tryParse(await db.getSetting('auto_backup_minute') ?? '30') ?? 30;

    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour.clamp(0, 23), minute.clamp(0, 59));
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    final initialDelay = next.difference(now);

    await Workmanager().registerPeriodicTask(
      autoBackupUniqueName,
      autoBackupTaskName,
      frequency: const Duration(hours: 24),
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<bool> runBackupNow() async {
    final db = AppDatabase();
    try {
      final files = await BackupExportService.saveBackupFilesLocally();

      await BackupRunLogService.markRun(
        status: 'OK',
        details: 'Respaldo local guardado: ${files.jsonFileName} y ${files.excelFileName}',
      );
      return true;
    } catch (error) {
      await BackupRunLogService.markRun(
        status: 'Falló',
        details: error.toString(),
      );
      return false;
    }
  }
}