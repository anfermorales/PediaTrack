import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart' as xl;
import 'package:path_provider/path_provider.dart';

import '../../data/database/app_database.dart';

class BackupFiles {
  final String jsonFilePath;
  final String excelFilePath;
  final String jsonFileName;
  final String excelFileName;

  const BackupFiles({
    required this.jsonFilePath,
    required this.excelFilePath,
    required this.jsonFileName,
    required this.excelFileName,
  });
}

class BackupExportService {
  const BackupExportService._();

  static Future<Map<String, dynamic>> buildBackupData() async {
    final db = AppDatabase();
    final children = await db.getAllChildren();
    final growthRecords = <Map<String, dynamic>>[];
    final habitRecords = <Map<String, dynamic>>[];
    final vaccineDefinitions = <Map<String, dynamic>>[];
    final childVaccines = <Map<String, dynamic>>[];

    for (final child in children) {
      final childGrowth = await db.getGrowthRecordsForChild(child.id);
      for (final record in childGrowth) {
        growthRecords.add({
          'id': record.id,
          'child_id': record.childId,
          'weight': record.weight,
          'height': record.height,
          'head_circumference': record.headCircumference,
          'date': record.date.toIso8601String(),
          'notes': record.notes,
          'created_at': record.createdAt.toIso8601String(),
        });
      }

      final childHabits = await db.getHabitRecordsForChild(child.id);
      for (final record in childHabits) {
        habitRecords.add({
          'id': record.id,
          'child_id': record.childId,
          'type': record.type,
          'recorded_at': record.recordedAt.toIso8601String(),
          'notes': record.notes,
          'created_at': record.createdAt.toIso8601String(),
        });
      }

      final vaccines = await db.getChildVaccines(child.id);
      for (final vaccine in vaccines) {
        childVaccines.add({
          'id': vaccine.id,
          'child_id': vaccine.childId,
          'vaccine_definition_id': vaccine.vaccineDefinitionId,
          'applied_date': vaccine.appliedDate.toIso8601String(),
          'batch': vaccine.batch,
          'notes': vaccine.notes,
          'created_at': vaccine.createdAt.toIso8601String(),
        });
      }
    }

    final definitions = await db.getAllVaccineDefinitions();
    for (final def in definitions) {
      vaccineDefinitions.add({
        'id': def.id,
        'name': def.name,
        'description': def.description,
        'dose_number': def.doseNumber,
        'total_doses': def.totalDoses,
        'recommended_age_months': def.recommendedAgeMonths,
        'category': def.category,
      });
    }

    return {
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': '1.0.0',
      'summary': {
        'children': children.length,
        'growth_records': growthRecords.length,
        'habit_records': habitRecords.length,
        'vaccine_definitions': vaccineDefinitions.length,
        'child_vaccines': childVaccines.length,
      },
      'children': children.map((c) => {
        'id': c.id,
        'name': c.name,
        'birth_date': c.birthDate.toIso8601String(),
        'gender': c.gender,
        'birth_weight': c.birthWeight,
        'birth_height': c.birthHeight,
        'photo': c.photo,
        'created_at': c.createdAt.toIso8601String(),
      }).toList(),
      'growth_records': growthRecords,
      'habit_records': habitRecords,
      'vaccine_definitions': vaccineDefinitions,
      'child_vaccines': childVaccines,
    };
  }

