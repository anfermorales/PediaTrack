// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'who_growth_database.dart';

// ignore_for_file: type=lint
class $WhoLmsDataTable extends WhoLmsData
    with TableInfo<$WhoLmsDataTable, WhoLmsDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WhoLmsDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ageMonthsMeta =
      const VerificationMeta('ageMonths');
  @override
  late final GeneratedColumn<int> ageMonths = GeneratedColumn<int>(
      'age_months', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _measurementTypeMeta =
      const VerificationMeta('measurementType');
  @override
  late final GeneratedColumn<String> measurementType = GeneratedColumn<String>(
      'measurement_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
      'gender', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lMeta = const VerificationMeta('l');
  @override
  late final GeneratedColumn<double> l = GeneratedColumn<double>(
      'l', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mMeta = const VerificationMeta('m');
  @override
  late final GeneratedColumn<double> m = GeneratedColumn<double>(
      'm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sMeta = const VerificationMeta('s');
  @override
  late final GeneratedColumn<double> s = GeneratedColumn<double>(
      's', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ageMonths, measurementType, gender, l, m, s];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'who_lms_data';
  @override
  VerificationContext validateIntegrity(Insertable<WhoLmsDataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('age_months')) {
      context.handle(_ageMonthsMeta,
          ageMonths.isAcceptableOrUnknown(data['age_months']!, _ageMonthsMeta));
    } else if (isInserting) {
      context.missing(_ageMonthsMeta);
    }
    if (data.containsKey('measurement_type')) {
      context.handle(
          _measurementTypeMeta,
          measurementType.isAcceptableOrUnknown(
              data['measurement_type']!, _measurementTypeMeta));
    } else if (isInserting) {
      context.missing(_measurementTypeMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('l')) {
      context.handle(_lMeta, l.isAcceptableOrUnknown(data['l']!, _lMeta));
    } else if (isInserting) {
      context.missing(_lMeta);
    }
    if (data.containsKey('m')) {
      context.handle(_mMeta, m.isAcceptableOrUnknown(data['m']!, _mMeta));
    } else if (isInserting) {
      context.missing(_mMeta);
    }
    if (data.containsKey('s')) {
      context.handle(_sMeta, s.isAcceptableOrUnknown(data['s']!, _sMeta));
    } else if (isInserting) {
      context.missing(_sMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WhoLmsDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WhoLmsDataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ageMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age_months'])!,
      measurementType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}measurement_type'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!,
      l: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}l'])!,
      m: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}m'])!,
      s: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}s'])!,
    );
  }

  @override
  $WhoLmsDataTable createAlias(String alias) {
    return $WhoLmsDataTable(attachedDatabase, alias);
  }
}

class WhoLmsDataData extends DataClass implements Insertable<WhoLmsDataData> {
  final int id;
  final int ageMonths;
  final String measurementType;
  final int gender;
  final double l;
  final double m;
  final double s;
  const WhoLmsDataData(
      {required this.id,
      required this.ageMonths,
      required this.measurementType,
      required this.gender,
      required this.l,
      required this.m,
      required this.s});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['age_months'] = Variable<int>(ageMonths);
    map['measurement_type'] = Variable<String>(measurementType);
    map['gender'] = Variable<int>(gender);
    map['l'] = Variable<double>(l);
    map['m'] = Variable<double>(m);
    map['s'] = Variable<double>(s);
    return map;
  }

  WhoLmsDataCompanion toCompanion(bool nullToAbsent) {
    return WhoLmsDataCompanion(
      id: Value(id),
      ageMonths: Value(ageMonths),
      measurementType: Value(measurementType),
      gender: Value(gender),
      l: Value(l),
      m: Value(m),
      s: Value(s),
    );
  }

  factory WhoLmsDataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WhoLmsDataData(
      id: serializer.fromJson<int>(json['id']),
      ageMonths: serializer.fromJson<int>(json['ageMonths']),
      measurementType: serializer.fromJson<String>(json['measurementType']),
      gender: serializer.fromJson<int>(json['gender']),
      l: serializer.fromJson<double>(json['l']),
      m: serializer.fromJson<double>(json['m']),
      s: serializer.fromJson<double>(json['s']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ageMonths': serializer.toJson<int>(ageMonths),
      'measurementType': serializer.toJson<String>(measurementType),
      'gender': serializer.toJson<int>(gender),
      'l': serializer.toJson<double>(l),
      'm': serializer.toJson<double>(m),
      's': serializer.toJson<double>(s),
    };
  }

  WhoLmsDataData copyWith(
          {int? id,
          int? ageMonths,
          String? measurementType,
          int? gender,
          double? l,
          double? m,
          double? s}) =>
      WhoLmsDataData(
        id: id ?? this.id,
        ageMonths: ageMonths ?? this.ageMonths,
        measurementType: measurementType ?? this.measurementType,
        gender: gender ?? this.gender,
        l: l ?? this.l,
        m: m ?? this.m,
        s: s ?? this.s,
      );
  @override
  String toString() {
    return (StringBuffer('WhoLmsDataData(')
          ..write('id: $id, ')
          ..write('ageMonths: $ageMonths, ')
          ..write('measurementType: $measurementType, ')
          ..write('gender: $gender, ')
          ..write('l: $l, ')
          ..write('m: $m, ')
          ..write('s: $s')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ageMonths, measurementType, gender, l, m, s);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhoLmsDataData &&
          other.id == this.id &&
          other.ageMonths == this.ageMonths &&
          other.measurementType == this.measurementType &&
          other.gender == this.gender &&
          other.l == this.l &&
          other.m == this.m &&
          other.s == this.s);
}

