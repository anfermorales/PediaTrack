// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChildrenTable extends Children
    with TableInfo<$ChildrenTable, ChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _birthDateMeta =
      const VerificationMeta('birthDate');
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
      'birth_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
      'gender', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _birthWeightMeta =
      const VerificationMeta('birthWeight');
  @override
  late final GeneratedColumn<double> birthWeight = GeneratedColumn<double>(
      'birth_weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _birthHeightMeta =
      const VerificationMeta('birthHeight');
  @override
  late final GeneratedColumn<double> birthHeight = GeneratedColumn<double>(
      'birth_height', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
      'photo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, birthDate, gender, birthWeight, birthHeight, photo, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'children';
  @override
  VerificationContext validateIntegrity(Insertable<ChildrenData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(_birthDateMeta,
          birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta));
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('birth_weight')) {
      context.handle(
          _birthWeightMeta,
          birthWeight.isAcceptableOrUnknown(
              data['birth_weight']!, _birthWeightMeta));
    }
    if (data.containsKey('birth_height')) {
      context.handle(
          _birthHeightMeta,
          birthHeight.isAcceptableOrUnknown(
              data['birth_height']!, _birthHeightMeta));
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildrenData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      birthDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birth_date'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!,
      birthWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}birth_weight']),
      birthHeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}birth_height']),
      photo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChildrenTable createAlias(String alias) {
    return $ChildrenTable(attachedDatabase, alias);
  }
}

