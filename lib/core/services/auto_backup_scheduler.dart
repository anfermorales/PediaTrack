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
    return AutoBackupScheduler.runBackupNow(trigger: 'auto');
  });
}

class AutoBackupScheduler {
  const AutoBackupScheduler._();

  static DateTime _nextRunFromNow({
    required DateTime now,
    required int hour,
    required int minute,
  }) {
    var next = DateTime(
      now.year,
      now.month,
      now.day,
      hour.clamp(0, 23),
      minute.clamp(0, 59),
    );
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  static Future<void> initialize() async {
    await Workmanager().initialize(autoBackupCallbackDispatcher, isInDebugMode: false);
  }

  static Future<void> syncFromDatabase({
    DateTime? overrideNextRunAt,
  }) async {
    final db = AppDatabase();
    final enabled = (await db.getSetting('auto_backup_enabled') ?? 'false') == 'true';

    await Workmanager().cancelByUniqueName(autoBackupUniqueName);
    await db.setSetting('backup_next_run_at', '');
    await db.setSetting('backup_auto_pending', 'false');
    if (!enabled) {
      return;
    }

    final hour = int.tryParse(await db.getSetting('auto_backup_hour') ?? '23') ?? 23;
    final minute = int.tryParse(await db.getSetting('auto_backup_minute') ?? '30') ?? 30;

    final now = DateTime.now();
    final next = (overrideNextRunAt != null && overrideNextRunAt.isAfter(now))
        ? overrideNextRunAt
        : _nextRunFromNow(now: now, hour: hour, minute: minute);
    final initialDelay = next.difference(now);
    await db.setSetting('backup_next_run_at', next.toIso8601String());
    await db.setSetting('backup_auto_pending', 'true');

    await Workmanager().registerOneOffTask(
      autoBackupUniqueName,
      autoBackupTaskName,
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<bool> runBackupNow({String? folderName, String trigger = 'manual'}) async {
    final db = AppDatabase();
    try {
      final selectedFolder = (folderName != null && folderName.trim().isNotEmpty)
          ? folderName.trim()
          : (await db.getSetting('backup_folder') ?? 'PediaTrack');

      final files = await BackupExportService.saveBackupFilesLocally(selectedFolder);

      await BackupRunLogService.markRun(
        db: db,
        status: 'OK',
        trigger: trigger,
        details: 'Respaldo local guardado: ${files.jsonFileName} y ${files.excelFileName}',
      );

      if (trigger == 'auto') {
        final hour = int.tryParse(await db.getSetting('auto_backup_hour') ?? '23') ?? 23;
        final minute = int.tryParse(await db.getSetting('auto_backup_minute') ?? '30') ?? 30;
        final next = _nextRunFromNow(
          now: DateTime.now(),
          hour: hour,
          minute: minute,
        );
        await db.setSetting('backup_auto_pending', 'false');
        await syncFromDatabase(overrideNextRunAt: next);
      }
      return true;
    } catch (error) {
      await BackupRunLogService.markRun(
        db: db,
        status: 'Fallo',
        trigger: trigger,
        details: error.toString(),
      );
      return false;
    }
  }
}