class WhoLmsDataCompanion extends UpdateCompanion<WhoLmsDataData> {
  final Value<int> id;
  final Value<int> ageMonths;
  final Value<String> measurementType;
  final Value<int> gender;
  final Value<double> l;
  final Value<double> m;
  final Value<double> s;
  const WhoLmsDataCompanion({
    this.id = const Value.absent(),
    this.ageMonths = const Value.absent(),
    this.measurementType = const Value.absent(),
    this.gender = const Value.absent(),
    this.l = const Value.absent(),
    this.m = const Value.absent(),
    this.s = const Value.absent(),
  });
  WhoLmsDataCompanion.insert({
    this.id = const Value.absent(),
    required int ageMonths,
    required String measurementType,
    required int gender,
    required double l,
    required double m,
    required double s,
  })  : ageMonths = Value(ageMonths),
        measurementType = Value(measurementType),
        gender = Value(gender),
        l = Value(l),
        m = Value(m),
        s = Value(s);
  static Insertable<WhoLmsDataData> custom({
    Expression<int>? id,
    Expression<int>? ageMonths,
    Expression<String>? measurementType,
    Expression<int>? gender,
    Expression<double>? l,
    Expression<double>? m,
    Expression<double>? s,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ageMonths != null) 'age_months': ageMonths,
      if (measurementType != null) 'measurement_type': measurementType,
      if (gender != null) 'gender': gender,
      if (l != null) 'l': l,
      if (m != null) 'm': m,
      if (s != null) 's': s,
    });
  }

  WhoLmsDataCompanion copyWith(
      {Value<int>? id,
      Value<int>? ageMonths,
      Value<String>? measurementType,
      Value<int>? gender,
      Value<double>? l,
      Value<double>? m,
      Value<double>? s}) {
    return WhoLmsDataCompanion(
      id: id ?? this.id,
      ageMonths: ageMonths ?? this.ageMonths,
      measurementType: measurementType ?? this.measurementType,
      gender: gender ?? this.gender,
      l: l ?? this.l,
      m: m ?? this.m,
      s: s ?? this.s,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ageMonths.present) {
      map['age_months'] = Variable<int>(ageMonths.value);
    }
    if (measurementType.present) {
      map['measurement_type'] = Variable<String>(measurementType.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (l.present) {
      map['l'] = Variable<double>(l.value);
    }
    if (m.present) {
      map['m'] = Variable<double>(m.value);
    }
    if (s.present) {
      map['s'] = Variable<double>(s.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WhoLmsDataCompanion(')
          ..write('id: $id, ')
          ..write('ageMonths: $ageMonths, ')
          ..write('measurementType: $measurementType, ')
          ..write('gender: $gender, ')
          ..write('l: $l, ')
          ..write('m: $m, ')
          ..write('s: $s')
          ..write(')'))
        .toString();
  }
}

abstract class _$WhoGrowthDatabase extends GeneratedDatabase {
  _$WhoGrowthDatabase(QueryExecutor e) : super(e);
  _$WhoGrowthDatabaseManager get managers => _$WhoGrowthDatabaseManager(this);
  late final $WhoLmsDataTable whoLmsData = $WhoLmsDataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [whoLmsData];
}

typedef $$WhoLmsDataTableInsertCompanionBuilder = WhoLmsDataCompanion Function({
  Value<int> id,
  required int ageMonths,
  required String measurementType,
  required int gender,
  required double l,
  required double m,
  required double s,
});
typedef $$WhoLmsDataTableUpdateCompanionBuilder = WhoLmsDataCompanion Function({
  Value<int> id,
  Value<int> ageMonths,
  Value<String> measurementType,
  Value<int> gender,
  Value<double> l,
  Value<double> m,
  Value<double> s,
});

class $$WhoLmsDataTableTableManager extends RootTableManager<
    _$WhoGrowthDatabase,
    $WhoLmsDataTable,
    WhoLmsDataData,
    $$WhoLmsDataTableFilterComposer,
    $$WhoLmsDataTableOrderingComposer,
    $$WhoLmsDataTableProcessedTableManager,
    $$WhoLmsDataTableInsertCompanionBuilder,
    $$WhoLmsDataTableUpdateCompanionBuilder> {
  $$WhoLmsDataTableTableManager(_$WhoGrowthDatabase db, $WhoLmsDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$WhoLmsDataTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$WhoLmsDataTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$WhoLmsDataTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> ageMonths = const Value.absent(),
            Value<String> measurementType = const Value.absent(),
            Value<int> gender = const Value.absent(),
            Value<double> l = const Value.absent(),
            Value<double> m = const Value.absent(),
            Value<double> s = const Value.absent(),
          }) =>
              WhoLmsDataCompanion(
            id: id,
            ageMonths: ageMonths,
            measurementType: measurementType,
            gender: gender,
            l: l,
            m: m,
            s: s,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int ageMonths,
            required String measurementType,
            required int gender,
            required double l,
            required double m,
            required double s,
          }) =>
              WhoLmsDataCompanion.insert(
            id: id,
            ageMonths: ageMonths,
            measurementType: measurementType,
            gender: gender,
            l: l,
            m: m,
            s: s,
          ),
        ));
}