class ChildrenData extends DataClass implements Insertable<ChildrenData> {
  final int id;
  final String name;
  final DateTime birthDate;
  final int gender;
  final double? birthWeight;
  final double? birthHeight;
  final String? photo;
  final DateTime createdAt;
  const ChildrenData(
      {required this.id,
      required this.name,
      required this.birthDate,
      required this.gender,
      this.birthWeight,
      this.birthHeight,
      this.photo,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['gender'] = Variable<int>(gender);
    if (!nullToAbsent || birthWeight != null) {
      map['birth_weight'] = Variable<double>(birthWeight);
    }
    if (!nullToAbsent || birthHeight != null) {
      map['birth_height'] = Variable<double>(birthHeight);
    }
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChildrenCompanion toCompanion(bool nullToAbsent) {
    return ChildrenCompanion(
      id: Value(id),
      name: Value(name),
      birthDate: Value(birthDate),
      gender: Value(gender),
      birthWeight: birthWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(birthWeight),
      birthHeight: birthHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(birthHeight),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
      createdAt: Value(createdAt),
    );
  }

  factory ChildrenData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildrenData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      gender: serializer.fromJson<int>(json['gender']),
      birthWeight: serializer.fromJson<double?>(json['birthWeight']),
      birthHeight: serializer.fromJson<double?>(json['birthHeight']),
      photo: serializer.fromJson<String?>(json['photo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'gender': serializer.toJson<int>(gender),
      'birthWeight': serializer.toJson<double?>(birthWeight),
      'birthHeight': serializer.toJson<double?>(birthHeight),
      'photo': serializer.toJson<String?>(photo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChildrenData copyWith(
          {int? id,
          String? name,
          DateTime? birthDate,
          int? gender,
          Value<double?> birthWeight = const Value.absent(),
          Value<double?> birthHeight = const Value.absent(),
          Value<String?> photo = const Value.absent(),
          DateTime? createdAt}) =>
      ChildrenData(
        id: id ?? this.id,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        birthWeight: birthWeight.present ? birthWeight.value : this.birthWeight,
        birthHeight: birthHeight.present ? birthHeight.value : this.birthHeight,
        photo: photo.present ? photo.value : this.photo,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('ChildrenData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('birthWeight: $birthWeight, ')
          ..write('birthHeight: $birthHeight, ')
          ..write('photo: $photo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, birthDate, gender, birthWeight, birthHeight, photo, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildrenData &&
          other.id == this.id &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.birthWeight == this.birthWeight &&
          other.birthHeight == this.birthHeight &&
          other.photo == this.photo &&
          other.createdAt == this.createdAt);
}

class ChildrenCompanion extends UpdateCompanion<ChildrenData> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> birthDate;
  final Value<int> gender;
  final Value<double?> birthWeight;
  final Value<double?> birthHeight;
  final Value<String?> photo;
  final Value<DateTime> createdAt;
  const ChildrenCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthWeight = const Value.absent(),
    this.birthHeight = const Value.absent(),
    this.photo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChildrenCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime birthDate,
    required int gender,
    this.birthWeight = const Value.absent(),
    this.birthHeight = const Value.absent(),
    this.photo = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        birthDate = Value(birthDate),
        gender = Value(gender);
  static Insertable<ChildrenData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? birthDate,
    Expression<int>? gender,
    Expression<double>? birthWeight,
    Expression<double>? birthHeight,
    Expression<String>? photo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (birthWeight != null) 'birth_weight': birthWeight,
      if (birthHeight != null) 'birth_height': birthHeight,
      if (photo != null) 'photo': photo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChildrenCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? birthDate,
      Value<int>? gender,
      Value<double?>? birthWeight,
      Value<double?>? birthHeight,
      Value<String?>? photo,
      Value<DateTime>? createdAt}) {
    return ChildrenCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      birthWeight: birthWeight ?? this.birthWeight,
      birthHeight: birthHeight ?? this.birthHeight,
      photo: photo ?? this.photo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (birthWeight.present) {
      map['birth_weight'] = Variable<double>(birthWeight.value);
    }
    if (birthHeight.present) {
      map['birth_height'] = Variable<double>(birthHeight.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('birthWeight: $birthWeight, ')
          ..write('birthHeight: $birthHeight, ')
          ..write('photo: $photo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GrowthRecordsTable extends GrowthRecords
    with TableInfo<$GrowthRecordsTable, GrowthRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrowthRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _childIdMeta =
      const VerificationMeta('childId');
  @override
  late final GeneratedColumn<int> childId = GeneratedColumn<int>(
      'child_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES children (id)'));
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
      'height', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, childId, weight, height, date, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'growth_records';
  @override
  VerificationContext validateIntegrity(Insertable<GrowthRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('child_id')) {
      context.handle(_childIdMeta,
          childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta));
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrowthRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrowthRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      childId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}child_id'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight']),
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GrowthRecordsTable createAlias(String alias) {
    return $GrowthRecordsTable(attachedDatabase, alias);
  }
}

class GrowthRecord extends DataClass implements Insertable<GrowthRecord> {
  final int id;
  final int childId;
  final double? weight;
  final double? height;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
  const GrowthRecord(
      {required this.id,
      required this.childId,
      this.weight,
      this.height,
      required this.date,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['child_id'] = Variable<int>(childId);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<double>(height);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GrowthRecordsCompanion toCompanion(bool nullToAbsent) {
    return GrowthRecordsCompanion(
      id: Value(id),
      childId: Value(childId),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      date: Value(date),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory GrowthRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrowthRecord(
      id: serializer.fromJson<int>(json['id']),
      childId: serializer.fromJson<int>(json['childId']),
      weight: serializer.fromJson<double?>(json['weight']),
      height: serializer.fromJson<double?>(json['height']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'childId': serializer.toJson<int>(childId),
      'weight': serializer.toJson<double?>(weight),
      'height': serializer.toJson<double?>(height),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GrowthRecord copyWith(
          {int? id,
          int? childId,
          Value<double?> weight = const Value.absent(),
          Value<double?> height = const Value.absent(),
          DateTime? date,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      GrowthRecord(
        id: id ?? this.id,
        childId: childId ?? this.childId,
        weight: weight.present ? weight.value : this.weight,
        height: height.present ? height.value : this.height,
        date: date ?? this.date,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('GrowthRecord(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, childId, weight, height, date, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrowthRecord &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class GrowthRecordsCompanion extends UpdateCompanion<GrowthRecord> {
  final Value<int> id;
  final Value<int> childId;
  final Value<double?> weight;
  final Value<double?> height;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const GrowthRecordsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GrowthRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int childId,
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    required DateTime date,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : childId = Value(childId),
        date = Value(date);
  static Insertable<GrowthRecord> custom({
    Expression<int>? id,
    Expression<int>? childId,
    Expression<double>? weight,
    Expression<double>? height,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GrowthRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? childId,
      Value<double?>? weight,
      Value<double?>? height,
      Value<DateTime>? date,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return GrowthRecordsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<int>(childId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrowthRecordsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HabitRecordsTable extends HabitRecords
    with TableInfo<$HabitRecordsTable, HabitRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _childIdMeta =
      const VerificationMeta('childId');
  @override
  late final GeneratedColumn<int> childId = GeneratedColumn<int>(
      'child_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES children (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, childId, type, recordedAt, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_records';
  @override
  VerificationContext validateIntegrity(Insertable<HabitRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('child_id')) {
      context.handle(_childIdMeta,
          childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta));
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      childId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}child_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HabitRecordsTable createAlias(String alias) {
    return $HabitRecordsTable(attachedDatabase, alias);
  }
}

class HabitRecord extends DataClass implements Insertable<HabitRecord> {
  final int id;
  final int childId;
  final int type;
  final DateTime recordedAt;
  final String? notes;
  final DateTime createdAt;
  const HabitRecord(
      {required this.id,
      required this.childId,
      required this.type,
      required this.recordedAt,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['child_id'] = Variable<int>(childId);
    map['type'] = Variable<int>(type);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HabitRecordsCompanion toCompanion(bool nullToAbsent) {
    return HabitRecordsCompanion(
      id: Value(id),
      childId: Value(childId),
      type: Value(type),
      recordedAt: Value(recordedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory HabitRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRecord(
      id: serializer.fromJson<int>(json['id']),
      childId: serializer.fromJson<int>(json['childId']),
      type: serializer.fromJson<int>(json['type']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'childId': serializer.toJson<int>(childId),
      'type': serializer.toJson<int>(type),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HabitRecord copyWith(
          {int? id,
          int? childId,
          int? type,
          DateTime? recordedAt,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      HabitRecord(
        id: id ?? this.id,
        childId: childId ?? this.childId,
        type: type ?? this.type,
        recordedAt: recordedAt ?? this.recordedAt,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('HabitRecord(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('type: $type, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, childId, type, recordedAt, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRecord &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.type == this.type &&
          other.recordedAt == this.recordedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class HabitRecordsCompanion extends UpdateCompanion<HabitRecord> {
  final Value<int> id;
  final Value<int> childId;
  final Value<int> type;
  final Value<DateTime> recordedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const HabitRecordsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.type = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HabitRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int childId,
    required int type,
    required DateTime recordedAt,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : childId = Value(childId),
        type = Value(type),
        recordedAt = Value(recordedAt);
  static Insertable<HabitRecord> custom({
    Expression<int>? id,
    Expression<int>? childId,
    Expression<int>? type,
    Expression<DateTime>? recordedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (type != null) 'type': type,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HabitRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? childId,
      Value<int>? type,
      Value<DateTime>? recordedAt,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return HabitRecordsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      type: type ?? this.type,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<int>(childId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitRecordsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('type: $type, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $ChildrenTable children = $ChildrenTable(this);
  late final $GrowthRecordsTable growthRecords = $GrowthRecordsTable(this);
  late final $HabitRecordsTable habitRecords = $HabitRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [children, growthRecords, habitRecords];
}

typedef $$ChildrenTableInsertCompanionBuilder = ChildrenCompanion Function({
  Value<int> id,
  required String name,
  required DateTime birthDate,
  required int gender,
  Value<double?> birthWeight,
  Value<double?> birthHeight,
  Value<String?> photo,
  Value<DateTime> createdAt,
});
typedef $$ChildrenTableUpdateCompanionBuilder = ChildrenCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> birthDate,
  Value<int> gender,
  Value<double?> birthWeight,
  Value<double?> birthHeight,
  Value<String?> photo,
  Value<DateTime> createdAt,
});

class $$ChildrenTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChildrenTable,
    ChildrenData,
    $$ChildrenTableFilterComposer,
    $$ChildrenTableOrderingComposer,
    $$ChildrenTableProcessedTableManager,
    $$ChildrenTableInsertCompanionBuilder,
    $$ChildrenTableUpdateCompanionBuilder> {
  $$ChildrenTableTableManager(_$AppDatabase db, $ChildrenTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ChildrenTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ChildrenTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ChildrenTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> birthDate = const Value.absent(),
            Value<int> gender = const Value.absent(),
            Value<double?> birthWeight = const Value.absent(),
            Value<double?> birthHeight = const Value.absent(),
            Value<String?> photo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ChildrenCompanion(
            id: id,
            name: name,
            birthDate: birthDate,
            gender: gender,
            birthWeight: birthWeight,
            birthHeight: birthHeight,
            photo: photo,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String name,
            required DateTime birthDate,
            required int gender,
            Value<double?> birthWeight = const Value.absent(),
            Value<double?> birthHeight = const Value.absent(),
            Value<String?> photo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ChildrenCompanion.insert(
            id: id,
            name: name,
            birthDate: birthDate,
            gender: gender,
            birthWeight: birthWeight,
            birthHeight: birthHeight,
            photo: photo,
            createdAt: createdAt,
          ),
        ));
}

class $$ChildrenTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $ChildrenTable,
    ChildrenData,
    $$ChildrenTableFilterComposer,
    $$ChildrenTableOrderingComposer,
    $$ChildrenTableProcessedTableManager,
    $$ChildrenTableInsertCompanionBuilder,
    $$ChildrenTableUpdateCompanionBuilder> {
  $$ChildrenTableProcessedTableManager(super.$state);
}

class $$ChildrenTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get birthDate => $state.composableBuilder(
      column: $state.table.birthDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get birthWeight => $state.composableBuilder(
      column: $state.table.birthWeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get birthHeight => $state.composableBuilder(
      column: $state.table.birthHeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get photo => $state.composableBuilder(
      column: $state.table.photo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter growthRecordsRefs(
      ComposableFilter Function($$GrowthRecordsTableFilterComposer f) f) {
    final $$GrowthRecordsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.growthRecords,
        getReferencedColumn: (t) => t.childId,
        builder: (joinBuilder, parentComposers) =>
            $$GrowthRecordsTableFilterComposer(ComposerState($state.db,
                $state.db.growthRecords, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter habitRecordsRefs(
      ComposableFilter Function($$HabitRecordsTableFilterComposer f) f) {
    final $$HabitRecordsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.habitRecords,
        getReferencedColumn: (t) => t.childId,
        builder: (joinBuilder, parentComposers) =>
            $$HabitRecordsTableFilterComposer(ComposerState($state.db,
                $state.db.habitRecords, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ChildrenTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get birthDate => $state.composableBuilder(
      column: $state.table.birthDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get birthWeight => $state.composableBuilder(
      column: $state.table.birthWeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get birthHeight => $state.composableBuilder(
      column: $state.table.birthHeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get photo => $state.composableBuilder(
      column: $state.table.photo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$GrowthRecordsTableInsertCompanionBuilder = GrowthRecordsCompanion
    Function({
  Value<int> id,
  required int childId,
  Value<double?> weight,
  Value<double?> height,
  required DateTime date,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$GrowthRecordsTableUpdateCompanionBuilder = GrowthRecordsCompanion
    Function({
  Value<int> id,
  Value<int> childId,
  Value<double?> weight,
  Value<double?> height,
  Value<DateTime> date,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

class $$GrowthRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrowthRecordsTable,
    GrowthRecord,
    $$GrowthRecordsTableFilterComposer,
    $$GrowthRecordsTableOrderingComposer,
    $$GrowthRecordsTableProcessedTableManager,
    $$GrowthRecordsTableInsertCompanionBuilder,
    $$GrowthRecordsTableUpdateCompanionBuilder> {
  $$GrowthRecordsTableTableManager(_$AppDatabase db, $GrowthRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GrowthRecordsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GrowthRecordsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$GrowthRecordsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> childId = const Value.absent(),
            Value<double?> weight = const Value.absent(),
            Value<double?> height = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GrowthRecordsCompanion(
            id: id,
            childId: childId,
            weight: weight,
            height: height,
            date: date,
            notes: notes,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int childId,
            Value<double?> weight = const Value.absent(),
            Value<double?> height = const Value.absent(),
            required DateTime date,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GrowthRecordsCompanion.insert(
            id: id,
            childId: childId,
            weight: weight,
            height: height,
            date: date,
            notes: notes,
            createdAt: createdAt,
          ),
        ));
}

class $$GrowthRecordsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $GrowthRecordsTable,
    GrowthRecord,
    $$GrowthRecordsTableFilterComposer,
    $$GrowthRecordsTableOrderingComposer,
    $$GrowthRecordsTableProcessedTableManager,
    $$GrowthRecordsTableInsertCompanionBuilder,
    $$GrowthRecordsTableUpdateCompanionBuilder> {
  $$GrowthRecordsTableProcessedTableManager(super.$state);
}

class $$GrowthRecordsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GrowthRecordsTable> {
  $$GrowthRecordsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get height => $state.composableBuilder(
      column: $state.table.height,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $state.db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ChildrenTableFilterComposer(ComposerState(
                $state.db, $state.db.children, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$GrowthRecordsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GrowthRecordsTable> {
  $$GrowthRecordsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get height => $state.composableBuilder(
      column: $state.table.height,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $state.db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ChildrenTableOrderingComposer(ComposerState(
                $state.db, $state.db.children, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$HabitRecordsTableInsertCompanionBuilder = HabitRecordsCompanion
    Function({
  Value<int> id,
  required int childId,
  required int type,
  required DateTime recordedAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$HabitRecordsTableUpdateCompanionBuilder = HabitRecordsCompanion
    Function({
  Value<int> id,
  Value<int> childId,
  Value<int> type,
  Value<DateTime> recordedAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

class $$HabitRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitRecordsTable,
    HabitRecord,
    $$HabitRecordsTableFilterComposer,
    $$HabitRecordsTableOrderingComposer,
    $$HabitRecordsTableProcessedTableManager,
    $$HabitRecordsTableInsertCompanionBuilder,
    $$HabitRecordsTableUpdateCompanionBuilder> {
  $$HabitRecordsTableTableManager(_$AppDatabase db, $HabitRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HabitRecordsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HabitRecordsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$HabitRecordsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> childId = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              HabitRecordsCompanion(
            id: id,
            childId: childId,
            type: type,
            recordedAt: recordedAt,
            notes: notes,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int childId,
            required int type,
            required DateTime recordedAt,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              HabitRecordsCompanion.insert(
            id: id,
            childId: childId,
            type: type,
            recordedAt: recordedAt,
            notes: notes,
            createdAt: createdAt,
          ),
        ));
}

class $$HabitRecordsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $HabitRecordsTable,
    HabitRecord,
    $$HabitRecordsTableFilterComposer,
    $$HabitRecordsTableOrderingComposer,
    $$HabitRecordsTableProcessedTableManager,
    $$HabitRecordsTableInsertCompanionBuilder,
    $$HabitRecordsTableUpdateCompanionBuilder> {
  $$HabitRecordsTableProcessedTableManager(super.$state);
}

class $$HabitRecordsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get recordedAt => $state.composableBuilder(
      column: $state.table.recordedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $state.db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ChildrenTableFilterComposer(ComposerState(
                $state.db, $state.db.children, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$HabitRecordsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get recordedAt => $state.composableBuilder(
      column: $state.table.recordedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $state.db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ChildrenTableOrderingComposer(ComposerState(
                $state.db, $state.db.children, joinBuilder, parentComposers)));
    return composer;
  }
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$ChildrenTableTableManager get children =>
      $$ChildrenTableTableManager(_db, _db.children);
  $$GrowthRecordsTableTableManager get growthRecords =>
      $$GrowthRecordsTableTableManager(_db, _db.growthRecords);
  $$HabitRecordsTableTableManager get habitRecords =>
      $$HabitRecordsTableTableManager(_db, _db.habitRecords);
}
