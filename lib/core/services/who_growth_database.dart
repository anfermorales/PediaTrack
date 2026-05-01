import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'who_growth_database.g.dart';

class WhoLmsData extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ageMonths => integer()();
  TextColumn get measurementType => text()();
  IntColumn get gender => integer()();
  RealColumn get l => real()();
  RealColumn get m => real()();
  RealColumn get s => real()();
}

@DriftDatabase(tables: [WhoLmsData])
class WhoGrowthDatabase extends _$WhoGrowthDatabase {
  WhoGrowthDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> initializeData() async {
    final count = await (select(whoLmsData)..limit(1)).getSingleOrNull();
    if (count != null) return;

    await _loadFromAsset('assets/who/weight_male.json', 'weight', 0);
    await _loadFromAsset('assets/who/weight_female.json', 'weight', 1);
    await _loadFromAsset('assets/who/height_male.json', 'height', 0);
    await _loadFromAsset('assets/who/height_female.json', 'height', 1);
  }

  Future<void> _loadFromAsset(String path, String type, int gender) async {
    final String jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);

    for (final item in jsonList) {
      await into(whoLmsData).insert(WhoLmsDataCompanion.insert(
        ageMonths: item['ageMonths'] as int,
        measurementType: type,
        gender: gender,
        l: (item['L'] as num).toDouble(),
        m: (item['M'] as num).toDouble(),
        s: (item['S'] as num).toDouble(),
      ));
    }
  }

  Future<List<WhoLmsDataData>> getLmsData({
    required String measurementType,
    required int gender,
  }) {
    return (select(whoLmsData)
          ..where((t) =>
              t.measurementType.equals(measurementType) &
              t.gender.equals(gender))
          ..orderBy([(t) => OrderingTerm.asc(t.ageMonths)]))
        .get();
  }

  Future<WhoLmsDataData?> getLmsForAge({
    required String measurementType,
    required int gender,
    required int ageMonths,
  }) {
    return (select(whoLmsData)
          ..where((t) =>
              t.measurementType.equals(measurementType) &
              t.gender.equals(gender) &
              t.ageMonths.equals(ageMonths)))
        .getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'who_growth.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final whoGrowthDatabase = WhoGrowthDatabase();