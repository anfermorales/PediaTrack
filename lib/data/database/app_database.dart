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

@DriftDatabase(tables: [Children, GrowthRecords, HabitRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(children, children.birthWeight);
          await m.addColumn(children, children.birthHeight);
        }
      },
    );
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pediatrack.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}