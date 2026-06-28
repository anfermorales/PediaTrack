import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers/database_providers.dart';
import '../../../core/services/auto_backup_scheduler.dart';
import '../../../core/services/backup_export_service.dart';
import '../../../data/database/app_database.dart';

/// Settings sheet for app configuration
class SettingsSheet extends ConsumerStatefulWidget {
  const SettingsSheet({super.key, required this.database});

  final AppDatabase database;

  @override
  ConsumerState<SettingsSheet> createState() => _SettingsSheetState();
}

enum _ExportAction { shareJson, downloadJson, shareExcel, downloadExcel }

class _SettingsSheetState extends ConsumerState<SettingsSheet> {
  bool _autoBackupEnabled = false;
  int _backupHour = 23;
  int _backupMinute = 30;
  String _backupFolder = 'PediaTrack';
  String? _lastBackupAt;
  String? _lastBackupStatus;
  String? _lastBackupTrigger;
  String? _lastAutoRunAt;
  String? _lastAutoStatus;
  String? _lastManualRunAt;
  String? _lastManualStatus;
  String? _nextRunAt;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final db = widget.database;
    final enabled = await db.getSetting('auto_backup_enabled');
    final hour = await db.getSetting('auto_backup_hour');
    final minute = await db.getSetting('auto_backup_minute');
    final folder = await db.getSetting('backup_folder');
    final lastRun = await db.getSetting('backup_last_run_at');
    final lastStatus = await db.getSetting('backup_last_status');
    final lastTrigger = await db.getSetting('backup_last_trigger');
    final lastAutoRun = await db.getSetting('backup_last_auto_run_at');
    final lastAutoStatus = await db.getSetting('backup_last_auto_status');
    final lastManualRun = await db.getSetting('backup_last_manual_run_at');
    final lastManualStatus = await db.getSetting('backup_last_manual_status');
    final nextRun = await db.getSetting('backup_next_run_at');

