import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

enum DbGender { male, female }
enum HabitType { normal, constipation, diarrhea }

class Children extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get birthDate => dateTime()();
  IntColumn get gender => integer()();
  RealColumn get birthWeight => real().nullable()();
  RealColumn get birthHeight => real().nullable()();
  TextColumn get photo => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class GrowthRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Children, #id)();
  RealColumn get weight => real().nullable()();
  RealColumn get height => real().nullable()();
  RealColumn get headCircumference => real().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class HabitRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Children, #id)();
  IntColumn get type => integer()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class VaccineDefinitions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get doseNumber => integer()();
  IntColumn get totalDoses => integer()();
  IntColumn get recommendedAgeMonths => integer()();
  TextColumn get category => text()();
}

class ChildVaccines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Children, #id)();
  IntColumn get vaccineDefinitionId => integer().references(VaccineDefinitions, #id)();
  DateTimeColumn get appliedDate => dateTime()();
  TextColumn get batch => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Children, GrowthRecords, HabitRecords, VaccineDefinitions, ChildVaccines, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedVaccineDefinitions();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(children, children.birthWeight);
          await m.addColumn(children, children.birthHeight);
        }
        if (from < 3) {
          await m.addColumn(growthRecords, growthRecords.headCircumference);
          await m.createTable(vaccineDefinitions);
          await m.createTable(childVaccines);
          await _seedVaccineDefinitions();
        }
        if (from < 4) {
          await m.createTable(settings);
        }
      },
    );
  }

  Future<void> _seedVaccineDefinitions() async {
    final vaccines = [
      VaccineDefinitionsCompanion.insert(name: 'BCG', description: const Value('Bacilo Calmette-Guérin - Tuberculosis'), doseNumber: 1, totalDoses: 1, recommendedAgeMonths: 0, category: 'tuberculosis'),
      VaccineDefinitionsCompanion.insert(name: 'Hepatitis B', description: const Value('Primera dosis al nacer'), doseNumber: 1, totalDoses: 3, recommendedAgeMonths: 0, category: 'hepatitis'),
      VaccineDefinitionsCompanion.insert(name: 'Hepatitis B', description: const Value('Segunda dosis'), doseNumber: 2, totalDoses: 3, recommendedAgeMonths: 1, category: 'hepatitis'),
      VaccineDefinitionsCompanion.insert(name: 'Hepatitis B', description: const Value('Tercera dosis'), doseNumber: 3, totalDoses: 3, recommendedAgeMonths: 6, category: 'hepatitis'),
      VaccineDefinitionsCompanion.insert(name: 'Pentavalente', description: const Value('Difteria, Tos ferina, Tétanos, Haemophilus influenzae b, Polio - Primera dosis'), doseNumber: 1, totalDoses: 5, recommendedAgeMonths: 2, category: 'dpt'),
      VaccineDefinitionsCompanion.insert(name: 'Pentavalente', description: const Value('Segunda dosis'), doseNumber: 2, totalDoses: 5, recommendedAgeMonths: 4, category: 'dpt'),
      VaccineDefinitionsCompanion.insert(name: 'Pentavalente', description: const Value('Tercera dosis'), doseNumber: 3, totalDoses: 5, recommendedAgeMonths: 6, category: 'dpt'),
      VaccineDefinitionsCompanion.insert(name: 'Pentavalente', description: const Value('Cuarta dosis'), doseNumber: 4, totalDoses: 5, recommendedAgeMonths: 18, category: 'dpt'),
      VaccineDefinitionsCompanion.insert(name: 'Pentavalente', description: const Value('Quinta dosis (refuerzo)'), doseNumber: 5, totalDoses: 5, recommendedAgeMonths: 48, category: 'dpt'),
      VaccineDefinitionsCompanion.insert(name: 'Rotavirus', description: const Value('Primera dosis'), doseNumber: 1, totalDoses: 3, recommendedAgeMonths: 2, category: 'rotavirus'),
      VaccineDefinitionsCompanion.insert(name: 'Rotavirus', description: const Value('Segunda dosis'), doseNumber: 2, totalDoses: 3, recommendedAgeMonths: 4, category: 'rotavirus'),
      VaccineDefinitionsCompanion.insert(name: 'Rotavirus', description: const Value('Tercera dosis'), doseNumber: 3, totalDoses: 3, recommendedAgeMonths: 6, category: 'rotavirus'),
      VaccineDefinitionsCompanion.insert(name: 'Neumococo', description: const Value('Primera dosis'), doseNumber: 1, totalDoses: 4, recommendedAgeMonths: 2, category: 'neumococo'),
      VaccineDefinitionsCompanion.insert(name: 'Neumococo', description: const Value('Segunda dosis'), doseNumber: 2, totalDoses: 4, recommendedAgeMonths: 4, category: 'neumococo'),
      VaccineDefinitionsCompanion.insert(name: 'Neumococo', description: const Value('Tercera dosis'), doseNumber: 3, totalDoses: 4, recommendedAgeMonths: 6, category: 'neumococo'),
      VaccineDefinitionsCompanion.insert(name: 'Neumococo', description: const Value('Refuerzo'), doseNumber: 4, totalDoses: 4, recommendedAgeMonths: 12, category: 'neumococo'),
      VaccineDefinitionsCompanion.insert(name: 'Influenza', description: const Value('Primera dosis anual'), doseNumber: 1, totalDoses: 999, recommendedAgeMonths: 6, category: 'influenza'),
      VaccineDefinitionsCompanion.insert(name: 'SRP (Sarampión, Rubeola, Paperas)', description: const Value('Primera dosis'), doseNumber: 1, totalDoses: 2, recommendedAgeMonths: 12, category: 'spr'),
      VaccineDefinitionsCompanion.insert(name: 'SRP (Sarampión, Rubeola, Paperas)', description: const Value('Segunda dosis (refuerzo)'), doseNumber: 2, totalDoses: 2, recommendedAgeMonths: 48, category: 'spr'),
      VaccineDefinitionsCompanion.insert(name: 'Varicela', description: const Value('Primera dosis'), doseNumber: 1, totalDoses: 2, recommendedAgeMonths: 12, category: 'varicela'),
      VaccineDefinitionsCompanion.insert(name: 'Varicela', description: const Value('Segunda dosis (refuerzo)'), doseNumber: 2, totalDoses: 2, recommendedAgeMonths: 48, category: 'varicela'),
      VaccineDefinitionsCompanion.insert(name: 'Hepatitis A', description: const Value('Primera dosis'), doseNumber: 1, totalDoses: 2, recommendedAgeMonths: 12, category: 'hepatitis_a'),
      VaccineDefinitionsCompanion.insert(name: 'Hepatitis A', description: const Value('Segunda dosis'), doseNumber: 2, totalDoses: 2, recommendedAgeMonths: 18, category: 'hepatitis_a'),
      VaccineDefinitionsCompanion.insert(name: 'Dengue', description: const Value('Primera dosis'), doseNumber: 1, totalDoses: 3, recommendedAgeMonths: 96, category: 'dengue'),
      VaccineDefinitionsCompanion.insert(name: 'Dengue', description: const Value('Segunda dosis'), doseNumber: 2, totalDoses: 3, recommendedAgeMonths: 102, category: 'dengue'),
      VaccineDefinitionsCompanion.insert(name: 'Dengue', description: const Value('Tercera dosis'), doseNumber: 3, totalDoses: 3, recommendedAgeMonths: 108, category: 'dengue'),
      VaccineDefinitionsCompanion.insert(name: 'VPH (Virus del Papiloma Humano)', description: const Value('Primera dosis'), doseNumber: 1, totalDoses: 2, recommendedAgeMonths: 108, category: 'vph'),
      VaccineDefinitionsCompanion.insert(name: 'VPH (Virus del Papiloma Humano)', description: const Value('Segunda dosis'), doseNumber: 2, totalDoses: 2, recommendedAgeMonths: 114, category: 'vph'),
    ];

    for (final vaccine in vaccines) {
      await into(vaccineDefinitions).insert(vaccine);
    }
  }

  Future<List<ChildrenData>> getAllChildren() => select(children).get();
  Stream<List<ChildrenData>> watchAllChildren() => select(children).watch();
  Future<ChildrenData?> getChildById(int id) =>
      (select(children)..where((c) => c.id.equals(id))).getSingleOrNull();
  Future<int> insertChild(ChildrenCompanion child) => into(children).insert(child);
  Future<bool> updateChild(ChildrenData child) => update(children).replace(child);
  Future<int> updateChildBirthData(int childId, double? birthWeight, double? birthHeight) =>
      (update(children)..where((c) => c.id.equals(childId))).write(
        ChildrenCompanion(
          birthWeight: birthWeight != null ? Value(birthWeight) : const Value.absent(),
          birthHeight: birthHeight != null ? Value(birthHeight) : const Value.absent(),
        ),
      );
  Future<int> deleteChild(int id) =>
      (delete(children)..where((c) => c.id.equals(id))).go();

  Future<List<GrowthRecord>> getGrowthRecordsForChild(int childId) =>
      (select(growthRecords)
            ..where((g) => g.childId.equals(childId))
            ..orderBy([(g) => OrderingTerm.desc(g.date)]))
          .get();

  Stream<List<GrowthRecord>> watchGrowthRecordsForChild(int childId) =>
      (select(growthRecords)
            ..where((g) => g.childId.equals(childId))
            ..orderBy([(g) => OrderingTerm.desc(g.date)]))
          .watch();

  Future<int> insertGrowthRecord(GrowthRecordsCompanion record) =>
      into(growthRecords).insert(record);

  Future<int> deleteGrowthRecord(int id) =>
      (delete(growthRecords)..where((g) => g.id.equals(id))).go();

  Future<List<HabitRecord>> getHabitRecordsForChild(int childId) =>
      (select(habitRecords)
            ..where((h) => h.childId.equals(childId))
            ..orderBy([(h) => OrderingTerm.desc(h.recordedAt)]))
          .get();

  Future<List<HabitRecord>> getTodayHabitsForChild(int childId) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return (select(habitRecords)
          ..where((h) =>
              h.childId.equals(childId) &
              h.recordedAt.isBiggerOrEqualValue(start) &
              h.recordedAt.isSmallerThanValue(end))
          ..orderBy([(h) => OrderingTerm.desc(h.recordedAt)]))
        .get();
  }

  Future<int> insertHabitRecord(HabitRecordsCompanion record) =>
      into(habitRecords).insert(record);

  Future<int> deleteHabitRecord(int id) =>
      (delete(habitRecords)..where((h) => h.id.equals(id))).go();

  Future<int> updateHabitRecord(int id, DateTime recordedAt, {String? notes}) =>
      (update(habitRecords)..where((h) => h.id.equals(id))).write(
        HabitRecordsCompanion(
          recordedAt: Value(recordedAt),
          notes: notes == null ? const Value.absent() : Value(notes),
        ),
      );

  Future<List<VaccineDefinition>> getAllVaccineDefinitions() =>
      (select(vaccineDefinitions)
            ..orderBy([(v) => OrderingTerm.asc(v.recommendedAgeMonths), (v) => OrderingTerm.asc(v.doseNumber)]))
          .get();

  Stream<List<VaccineDefinition>> watchAllVaccineDefinitions() =>
      (select(vaccineDefinitions)
            ..orderBy([(v) => OrderingTerm.asc(v.recommendedAgeMonths), (v) => OrderingTerm.asc(v.doseNumber)]))
          .watch();

  Future<List<ChildVaccine>> getChildVaccines(int childId) =>
      (select(childVaccines)
            ..where((cv) => cv.childId.equals(childId))
            ..orderBy([(cv) => OrderingTerm.desc(cv.appliedDate)]))
          .get();

  Stream<List<ChildVaccine>> watchChildVaccines(int childId) =>
      (select(childVaccines)
            ..where((cv) => cv.childId.equals(childId))
            ..orderBy([(cv) => OrderingTerm.desc(cv.appliedDate)]))
          .watch();

  Future<List<ChildVaccine>> getUpcomingVaccines(int childId, {int monthsAhead = 1}) {
    final now = DateTime.now();
    final future = DateTime(now.year, now.month + monthsAhead, now.day);
    return (select(childVaccines)
          ..where((cv) =>
              cv.childId.equals(childId) &
              cv.appliedDate.isBiggerOrEqualValue(now) &
              cv.appliedDate.isSmallerThanValue(future)))
        .get();
  }

  Future<int> insertChildVaccine(ChildVaccinesCompanion record) =>
      into(childVaccines).insert(record);

  Future<int> deleteChildVaccine(int id) =>
      (delete(childVaccines)..where((cv) => cv.id.equals(id))).go();

  Future<int> updateChildVaccine(
    int id, {
    required DateTime appliedDate,
    String? batch,
    String? notes,
  }) =>
      (update(childVaccines)..where((cv) => cv.id.equals(id))).write(
        ChildVaccinesCompanion(
          appliedDate: Value(appliedDate),
          batch: batch == null ? const Value(null) : Value(batch),
          notes: notes == null ? const Value(null) : Value(notes),
        ),
      );

  Future<ChildVaccine?> getChildVaccineByDefinitionAndChild(int childId, int vaccineDefinitionId) =>
      (select(childVaccines)
            ..where((cv) => cv.childId.equals(childId) & cv.vaccineDefinitionId.equals(vaccineDefinitionId)))
          .getSingleOrNull();

  Future<VaccineDefinition?> getVaccineDefinitionById(int id) =>
      (select(vaccineDefinitions)..where((v) => v.id.equals(id))).getSingleOrNull();

  Future<String?> getSetting(String key) async {
    final result = await customSelect(
      'SELECT value FROM settings WHERE key = ?',
      variables: [Variable.withString(key)],
    ).getSingleOrNull();
    return result?.read<String>('value');
  }

  Future<void> setSetting(String key, String value) async {
    await customInsert(
      'INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)',
      variables: [Variable.withString(key), Variable.withString(value)],
    );
  }

  Future<void> importBackupData(Map<String, dynamic> data) async {
    await transaction(() async {
      await (delete(children)).go();
      await (delete(growthRecords)).go();
      await (delete(habitRecords)).go();
      await (delete(childVaccines)).go();

      final childrenData = data['children'] as List? ?? [];
      for (final childMap in childrenData) {
        final child = ChildrenCompanion.insert(
          name: childMap['name'] as String,
          birthDate: DateTime.parse(childMap['birth_date'] as String),
          gender: childMap['gender'] as int,
          birthWeight: childMap['birth_weight'] != null
              ? Value(childMap['birth_weight'] as double)
              : const Value.absent(),
          birthHeight: childMap['birth_height'] != null
              ? Value(childMap['birth_height'] as double)
              : const Value.absent(),
        );
        await into(children).insert(child);
      }

      final growthData = data['growth_records'] as List? ?? [];
      for (final recordMap in growthData) {
        final record = GrowthRecordsCompanion.insert(
          childId: recordMap['child_id'] as int,
          date: DateTime.parse(recordMap['date'] as String),
          weight: recordMap['weight'] != null
              ? Value(recordMap['weight'] as double)
              : const Value.absent(),
          height: recordMap['height'] != null
              ? Value(recordMap['height'] as double)
              : const Value.absent(),
          headCircumference: recordMap['head_circumference'] != null
              ? Value(recordMap['head_circumference'] as double)
              : const Value.absent(),
        );
        await into(growthRecords).insert(record);
      }

      final habitData = data['habit_records'] as List? ?? [];
      for (final recordMap in habitData) {
        final record = HabitRecordsCompanion.insert(
          childId: recordMap['child_id'] as int,
          type: recordMap['type'] as int,
          recordedAt: DateTime.parse(recordMap['recorded_at'] as String),
        );
        await into(habitRecords).insert(record);
      }

      final vaccineDefsData = data['vaccine_definitions'] as List? ?? [];
      for (final defMap in vaccineDefsData) {
        final def = VaccineDefinitionsCompanion.insert(
          name: defMap['name'] as String,
          description: defMap['description'] != null
              ? Value(defMap['description'] as String)
              : const Value.absent(),
          doseNumber: defMap['dose_number'] as int,
          totalDoses: defMap['total_doses'] as int,
          recommendedAgeMonths: defMap['recommended_age_months'] as int,
          category: defMap['category'] as String,
        );
        await into(vaccineDefinitions).insert(def);
      }

      final childVaccinesData = data['child_vaccines'] as List? ?? [];
      for (final vaccineMap in childVaccinesData) {
        final vaccine = ChildVaccinesCompanion.insert(
          childId: vaccineMap['child_id'] as int,
          vaccineDefinitionId: vaccineMap['vaccine_definition_id'] as int,
          appliedDate: DateTime.parse(vaccineMap['applied_date'] as String),
          batch: vaccineMap['batch'] != null
              ? Value(vaccineMap['batch'] as String)
              : const Value.absent(),
          notes: vaccineMap['notes'] != null
              ? Value(vaccineMap['notes'] as String)
              : const Value.absent(),
        );
        await into(childVaccines).insert(vaccine);
      }
    });
  }

  Future<void> deleteAllData() async {
    await transaction(() async {
      await (delete(childVaccines)).go();
      await (delete(habitRecords)).go();
      await (delete(growthRecords)).go();
      await (delete(children)).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pediatrack.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

