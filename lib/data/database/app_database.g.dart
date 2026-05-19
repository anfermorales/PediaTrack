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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  List<GeneratedColumn> get $columns => [
        id,
        name,
        birthDate,
        gender,
        birthWeight,
        birthHeight,
        notes,
        photo,
        createdAt
      ];
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
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
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
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
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
  final String? notes;
  final String? photo;
  final DateTime createdAt;
  const ChildrenData(
      {required this.id,
      required this.name,
      required this.birthDate,
      required this.gender,
      this.birthWeight,
      this.birthHeight,
      this.notes,
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
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
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
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
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
      notes: serializer.fromJson<String?>(json['notes']),
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
      'notes': serializer.toJson<String?>(notes),
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
          Value<String?> notes = const Value.absent(),
          Value<String?> photo = const Value.absent(),
          DateTime? createdAt}) =>
      ChildrenData(
        id: id ?? this.id,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        birthWeight: birthWeight.present ? birthWeight.value : this.birthWeight,
        birthHeight: birthHeight.present ? birthHeight.value : this.birthHeight,
        notes: notes.present ? notes.value : this.notes,
        photo: photo.present ? photo.value : this.photo,
        createdAt: createdAt ?? this.createdAt,
      );
  ChildrenData copyWithCompanion(ChildrenCompanion data) {
    return ChildrenData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthWeight:
          data.birthWeight.present ? data.birthWeight.value : this.birthWeight,
      birthHeight:
          data.birthHeight.present ? data.birthHeight.value : this.birthHeight,
      notes: data.notes.present ? data.notes.value : this.notes,
      photo: data.photo.present ? data.photo.value : this.photo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('birthWeight: $birthWeight, ')
          ..write('birthHeight: $birthHeight, ')
          ..write('notes: $notes, ')
          ..write('photo: $photo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, birthDate, gender, birthWeight,
      birthHeight, notes, photo, createdAt);
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
          other.notes == this.notes &&
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
  final Value<String?> notes;
  final Value<String?> photo;
  final Value<DateTime> createdAt;
  const ChildrenCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthWeight = const Value.absent(),
    this.birthHeight = const Value.absent(),
    this.notes = const Value.absent(),
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
    this.notes = const Value.absent(),
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
    Expression<String>? notes,
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
      if (notes != null) 'notes': notes,
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
      Value<String?>? notes,
      Value<String?>? photo,
      Value<DateTime>? createdAt}) {
    return ChildrenCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      birthWeight: birthWeight ?? this.birthWeight,
      birthHeight: birthHeight ?? this.birthHeight,
      notes: notes ?? this.notes,
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
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
          ..write('notes: $notes, ')
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
  static const VerificationMeta _headCircumferenceMeta =
      const VerificationMeta('headCircumference');
  @override
  late final GeneratedColumn<double> headCircumference =
      GeneratedColumn<double>('head_circumference', aliasedName, true,
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
      [id, childId, weight, height, headCircumference, date, notes, createdAt];
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
    if (data.containsKey('head_circumference')) {
      context.handle(
          _headCircumferenceMeta,
          headCircumference.isAcceptableOrUnknown(
              data['head_circumference']!, _headCircumferenceMeta));
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
      headCircumference: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}head_circumference']),
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
  final double? headCircumference;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
  const GrowthRecord(
      {required this.id,
      required this.childId,
      this.weight,
      this.height,
      this.headCircumference,
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
    if (!nullToAbsent || headCircumference != null) {
      map['head_circumference'] = Variable<double>(headCircumference);
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
      headCircumference: headCircumference == null && nullToAbsent
          ? const Value.absent()
          : Value(headCircumference),
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
      headCircumference:
          serializer.fromJson<double?>(json['headCircumference']),
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
      'headCircumference': serializer.toJson<double?>(headCircumference),
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
          Value<double?> headCircumference = const Value.absent(),
          DateTime? date,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      GrowthRecord(
        id: id ?? this.id,
        childId: childId ?? this.childId,
        weight: weight.present ? weight.value : this.weight,
        height: height.present ? height.value : this.height,
        headCircumference: headCircumference.present
            ? headCircumference.value
            : this.headCircumference,
        date: date ?? this.date,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  GrowthRecord copyWithCompanion(GrowthRecordsCompanion data) {
    return GrowthRecord(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      weight: data.weight.present ? data.weight.value : this.weight,
      height: data.height.present ? data.height.value : this.height,
      headCircumference: data.headCircumference.present
          ? data.headCircumference.value
          : this.headCircumference,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrowthRecord(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('headCircumference: $headCircumference, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, childId, weight, height, headCircumference, date, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrowthRecord &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.headCircumference == this.headCircumference &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class GrowthRecordsCompanion extends UpdateCompanion<GrowthRecord> {
  final Value<int> id;
  final Value<int> childId;
  final Value<double?> weight;
  final Value<double?> height;
  final Value<double?> headCircumference;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const GrowthRecordsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.headCircumference = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GrowthRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int childId,
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.headCircumference = const Value.absent(),
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
    Expression<double>? headCircumference,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (headCircumference != null) 'head_circumference': headCircumference,
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
      Value<double?>? headCircumference,
      Value<DateTime>? date,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return GrowthRecordsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      headCircumference: headCircumference ?? this.headCircumference,
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
    if (headCircumference.present) {
      map['head_circumference'] = Variable<double>(headCircumference.value);
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
          ..write('headCircumference: $headCircumference, ')
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
  HabitRecord copyWithCompanion(HabitRecordsCompanion data) {
    return HabitRecord(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      type: data.type.present ? data.type.value : this.type,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

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

class $VaccineDefinitionsTable extends VaccineDefinitions
    with TableInfo<$VaccineDefinitionsTable, VaccineDefinition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccineDefinitionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _doseNumberMeta =
      const VerificationMeta('doseNumber');
  @override
  late final GeneratedColumn<int> doseNumber = GeneratedColumn<int>(
      'dose_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalDosesMeta =
      const VerificationMeta('totalDoses');
  @override
  late final GeneratedColumn<int> totalDoses = GeneratedColumn<int>(
      'total_doses', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recommendedAgeMonthsMeta =
      const VerificationMeta('recommendedAgeMonths');
  @override
  late final GeneratedColumn<int> recommendedAgeMonths = GeneratedColumn<int>(
      'recommended_age_months', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        doseNumber,
        totalDoses,
        recommendedAgeMonths,
        category
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccine_definitions';
  @override
  VerificationContext validateIntegrity(Insertable<VaccineDefinition> instance,
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('dose_number')) {
      context.handle(
          _doseNumberMeta,
          doseNumber.isAcceptableOrUnknown(
              data['dose_number']!, _doseNumberMeta));
    } else if (isInserting) {
      context.missing(_doseNumberMeta);
    }
    if (data.containsKey('total_doses')) {
      context.handle(
          _totalDosesMeta,
          totalDoses.isAcceptableOrUnknown(
              data['total_doses']!, _totalDosesMeta));
    } else if (isInserting) {
      context.missing(_totalDosesMeta);
    }
    if (data.containsKey('recommended_age_months')) {
      context.handle(
          _recommendedAgeMonthsMeta,
          recommendedAgeMonths.isAcceptableOrUnknown(
              data['recommended_age_months']!, _recommendedAgeMonthsMeta));
    } else if (isInserting) {
      context.missing(_recommendedAgeMonthsMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaccineDefinition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaccineDefinition(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      doseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dose_number'])!,
      totalDoses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_doses'])!,
      recommendedAgeMonths: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recommended_age_months'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
    );
  }

  @override
  $VaccineDefinitionsTable createAlias(String alias) {
    return $VaccineDefinitionsTable(attachedDatabase, alias);
  }
}

class VaccineDefinition extends DataClass
    implements Insertable<VaccineDefinition> {
  final int id;
  final String name;
  final String? description;
  final int doseNumber;
  final int totalDoses;
  final int recommendedAgeMonths;
  final String category;
  const VaccineDefinition(
      {required this.id,
      required this.name,
      this.description,
      required this.doseNumber,
      required this.totalDoses,
      required this.recommendedAgeMonths,
      required this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['dose_number'] = Variable<int>(doseNumber);
    map['total_doses'] = Variable<int>(totalDoses);
    map['recommended_age_months'] = Variable<int>(recommendedAgeMonths);
    map['category'] = Variable<String>(category);
    return map;
  }

  VaccineDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return VaccineDefinitionsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      doseNumber: Value(doseNumber),
      totalDoses: Value(totalDoses),
      recommendedAgeMonths: Value(recommendedAgeMonths),
      category: Value(category),
    );
  }

  factory VaccineDefinition.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaccineDefinition(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      doseNumber: serializer.fromJson<int>(json['doseNumber']),
      totalDoses: serializer.fromJson<int>(json['totalDoses']),
      recommendedAgeMonths:
          serializer.fromJson<int>(json['recommendedAgeMonths']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'doseNumber': serializer.toJson<int>(doseNumber),
      'totalDoses': serializer.toJson<int>(totalDoses),
      'recommendedAgeMonths': serializer.toJson<int>(recommendedAgeMonths),
      'category': serializer.toJson<String>(category),
    };
  }

  VaccineDefinition copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          int? doseNumber,
          int? totalDoses,
          int? recommendedAgeMonths,
          String? category}) =>
      VaccineDefinition(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        doseNumber: doseNumber ?? this.doseNumber,
        totalDoses: totalDoses ?? this.totalDoses,
        recommendedAgeMonths: recommendedAgeMonths ?? this.recommendedAgeMonths,
        category: category ?? this.category,
      );
  VaccineDefinition copyWithCompanion(VaccineDefinitionsCompanion data) {
    return VaccineDefinition(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      doseNumber:
          data.doseNumber.present ? data.doseNumber.value : this.doseNumber,
      totalDoses:
          data.totalDoses.present ? data.totalDoses.value : this.totalDoses,
      recommendedAgeMonths: data.recommendedAgeMonths.present
          ? data.recommendedAgeMonths.value
          : this.recommendedAgeMonths,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaccineDefinition(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('doseNumber: $doseNumber, ')
          ..write('totalDoses: $totalDoses, ')
          ..write('recommendedAgeMonths: $recommendedAgeMonths, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, doseNumber, totalDoses,
      recommendedAgeMonths, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaccineDefinition &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.doseNumber == this.doseNumber &&
          other.totalDoses == this.totalDoses &&
          other.recommendedAgeMonths == this.recommendedAgeMonths &&
          other.category == this.category);
}

class VaccineDefinitionsCompanion extends UpdateCompanion<VaccineDefinition> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> doseNumber;
  final Value<int> totalDoses;
  final Value<int> recommendedAgeMonths;
  final Value<String> category;
  const VaccineDefinitionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.doseNumber = const Value.absent(),
    this.totalDoses = const Value.absent(),
    this.recommendedAgeMonths = const Value.absent(),
    this.category = const Value.absent(),
  });
  VaccineDefinitionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int doseNumber,
    required int totalDoses,
    required int recommendedAgeMonths,
    required String category,
  })  : name = Value(name),
        doseNumber = Value(doseNumber),
        totalDoses = Value(totalDoses),
        recommendedAgeMonths = Value(recommendedAgeMonths),
        category = Value(category);
  static Insertable<VaccineDefinition> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? doseNumber,
    Expression<int>? totalDoses,
    Expression<int>? recommendedAgeMonths,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (doseNumber != null) 'dose_number': doseNumber,
      if (totalDoses != null) 'total_doses': totalDoses,
      if (recommendedAgeMonths != null)
        'recommended_age_months': recommendedAgeMonths,
      if (category != null) 'category': category,
    });
  }

  VaccineDefinitionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? doseNumber,
      Value<int>? totalDoses,
      Value<int>? recommendedAgeMonths,
      Value<String>? category}) {
    return VaccineDefinitionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      doseNumber: doseNumber ?? this.doseNumber,
      totalDoses: totalDoses ?? this.totalDoses,
      recommendedAgeMonths: recommendedAgeMonths ?? this.recommendedAgeMonths,
      category: category ?? this.category,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (doseNumber.present) {
      map['dose_number'] = Variable<int>(doseNumber.value);
    }
    if (totalDoses.present) {
      map['total_doses'] = Variable<int>(totalDoses.value);
    }
    if (recommendedAgeMonths.present) {
      map['recommended_age_months'] = Variable<int>(recommendedAgeMonths.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaccineDefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('doseNumber: $doseNumber, ')
          ..write('totalDoses: $totalDoses, ')
          ..write('recommendedAgeMonths: $recommendedAgeMonths, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $ChildVaccinesTable extends ChildVaccines
    with TableInfo<$ChildVaccinesTable, ChildVaccine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildVaccinesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _vaccineDefinitionIdMeta =
      const VerificationMeta('vaccineDefinitionId');
  @override
  late final GeneratedColumn<int> vaccineDefinitionId = GeneratedColumn<int>(
      'vaccine_definition_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES vaccine_definitions (id)'));
  static const VerificationMeta _appliedDateMeta =
      const VerificationMeta('appliedDate');
  @override
  late final GeneratedColumn<DateTime> appliedDate = GeneratedColumn<DateTime>(
      'applied_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _batchMeta = const VerificationMeta('batch');
  @override
  late final GeneratedColumn<String> batch = GeneratedColumn<String>(
      'batch', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
      [id, childId, vaccineDefinitionId, appliedDate, batch, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'child_vaccines';
  @override
  VerificationContext validateIntegrity(Insertable<ChildVaccine> instance,
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
    if (data.containsKey('vaccine_definition_id')) {
      context.handle(
          _vaccineDefinitionIdMeta,
          vaccineDefinitionId.isAcceptableOrUnknown(
              data['vaccine_definition_id']!, _vaccineDefinitionIdMeta));
    } else if (isInserting) {
      context.missing(_vaccineDefinitionIdMeta);
    }
    if (data.containsKey('applied_date')) {
      context.handle(
          _appliedDateMeta,
          appliedDate.isAcceptableOrUnknown(
              data['applied_date']!, _appliedDateMeta));
    } else if (isInserting) {
      context.missing(_appliedDateMeta);
    }
    if (data.containsKey('batch')) {
      context.handle(
          _batchMeta, batch.isAcceptableOrUnknown(data['batch']!, _batchMeta));
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
  ChildVaccine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildVaccine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      childId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}child_id'])!,
      vaccineDefinitionId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}vaccine_definition_id'])!,
      appliedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}applied_date'])!,
      batch: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChildVaccinesTable createAlias(String alias) {
    return $ChildVaccinesTable(attachedDatabase, alias);
  }
}

class ChildVaccine extends DataClass implements Insertable<ChildVaccine> {
  final int id;
  final int childId;
  final int vaccineDefinitionId;
  final DateTime appliedDate;
  final String? batch;
  final String? notes;
  final DateTime createdAt;
  const ChildVaccine(
      {required this.id,
      required this.childId,
      required this.vaccineDefinitionId,
      required this.appliedDate,
      this.batch,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['child_id'] = Variable<int>(childId);
    map['vaccine_definition_id'] = Variable<int>(vaccineDefinitionId);
    map['applied_date'] = Variable<DateTime>(appliedDate);
    if (!nullToAbsent || batch != null) {
      map['batch'] = Variable<String>(batch);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChildVaccinesCompanion toCompanion(bool nullToAbsent) {
    return ChildVaccinesCompanion(
      id: Value(id),
      childId: Value(childId),
      vaccineDefinitionId: Value(vaccineDefinitionId),
      appliedDate: Value(appliedDate),
      batch:
          batch == null && nullToAbsent ? const Value.absent() : Value(batch),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory ChildVaccine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildVaccine(
      id: serializer.fromJson<int>(json['id']),
      childId: serializer.fromJson<int>(json['childId']),
      vaccineDefinitionId:
          serializer.fromJson<int>(json['vaccineDefinitionId']),
      appliedDate: serializer.fromJson<DateTime>(json['appliedDate']),
      batch: serializer.fromJson<String?>(json['batch']),
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
      'vaccineDefinitionId': serializer.toJson<int>(vaccineDefinitionId),
      'appliedDate': serializer.toJson<DateTime>(appliedDate),
      'batch': serializer.toJson<String?>(batch),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChildVaccine copyWith(
          {int? id,
          int? childId,
          int? vaccineDefinitionId,
          DateTime? appliedDate,
          Value<String?> batch = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      ChildVaccine(
        id: id ?? this.id,
        childId: childId ?? this.childId,
        vaccineDefinitionId: vaccineDefinitionId ?? this.vaccineDefinitionId,
        appliedDate: appliedDate ?? this.appliedDate,
        batch: batch.present ? batch.value : this.batch,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  ChildVaccine copyWithCompanion(ChildVaccinesCompanion data) {
    return ChildVaccine(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      vaccineDefinitionId: data.vaccineDefinitionId.present
          ? data.vaccineDefinitionId.value
          : this.vaccineDefinitionId,
      appliedDate:
          data.appliedDate.present ? data.appliedDate.value : this.appliedDate,
      batch: data.batch.present ? data.batch.value : this.batch,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildVaccine(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('vaccineDefinitionId: $vaccineDefinitionId, ')
          ..write('appliedDate: $appliedDate, ')
          ..write('batch: $batch, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, childId, vaccineDefinitionId, appliedDate, batch, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildVaccine &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.vaccineDefinitionId == this.vaccineDefinitionId &&
          other.appliedDate == this.appliedDate &&
          other.batch == this.batch &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class ChildVaccinesCompanion extends UpdateCompanion<ChildVaccine> {
  final Value<int> id;
  final Value<int> childId;
  final Value<int> vaccineDefinitionId;
  final Value<DateTime> appliedDate;
  final Value<String?> batch;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const ChildVaccinesCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.vaccineDefinitionId = const Value.absent(),
    this.appliedDate = const Value.absent(),
    this.batch = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChildVaccinesCompanion.insert({
    this.id = const Value.absent(),
    required int childId,
    required int vaccineDefinitionId,
    required DateTime appliedDate,
    this.batch = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : childId = Value(childId),
        vaccineDefinitionId = Value(vaccineDefinitionId),
        appliedDate = Value(appliedDate);
  static Insertable<ChildVaccine> custom({
    Expression<int>? id,
    Expression<int>? childId,
    Expression<int>? vaccineDefinitionId,
    Expression<DateTime>? appliedDate,
    Expression<String>? batch,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (vaccineDefinitionId != null)
        'vaccine_definition_id': vaccineDefinitionId,
      if (appliedDate != null) 'applied_date': appliedDate,
      if (batch != null) 'batch': batch,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChildVaccinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? childId,
      Value<int>? vaccineDefinitionId,
      Value<DateTime>? appliedDate,
      Value<String?>? batch,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return ChildVaccinesCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      vaccineDefinitionId: vaccineDefinitionId ?? this.vaccineDefinitionId,
      appliedDate: appliedDate ?? this.appliedDate,
      batch: batch ?? this.batch,
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
    if (vaccineDefinitionId.present) {
      map['vaccine_definition_id'] = Variable<int>(vaccineDefinitionId.value);
    }
    if (appliedDate.present) {
      map['applied_date'] = Variable<DateTime>(appliedDate.value);
    }
    if (batch.present) {
      map['batch'] = Variable<String>(batch.value);
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
    return (StringBuffer('ChildVaccinesCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('vaccineDefinitionId: $vaccineDefinitionId, ')
          ..write('appliedDate: $appliedDate, ')
          ..write('batch: $batch, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChildrenTable children = $ChildrenTable(this);
  late final $GrowthRecordsTable growthRecords = $GrowthRecordsTable(this);
  late final $HabitRecordsTable habitRecords = $HabitRecordsTable(this);
  late final $VaccineDefinitionsTable vaccineDefinitions =
      $VaccineDefinitionsTable(this);
  late final $ChildVaccinesTable childVaccines = $ChildVaccinesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        children,
        growthRecords,
        habitRecords,
        vaccineDefinitions,
        childVaccines,
        settings
      ];
}

typedef $$ChildrenTableCreateCompanionBuilder = ChildrenCompanion Function({
  Value<int> id,
  required String name,
  required DateTime birthDate,
  required int gender,
  Value<double?> birthWeight,
  Value<double?> birthHeight,
  Value<String?> notes,
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
  Value<String?> notes,
  Value<String?> photo,
  Value<DateTime> createdAt,
});

final class $$ChildrenTableReferences
    extends BaseReferences<_$AppDatabase, $ChildrenTable, ChildrenData> {
  $$ChildrenTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GrowthRecordsTable, List<GrowthRecord>>
      _growthRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.growthRecords,
              aliasName: $_aliasNameGenerator(
                  db.children.id, db.growthRecords.childId));

  $$GrowthRecordsTableProcessedTableManager get growthRecordsRefs {
    final manager = $$GrowthRecordsTableTableManager($_db, $_db.growthRecords)
        .filter((f) => f.childId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_growthRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HabitRecordsTable, List<HabitRecord>>
      _habitRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.habitRecords,
          aliasName:
              $_aliasNameGenerator(db.children.id, db.habitRecords.childId));

  $$HabitRecordsTableProcessedTableManager get habitRecordsRefs {
    final manager = $$HabitRecordsTableTableManager($_db, $_db.habitRecords)
        .filter((f) => f.childId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ChildVaccinesTable, List<ChildVaccine>>
      _childVaccinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.childVaccines,
              aliasName: $_aliasNameGenerator(
                  db.children.id, db.childVaccines.childId));

  $$ChildVaccinesTableProcessedTableManager get childVaccinesRefs {
    final manager = $$ChildVaccinesTableTableManager($_db, $_db.childVaccines)
        .filter((f) => f.childId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_childVaccinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get birthWeight => $composableBuilder(
      column: $table.birthWeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get birthHeight => $composableBuilder(
      column: $table.birthHeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photo => $composableBuilder(
      column: $table.photo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> growthRecordsRefs(
      Expression<bool> Function($$GrowthRecordsTableFilterComposer f) f) {
    final $$GrowthRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.growthRecords,
        getReferencedColumn: (t) => t.childId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GrowthRecordsTableFilterComposer(
              $db: $db,
              $table: $db.growthRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> habitRecordsRefs(
      Expression<bool> Function($$HabitRecordsTableFilterComposer f) f) {
    final $$HabitRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitRecords,
        getReferencedColumn: (t) => t.childId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitRecordsTableFilterComposer(
              $db: $db,
              $table: $db.habitRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> childVaccinesRefs(
      Expression<bool> Function($$ChildVaccinesTableFilterComposer f) f) {
    final $$ChildVaccinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.childVaccines,
        getReferencedColumn: (t) => t.childId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildVaccinesTableFilterComposer(
              $db: $db,
              $table: $db.childVaccines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get birthWeight => $composableBuilder(
      column: $table.birthWeight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get birthHeight => $composableBuilder(
      column: $table.birthHeight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photo => $composableBuilder(
      column: $table.photo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get birthWeight => $composableBuilder(
      column: $table.birthWeight, builder: (column) => column);

  GeneratedColumn<double> get birthHeight => $composableBuilder(
      column: $table.birthHeight, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> growthRecordsRefs<T extends Object>(
      Expression<T> Function($$GrowthRecordsTableAnnotationComposer a) f) {
    final $$GrowthRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.growthRecords,
        getReferencedColumn: (t) => t.childId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GrowthRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.growthRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> habitRecordsRefs<T extends Object>(
      Expression<T> Function($$HabitRecordsTableAnnotationComposer a) f) {
    final $$HabitRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitRecords,
        getReferencedColumn: (t) => t.childId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.habitRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> childVaccinesRefs<T extends Object>(
      Expression<T> Function($$ChildVaccinesTableAnnotationComposer a) f) {
    final $$ChildVaccinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.childVaccines,
        getReferencedColumn: (t) => t.childId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildVaccinesTableAnnotationComposer(
              $db: $db,
              $table: $db.childVaccines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChildrenTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChildrenTable,
    ChildrenData,
    $$ChildrenTableFilterComposer,
    $$ChildrenTableOrderingComposer,
    $$ChildrenTableAnnotationComposer,
    $$ChildrenTableCreateCompanionBuilder,
    $$ChildrenTableUpdateCompanionBuilder,
    (ChildrenData, $$ChildrenTableReferences),
    ChildrenData,
    PrefetchHooks Function(
        {bool growthRecordsRefs,
        bool habitRecordsRefs,
        bool childVaccinesRefs})> {
  $$ChildrenTableTableManager(_$AppDatabase db, $ChildrenTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> birthDate = const Value.absent(),
            Value<int> gender = const Value.absent(),
            Value<double?> birthWeight = const Value.absent(),
            Value<double?> birthHeight = const Value.absent(),
            Value<String?> notes = const Value.absent(),
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
            notes: notes,
            photo: photo,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required DateTime birthDate,
            required int gender,
            Value<double?> birthWeight = const Value.absent(),
            Value<double?> birthHeight = const Value.absent(),
            Value<String?> notes = const Value.absent(),
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
            notes: notes,
            photo: photo,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ChildrenTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {growthRecordsRefs = false,
              habitRecordsRefs = false,
              childVaccinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (growthRecordsRefs) db.growthRecords,
                if (habitRecordsRefs) db.habitRecords,
                if (childVaccinesRefs) db.childVaccines
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (growthRecordsRefs)
                    await $_getPrefetchedData<ChildrenData, $ChildrenTable,
                            GrowthRecord>(
                        currentTable: table,
                        referencedTable: $$ChildrenTableReferences
                            ._growthRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChildrenTableReferences(db, table, p0)
                                .growthRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.childId == item.id),
                        typedResults: items),
                  if (habitRecordsRefs)
                    await $_getPrefetchedData<ChildrenData, $ChildrenTable,
                            HabitRecord>(
                        currentTable: table,
                        referencedTable: $$ChildrenTableReferences
                            ._habitRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChildrenTableReferences(db, table, p0)
                                .habitRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.childId == item.id),
                        typedResults: items),
                  if (childVaccinesRefs)
                    await $_getPrefetchedData<ChildrenData, $ChildrenTable,
                            ChildVaccine>(
                        currentTable: table,
                        referencedTable: $$ChildrenTableReferences
                            ._childVaccinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChildrenTableReferences(db, table, p0)
                                .childVaccinesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.childId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChildrenTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChildrenTable,
    ChildrenData,
    $$ChildrenTableFilterComposer,
    $$ChildrenTableOrderingComposer,
    $$ChildrenTableAnnotationComposer,
    $$ChildrenTableCreateCompanionBuilder,
    $$ChildrenTableUpdateCompanionBuilder,
    (ChildrenData, $$ChildrenTableReferences),
    ChildrenData,
    PrefetchHooks Function(
        {bool growthRecordsRefs,
        bool habitRecordsRefs,
        bool childVaccinesRefs})>;
typedef $$GrowthRecordsTableCreateCompanionBuilder = GrowthRecordsCompanion
    Function({
  Value<int> id,
  required int childId,
  Value<double?> weight,
  Value<double?> height,
  Value<double?> headCircumference,
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
  Value<double?> headCircumference,
  Value<DateTime> date,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$GrowthRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $GrowthRecordsTable, GrowthRecord> {
  $$GrowthRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ChildrenTable _childIdTable(_$AppDatabase db) =>
      db.children.createAlias(
          $_aliasNameGenerator(db.growthRecords.childId, db.children.id));

  $$ChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<int>('child_id')!;

    final manager = $$ChildrenTableTableManager($_db, $_db.children)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$GrowthRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $GrowthRecordsTable> {
  $$GrowthRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get headCircumference => $composableBuilder(
      column: $table.headCircumference,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableFilterComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GrowthRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrowthRecordsTable> {
  $$GrowthRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get headCircumference => $composableBuilder(
      column: $table.headCircumference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableOrderingComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GrowthRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrowthRecordsTable> {
  $$GrowthRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get headCircumference => $composableBuilder(
      column: $table.headCircumference, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ChildrenTableAnnotationComposer get childId {
    final $$ChildrenTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableAnnotationComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GrowthRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrowthRecordsTable,
    GrowthRecord,
    $$GrowthRecordsTableFilterComposer,
    $$GrowthRecordsTableOrderingComposer,
    $$GrowthRecordsTableAnnotationComposer,
    $$GrowthRecordsTableCreateCompanionBuilder,
    $$GrowthRecordsTableUpdateCompanionBuilder,
    (GrowthRecord, $$GrowthRecordsTableReferences),
    GrowthRecord,
    PrefetchHooks Function({bool childId})> {
  $$GrowthRecordsTableTableManager(_$AppDatabase db, $GrowthRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrowthRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrowthRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrowthRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> childId = const Value.absent(),
            Value<double?> weight = const Value.absent(),
            Value<double?> height = const Value.absent(),
            Value<double?> headCircumference = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GrowthRecordsCompanion(
            id: id,
            childId: childId,
            weight: weight,
            height: height,
            headCircumference: headCircumference,
            date: date,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int childId,
            Value<double?> weight = const Value.absent(),
            Value<double?> height = const Value.absent(),
            Value<double?> headCircumference = const Value.absent(),
            required DateTime date,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GrowthRecordsCompanion.insert(
            id: id,
            childId: childId,
            weight: weight,
            height: height,
            headCircumference: headCircumference,
            date: date,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GrowthRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (childId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.childId,
                    referencedTable:
                        $$GrowthRecordsTableReferences._childIdTable(db),
                    referencedColumn:
                        $$GrowthRecordsTableReferences._childIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$GrowthRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrowthRecordsTable,
    GrowthRecord,
    $$GrowthRecordsTableFilterComposer,
    $$GrowthRecordsTableOrderingComposer,
    $$GrowthRecordsTableAnnotationComposer,
    $$GrowthRecordsTableCreateCompanionBuilder,
    $$GrowthRecordsTableUpdateCompanionBuilder,
    (GrowthRecord, $$GrowthRecordsTableReferences),
    GrowthRecord,
    PrefetchHooks Function({bool childId})>;
typedef $$HabitRecordsTableCreateCompanionBuilder = HabitRecordsCompanion
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

final class $$HabitRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitRecordsTable, HabitRecord> {
  $$HabitRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildrenTable _childIdTable(_$AppDatabase db) =>
      db.children.createAlias(
          $_aliasNameGenerator(db.habitRecords.childId, db.children.id));

  $$ChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<int>('child_id')!;

    final manager = $$ChildrenTableTableManager($_db, $_db.children)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HabitRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableFilterComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableOrderingComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ChildrenTableAnnotationComposer get childId {
    final $$ChildrenTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableAnnotationComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitRecordsTable,
    HabitRecord,
    $$HabitRecordsTableFilterComposer,
    $$HabitRecordsTableOrderingComposer,
    $$HabitRecordsTableAnnotationComposer,
    $$HabitRecordsTableCreateCompanionBuilder,
    $$HabitRecordsTableUpdateCompanionBuilder,
    (HabitRecord, $$HabitRecordsTableReferences),
    HabitRecord,
    PrefetchHooks Function({bool childId})> {
  $$HabitRecordsTableTableManager(_$AppDatabase db, $HabitRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HabitRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (childId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.childId,
                    referencedTable:
                        $$HabitRecordsTableReferences._childIdTable(db),
                    referencedColumn:
                        $$HabitRecordsTableReferences._childIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HabitRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitRecordsTable,
    HabitRecord,
    $$HabitRecordsTableFilterComposer,
    $$HabitRecordsTableOrderingComposer,
    $$HabitRecordsTableAnnotationComposer,
    $$HabitRecordsTableCreateCompanionBuilder,
    $$HabitRecordsTableUpdateCompanionBuilder,
    (HabitRecord, $$HabitRecordsTableReferences),
    HabitRecord,
    PrefetchHooks Function({bool childId})>;
typedef $$VaccineDefinitionsTableCreateCompanionBuilder
    = VaccineDefinitionsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required int doseNumber,
  required int totalDoses,
  required int recommendedAgeMonths,
  required String category,
});
typedef $$VaccineDefinitionsTableUpdateCompanionBuilder
    = VaccineDefinitionsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<int> doseNumber,
  Value<int> totalDoses,
  Value<int> recommendedAgeMonths,
  Value<String> category,
});

final class $$VaccineDefinitionsTableReferences extends BaseReferences<
    _$AppDatabase, $VaccineDefinitionsTable, VaccineDefinition> {
  $$VaccineDefinitionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChildVaccinesTable, List<ChildVaccine>>
      _childVaccinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.childVaccines,
              aliasName: $_aliasNameGenerator(db.vaccineDefinitions.id,
                  db.childVaccines.vaccineDefinitionId));

  $$ChildVaccinesTableProcessedTableManager get childVaccinesRefs {
    final manager = $$ChildVaccinesTableTableManager($_db, $_db.childVaccines)
        .filter((f) =>
            f.vaccineDefinitionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_childVaccinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$VaccineDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $VaccineDefinitionsTable> {
  $$VaccineDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDoses => $composableBuilder(
      column: $table.totalDoses, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recommendedAgeMonths => $composableBuilder(
      column: $table.recommendedAgeMonths,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  Expression<bool> childVaccinesRefs(
      Expression<bool> Function($$ChildVaccinesTableFilterComposer f) f) {
    final $$ChildVaccinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.childVaccines,
        getReferencedColumn: (t) => t.vaccineDefinitionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildVaccinesTableFilterComposer(
              $db: $db,
              $table: $db.childVaccines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VaccineDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $VaccineDefinitionsTable> {
  $$VaccineDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDoses => $composableBuilder(
      column: $table.totalDoses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recommendedAgeMonths => $composableBuilder(
      column: $table.recommendedAgeMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$VaccineDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaccineDefinitionsTable> {
  $$VaccineDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => column);

  GeneratedColumn<int> get totalDoses => $composableBuilder(
      column: $table.totalDoses, builder: (column) => column);

  GeneratedColumn<int> get recommendedAgeMonths => $composableBuilder(
      column: $table.recommendedAgeMonths, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  Expression<T> childVaccinesRefs<T extends Object>(
      Expression<T> Function($$ChildVaccinesTableAnnotationComposer a) f) {
    final $$ChildVaccinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.childVaccines,
        getReferencedColumn: (t) => t.vaccineDefinitionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildVaccinesTableAnnotationComposer(
              $db: $db,
              $table: $db.childVaccines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VaccineDefinitionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VaccineDefinitionsTable,
    VaccineDefinition,
    $$VaccineDefinitionsTableFilterComposer,
    $$VaccineDefinitionsTableOrderingComposer,
    $$VaccineDefinitionsTableAnnotationComposer,
    $$VaccineDefinitionsTableCreateCompanionBuilder,
    $$VaccineDefinitionsTableUpdateCompanionBuilder,
    (VaccineDefinition, $$VaccineDefinitionsTableReferences),
    VaccineDefinition,
    PrefetchHooks Function({bool childVaccinesRefs})> {
  $$VaccineDefinitionsTableTableManager(
      _$AppDatabase db, $VaccineDefinitionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccineDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccineDefinitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccineDefinitionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> doseNumber = const Value.absent(),
            Value<int> totalDoses = const Value.absent(),
            Value<int> recommendedAgeMonths = const Value.absent(),
            Value<String> category = const Value.absent(),
          }) =>
              VaccineDefinitionsCompanion(
            id: id,
            name: name,
            description: description,
            doseNumber: doseNumber,
            totalDoses: totalDoses,
            recommendedAgeMonths: recommendedAgeMonths,
            category: category,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required int doseNumber,
            required int totalDoses,
            required int recommendedAgeMonths,
            required String category,
          }) =>
              VaccineDefinitionsCompanion.insert(
            id: id,
            name: name,
            description: description,
            doseNumber: doseNumber,
            totalDoses: totalDoses,
            recommendedAgeMonths: recommendedAgeMonths,
            category: category,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$VaccineDefinitionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({childVaccinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (childVaccinesRefs) db.childVaccines
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (childVaccinesRefs)
                    await $_getPrefetchedData<VaccineDefinition,
                            $VaccineDefinitionsTable, ChildVaccine>(
                        currentTable: table,
                        referencedTable: $$VaccineDefinitionsTableReferences
                            ._childVaccinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VaccineDefinitionsTableReferences(db, table, p0)
                                .childVaccinesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.vaccineDefinitionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$VaccineDefinitionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VaccineDefinitionsTable,
    VaccineDefinition,
    $$VaccineDefinitionsTableFilterComposer,
    $$VaccineDefinitionsTableOrderingComposer,
    $$VaccineDefinitionsTableAnnotationComposer,
    $$VaccineDefinitionsTableCreateCompanionBuilder,
    $$VaccineDefinitionsTableUpdateCompanionBuilder,
    (VaccineDefinition, $$VaccineDefinitionsTableReferences),
    VaccineDefinition,
    PrefetchHooks Function({bool childVaccinesRefs})>;
typedef $$ChildVaccinesTableCreateCompanionBuilder = ChildVaccinesCompanion
    Function({
  Value<int> id,
  required int childId,
  required int vaccineDefinitionId,
  required DateTime appliedDate,
  Value<String?> batch,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$ChildVaccinesTableUpdateCompanionBuilder = ChildVaccinesCompanion
    Function({
  Value<int> id,
  Value<int> childId,
  Value<int> vaccineDefinitionId,
  Value<DateTime> appliedDate,
  Value<String?> batch,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$ChildVaccinesTableReferences
    extends BaseReferences<_$AppDatabase, $ChildVaccinesTable, ChildVaccine> {
  $$ChildVaccinesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ChildrenTable _childIdTable(_$AppDatabase db) =>
      db.children.createAlias(
          $_aliasNameGenerator(db.childVaccines.childId, db.children.id));

  $$ChildrenTableProcessedTableManager get childId {
    final $_column = $_itemColumn<int>('child_id')!;

    final manager = $$ChildrenTableTableManager($_db, $_db.children)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $VaccineDefinitionsTable _vaccineDefinitionIdTable(_$AppDatabase db) =>
      db.vaccineDefinitions.createAlias($_aliasNameGenerator(
          db.childVaccines.vaccineDefinitionId, db.vaccineDefinitions.id));

  $$VaccineDefinitionsTableProcessedTableManager get vaccineDefinitionId {
    final $_column = $_itemColumn<int>('vaccine_definition_id')!;

    final manager =
        $$VaccineDefinitionsTableTableManager($_db, $_db.vaccineDefinitions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vaccineDefinitionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChildVaccinesTableFilterComposer
    extends Composer<_$AppDatabase, $ChildVaccinesTable> {
  $$ChildVaccinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get appliedDate => $composableBuilder(
      column: $table.appliedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batch => $composableBuilder(
      column: $table.batch, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ChildrenTableFilterComposer get childId {
    final $$ChildrenTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableFilterComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VaccineDefinitionsTableFilterComposer get vaccineDefinitionId {
    final $$VaccineDefinitionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vaccineDefinitionId,
        referencedTable: $db.vaccineDefinitions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VaccineDefinitionsTableFilterComposer(
              $db: $db,
              $table: $db.vaccineDefinitions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChildVaccinesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildVaccinesTable> {
  $$ChildVaccinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get appliedDate => $composableBuilder(
      column: $table.appliedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batch => $composableBuilder(
      column: $table.batch, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ChildrenTableOrderingComposer get childId {
    final $$ChildrenTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableOrderingComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VaccineDefinitionsTableOrderingComposer get vaccineDefinitionId {
    final $$VaccineDefinitionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vaccineDefinitionId,
        referencedTable: $db.vaccineDefinitions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VaccineDefinitionsTableOrderingComposer(
              $db: $db,
              $table: $db.vaccineDefinitions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChildVaccinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildVaccinesTable> {
  $$ChildVaccinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get appliedDate => $composableBuilder(
      column: $table.appliedDate, builder: (column) => column);

  GeneratedColumn<String> get batch =>
      $composableBuilder(column: $table.batch, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ChildrenTableAnnotationComposer get childId {
    final $$ChildrenTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childId,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableAnnotationComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VaccineDefinitionsTableAnnotationComposer get vaccineDefinitionId {
    final $$VaccineDefinitionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.vaccineDefinitionId,
            referencedTable: $db.vaccineDefinitions,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$VaccineDefinitionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.vaccineDefinitions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ChildVaccinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChildVaccinesTable,
    ChildVaccine,
    $$ChildVaccinesTableFilterComposer,
    $$ChildVaccinesTableOrderingComposer,
    $$ChildVaccinesTableAnnotationComposer,
    $$ChildVaccinesTableCreateCompanionBuilder,
    $$ChildVaccinesTableUpdateCompanionBuilder,
    (ChildVaccine, $$ChildVaccinesTableReferences),
    ChildVaccine,
    PrefetchHooks Function({bool childId, bool vaccineDefinitionId})> {
  $$ChildVaccinesTableTableManager(_$AppDatabase db, $ChildVaccinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildVaccinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildVaccinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildVaccinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> childId = const Value.absent(),
            Value<int> vaccineDefinitionId = const Value.absent(),
            Value<DateTime> appliedDate = const Value.absent(),
            Value<String?> batch = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ChildVaccinesCompanion(
            id: id,
            childId: childId,
            vaccineDefinitionId: vaccineDefinitionId,
            appliedDate: appliedDate,
            batch: batch,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int childId,
            required int vaccineDefinitionId,
            required DateTime appliedDate,
            Value<String?> batch = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ChildVaccinesCompanion.insert(
            id: id,
            childId: childId,
            vaccineDefinitionId: vaccineDefinitionId,
            appliedDate: appliedDate,
            batch: batch,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChildVaccinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {childId = false, vaccineDefinitionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (childId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.childId,
                    referencedTable:
                        $$ChildVaccinesTableReferences._childIdTable(db),
                    referencedColumn:
                        $$ChildVaccinesTableReferences._childIdTable(db).id,
                  ) as T;
                }
                if (vaccineDefinitionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.vaccineDefinitionId,
                    referencedTable: $$ChildVaccinesTableReferences
                        ._vaccineDefinitionIdTable(db),
                    referencedColumn: $$ChildVaccinesTableReferences
                        ._vaccineDefinitionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChildVaccinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChildVaccinesTable,
    ChildVaccine,
    $$ChildVaccinesTableFilterComposer,
    $$ChildVaccinesTableOrderingComposer,
    $$ChildVaccinesTableAnnotationComposer,
    $$ChildVaccinesTableCreateCompanionBuilder,
    $$ChildVaccinesTableUpdateCompanionBuilder,
    (ChildVaccine, $$ChildVaccinesTableReferences),
    ChildVaccine,
    PrefetchHooks Function({bool childId, bool vaccineDefinitionId})>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChildrenTableTableManager get children =>
      $$ChildrenTableTableManager(_db, _db.children);
  $$GrowthRecordsTableTableManager get growthRecords =>
      $$GrowthRecordsTableTableManager(_db, _db.growthRecords);
  $$HabitRecordsTableTableManager get habitRecords =>
      $$HabitRecordsTableTableManager(_db, _db.habitRecords);
  $$VaccineDefinitionsTableTableManager get vaccineDefinitions =>
      $$VaccineDefinitionsTableTableManager(_db, _db.vaccineDefinitions);
  $$ChildVaccinesTableTableManager get childVaccines =>
      $$ChildVaccinesTableTableManager(_db, _db.childVaccines);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
