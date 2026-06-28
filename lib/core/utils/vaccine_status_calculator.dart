import 'package:flutter/foundation.dart';

import 'age_calculator.dart';

enum VaccineStatus { pending, due, overdue, completed }

extension VaccineStatusX on VaccineStatus {
  String get label {
    switch (this) {
      case VaccineStatus.completed:
        return 'Completada';
      case VaccineStatus.overdue:
        return 'Atrasada';
      case VaccineStatus.due:
        return 'Pendiente hoy';
      case VaccineStatus.pending:
        return 'Pendiente';
    }
  }

  bool get isOverdue => this == VaccineStatus.overdue;
  bool get isCompleted => this == VaccineStatus.completed;
  bool get isPending => this == VaccineStatus.pending || this == VaccineStatus.due;
}

@immutable
class VaccineStatusCalculator {
  const VaccineStatusCalculator._();

  static const int _approximateDaysPerMonth = 30;

  static DateTime dueDateFor({
    required DateTime birthDate,
    required int recommendedAgeMonths,
  }) {
    if (recommendedAgeMonths <= 0) return birthDate;
    return birthDate.add(Duration(days: recommendedAgeMonths * _approximateDaysPerMonth));
  }

  static bool isOverdue({
    required DateTime birthDate,
    required int recommendedAgeMonths,
    required bool isCompleted,
    DateTime? now,
  }) {
    if (isCompleted) return false;
    final reference = now ?? DateTime.now();
    final due = dueDateFor(
      birthDate: birthDate,
      recommendedAgeMonths: recommendedAgeMonths,
    );
    // Day-level granularity: any time on the due date is still on time.
    final refDate = DateTime(reference.year, reference.month, reference.day);
    final dueDate = DateTime(due.year, due.month, due.day);
    return refDate.isAfter(dueDate);
  }

  static bool isDueReached({
    required DateTime birthDate,
    required int recommendedAgeMonths,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    return AgeCalculator.completedMonths(birthDate, reference: reference) >=
        recommendedAgeMonths;
  }

  static VaccineStatus computeStatus({
    required DateTime birthDate,
    required int recommendedAgeMonths,
    required bool isCompleted,
    DateTime? now,
  }) {
    if (isCompleted) return VaccineStatus.completed;
    if (isOverdue(
      birthDate: birthDate,
      recommendedAgeMonths: recommendedAgeMonths,
      isCompleted: isCompleted,
      now: now,
    )) {
      return VaccineStatus.overdue;
    }
    if (isDueReached(
      birthDate: birthDate,
      recommendedAgeMonths: recommendedAgeMonths,
      now: now,
    )) {
      return VaccineStatus.due;
    }
    return VaccineStatus.pending;
  }
}