class $$WhoLmsDataTableProcessedTableManager extends ProcessedTableManager<
    _$WhoGrowthDatabase,
    $WhoLmsDataTable,
    WhoLmsDataData,
    $$WhoLmsDataTableFilterComposer,
    $$WhoLmsDataTableOrderingComposer,
    $$WhoLmsDataTableProcessedTableManager,
    $$WhoLmsDataTableInsertCompanionBuilder,
    $$WhoLmsDataTableUpdateCompanionBuilder> {
  $$WhoLmsDataTableProcessedTableManager(super.$state);
}

class $$WhoLmsDataTableFilterComposer
    extends FilterComposer<_$WhoGrowthDatabase, $WhoLmsDataTable> {
  $$WhoLmsDataTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get ageMonths => $state.composableBuilder(
      column: $state.table.ageMonths,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get measurementType => $state.composableBuilder(
      column: $state.table.measurementType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get l => $state.composableBuilder(
      column: $state.table.l,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get m => $state.composableBuilder(
      column: $state.table.m,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get s => $state.composableBuilder(
      column: $state.table.s,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$WhoLmsDataTableOrderingComposer
    extends OrderingComposer<_$WhoGrowthDatabase, $WhoLmsDataTable> {
  $$WhoLmsDataTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get ageMonths => $state.composableBuilder(
      column: $state.table.ageMonths,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get measurementType => $state.composableBuilder(
      column: $state.table.measurementType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get l => $state.composableBuilder(
      column: $state.table.l,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get m => $state.composableBuilder(
      column: $state.table.m,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get s => $state.composableBuilder(
      column: $state.table.s,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$WhoGrowthDatabaseManager {
  final _$WhoGrowthDatabase _db;
  _$WhoGrowthDatabaseManager(this._db);
  $$WhoLmsDataTableTableManager get whoLmsData =>
      $$WhoLmsDataTableTableManager(_db, _db.whoLmsData);
}