  static Uint8List buildBackupExcelData(Map<String, dynamic> backupData) {
    final excel = xl.Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet();
    if (defaultSheet != null) {
      excel.delete(defaultSheet);
    }

    final thinBorder = xl.Border(
      borderStyle: xl.BorderStyle.Thin,
      borderColorHex: xl.ExcelColor.grey300,
    );

    final titleStyle = xl.CellStyle(
      bold: true,
      fontSize: 14,
      fontColorHex: xl.ExcelColor.white,
      backgroundColorHex: xl.ExcelColor.teal700,
      horizontalAlign: xl.HorizontalAlign.Center,
      verticalAlign: xl.VerticalAlign.Center,
      leftBorder: thinBorder,
      rightBorder: thinBorder,
      topBorder: thinBorder,
      bottomBorder: thinBorder,
    );

    final sectionStyle = xl.CellStyle(
      bold: true,
      fontColorHex: xl.ExcelColor.white,
      backgroundColorHex: xl.ExcelColor.blueGrey700,
      horizontalAlign: xl.HorizontalAlign.Left,
      verticalAlign: xl.VerticalAlign.Center,
      leftBorder: thinBorder,
      rightBorder: thinBorder,
      topBorder: thinBorder,
      bottomBorder: thinBorder,
    );

    final headerStyle = xl.CellStyle(
      bold: true,
      fontColorHex: xl.ExcelColor.white,
      backgroundColorHex: xl.ExcelColor.teal700,
      horizontalAlign: xl.HorizontalAlign.Center,
      verticalAlign: xl.VerticalAlign.Center,
      textWrapping: xl.TextWrapping.WrapText,
      leftBorder: thinBorder,
      rightBorder: thinBorder,
      topBorder: thinBorder,
      bottomBorder: thinBorder,
    );

    final labelStyle = xl.CellStyle(
      bold: true,
      backgroundColorHex: xl.ExcelColor.grey300,
      leftBorder: thinBorder,
      rightBorder: thinBorder,
      topBorder: thinBorder,
      bottomBorder: thinBorder,
    );

    final valueStyle = xl.CellStyle(
      textWrapping: xl.TextWrapping.WrapText,
      verticalAlign: xl.VerticalAlign.Top,
      leftBorder: thinBorder,
      rightBorder: thinBorder,
      topBorder: thinBorder,
      bottomBorder: thinBorder,
    );

    void styleRow(xl.Sheet sheet, int row, int colCount, xl.CellStyle style) {
      for (int c = 0; c < colCount; c++) {
        sheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: c, rowIndex: row)).cellStyle = style;
      }
    }

    String normalizeLabel(String key) {
      switch (key) {
        case 'children':
          return 'Niños';
        case 'growth_records':
          return 'Registros de crecimiento';
        case 'habit_records':
          return 'Registros de hábitos';
        case 'vaccine_definitions':
          return 'Definiciones de vacunas';
        case 'child_vaccines':
          return 'Vacunas aplicadas';
        case 'exported_at':
          return 'Exportado el';
        case 'name':
          return 'Nombre';
        case 'birth_date':
          return 'Fecha de nacimiento';
        case 'gender':
          return 'Género';
        case 'birth_weight':
          return 'Peso al nacer (kg)';
        case 'birth_height':
          return 'Estatura al nacer (cm)';
        case 'weight':
          return 'Peso (kg)';
        case 'height':
          return 'Estatura (cm)';
        case 'head_circumference':
          return 'Perímetro craneal (cm)';
        case 'date':
          return 'Fecha';
        case 'type':
          return 'Tipo';
        case 'recorded_at':
          return 'Fecha y hora';
        case 'applied_date':
          return 'Fecha de aplicación';
        case 'batch':
          return 'Lote';
        default:
          return key.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
      }
    }

    List<Map<String, dynamic>> castRows(dynamic rows) {
      return ((rows as List?) ?? []).map((item) => Map<String, dynamic>.from(item as Map)).toList();
    }

    void addSheetFromMaps(String sheetName, String sheetTitle, List<Map<String, dynamic>> rows) {
      final sheet = excel[sheetName];
      sheet.setDefaultColumnWidth(18);
      int rowIndex = 0;

      void append(List<String> values, xl.CellStyle style, {double? height}) {
        sheet.appendRow(values.map((v) => xl.TextCellValue(v)).toList());
        styleRow(sheet, rowIndex, values.length, style);
        if (height != null) {
          sheet.setRowHeight(rowIndex, height);
        }
        rowIndex++;
      }

      append([sheetTitle], titleStyle, height: 26);
      if ((rows.isNotEmpty ? rows.first.keys.length : 1) > 1) {
        final mergeCols = rows.isNotEmpty ? rows.first.keys.length - 1 : 1;
        sheet.merge(
          xl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
          xl.CellIndex.indexByColumnRow(columnIndex: mergeCols, rowIndex: 0),
        );
      }

      append(['Generado', (backupData['exported_at'] ?? '').toString()], valueStyle);
      append(['', ''], valueStyle);

      if (rows.isEmpty) {
        append(['Sin datos'], sectionStyle);
        return;
      }

      final headers = rows.first.keys.toList();
      append(headers.map(normalizeLabel).toList(), headerStyle, height: 22);

      for (final row in rows) {
        append(headers.map((k) => (row[k] ?? '').toString()).toList(), valueStyle);
      }

      for (int col = 0; col < headers.length; col++) {
        int maxLen = normalizeLabel(headers[col]).length;
        for (final row in rows) {
          final len = (row[headers[col]] ?? '').toString().length;
          if (len > maxLen) maxLen = len;
        }
        sheet.setColumnWidth(col, (maxLen + 2).clamp(12, 42).toDouble());
      }
    }

    final summarySheet = excel['Resumen'];
    summarySheet.setColumnWidth(0, 30);
    summarySheet.setColumnWidth(1, 38);

    int summaryRow = 0;
    void appendSummary(List<String> values, xl.CellStyle style, {double? height}) {
      summarySheet.appendRow(values.map((v) => xl.TextCellValue(v)).toList());
      styleRow(summarySheet, summaryRow, values.length, style);
      if (height != null) {
        summarySheet.setRowHeight(summaryRow, height);
      }
      summaryRow++;
    }

    appendSummary(['Respaldo PediaTrack'], titleStyle, height: 26);
    summarySheet.merge(
      xl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
      xl.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0),
    );
    appendSummary(['Exportado el', (backupData['exported_at'] ?? '').toString()], valueStyle);
    appendSummary(['Resumen General'], sectionStyle);
    summarySheet.merge(
      xl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
      xl.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 2),
    );

    final summary = Map<String, dynamic>.from(backupData['summary'] as Map? ?? {});
    for (final entry in summary.entries) {
      appendSummary([normalizeLabel(entry.key), entry.value.toString()], labelStyle);
      summarySheet.cell(xl.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: summaryRow - 1)).cellStyle = valueStyle;
    }

    addSheetFromMaps('Ninos', 'Niños', castRows(backupData['children']));
    addSheetFromMaps('Crecimiento', 'Registros de Crecimiento', castRows(backupData['growth_records']));
    addSheetFromMaps('Habitos', 'Registros de Hábitos', castRows(backupData['habit_records']));
    addSheetFromMaps('VacunasDef', 'Definiciones de Vacunas', castRows(backupData['vaccine_definitions']));
    addSheetFromMaps('VacunasApl', 'Vacunas Aplicadas', castRows(backupData['child_vaccines']));

    excel.setDefaultSheet('Resumen');
    final bytes = excel.save();
    if (bytes == null || bytes.isEmpty) {
      throw Exception('No se pudo generar el archivo Excel');
    }
    return Uint8List.fromList(bytes);
  }

  static Future<BackupFiles> createBackupFiles() async {
    final backupData = await buildBackupData();
    final now = DateTime.now();
    final stamp = now.toIso8601String().replaceAll(':', '-');
    final jsonName = 'pediatrack_backup_$stamp.json';
    final excelName = 'pediatrack_backup_$stamp.xlsx';

    final tempDir = await getTemporaryDirectory();
    final jsonFile = File('${tempDir.path}/$jsonName');
    final excelFile = File('${tempDir.path}/$excelName');

    final jsonPretty = const JsonEncoder.withIndent('  ').convert(backupData);
    await jsonFile.writeAsString(jsonPretty, flush: true);
    final excelBytes = buildBackupExcelData(backupData);
    await excelFile.writeAsBytes(excelBytes, flush: true);

    return BackupFiles(
      jsonFilePath: jsonFile.path,
      excelFilePath: excelFile.path,
      jsonFileName: jsonName,
      excelFileName: excelName,
    );
  }

  static Future<Uint8List> buildBackupJsonBytes() async {
    final backupData = await buildBackupData();
    final content = const JsonEncoder.withIndent('  ').convert(backupData);
    return Uint8List.fromList(utf8.encode(content));
  }

  static Future<Uint8List> buildBackupExcelBytes() async {
    final backupData = await buildBackupData();
    return buildBackupExcelData(backupData);
  }

  static Future<String> _getBackupDirectory([String? folderName]) async {
    final appDir = await getExternalStorageDirectory();
    if (appDir == null) {
      throw Exception('No se pudo obtener el directorio de almacenamiento');
    }
    final androidIndex = appDir.path.indexOf('/Android/');
    String basePath;
    if (androidIndex != -1) {
      basePath = appDir.path.substring(0, androidIndex);
    } else {
      basePath = appDir.path;
    }
    final folder = folderName ?? 'PediaTrack';
    final backupDir = Directory('$basePath/Documents/$folder/backup');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  static Future<BackupFiles> saveBackupFilesLocally([String? folderName]) async {
    final backupData = await buildBackupData();
    final now = DateTime.now();
    final stamp = now.toIso8601String().replaceAll(':', '-');
    final jsonName = 'pediatrack_backup_$stamp.json';
    final excelName = 'pediatrack_backup_$stamp.xlsx';

    final db = AppDatabase();
    final folder = folderName ?? await db.getSetting('backup_folder') ?? 'PediaTrack';
    final backupDir = await _getBackupDirectory(folder);
    final jsonFile = File('$backupDir/$jsonName');
    final excelFile = File('$backupDir/$excelName');

    final jsonPretty = const JsonEncoder.withIndent('  ').convert(backupData);
    await jsonFile.writeAsString(jsonPretty, flush: true);
    final excelBytes = buildBackupExcelData(backupData);
    await excelFile.writeAsBytes(excelBytes, flush: true);

    await _cleanupOldBackups(backupDir);

    return BackupFiles(
      jsonFilePath: jsonFile.path,
      excelFilePath: excelFile.path,
      jsonFileName: jsonName,
      excelFileName: excelName,
    );
  }

  static Future<void> _cleanupOldBackups(String backupDir) async {
    final dir = Directory(backupDir);
    final files = await dir.list().toList();
    final jsonFiles = files.where((f) => f.path.endsWith('.json')).toList();
    final excelFiles = files.where((f) => f.path.endsWith('.xlsx')).toList();

    if (jsonFiles.length > 5) {
      jsonFiles.sort((a, b) => a.path.compareTo(b.path));
      for (var i = 0; i < jsonFiles.length - 5; i++) {
        await jsonFiles[i].delete();
      }
    }
    if (excelFiles.length > 5) {
      excelFiles.sort((a, b) => a.path.compareTo(b.path));
      for (var i = 0; i < excelFiles.length - 5; i++) {
        await excelFiles[i].delete();
      }
    }
  }

  static Future<List<String>> getLocalBackupFiles([String? folderName]) async {
    try {
      final db = AppDatabase();
      final folder = folderName ?? await db.getSetting('backup_folder') ?? 'PediaTrack';
      final backupDir = await _getBackupDirectory(folder);
      final dir = Directory(backupDir);
      if (!await dir.exists()) return [];

      final files = await dir.list().toList();
      return files
          .where((f) => f is File && (f.path.endsWith('.json') || f.path.endsWith('.xlsx')))
          .map((f) => f.path)
          .toList();
    } catch (e) {
      return [];
    }
  }
}

class BackupRunLogService {
  const BackupRunLogService._();

  static Future<void> markRun({
    required String status,
    String? details,
  }) async {
    final db = AppDatabase();
    await db.setSetting('backup_last_run_at', DateTime.now().toIso8601String());
    final message = details == null || details.trim().isEmpty
        ? status
        : '$status: ${details.trim()}';
    await db.setSetting('backup_last_status', message);
  }
}