    setState(() {
      _autoBackupEnabled = enabled == 'true';
      _backupHour = int.tryParse(hour ?? '23') ?? 23;
      _backupMinute = int.tryParse(minute ?? '30') ?? 30;
      _backupFolder = folder ?? 'PediaTrack';
      _lastBackupAt = lastRun;
      _lastBackupStatus = lastStatus;
      _lastBackupTrigger = lastTrigger;
      _lastAutoRunAt = lastAutoRun;
      _lastAutoStatus = lastAutoStatus;
      _lastManualRunAt = lastManualRun;
      _lastManualStatus = lastManualStatus;
      _nextRunAt = nextRun;
      _isLoading = false;
    });
  }

  Future<void> _saveSetting(String key, String value) async {
    final db = widget.database;
    await db.setSetting(key, value);
  }

  Future<void> _editNextRun() async {
    if (_nextRunAt == null) return;
    final currentDate = DateTime.tryParse(_nextRunAt!) ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDate),
    );

    if (time == null || !mounted) return;

    final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    await widget.database.setSetting('backup_next_run_at', newDateTime.toIso8601String());
    await AutoBackupScheduler.syncFromDatabase(overrideNextRunAt: newDateTime);
    await _loadSettings();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Próximo respaldo: ${DateFormat('dd MMM yyyy HH:mm', 'es').format(newDateTime)}')),
      );
    }
  }

  Future<void> _runBackupNow({bool forceAuto = false}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando respaldo...')),
    );

    try {
      final trigger = forceAuto ? 'auto' : 'manual';
      final files = await BackupExportService.saveBackupFilesLocally(_backupFolder);
      await BackupRunLogService.markRun(
        db: widget.database,
        status: 'OK',
        trigger: trigger,
        details: 'Respaldo guardado: ${files.jsonFileName}',
      );
      await _loadSettings();
      await AutoBackupScheduler.syncFromDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Respaldo guardado en: ${files.jsonFilePath}')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showExportOptions(BuildContext context) async {
    final action = await showModalBottomSheet<_ExportAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.cloud_upload, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    const Text('Exportar datos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: const BorderRadius.all(Radius.circular(8))), child: const Icon(Icons.share, color: Colors.blue, size: 20)),
                title: const Text('Compartir JSON'),
                subtitle: const Text('Enviar por correo o WhatsApp'),
                onTap: () => Navigator.pop(context, _ExportAction.shareJson),
              ),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: const BorderRadius.all(Radius.circular(8))), child: const Icon(Icons.download, color: Colors.green, size: 20)),
                title: const Text('Descargar JSON'),
                subtitle: const Text('Guardar archivo localmente'),
                onTap: () => Navigator.pop(context, _ExportAction.downloadJson),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: const BorderRadius.all(Radius.circular(8))), child: const Icon(Icons.share, color: Colors.orange, size: 20)),
                title: const Text('Compartir Excel'),
                subtitle: const Text('Enviar por correo o WhatsApp'),
                onTap: () => Navigator.pop(context, _ExportAction.shareExcel),
              ),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), borderRadius: const BorderRadius.all(Radius.circular(8))), child: const Icon(Icons.download, color: Colors.teal, size: 20)),
                title: const Text('Descargar Excel'),
                subtitle: const Text('Guardar archivo localmente'),
                onTap: () => Navigator.pop(context, _ExportAction.downloadExcel),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (action == null) return;
    await _exportData(action);
  }

  Future<void> _exportData(_ExportAction action) async {
    try {
      if (action == _ExportAction.shareJson || action == _ExportAction.downloadJson) {
        final bytes = await BackupExportService.buildBackupJsonBytes();

        if (action == _ExportAction.shareJson) {
          await _shareBackupFile(bytes: bytes, extension: 'json', mimeType: 'application/json', label: 'Respaldo PediaTrack (JSON)');
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Respaldo JSON listo para compartir')));
          return;
        }

        final savedPath = await _saveBackupFile(bytes: bytes, extension: 'json');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Respaldo guardado en: $savedPath')));
        return;
      }

      final bytes = await BackupExportService.buildBackupExcelBytes();

      if (action == _ExportAction.shareExcel) {
        await _shareBackupFile(bytes: bytes, extension: 'xlsx', mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', label: 'Respaldo PediaTrack (Excel)');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Respaldo Excel listo para compartir')));
        return;
      }

      final savedPath = await _saveBackupFile(bytes: bytes, extension: 'xlsx');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Excel guardado en: $savedPath')));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo exportar: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _shareBackupFile({required Uint8List bytes, required String extension, required String mimeType, required String label}) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = 'pediatrack_backup_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles([XFile(file.path, mimeType: mimeType)], text: label, subject: label);
  }

  Future<String> _saveBackupFile({required Uint8List bytes, required String extension}) async {
    final fileName = 'pediatrack_backup_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final pickedPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar respaldo',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [extension],
      bytes: bytes,
    );

    if (pickedPath != null && pickedPath.trim().isNotEmpty) return pickedPath;

    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      final file = File('${downloadsDir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    }

    if (Platform.isAndroid) {
      final file = File('/storage/emulated/0/Download/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    }

    throw Exception('No se encontró una ruta para guardar el respaldo');
  }

  Future<void> _importBackup() async {
    final selected = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    final path = selected?.files.single.path;
    if (path == null) return;

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Importar respaldo'),
        content: const Text(
          'Esto reemplazará todos los datos actuales. ¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Importar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final content = await File(path).readAsString();
      final decoded = jsonDecode(content);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Formato de respaldo inválido');
      }

      final db = ref.read(databaseProvider);
      await db.importBackupData(decoded);

      ref.invalidate(childrenStreamProvider);
      ref.invalidate(selectedChildIdProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Respaldo importado correctamente')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Configuración',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        controller: scrollController,
                        children: [
                          _buildSection(
                            title: 'Respaldo Automático',
                            children: [
                              SwitchListTile(
                                title: const Text('Respaldo automático'),
                                subtitle: const Text('Crear backup cada día'),
                                value: _autoBackupEnabled,
                                onChanged: (value) async {
                                  setState(() => _autoBackupEnabled = value);
                                  await _saveSetting('auto_backup_enabled', value.toString());
                                  await AutoBackupScheduler.syncFromDatabase();
                                  await _loadSettings();
                                },
                              ),
                              ListTile(
                                title: const Text('Hora del respaldo'),
                                subtitle: Text(
                                  '${_backupHour.toString().padLeft(2, '0')}:${_backupMinute.toString().padLeft(2, '0')}',
                                ),
                                trailing: const Icon(Icons.schedule),
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: _backupHour, minute: _backupMinute),
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _backupHour = time.hour;
                                      _backupMinute = time.minute;
                                    });
                                    await _saveSetting('auto_backup_hour', time.hour.toString());
                                    await _saveSetting('auto_backup_minute', time.minute.toString());
                                    await AutoBackupScheduler.syncFromDatabase();
                                    await _loadSettings();
                                  }
                                },
                              ),
                              ListTile(
                                title: const Text('Carpeta de respaldo'),
                                subtitle: Text(_backupFolder),
                                trailing: const Icon(Icons.folder_outlined),
                                onTap: () async {
                                  final controller = TextEditingController(text: _backupFolder);
                                  final result = await showDialog<String>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Carpeta de respaldo'),
                                      content: TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                          labelText: 'Nombre de carpeta',
                                          hintText: 'Ej: PediaTrack',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, controller.text),
                                          child: const Text('Guardar'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (result != null && result.isNotEmpty) {
                                    setState(() => _backupFolder = result);
                                    await _saveSetting('backup_folder', result);
                                    await _loadSettings();
                                  }
                                },
                              ),
                              if (_nextRunAt != null && _autoBackupEnabled)
                                ListTile(
                                  title: const Text('Próximo respaldo'),
                                  subtitle: Text(
                                    DateFormat('dd MMM yyyy HH:mm', 'es').format(
                                      DateTime.tryParse(_nextRunAt!) ?? DateTime.now(),
                                    ),
                                  ),
                                  trailing: const Icon(Icons.edit_calendar),
                                  onTap: () => _editNextRun(),
                                ),
                              ListTile(
                                title: const Text('Ejecutar ahora'),
                                subtitle: const Text('Generar backup manualmente'),
                                trailing: const Icon(Icons.play_arrow),
                                onTap: () => _runBackupNow(),
                              ),
                              if (_autoBackupEnabled)
                                ListTile(
                                  title: const Text('Forzar respaldo automático'),
                                  subtitle: const Text('Prueba del sistema de respaldo'),
                                  trailing: const Icon(Icons.flash_on),
                                  onTap: () => _runBackupNow(forceAuto: true),
                                ),
                              if (_lastBackupAt != null)
                                ListTile(
                                  title: Text('Último respaldo${_lastBackupTrigger != null ? ' (${_lastBackupTrigger == 'auto' ? 'Automático' : 'Manual'})' : ''}'),
                                  subtitle: Text(
                                    '${DateFormat('dd MMM yyyy HH:mm', 'es').format(DateTime.tryParse(_lastBackupAt!) ?? DateTime.now())}\n${_lastBackupStatus ?? ""}',
                                  ),
                                  isThreeLine: true,
                                ),
                              if (_lastAutoRunAt != null)
                                ListTile(
                                  title: const Text('Último automático'),
                                  subtitle: Text(
                                    '${DateFormat('dd MMM yyyy HH:mm', 'es').format(DateTime.tryParse(_lastAutoRunAt!) ?? DateTime.now())}\n${_lastAutoStatus ?? ""}',
                                  ),
                                  isThreeLine: true,
                                ),
                              if (_lastManualRunAt != null)
                                ListTile(
                                  title: const Text('Último manual'),
                                  subtitle: Text(
                                    '${DateFormat('dd MMM yyyy HH:mm', 'es').format(DateTime.tryParse(_lastManualRunAt!) ?? DateTime.now())}\n${_lastManualStatus ?? ""}',
                                  ),
                                  isThreeLine: true,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            title: 'Exportar / Importar',
                            children: [
                              ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.cloud_upload, color: Theme.of(context).colorScheme.primary, size: 20),
                                ),
                                title: const Text('Exportar datos'),
                                subtitle: const Text('Compartir o descargar respaldo JSON y Excel'),
                                onTap: () => _showExportOptions(context),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.download, color: Colors.green, size: 20),
                                ),
                                title: const Text('Importar respaldo'),
                                subtitle: const Text('Cargar un archivo JSON de respaldo'),
                                onTap: _importBackup,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            title: 'Acerca de',
                            children: [
                              const ListTile(
                                title: Text('Versión'),
                                subtitle: Text('1.0.0'),
                              ),
                              const ListTile(
                                title: Text('Desarrollado con'),
                                subtitle: Text('Flutter + Riverpod'),
                              ),
                              const SizedBox(height: 10),
                              const _TorogozBrandCard(),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _TorogozBrandCard extends StatelessWidget {
  const _TorogozBrandCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark ? Colors.white70 : const Color(0xFF263238);
    final borderColor = isDark ? const Color(0xFF334155) : Theme.of(context).colorScheme.outline.withValues(alpha: 0.35);
    final logoBgColor = isDark ? Colors.white : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: logoBgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFFE2E8F0) : Colors.transparent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SvgPicture.asset(
                'assets/icon/logo-torogoz.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '© 2026 TOROGOZ TECH S.A.S. DE C.V.',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}