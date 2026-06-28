// lib/features/children/models/child_model.dart

import 'package:drift/drift.dart' as drift;
import 'package:pediatrack/core/utils/age_calculator.dart';

/// Modelo inmutable para datos del niño
/// Reemplaza el uso de clases mutables con final fields
class ChildModel {
  final int id;
  final String name;
  final DateTime birthDate;
  final int gender;
  final double? birthWeight;
  final double? birthHeight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChildModel({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.birthWeight,
    this.birthHeight,
    this.createdAt,
    this.updatedAt,
  });

  /// Edad en meses cumplidos desde la fecha de nacimiento (máx. 60 para UI).
  int get ageMonths {
    return AgeCalculator.completedMonths(birthDate).clamp(0, 60);
  }

  /// Edad en formato legible (X años, Y meses)
  String get ageDisplay {
    final months = ageMonths;
    if (months < 12) return '$months meses';
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) return '$years año${years > 1 ? 's' : ''}';
    return '$years año${years > 1 ? 's' : ''}, $remainingMonths mes${remainingMonths > 1 ? 'es' : ''}';
  }

  /// Género en formato legible
  String get genderDisplay => gender == 0 ? 'Niño' : 'Niña';

  /// Verifica si el niño es menor de 12 meses
  bool get isInfant => ageMonths < 12;

  /// Copia con nuevos valores
  ChildModel copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    int? gender,
    double? birthWeight,
    double? birthHeight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      birthWeight: birthWeight ?? this.birthWeight,
      birthHeight: birthHeight ?? this.birthHeight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          birthDate == other.birthDate &&
          gender == other.gender;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ birthDate.hashCode ^ gender.hashCode;

  @override
  String toString() => 'ChildModel(id: $id, name: $name, age: $ageMonths months)';
}

/// Helper para convertir de Drift data class a ChildModel
extension ChildrenDataToModel on dynamic {
  ChildModel toChildModel() {
    return ChildModel(
      id: id as int,
      name: name as String,
      birthDate: birthDate as DateTime,
      gender: gender as int,
      birthWeight: birthWeight as double?,
      birthHeight: birthHeight as double?,
    );
  }
}